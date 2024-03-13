const { expect } = require("chai");
const { ethers } = require("hardhat");



describe("MyToken", function () {
  let MyToken;
  let myToken;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    MyToken = await ethers.getContractFactory("MyToken");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    myToken = await MyToken.deploy();
    await myToken.deployed();
  });

  it("Should have correct name, symbol, and initial supply", async function () {
    expect(await myToken.name()).to.equal("MyToken");
    expect(await myToken.symbol()).to.equal("MT");
    expect(await myToken.totalSupply()).to.equal(100);
  });

  it("Should allow buying tokens", async function () {
    const amount = 10;
    const totalPrice = 10 * 1 ether; // Assuming token price is 1 ether per token

    await expect(() => owner.sendTransaction({ to: myToken.address, value: totalPrice })).to.changeEtherBalance(owner, -totalPrice);
    await expect(() => myToken.buyTokens(amount)).to.changeTokenBalance(myToken, owner, -amount);
    expect(await myToken.balanceOf(owner.address)).to.equal(amount);
  });

  it("Should allow selling tokens", async function () {
    const amount = 10;
    const totalPrice = 10 * 1 ether; // Assuming token price is 1 ether per token

    await myToken.buyTokens(amount);
    expect(await myToken.balanceOf(owner.address)).to.equal(amount);

    await expect(() => myToken.connect(owner).sellTokens(amount)).to.changeEtherBalance(owner, totalPrice);
    expect(await myToken.balanceOf(owner.address)).to.equal(0);
  });
});