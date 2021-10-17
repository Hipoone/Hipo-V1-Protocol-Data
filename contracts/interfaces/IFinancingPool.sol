// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {DataTypes} from '../protocol/libraries/types/DataTypes.sol';

interface IFinancingPool {

    function pledge(
        address collateralAsset,
        uint256 collateralAssetAmount
        ) external;

    event Pledge(
        address indexed collateralAsset,
        address indexed issuer,
        uint256 collateralAssetAmount
        );

    function redeem(
        address collateralAsset,
        uint256 collateralAssetAmount
        ) external;

    event Redeem(
        address indexed collateralAsset,
        address indexed issuer,
        uint256 collateralAssetAmount
        );

    function getCollateralData(
        address collateralAsset
        ) external view returns(DataTypes.CollateralData memory);

    event CollateralEnabled(
        address indexed collateralAsset,
        address indexed issuer
        );

    event CollateralDisabled(
        address indexed collateralAsset,
        address indexed issuer
        );

    function initCollateral(
        address collateralAsset,
        address underlyingAssetA,
        address underlyingAssetB,
        address colTokenAddress
        ) external;

    function initReserve(
        address asset,
        address hTokenAddress,
        address bondTokenAddress,
        address debtTokenAddress,
        address interestTokenAddress,
        address hipoLpTokenAddress,
        address hipoTreasuryAddress,
        address hipoFreeAddress,
        uint256 bondDuration,
        uint256 id
        ) external;

    function issue(
        address lpToken,
        address asset,
        uint256 amount, //bonds amount
        uint256 bondDuration
        ) external;

    event Issue(
        address indexed collateralAsset,
        address indexed issuer,
        address indexed bondAsset,
        uint256 bondAmount,
        uint256 bondDuration,
        uint256 interestAmount,
        uint256 startTimestamp
        );

    function repay(
        address collateralAsset,
        address asset,
        uint256 duration,
        uint256 id,
        uint256 amountSent
        ) external;

    event Repay(
        address indexed issuer,
        address collateralAsset,
        address asset,
        uint256 duration,
        uint256 indexed id,
        uint256 amountToRepay
        );


    function removeLiquidity(
        address asset,
        uint256 bondDuration,
        uint256 liquidity
        ) external;

    function purchase(
        address asset,
        uint256 amount,
        uint256 duration
        ) external;

    event Purchase(
        address indexed investor,
        address indexed asset,
        uint256 indexed duration,
        uint256 bondAmount,
        uint256 investorFee,
        uint256 principalAmount,
        uint256 interestAmount
        );

    function withdrawMaturityBonds(
        address asset,
        uint256 duration,
        uint256 id
        ) external;

    event WithdrawMaturityBonds(
        address indexed investor,
        uint256 indexed id,
        address asset,
        uint256 duration,
        uint256 amountToWithdraw
        );

    function withdrawImmaturityBonds(
        address asset,
        uint256 duration,
        uint256 withdrawAmount,
        uint256 id
        ) external;

    function addLiquidity(
        address asset,
        uint256 bondDuration,
        uint256 bondAmount
        ) external;

    event AddLiquidity(
        address indexed asset,
        uint256 bondDuration,
        address indexed liquidityProvider,
        uint256 bondAmount,
        uint256 principalLiquidity,
        uint256 interestLiquidity
        );


    function setReserveConfiguration(
        uint256 id,
        uint256 reserveConfiguration
        ) external;

    function setBondTypes(
        uint256 index,
        uint256 duration
        ) external;

    function getReserveData(
        uint256 id
        ) external view returns(DataTypes.ReserveData memory);

    function getCollateralConfiguration(
        address collateralAsset
        ) external view returns (DataTypes.CollateralConfigurationMap memory);

    function getReserveConfiguration(
        uint256 id
        ) external view returns (DataTypes.ReserveConfigurationMap memory);

    function getReservesList() external view returns (DataTypes.Reserve[] memory);

    event Paused();

    event Unpaused();

    function setPause(bool val) external;

    function paused() external view returns(bool);

    function getCollateralsList() external view returns (address[] memory);

    function setCollateralConfiguration(
        address collateralAsset,
        uint256 collateralConfiguration
        ) external;

    function finalizeTransfer(
        address asset,
        address from,
        address to,
        uint256 amount,
        uint256 balanceFromBefore,
        uint256 balanceToBefore
        ) external;

    function liquidationCall(
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtId,
        uint256 duration,
        uint256 debtToCover
        ) external;

    event LiquidationCall(
        address indexed collateralAsset,
        address indexed debtAsset,
        address indexed issuer,
        uint256 debtToCover,
        uint256 liquidatedCollateralAmount,
        address liquidator
        );

    function liquidationCallToExpiredDebts(
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtId,
        uint256 duration,
        uint256 debtToCover
        ) external;

    event LiquidationCallToExpiredDebts(
        address indexed collateralAsset,
        address indexed debtAsset,
        address indexed issuer,
        uint256 debtToCover,
        uint256 liquidatedCollateralAmount,
        address liquidator
        );
}
