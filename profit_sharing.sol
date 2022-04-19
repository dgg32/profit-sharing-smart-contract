// SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.5.0 <0.9.0;

contract Profit_sharing {
    mapping(address => uint) public partners_shares;
    mapping(address => uint) public partners_income;
    address [] public partners;
    uint total_share;

    address public manager; 


    constructor () {
        manager = msg.sender; 
    }

    receive () payable external {

        for (uint i; i < partners.length; ++i)
        {
            uint share = partners_shares[partners[i]];
            partners_income[partners[i]] += msg.value * share / total_share;
        }
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function get_total_share() public view returns(uint){
        return total_share;
    }


    function getBalance() public view returns(uint){
        return address(payable(msg.sender)).balance;
    }

    function modify_partners (address partner, uint share) public {
        require(msg.sender == manager);
        require(share >= 1);
        if (partners_shares[partner] > 0)
        {
            total_share -= partners_shares[partner];
            total_share += share;
            partners_shares[partner] = share;
        }
        else
        {
            total_share += share;
            partners_shares[partner] = share;
            partners.push(partner);
            partners_income[partner] = 0;
        }
        
    }

    function claim_share () public payable {
        address payable recipient = payable(msg.sender);
        uint amount = partners_income[msg.sender];
        partners_income[msg.sender] = 0;
        recipient.transfer(amount);
    }

    
}
