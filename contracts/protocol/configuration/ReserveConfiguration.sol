// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;

import {DataTypes} from '../types/DataTypes.sol';
import {Errors} from '../helpers/Errors.sol';

library ReserveConfiguration {

    uint256 constant ACTIVE_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF;
    uint256 constant FROZEN_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF;
    uint256 constant ISSUING_MASK =               0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF;
    uint256 constant DECIMALS_MASK =              0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF;
    uint256 constant ISSUER_FEE_MASK =            0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000;
    uint256 constant INVESTOR_FEE_MASK =          0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF;

    uint256 constant INVESTOR_FEE_START_BIT_POSITON = 16;
    uint256 constant RESERVE_DECIMALS_START_BIT_POSITION = 48;
    uint256 constant IS_ACTIVE_START_BIT_POSITION = 56;
    uint256 constant IS_FROZEN_START_BIT_POSITION = 57;
    uint256 constant ISSUING_ENABLED_START_BIT_POSITION = 58;

    uint256 constant MAX_VALID_ISSUER_FEE = 65535;
    uint256 constant MAX_VALID_INVESTOR_FEE = 65535;
    uint256 constant MAX_VALID_DECIMALS = 255;

    function setIssuerFee(DataTypes.ReserveConfigurationMap memory self, uint256 issuerFee) internal pure {
        require(issuerFee <= MAX_VALID_ISSUER_FEE, Errors.RC_INVALID_ISSUER_FEE);

        self.data = (self.data & ISSUER_FEE_MASK) | issuerFee;
    }

    function getIssuerFee(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
        return self.data & (~ISSUER_FEE_MASK);
    }

    function getIssuerFeeMemory(DataTypes.ReserveConfigurationMap memory self) internal pure returns (uint256) {
        return self.data & (~ISSUER_FEE_MASK);
    }

    function setInvestorFee(DataTypes.ReserveConfigurationMap memory self, uint256 investorFee)
        internal
        pure
    {
        require(investorFee <= MAX_VALID_INVESTOR_FEE, Errors.RC_INVALID_INVESTOR_FEE);

        self.data =
            (self.data & INVESTOR_FEE_MASK) |
            (investorFee << INVESTOR_FEE_START_BIT_POSITON);
    }

    function getInvestorFee(DataTypes.ReserveConfigurationMap storage self)
        internal
        view
        returns (uint256)
    {
        return (self.data & ~INVESTOR_FEE_MASK) >> INVESTOR_FEE_START_BIT_POSITON;
    }

    function getInvestorFeeMemory(DataTypes.ReserveConfigurationMap memory self)
        internal
        pure
        returns (uint256)
    {
        return (self.data & ~INVESTOR_FEE_MASK) >> INVESTOR_FEE_START_BIT_POSITON;
    }

    function setDecimals(DataTypes.ReserveConfigurationMap memory self, uint256 decimals)
        internal
        pure
    {
        require(decimals <= MAX_VALID_DECIMALS, "ERROR_INFORMATION");

        self.data = (self.data & DECIMALS_MASK) | (decimals << RESERVE_DECIMALS_START_BIT_POSITION);
    }

    function getDecimals(DataTypes.ReserveConfigurationMap storage self)
        internal
        view
        returns (uint256)
    {
        return (self.data & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION;
    }

    function setActive(DataTypes.ReserveConfigurationMap memory self, bool active) internal pure {
        self.data =
            (self.data & ACTIVE_MASK) |
            (uint256(active ? 1 : 0) << IS_ACTIVE_START_BIT_POSITION);
    }

    function getActive(DataTypes.ReserveConfigurationMap storage self) internal view returns (bool) {
        return(self.data & ~ACTIVE_MASK) != 0;
    }

    function setFrozen(DataTypes.ReserveConfigurationMap memory self, bool frozen) internal pure {
        self.data =
            (self.data & FROZEN_MASK) |
            (uint256(frozen ? 1 : 0) << IS_FROZEN_START_BIT_POSITION);
    }

    function getFrozen(DataTypes.ReserveConfigurationMap storage self) internal view returns (bool) {
        return (self.data & ~FROZEN_MASK) != 0;
    }

    function setIssuingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled)
        internal
        pure
    {
        self.data =
            (self.data & ISSUING_MASK) |
            (uint256(enabled ? 1 : 0) << ISSUING_ENABLED_START_BIT_POSITION);
    }

    function getIssuingEnabled(DataTypes.ReserveConfigurationMap storage self)
        internal
        view
        returns (bool)
    {
        return (self.data & ~ISSUING_MASK) != 0;
    }

    function getFlags(DataTypes.ReserveConfigurationMap storage self) internal view returns (
        bool,
        bool,
        bool
        )
        {
            uint256 dataLocal = self.data;
            return (
                (dataLocal & ~ACTIVE_MASK) != 0,
                (dataLocal & ~FROZEN_MASK) != 0,
                (dataLocal & ~ISSUING_MASK) !=0
                );
    }

    function getParams(
        DataTypes.ReserveConfigurationMap storage self
        ) internal view returns (
            uint256
            ) {
                uint256 dataLocal = self.data;

                return(
                    (dataLocal & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION
                    );
    }

    function getFlagsMemory(DataTypes.ReserveConfigurationMap memory self) internal pure returns (
        bool,
        bool,
        bool
        )
        {
            uint256 dataLocal = self.data;
            return (
                (dataLocal & ~ACTIVE_MASK) != 0,
                (dataLocal & ~FROZEN_MASK) != 0,
                (dataLocal & ~ISSUING_MASK) !=0
                );
    }

    function getParamsMemory(
        DataTypes.ReserveConfigurationMap memory self
        ) internal pure returns (
            uint256
            ) {
                uint256 dataLocal = self.data;

                return(
                    (dataLocal & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION
                    );
    }
}
