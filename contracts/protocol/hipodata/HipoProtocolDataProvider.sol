// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {IFinancingPool} from '../../interfaces/IFinancingPool.sol';
import {DataTypes} from '../libraries/types/DataTypes.sol';
import {CollateralConfiguration} from '../libraries/configuration/CollateralConfiguration.sol';
import {ReserveConfiguration} from '../libraries/configuration/ReserveConfiguration.sol';
import {IPoolAddressesProvider} from '../../interfaces/IPoolAddressesProvider.sol';
import {IERC20Detailed} from '../../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {SafeMath} from '../../dependencies/openzeppelin/contracts/SafeMath.sol';
import {WadRayMath} from '../libraries/math/WadRayMath.sol';


import {IHipoAMMV1Pair} from '../../interfaces/IHipoAMMV1Pair.sol';
import {IHipoAMMV1Factory} from '../../interfaces/IHipoAMMV1Factory.sol';

contract HipoProtocolDataProvider {

    using CollateralConfiguration for DataTypes.CollateralConfigurationMap;
    using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

    using SafeMath for uint256;
    using WadRayMath for uint256;

    struct Reserve {
        address assetAddress;
        uint256 duration;
        uint256 id;
    }

    struct Collateral {
        address collateralAssetAddress;
        uint256 id;
        string symbol;
    }

    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;

    uint256 internal constant WAD = 1e18;

    constructor(IPoolAddressesProvider addressesProvider) public {
        ADDRESSES_PROVIDER = addressesProvider;
    }

    function getAllReserves() external view returns (Reserve[] memory) {

        IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());
        DataTypes.Reserve[] memory reservesList = pool.getReservesList();

        Reserve[] memory reserves = new Reserve[](reservesList.length);
        for (uint256 i = 0; i < reservesList.length; i++) {
            reserves[i] = Reserve({
                assetAddress: reservesList[i].asset,
                duration: reservesList[i].duration,
                id: i
            });
        }

        return reserves;
    }

    function getAllCollaterals() external view returns (Collateral[] memory) {

        IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());
        address[] memory collateralAssets = pool.getCollateralsList();

        Collateral[] memory collaterals = new Collateral[](collateralAssets.length);
        for (uint256 i = 0; i < collateralAssets.length; i++) {
            collaterals[i] = Collateral({
                collateralAssetAddress: collateralAssets[i],
                id: i,
                symbol: IERC20Detailed(collateralAssets[i]).symbol()
            });
        }
        return collaterals;
    }

    function getCollateralConfigurationData(address asset)
        external
        view
        returns (
            uint256 decimals,
            uint256 maxLtv,
            uint256 liquidationThreshold,
            uint256 liquidationBonus,
            bool isActive,
            bool isFrozen
            ) {
                IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());

                DataTypes.CollateralConfigurationMap memory configuration =
                    pool.getCollateralConfiguration(asset);

                (maxLtv, liquidationThreshold, decimals, liquidationBonus) =
                    configuration.getParamsMemory();

                (isActive, isFrozen) = configuration.getFlagsMemory();
            }

    function getReserveConfigurationData(uint256 id)
        external
        view
        returns (
            uint256 decimals,
            uint256 issuerFee,
            uint256 investorFee,
            bool isActive,
            bool isFrozen,
            bool isIssuing
            ) {
                IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());

                DataTypes.ReserveConfigurationMap memory configuration =
                    pool.getReserveConfiguration(id);

                decimals = configuration.getParamsMemory();

                issuerFee = configuration.getIssuerFeeMemory();

                investorFee = configuration.getInvestorFeeMemory();

                (isActive, isFrozen, isIssuing) = configuration.getFlagsMemory();
            }

    function getCollateralUnderlyingAssets (address collateralAssetAddress)
        external
        view
        returns (
            address underlyingAssetA,
            address underlyingAssetB
            ) {
                IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());
                DataTypes.CollateralData memory collateralData =
                    pool.getCollateralData(collateralAssetAddress);

                    return (collateralData.underlyingAssetA, collateralData.underlyingAssetB);
            }

    function getCollateralTotalAmount (address collateralAssetAddress)
        external
        view
        returns (
            uint256 collateralTotalAmount
            ) {
                IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());
                DataTypes.CollateralData memory collateralData =
                    pool.getCollateralData(collateralAssetAddress);
                address colTokenAddress = collateralData.colTokenAddress;
                collateralTotalAmount = IERC20(colTokenAddress).totalSupply();

                return collateralTotalAmount;
            }

    function getBondPrice (address asset, uint256 duration, address factory)
        external
        view
        returns (
            uint256 bondPrice
            ) {

                IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());
                uint256 reserveId = pool.getReserveId(asset, duration);

                DataTypes.ReserveData memory reserveData = pool.getReserveData(reserveId);

                address interestTokenAddress = reserveData.interestTokenAddress;

                address pair = IHipoAMMV1Factory(factory).getPair(interestTokenAddress, asset);

                (uint256 amountToken0, uint256 amountToken1, ) = IHipoAMMV1Pair(pair).getReserves();

                bondPrice = WAD.sub(amountToken1.wadDiv(amountToken0));

                return bondPrice;
            }
}
