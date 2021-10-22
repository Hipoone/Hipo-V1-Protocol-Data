// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {IFinancingPool} from '../../interfaces/IFinancingPool.sol';
import {IPoolAddressesProvider} from '../../interfaces/IPoolAddressesProvider.sol';
import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20.sol';
import {IERC20Detailed} from '../../dependencies/openzeppelin/contracts/IERC20.sol'
import {IDebtToken} from '../../interfaces/IDebtToken.sol';
import {IUniswapV2Pair} from '../../interfaces/IUniswapV2Pair.sol';

import {UserConfiguration} from '../libraries/configuration/UserConfiguration.sol';
import {CollateralConfiguration} from '../libraries/configuration/CollateralConfiguration.sol';

import {SafeMath} from '../../dependencies/openzeppelin/contracts/SafeMath.sol';
import {WadRayMath} '../libraries/math/WadRayMath.sol';

import {DataTypes} from '../libraries/types/DataTypes.sol';

contract WalletDataProvider {

    using UserConfiguration for DataTypes.IssuerConfigurationMap;
    using CollateralConfiguration for DataTypes.CollateralConfigurationMap;
    using SafeMath for uint256;
    using WadRayMath for uint256;

    struct Collateral {
        address collateralAssetAddress;
        uint256 amount;
    }

    struct IssuerDebt {
        address collateralAssetAddress;
        address debtAssetAddress;
        uint256 duration;
        uint256 debtId;
        uint256 startTimestamp;
        uint256 amount;
        bool isRepaid;
    }

    uint256 internal constant WAD = 1e18;

    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;

    constructor(IPoolAddressesProvider addressesProvider) public {
        ADDRESSES_PROVIDER = addressesProvider;
    }

    function getCollateralsAmountOfIssuer (address Issuer)
        view
        external
        returns (Collateral[] memory)
    {
        IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());
        address[] memory collateralAssets = pool.getCollateralsList();

        Collateral[] memory collaterals = new Collateral[](collateralAssets.length);
        DataTypes.CollateralData memory collateralData;
        address colTokenAddress;

        for(uint256 i = 0; i < collateralAssets.length; i++) {
            collateralData = pool.getCollateralData(collateralAssets[i]);
            colTokenAddress = collateralData.colTokenAddress;
            collaterals[i].collateralAssetAddress = collateralAssets[i];
            collaterals[i].amount = IERC20(colTokenAddress).balanceOf(Issuer);
        }

        return collaterals;
    }

    function getIssuerDebtsData(uint256 reserveId, address issuer)
        view
        external
        returns(IssuerDebt[] memory) {

            IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());

            DataTypes.ReserveData memory reserveData;

            reserveData = pool.getReserveData(reserveId);

            address debtTokenAddress = reserveData.debtTokenAddress;

            uint256[] memory issuerDebtsIds = IDebtToken(debtTokenAddress).getIssuerDebtsList(issuer);

            IssuerDebt[] memory issuerDebts = new IssuerDebt[](issuerDebtsIds.length);

            if(issuerDebtsIds.length == 0) {
                return issuerDebts;
            }

            for (uint256 j = 0; j < issuerDebtsIds.length; j++) {
                (uint256 startTimestamp, uint256 amount, address collateralAsset) =
                    IDebtToken(debtTokenAddress).getDebtData(issuer, issuerDebtsIds[j]);
                    issuerDebts[j].collateralAssetAddress = collateralAsset;
                    issuerDebts[j].debtAssetAddress = reserveData.asset;
                    issuerDebts[j].duration = reserveData.bondDuration;
                    issuerDebts[j].debtId = issuerDebtsIds[j];
                    issuerDebts[j].startTimestamp = startTimestamp;
                    issuerDebts[j].amount = amount;

                    if(amount == 0) {
                        issuerDebts[j].isRepaid = false;
                    }

                    if(amount != 0) {
                        issuerDebts[j].isRepaid = true;
                    }
            }

            return issuerDebts;
        }

    function getIssuerTotalDebts(address issuer, address collateralAssetAddress)
        view
        public
        returns (
            address debtAddressOfTokenA,
            uint256 totalDebtsOfTokenA,
            address debtAddressOfTokenB,
            uint256 totalDebtsOfTokenB
            ) {
                IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());

                DataTypes.CollateralData memory collateralData = pool.getCollateralData(collateralAssetAddress);
                DataTypes.IssuerConfigurationMap memory issuerConfig;

                issuerConfig = pool.getIssuerConfig(issuer);

                if(issuerConfig.isEmpty()) {
                    return (address(0), 0, address(0), 0);
                }

                if (!issuerConfig.isIssuing(collateralData.id)) {
                    return (address(0), 0, address(0), 0);
                }

                for(uint256 i = 0; i < 12; i++) {

                    if(!issuerConfig.getBondIssuingFlag(collateralData.id, i)) {
                        continue;
                    }

                    if(i < 6) {

                        DataTypes.ReserveData memory reserveData = pool.getReserveData(i);

                        uint256 issuerDebtsAmountOfCollateral = IDebtToken(reserveData.debtTokenAddress)
                                                                .getIssuerDebtsOfCollateral(issuer, collateralAssetAddress);

                        totalDebtsOfTokenA = totalDebtsOfTokenA.add(issuerDebtsAmountOfCollateral);
                    }

                    if (i > 5) {

                        DataTypes.ReserveData memory reserveData = pool.getReserveData(collateralData.id * 6 + i);

                        uint256 debtReserveBTokenBalance = IERC20(reserveData.debtTokenAddress).balanceOf(issuer);

                        totalDebtsOfTokenB = totalDebtsOfTokenB.add(debtReserveBTokenBalance);
                    }
                }

                return (
                    collateralData.underlyingAssetA,
                    totalDebtsOfTokenA,
                    collateralData.underlyingAssetB,
                    totalDebtsOfTokenB
                    );

        }

    function getIssuerLtv(address issuer, address collateralAssetAddress)
        view
        public
        returns(uint256 issuerLtv) {

            (
                ,
                uint256 totalDebtsOfTokenA,
                ,
                uint256 totalDebtsOfTokenB

            ) = getIssuerTotalDebts(issuer, collateralAssetAddress);

            if(totalDebtsOfTokenA == 0 && totalDebtsOfTokenB == 0) {
                return 0;
            }

            (
                uint256 amountOfUnderlyingAssetA,
                ,
                ,
                uint256 amountOfUnderlyingAssetB,
                ,

            ) = getIssuerCollateralAssetUnderlyingAssets(issuer, collateralAssetAddress);


            getIssuerCollateralAssetUnderlyingAssets(issuer, collateralAssetAddress);

            if (amountOfUnderlyingAssetA == 0) {
                return 0;
            }

            if (totalDebtsOfTokenA == 0) {
                return totalDebtsOfTokenB.wadDiv(amountOfUnderlyingAssetB.mul(2));
            }

            if (totalDebtsOfTokenB == 0) {
                return totalDebtsOfTokenA.wadDiv(amountOfUnderlyingAssetA.mul(2));
            }

            return (totalDebtsOfTokenA.wadDiv(amountOfUnderlyingAssetA.mul(2)))
                .add(totalDebtsOfTokenB.wadDiv(amountOfUnderlyingAssetB.mul(2)));
        }

    struct getIssuerCollateralAssetUnderlyingAssetsLocalVars {

        uint256 amountToken0;
        address token0;
        uint8 decimalsOfToken0;
        uint256 amountToken1;
        address token1;
        uint8 decimalsOfToken1;
    }

    function getIssuerCollateralAssetUnderlyingAssets(address issuer, address collateralAssetAddress)
        view
        public
        returns(
            uint256,
            address,
            uint8,
            uint256,
            address,
            uint8
            ) {

            getIssuerCollateralAssetUnderlyingAssetsLocalVars memory vars;

            IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());
            DataTypes.CollateralData memory collateralData = pool.getCollateralData(collateralAssetAddress);

            vars.token0 = IUniswapV2Pair(collateralAssetAddress).token0();
            vars.token1 = IUniswapV2Pair(collateralAssetAddress).token1();

            vars.decimalsOfToken0 = IERC20Detailed(vars.token0).decimals();
            vars.decimalsOfToken1 = IERC20Detailed(vars.token1).decimals();

            address colToken = collateralData.colTokenAddress;

            uint256 collateralAmount = IERC20(colToken).balanceOf(issuer);

            uint256 totalAmountOfUniPool = IERC20(collateralAssetAddress).totalSupply();

            (uint112 amountToken0InPool, uint112 amountToken1InPool, ) =
                IUniswapV2Pair(collateralAssetAddress).getReserves();

            uint256 issuerPoolShare = collateralAmount.wadDiv(totalAmountOfUniPool);

            vars.amountToken0 = issuerPoolShare.mul(uint256(amountToken0InPool)).div(WAD);
            vars.amountToken1 = issuerPoolShare.mul(uint256(amountToken1InPool)).div(WAD);

            if (collateralData.underlyingAssetA == vars.token0) {

                return (
                    vars.amountToken0,
                    vars.token0,
                    vars.decimalsOfToken0,
                    vars.amountToken1,
                    vars.token1,
                    vars.decimalsOfToken1
                    );
            }

            if (collateralData.underlyingAssetA == vars.token1) {

                return (
                    vars.amountToken1,
                    vars.token1,
                    vars.decimalsOfToken1,
                    vars.amountToken0,
                    vars.token0,
                    vars.decimalsOfToken0
                    );
            }
        }

    function getIssuerAvailableDebts(address issuer, address collateralAssetAddress)
        view
        external
        returns(uint256, uint256) {

            IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());

            DataTypes.CollateralConfigurationMap memory configuration =
                pool.getCollateralConfiguration(collateralAssetAddress);

            uint256 issuerLtv = getIssuerLtv(issuer, collateralAssetAddress);

            (uint256 maxLtv, , , ) = configuration.getParamsMemory();

            if (issuerLtv >= maxLtv) {
                return (0, 0);
            }

            (
                uint256 amountToken0,
                ,
                ,
                uint256 amountToken1,
                ,

            ) = getIssuerCollateralAssetUnderlyingAssets(issuer, collateralAssetAddress);

            uint256 totalAvailableDebtsOfToken0 = amountToken0.mul(maxLtv).div(100).mul(2);
            uint256 totalAvailableDebtsOfToken1 = amountToken1.mul(maxLtv).div(100).mul(2);
            uint256 issuerDebtOfToken0 = amountToken0.mul(issuerLtv).div(WAD);
            uint256 issuerDebtOfToken1 = amountToken1.mul(issuerLtv).div(WAD);

            return (totalAvailableDebtsOfToken0.sub(issuerDebtOfToken0), totalAvailableDebtsOfToken1.sub(issuerDebtOfToken1));
        }
}
