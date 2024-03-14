// Importar los contratos de Truffle Assertions
const { assert } = import('chai');

// Import contract
const MyToken = artifacts.require('MyToken');

contract('MyToken', (accounts) => {
    let myTokenInstance;

  // Before running the test cases, deploy Smart Contract(SC)
  before(async () => {
    myTokenInstance = await MyToken.deployed();
  });

  // Test case to check if the SC is deployed correctly
  it('Should deploy smart contract properly', async () => {
    assert(myTokenInstance.address !== '');
  });

  // Test case to buy tokens
  it('Should allow users to buy tokens', async () => {
    const buyer = accounts[1];
    const amount = 3;
    await myTokenInstance.buyTokens(amount, { from: buyer, value: amount });

    const balance = await myTokenInstance.balanceOf(buyer);
    assert.equal(balance, amount, 'Token balance is incorrect after purchase');
  });

  // Test case to sell tokens
  it('Should allow users to sell tokens', async () => {
    const seller = accounts[1];
    const amount = 3;
    const initialBalance = await myTokenInstance.balanceOf(seller);

    await myTokenInstance.sellTokens(amount, { from: seller });

    const finalBalance = await myTokenInstance.balanceOf(seller);
    assert.equal(finalBalance.toNumber(), initialBalance.toNumber() - amount, 'Token balance is incorrect after sale');
  });
})
