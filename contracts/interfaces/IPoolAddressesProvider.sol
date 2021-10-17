// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;

interface IPoolAddressesProvider {

    function getFinancingPoolCollateralManager() external view returns (address);

    function getAddress(bytes32 id) external view returns (address);

    function setCollateralPoolCollateralManager(address manager) external;

    function getFinancingPool() external view returns (address);

    event CollateralPoolCollateralManagerUpdated(address manager);
}
