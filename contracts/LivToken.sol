// 0.5.1-c8a2
// Enable optimization
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract LivToken is ERC20{

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor () ERC20("LivConect", "LIV") {
        _mint(msg.sender, 20000000 * (10 ** uint256(decimals())));
    }
}