// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {IFinancingPool} from '../../interfaces/IFinancingPool.sol';
import {IPoolAddressesProvider} from '../../interfaces/IPoolAddressesProvider.sol';
import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {DataTypes} from '../libraries/types/DataTypes.sol';

contract WalletDataProvider {

    struct Collateral {
        address collateralAssetAddress;
        uint256 amount;
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
}
