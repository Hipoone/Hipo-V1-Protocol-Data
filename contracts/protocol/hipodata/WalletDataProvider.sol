// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {IFinancingPool} from '../../interfaces/IFinancingPool.sol';
import {IPoolAddressesProvider} from '../../interfaces/IPoolAddressesProvider.sol';
import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {DataTypes} from '../libraries/types/DataTypes.sol';
import {IDebtToken} from '../../interfaces/IDebtToken.sol';

contract WalletDataProvider {

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

    function getIssuerDebtsData(uint256 reserveId, address user)
        view
        external
        returns(IssuerDebt[] memory) {

            IFinancingPool pool = IFinancingPool(ADDRESSES_PROVIDER.getFinancingPool());

            DataTypes.ReserveData memory reserveData;

            reserveData = pool.getReserveData(reserveId);

            address debtTokenAddress = reserveData.debtTokenAddress;

            uint256[] memory issuerDebtsIds = IDebtToken(debtTokenAddress).getIssuerDebtsList(user);

            IssuerDebt[] memory issuerDebts = new IssuerDebt[](issuerDebtsIds.length);

            if(issuerDebtsIds.length == 0) {
                return issuerDebts;
            }

            for (uint256 j = 0; j < issuerDebtsIds.length; j++) {
                (uint256 startTimestamp, uint256 amount, address collateralAsset) =
                    IDebtToken(debtTokenAddress).getDebtData(user, issuerDebtsIds[j]);
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

}
