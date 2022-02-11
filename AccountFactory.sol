// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Account{
    uint256 public balance;
    address public owner;
    address public bank;

    constructor(address _owner) payable{
        bank = msg.sender;
        owner = _owner;
        balance = _owner.balance;
    }
}


contract AccountFactory{

    Account [] public accounts;
    uint256 public balance;

    function createAccount(address _owner) external payable{
        Account account = new Account{value: 111}(_owner);
        accounts.push(account);
        balance = address(this).balance;
    }  


}