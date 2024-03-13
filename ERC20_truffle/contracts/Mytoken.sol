// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//Import of OpenZepelllin libraries
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

library SafeMath{
    // Substraction
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    // Add
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
        assert(c >= a);
        return c;
    }
    // Multiplicaion
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
        return 0;
    }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
        }
}


contract MyToken is ERC20 {
    using SafeMath for uint256;

    address public owner;
    uint256 public tokenPrice;
    uint256 public totalSupplyLimit;
    mapping(address => uint256) public balances;

    event TokenPurchase(address indexed buyer, uint256 amount, uint256 totalPrice);
    event TokenSale(address indexed selller, uint256 amount, uint256 totalPrice);

    constructor() ERC20("MyToken", "MT") {
        
        owner= msg.sender;
        tokenPrice = 1 * 1 ether; // 1 token= 1 ether(1 dolar)
        totalSupplyLimit = 100 ; // maximun amount of tokens
        // Token creation
        _mint(owner, totalSupplyLimit);
    }

    //Buy tokens
    function buyTokens(uint256 amount) external payable{
        require(amount>0, 'Amount muts be greather than 0');
        require(totalSupply() >= amount, 'Not enough tokens available');
        uint256 totalPrice = tokenPrice.mul(amount);
        require(msg.value >= totalPrice, "Insufficient funds");

        balances[owner] = balances[owner].sub(amount);
        balances[msg.sender] = balances[msg.sender].add(amount);
        emit Transfer(owner, msg.sender,amount);
        emit TokenPurchase(msg.sender, amount, totalPrice);

        //  return change
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
    }

    function sellTokens(uint256 amount) external{
        require(amount>0, "Amount must be greather than 0");
        require(balances[msg.sender] >= amount, "Insufficient token balance");

        uint256 totalPrice= tokenPrice.mul(amount);
        balances[msg.sender]= balances [msg.sender].sub(amount);
        balances[owner]=balances[owner].add(amount);

        emit Transfer(msg.sender, owner, amount);
        emit TokenSale(msg.sender,amount, totalPrice);

        payable(msg.sender).transfer(totalPrice);
    }
}