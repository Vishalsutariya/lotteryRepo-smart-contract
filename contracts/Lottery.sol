// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.20 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public players;

    //constructor
    constructor() {
        manager = payable(msg.sender);
    }

    //payable datatype is for when someone wants to pay
    function enter() public payable{
        //It'll check if value is greater than 0.01 ether or else it'll not allow player to enter in lottery
        require(msg.value > .01 ether);

        players.push(payable(msg.sender));
    }

    function random() private view returns (uint) {
        //It'll generate and return pSeudo random number
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    function pickWinner() public restricted {
        
        // require(msg.sender == manager);

        //It'll Generate index within length of player number
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
    }

    modifier restricted() {
        //It'll check if pickWinner function is called by manager or else it'll stop execution
        require(msg.sender == manager);
        _;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
}