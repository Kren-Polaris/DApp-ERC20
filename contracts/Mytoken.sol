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
    mapping(address => uint256) public balances;

    event TokenPurchase(address indexed buyer, uint256 amount, uint256 totalPrice);
    event TokenSale(address indexed selller, uint256 amount, uint256 totalPrice);

    constructor() ERC20("MyToken", "MT") {
        owner= msg.sender;
        tokenPrice = 1 * 1 ether; // 1 token= 1 ether(1 dolar)
        totalSupplyLimit = 100; // maximun amount of tokens
        // Token creation
        _mint(owner, totalSupplyLimit* (10 ** uint256(decimals())));
    }

    //Buy tokens
    function buyTokens(uint256 amount) external payable {
    require(amount > 0, 'Amount must be greater than 0');
    uint256 totalPrice = tokenPrice.mul(amount);
    require(msg.value >= totalPrice, "Insufficient funds");

    _transfer(owner, msg.sender, amount);

    emit TokenPurchase(msg.sender, amount, totalPrice);

    // Return change if there is any
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