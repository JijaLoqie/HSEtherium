// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC.sol";

contract Dimonken is IERC20 {
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowances;

    uint private _totalSupply;

    uint8 private  decimals;
    string private _name;
    string private _symbol;

    constructor() {
        _name = "Dimonken";
        _symbol = "DMNs";
        decimals = 18;
    }
    function _mint(address account, uint amount) external {
        require(account != address(0), "can't mint to the zero address!");

        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

    }

    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint) {
        return _balances[account];
    }

    function transfer(address to, uint amount) public override returns (bool) {
        require(_balances[msg.sender] >= amount, "not enough tokens on balance!");

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint amount) public override returns (bool) {
        uint allowAmount = _allowances[from][to];

        require(_balances[from] >= amount, "not enough tokens on balance!");

        _balances[from] -= amount;
        if (_allowances[from][to] != type(uint).max) {
            require(allowAmount <= amount, "can't spend this amount of tokens!");
            unchecked {
                _allowances[from][to] -= amount;
            }
        }

        _balances[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function approve(address spender, uint amount) public override returns (bool) {
        require(spender != address(0), "ERC20: approve from the zero address");
        address owner = msg.sender;
        require(owner != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint) {
        return _allowances[owner][spender];
    }
}