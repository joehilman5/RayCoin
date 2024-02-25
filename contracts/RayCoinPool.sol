// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract RayCoinPool {

    address public owner;
    IERC20 rayCoin;

    uint256 public price = 20000000;
    uint256 public payBack = 10000000;

    constructor(IERC20 _rayCoin) {
        owner = msg.sender;
        rayCoin = _rayCoin;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only Owner Can Call this Function");
        _;
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
    }

    function setPayBack(uint256 _payBack) public onlyOwner {
        payBack = _payBack;
    }

    function buyRayCoin() public payable {
        require(msg.value >= price, "Not Enough Money Sent");
        uint256 calcCoins = msg.value / price;
        rayCoin.transfer(msg.sender, calcCoins * 10 ** 18);
        
    }

    //NEEDS APPROVAL OR WONT WORK
    function sellRayCoin(uint256 _tokens) public {
        uint256 calcCoin = _tokens / (10 ** 18);
        uint256 etherBack = calcCoin * payBack;
        bool success = rayCoin.transferFrom(msg.sender, address(this), _tokens);
        require(success, "RayCoins did not transfer");
        (bool sent, ) = payable(msg.sender).call{value: etherBack}("");
        require(sent, "Ether Did Not send");
    }

    function payOut() public onlyOwner {
        (bool sent, ) = payable(owner).call{value: getContractBalance()}("");
        require(sent, "Ether Did not Send");
    }

    function getContractBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function sendOut() public onlyOwner {
        rayCoin.transfer(owner, rayCoin.balanceOf(address(this)));
    }

    receive() external payable { }

}