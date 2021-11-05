// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;

library Errors {

    string public constant VL_NO_ACTIVE_COLLATERAL_OR_RESERVE = '2'; // 'Action requires an active reserve'
    string public constant LPCM_LTV_NOT_ABOVE_THRESHOLD = '42'; // 'Health factor is not below the threshold'
    string public constant LPCM_COLLATERAL_CANNOT_BE_LIQUIDATED = '43'; // 'The collateral chosen cannot be liquidated'
    string public constant LPCM_SPECIFIED_CURRENCY_NOT_BORROWED_BY_ISSUER = '44'; // 'User did not borrow the specified currency'
    string public constant LPCM_NO_ERRORS = '46'; // 'No errors'
    string public constant LPCM_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = '45'; // "There isn't enough liquidity available to liquidate"
    string public constant VL_NO_ACTIVE_RESERVE = '2'; // 'Action requires an active reserve'
    string public constant VL_RESERVE_FROZEN = '3'; // 'Action cannot be performed because the reserve is frozen'
    string public constant VL_ISSUING_NOT_ENABLED = '7'; // 'Borrowing is not enabled'
    string public constant VL_INVALID_AMOUNT = '1'; // 'Amount must be greater than 0'
    string public constant VL_INVALID_COLLATERAL_ASSET = '99'; // 'Amount must be greater than 0'
    string public constant VL_NO_ACTIVE_COLLATERAL = '98'; // 'Amount must be greater than 0'
    string public constant VL_COLLATERAL_FROZEN = '97'; // 'Amount must be greater than 0'
    string public constant COLP_NOT_CONTRACT = '78';
    string public constant COLP_COLLATERAL_ALREADY_INITIALIZED = '96'; // 'Reserve has already been initialized'
    string public constant COLP_NO_MORE_COLLATERALS_ALLOWED = '65';
    string public constant FP_LIQUIDATION_CALL_FAILED = '23'; // 'Liquidation call failed'
    string public constant VL_NOT_ENOUGH_AVAILABLE_COLLATERAL_BALANCE = '5'; // 'User cannot withdraw more than the available balance'
    string public constant VL_ISSUER_REDEEM_NOT_ALLOWED = '95'; // 'User cannot withdraw more than the available balance'
    string public constant COLP_CALLER_MUST_BE_AN_COLTOKEN = '63';
    string public constant COLT_INVALID_BURN_AMOUNT = '58'; //invalid amount to burn
    string public constant COLT_INVALID_MINT_AMOUNT = '56'; //invalid amount to mint
    string public constant COLT_INVALID_ADDRESS = '94'; //invalid amount to mint
    string public constant COLP_IS_PAUSED = '101'; // 'Pool is paused'
    string public constant FP_IS_PAUSED = '64'; // 'Pool is paused'
    string public constant FP_ISSUER_NOT_PAY_ENOUGH_INTERESTS = '93';
    string public constant VL_ISSUER_NOT_ENOUGH_COLLATERALS = '92'; // 'User cannot withdraw more than the available balance'
    string public constant VL_NOT_SUPPORTED_ASSET = '91'; // 'User cannot withdraw more than the available balance'
    string public constant VL_BOND_NOT_EXIST = '90'; // 'User cannot withdraw more than the available balance'
    string public constant MATH_MULTIPLICATION_OVERFLOW = '48';
    string public constant MATH_DIVISION_BY_ZERO = '50';
    string public constant MATH_ADDITION_OVERFLOW = '49';
    string public constant LPTK_CALLER_MUST_BE_FINANCING_POOL = '89';
    string public constant LPTK_INVALID_MINT_AMOUNT = '88';
    string public constant LPTK_INVALID_BURN_AMOUNT = '87';
    string public constant LPTK_INVALID_ADDRESS = '86'; //invalid amount to mint
    string public constant DEBTTK_DEBT_ID_IS_EXIST = '102';
    string public constant DEBTTK_INVALID_MINT_AMOUNT = '103';
    string public constant DEBTTK_INVALID_ADDRESS = '104';
    string public constant DEBTTK_INVALID_DEBT_TOKEN_AMOUNT = '105';
    string public constant COLT_CALLER_MUST_BE_FINANCING_POOL = '106';
    string public constant INTTK_CALLER_MUST_BE_FINANCING_POOL = '107';
    string public constant INTTK_INVALID_MINT_AMOUNT = '108';
    string public constant INTTK_INVALID_ADDRESS = '109';
    string public constant INTTK_INVALID_BURN_AMOUNT = '110';
    string public constant HTK_INVALID_MINT_AMOUNT = '111';
    string public constant HTK_CALLER_MUST_BE_FINANCING_POOL = '112';
    string public constant HTK_INVALID_ADDRESS = '113';
    string public constant HTK_INVALID_BURN_AMOUNT = '114';
    string public constant FP_INVALID_RESERVE = '115';
    string public constant FP_ALLOWANCE_SHOULD_BE_ZERO = '116';
    string public constant VL_INVALID_HIPO_TREASURY_ADDRESS = '117';
    string public constant VL_REPAYMENT_AMOUNT_EXCEEDS_DEBTS = '118';
    string public constant FP_NOT_ALL_INTEREST_TOKENS_ARE_SOLD = '119';
    string public constant VL_INVALID_HTOKEN_ADDRESS = '120';
    string public constant VL_INVALID_PURCHASE_AMOUNT = '121';
    string public constant BONDTK_INVALID_BOND_TOKEN_AMOUNT = '122';
    string public constant BONDTK_BOND_TOKEN_NOT_ENOUGH_BALANCE = '123';
    string public constant RL_RESERVE_ALREADY_INITIALIAED = '124';
    string public constant RL_NOT_CONTRACT = '125';
    string public constant CL_NOT_CONTRACT = '126';
    string public constant CL_RESERVE_ALREADY_INITIALIAED = '127';
    string public constant VL_COLLATERAL_ASSET_BALANCE_NOT_ENOUGH = '128';
    string public constant UL_INVALID_INDEX = '129';
    string public constant BONDTK_INVALID_BOND_TOKEN_ID = '130';
    string public constant BONDTK_INVALID_ADDRESS = '131';
    string public constant DEBTTK_INVALID_DEBT_TOKEN_ID = '132';
    string public constant BASETK_CALLER_MUST_BE_FINANCING_POOL = '133';
    string public constant VL_IMMATURITY_BOND = '134';
    string public constant FP_INVALID_COLLATERAL_ASSET = '135';
    string public constant FP_NOT_ENOUGH_LIQUIDITY = '136';
    string public constant VL_NOT_ENOUGH_RESERVE = '137';
    string public constant LQ_INVALID_COLLATERAL_ASSET = '138';
    string public constant LQ_INVALID_RESERVE = '139';
    string public constant VL_INVALID_RESERVE = '140';
    string public constant RC_INVALID_ISSUER_FEE = '141';
    string public constant RC_INVALID_INVESTOR_FEE = '142';
    string public constant VL_MATURITY_BOND = '143';
    string public constant LPCM_DEBTS_NOT_EXPIRED = '144';
    string public constant UC_INVALID_INDEX = '145';
    string public constant RC_INVALID_INITIAL_SWAP_RATIO = '146';
    string public constant RL_TREASURY_NOT_ENOUGH_BALANCE = '147';
    string public constant IC_INVALID_INDEX = '148';
    string public constant CC_INVALID_LTV = '149';
    string public constant CC_INVALID_THRESHOLD = '150';
    string public constant CC_INVALID_BONUS = '151';
    string public constant CC_INVALID_DECIMALS = '152';
    string public constant RC_INVALID_DECIMALS = '153';

    enum CollateralManagerErrors {
        NO_ERROR,
        NO_COLLATERAL_AVAILABLE,
        COLLATERAL_CANNOT_BE_LIQUIDATED,
        CURRRENCY_NOT_BORROWED,
        LTV_BELOW_THRESHOLD,
        NOT_ENOUGH_LIQUIDITY,
        NO_ACTIVE_COLLATERAL_OR_RESERVE,
        HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
        INVALID_EQUAL_ASSETS_TO_SWAP,
        FROZEN_RESERVE,
        DEBTS_NOT_EXPIRED
    }
}
