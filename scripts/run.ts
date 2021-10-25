import { ethers } from "hardhat";

async function main() {
  const gameContractFactory = await ethers.getContractFactory("LeagueOfNFTs");
  const gameContract = await gameContractFactory.deploy();
  await gameContract.deployed();
  console.log("Contract deployed to: ", gameContract.address);
}

async function runMain() {
  try {
    await main();
    process.exitCode = 0;
  } catch (error) {
    console.log(error);
    process.exitCode = 1;
  }
}

runMain();
