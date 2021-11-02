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
    [70, 35, 30],
    "Rift Herald",
    "https://static.wikia.nocookie.net/leagueoflegends/images/5/54/Rift_Herald_Render.png/revision/latest/scale-to-width-down/699?cb=20190806000114",
    10000,
    600,
    50
  );
  await gameContract.deployed();
  console.log("Contract deployed to: ", gameContract.address);

  let txn = await gameContract.mintCharacterNFT(2);
  await txn.wait();

  txn = await gameContract.attackBoss();
  await txn.wait();

  txn = await gameContract.attackBoss();
  await txn.wait();

  const returnedTokenUri = await gameContract.tokenURI(1);
  console.log("Token URI: ", returnedTokenUri);
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
