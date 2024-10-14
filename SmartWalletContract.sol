//SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

contract Consumer {
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable {

    }
}

contract SmartContractWallet {
    address payable public  owner;

    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;

    mapping(address => bool) public guardians;
    address payable nextOwner;
    mapping(address => mapping(address => bool)) nextOwnerGuardianVotedBool;
    uint guardiansResetCount;
    uint public constant conformationsFromGaurdiansForReset = 3;

    constructor() {
        owner = payable(msg.sender);
    }

    function setGaurdian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner, "You are not the owner, Aborting!");
        guardians[_guardian] = _isGuardian;
    }

    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], "You are not the guardian of this wallet, Aborting!");
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] == false, "You alredy voted, Aborting!");
        if(_newOwner != nextOwner) {
            nextOwner = _newOwner;
            guardiansResetCount = 0;
        }

        guardiansResetCount++;

        if(guardiansResetCount >= conformationsFromGaurdiansForReset) {
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    function setAllAllowance(address _for, uint _amount) public {
        require(msg.sender == owner, "You are not the owner, Aborting!");
        allowance[_for] = _amount;

        if(_amount > 0) {
            isAllowedToSend[_for] = true;
        } else {
            isAllowedToSend[_for] = false;
        }
    }

    function transfer(address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory)  {
       // require(msg.sender == owner, "You are not the owner, aborting!");
       if(msg.sender != owner) {
        require(isAllowedToSend[msg.sender], "You are not allowed to send anything from this smart comtract, Abortig!");
        require(allowance[msg.sender] >= _amount, "You are trying to send more than you are allowed to, Aborting!");
        allowance[msg.sender] -= _amount;
       }
        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success, "Aborting, call was not successful");
        return returnData;
    }

    receive() external payable { }
}