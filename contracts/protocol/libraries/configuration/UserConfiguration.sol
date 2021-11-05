// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;

import {DataTypes} from '../types/DataTypes.sol';
import {Errors} from '../helpers/Errors.sol';

library UserConfiguration {

    uint256 internal constant ISSUING_MASK =      0x0001000100010001000100010001000100010001000100010001000100010001;
    uint256 internal constant ISSUING_BOND_MASK = 0x0000000000000000000000000000000000000000000000000000000000003FFC;

    function setIssuing(
        DataTypes.IssuerConfigurationMap storage self,
        uint256 collateralIndex,
        bool issuing
        ) internal {
        require(collateralIndex < 16, Errors.UL_INVALID_INDEX);
        self.data =((self.data & ~(1 << (collateralIndex * 16))) |
        (uint256(issuing ? 1:0) << (collateralIndex * 16)));
    }

    function setUsingAsCollateral(
        DataTypes.IssuerConfigurationMap storage self,
        uint256 collateralIndex,
        bool usingAsCollateral
        ) internal {
        require(collateralIndex < 16, Errors.UL_INVALID_INDEX);
        self.data = ((self.data & ~(1 << (collateralIndex * 16 + 1))) |
        (uint256(usingAsCollateral ? 1:0) << (collateralIndex * 16 + 1)));
    }

    function isIssuingAny(DataTypes.IssuerConfigurationMap memory self) internal pure returns (bool) {
        return self.data & ISSUING_MASK != 0;
    }

    function isIssuingBond(
        DataTypes.IssuerConfigurationMap memory self,
        uint256 collateralIndex
        ) internal pure returns (bool) {
            require(collateralIndex < 16, Errors.UL_INVALID_INDEX);
            return (self.data & (ISSUING_BOND_MASK << (collateralIndex * 16))) != 0;
    }

    function isIssuing(
        DataTypes.IssuerConfigurationMap memory self,
        uint256 collateralIndex
        ) internal pure returns (bool) {
            require(collateralIndex < 16, Errors.UL_INVALID_INDEX);
            return ((self.data & (1 << (collateralIndex * 16))) != 0);
    }

    function isUsingAsCollateral(
        DataTypes.IssuerConfigurationMap memory self,
        uint256 collateralIndex
        ) internal pure returns (bool) {
            require(collateralIndex < 16, Errors.UL_INVALID_INDEX);
            return ((self.data & (1 << (collateralIndex * 16 + 1))) != 0);
    }

    function isUsingAsCollateralOrIssuing(
        DataTypes.IssuerConfigurationMap memory self,
        uint256 collateralIndex
        ) internal pure returns (bool) {
            require(collateralIndex < 16, "COLP_UL_INVALID_INDEX");
            return (self.data >> (collateralIndex * 16)) & 3 != 0;
        }

    function isEmpty(DataTypes.IssuerConfigurationMap memory self) internal pure returns(bool) {
        return self.data == 0;
    }

    function getBondIssuingFlag(
        DataTypes.IssuerConfigurationMap memory self,
        uint256 collateralIndex,
        uint256 reserveIndex
        ) internal pure returns(
            bool
            ) {
                require(collateralIndex < 16, Errors.UL_INVALID_INDEX);
                require(reserveIndex < 24, Errors.UL_INVALID_INDEX);
                if(reserveIndex < 6) {
                    return ((self.data & (1 << (collateralIndex * 16 + reserveIndex + 2))) != 0);
                }

                if(reserveIndex > 5) {
                    return ((self.data & (1 << (collateralIndex * 16 + reserveIndex + 2 - collateralIndex * 6))) != 0);
                }
            }

    function setBondIssuingFlag(
        DataTypes.IssuerConfigurationMap storage self,
        uint256 collateralIndex,
        uint256 reserveIndex,
        bool bondIssuing
        ) internal {
            require(collateralIndex < 16, Errors.UC_INVALID_INDEX);
            require(reserveIndex < 24, Errors.UC_INVALID_INDEX);
            if(reserveIndex < 6) {
                self.data = ((self.data & ~(1 << (collateralIndex * 16 + reserveIndex + 2))) |
                (uint256(bondIssuing ? 1:0) << (collateralIndex * 16 + reserveIndex + 2)));
            }

            if(reserveIndex > 5) {
                self.data =((self.data & ~(1 << (collateralIndex * 16 + reserveIndex + 2 - collateralIndex * 6))) |
                (uint256(bondIssuing ? 1:0) << (collateralIndex * 16 + reserveIndex + 2 - collateralIndex * 6)));
            }
        }
}
