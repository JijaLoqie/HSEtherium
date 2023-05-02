// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC.sol";

contract Dimonken is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(_balances[msg.sender] >= amount, "not enough tokens on balance!");

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        uint allowAmount = _allowances[from][to];

        require(_balances[from] >= amount, "not enough tokens on balance!");

        _balances[from] -= amount;
        if (_allowances[from][to] != type(uint256).max) {
            require(allowAmount <= amount, "can't spend this amount of tokens!");
            unchecked {
                _allowances[from][to] -= amount;
            }
        }

        _balances[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        require(spender != address(0), "ERC20: approve from the zero address");
        address owner = msg.sender;
        require(owner != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
}