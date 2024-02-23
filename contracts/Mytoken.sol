// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//Import of OpenZepelllin libraries
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MyToken is ERC20 {
    using SafeMath for uint256;

    address public owner;
    uint256 public tokenPrice;
    uint256 public totalSupplyLimit;
    mapping(addres => uint256) public balances;

    event TokenPurchase(address indexed buyer, uint256 amount, uint256 totalPrice);
    event TokenSale(addres indexed selller, uint256 amount, uint256 totalPrice);

    constructor() ERC20("MyToken", "MT") {
        owner= msg.sender;
        tokenPrice = 1 * 1 ether; // 1 token= 1 ether(1 dolar)
        totalSupplyLimit = 100; // maximun amount of tokens
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
            payable(msg.sender).transfer(msg.value-totalPrice)
        }
    }

    function sellTokens(uint256 amount) external{
        require(amount>0, "Amount must be greather than 0");
        require(balances[msg.sender]) >= amount
    }
}