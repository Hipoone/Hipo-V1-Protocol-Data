// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;

import {DataTypes} from '../types/DataTypes.sol';

library CollateralConfiguration {

    uint256 constant ACTIVE_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF;
    uint256 constant FROZEN_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF;
    uint256 constant BORROWING_MASK =             0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF;

    uint256 constant LTV_MASK =                   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000;
    uint256 constant LIQUIDATION_THRESHOLD_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF;
    uint256 constant LIQUIDATION_BONUS_MASK =     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFF;
    uint256 constant DECIMALS_MASK =              0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF;

    uint256 constant LIQUIDATION_THRESHOLD_START_BIT_POSITON = 16;
    uint256 constant LIQUIDATION_BONUS_START_BIT_POSITION = 32;
    uint256 constant COLLATERAL_DECIMALS_START_BIT_POSITION = 48;
    uint256 constant IS_ACTIVE_START_BIT_POSITION = 56;
    uint256 constant IS_FROZEN_START_BIT_POSITION = 57;
    uint256 constant BORROWING_ENABLED_START_BIT_POSITION = 58;

    uint256 constant MAX_VALID_LTV = 65535;
    uint256 constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
    uint256 constant MAX_VALID_LIQUIDATION_BONUS = 65535;
    uint256 constant MAX_VALID_DECIMALS = 255;

    function setMaxLtv(DataTypes.CollateralConfigurationMap memory self, uint256 maxLtv) internal pure {
        require(maxLtv <= MAX_VALID_LTV, "ERROR_INFORMATION");

        self.data = (self.data & LTV_MASK) | maxLtv;
    }

    function getMaxLtv(DataTypes.CollateralConfigurationMap storage self) internal view returns (uint256) {
        return self.data & ~LTV_MASK;
    }

    function setLiquidationThreshold(DataTypes.CollateralConfigurationMap memory self, uint256 threshold)
        internal
        pure
    {
        require(threshold <= MAX_VALID_LIQUIDATION_THRESHOLD, "ERROR_INFORMATION");

        self.data =
            (self.data & LIQUIDATION_THRESHOLD_MASK) |
            (threshold << LIQUIDATION_THRESHOLD_START_BIT_POSITON);
    }

    function getLiquidationThreshold(DataTypes.CollateralConfigurationMap storage self)
        internal
        view
        returns (uint256)
    {
        return (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITON;
    }

    function setLiquidationBonus(DataTypes.CollateralConfigurationMap memory self, uint256 bonus)
        internal
        pure
    {
        require(bonus <= MAX_VALID_LIQUIDATION_BONUS, "ERROR_INFORMATION");

        self.data =
            (self.data & LIQUIDATION_BONUS_MASK) |
            (bonus << LIQUIDATION_BONUS_START_BIT_POSITION);
    }

    function getLiquidationBonus(DataTypes.CollateralConfigurationMap storage self)
        internal
        view
        returns (uint256)
    {
        return (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
    }

    function setDecimals(DataTypes.CollateralConfigurationMap memory self, uint256 decimals)
        internal
        pure
    {
        require(decimals <= MAX_VALID_DECIMALS, "ERROR_INFORMATION");

        self.data = (self.data & DECIMALS_MASK) | (decimals << COLLATERAL_DECIMALS_START_BIT_POSITION);
    }

    function getDecimals(DataTypes.CollateralConfigurationMap storage self)
        internal
        view
        returns (uint256)
    {
        return (self.data & ~DECIMALS_MASK) >> COLLATERAL_DECIMALS_START_BIT_POSITION;
    }

    function setActive(DataTypes.CollateralConfigurationMap memory self, bool active) internal pure {
        self.data =
            (self.data & ACTIVE_MASK) |
            (uint256(active ? 1 : 0) << IS_ACTIVE_START_BIT_POSITION);
    }

    function getActive(DataTypes.CollateralConfigurationMap storage self) internal view returns (bool) {
        return(self.data & ~ACTIVE_MASK) != 0;
    }

    function setFrozen(DataTypes.CollateralConfigurationMap memory self, bool frozen) internal pure {
        self.data =
            (self.data & FROZEN_MASK) |
            (uint256(frozen ? 1 : 0) << IS_FROZEN_START_BIT_POSITION);
    }

    function getFrozen(DataTypes.CollateralConfigurationMap storage self) internal view returns (bool) {
        return (self.data & ~FROZEN_MASK) != 0;
    }

    function getFlags(DataTypes.CollateralConfigurationMap storage self) internal view returns (
        bool,
        bool
        )
        {
            uint256 dataLocal = self.data;
            return (
                (dataLocal & ~ACTIVE_MASK) != 0,
                (dataLocal & ~FROZEN_MASK) != 0
                );
    }

    function getParams(
        DataTypes.CollateralConfigurationMap storage self
        ) internal view returns (
            uint256,
            uint256,
            uint256
            ) {
                uint256 dataLocal = self.data;

                return(
                    dataLocal & ~LTV_MASK,
                    (dataLocal & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITON,
                    (dataLocal & ~DECIMALS_MASK) >> COLLATERAL_DECIMALS_START_BIT_POSITION
                    );
    }

    function getLiquidationBonusParams(
        DataTypes.CollateralConfigurationMap storage self
        ) internal view returns (
            uint256
            ) {
                uint256 dataLocal = self.data;

                return(
                    (dataLocal & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION
                    );
    }

    function getParamsMemory(
        DataTypes.CollateralConfigurationMap memory self
        ) internal pure returns (
            uint256,
            uint256,
            uint256,
            uint256
            ) {
                uint256 dataLocal = self.data;

                return(
                    dataLocal & ~LTV_MASK,
                    (dataLocal & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION,
                    (dataLocal & ~DECIMALS_MASK) >> COLLATERAL_DECIMALS_START_BIT_POSITION,
                    (dataLocal & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION
                    );
    }

    function getFlagsMemory(DataTypes.CollateralConfigurationMap memory self) internal pure returns (
        bool,
        bool
        )
        {
            uint256 dataLocal = self.data;
            return (
                (dataLocal & ~ACTIVE_MASK) != 0,
                (dataLocal & ~FROZEN_MASK) != 0
                );
    }
}
