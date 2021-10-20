//SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;

import {IERC20} from '../dependencies/openzeppelin/contracts/IERC20.sol';

interface IDebtToken is IERC20 {

    event Initialized (
        address indexed underlyingAsset,
        uint256 indexed bondDuration,
        address indexed financingPool,
        uint8 bondTokenDecimals,
        string bondTokenName,
        string bondTokenSymbol,
        bytes params
        );

    event Mint(
        address receiver,
        uint256 amount,
        address collateralAsset,
        uint256 startTimestamp
        );

    function mint(
        address issuer,
        address collateralAsset,
        uint256 amount
        ) external returns (bool, uint256);

    function burn(
        address issuer,
        address collateralAsset,
        uint256 amount,
        uint256 id
        ) external;

    event Burn(
        address issuer,
        address collateralAsset,
        uint256 amount,
        uint256 id
        );

    function getIssuerDebtsList(address issuer) external view returns(uint256[] memory);

    function getDebtData(address issuer, uint256 id) external view returns (uint256, uint256, address);



    function getIssuerDebtsOfCollateral(address issuer, address collateralAsset) external view returns (uint256);
}
