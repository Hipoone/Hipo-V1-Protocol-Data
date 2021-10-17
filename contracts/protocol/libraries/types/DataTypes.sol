// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;

library DataTypes {

    struct CollateralData {
        CollateralConfigurationMap collateralConfiguration;
        address collateralAsset;
        address colTokenAddress;
        address underlyingAssetA;
        address underlyingAssetB;
        uint256 id;
    }

    struct ReserveData {
        ReserveConfigurationMap reserveConfiguration;
        address asset;
        uint256 bondDuration;
        address hTokenAddress;
        address bondTokenAddress;
        address debtTokenAddress;
        address interestTokenAddress;
        address hipoLpTokenAddress;
        address hipoTreasuryAddress;
        address hipoFeeAddress;
        uint256 id;
    }

    struct Reserve {
        address asset;
        uint256 duration;
    }

    struct CollateralConfigurationMap {
        uint256 data;
    }

    struct ReserveConfigurationMap {
        uint256 data;
    }

    struct IssuerConfigurationMap {
        uint256 data;
    }

    struct InvestorConfigurationMap {
        uint256 data;
    }

}
