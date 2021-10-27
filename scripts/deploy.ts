import { ethers } from "hardhat";

async function main() {
  const gameContractFactory = await ethers.getContractFactory("LeagueOfNFTs");
  const gameContract = await gameContractFactory.deploy(
    ["Galio", "Jinx", "Jhin"],
    [
      "https://rerollcdn.com/characters/Skin/6/Galio.png",
      "https://rerollcdn.com/characters/Skin/6/Jinx.png",
      "https://rerollcdn.com/characters/Skin/6/Jhin.png",
    ],
    [1800, 888, 700],
    [150, 88, 90],
    [650000000, 1100000000, 900000000],
    [70, 35, 30]
  );
  await gameContract.deployed();
  console.log("Contract deployed to: ", gameContract.address);

  let txn;
  txn = await gameContract.mintCharacterNFT(0);
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #2");

  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait();
  console.log("Minted NFT #3");

  console.log("Done deploying and minting!");
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
