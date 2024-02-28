import { ethers } from "hardhat";

async function main() {


  const EmaxNft= await ethers.deployContract("EmaxNftToken");

  await EmaxNft.waitForDeployment();

  const SocialMediaFactory= await ethers.deployContract("SocialMediaFactory",[EmaxNft.target]);

  await SocialMediaFactory.waitForDeployment();

  const EmaxSocialRoomNFT= await ethers.deployContract("EmaxSocialRoomNFT",[SocialMediaFactory.target]);

  await EmaxSocialRoomNFT.waitForDeployment();

  console.log( "THE CONTRACT ADDRESS OF THE NFT_TOKEN",  EmaxNft.target);
  console.log( "THE CONTRACT ADDRESS OF THE FACTORY ",  SocialMediaFactory.target);
  console.log( "THE CONTRACT ADDRESS OF THE SOCIAL MEDIA",  EmaxSocialRoomNFT.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.

// }
// ➜  project3Project git:(main) ✗ npx hardhat run scripts/deploy.ts --network mumbai
// THE CONTRACT ADDRESS OF THE NFT_TOKEN 0x7a2b674a87375d00c250772A311FB027f0366C14
// THE CONTRACT ADDRESS OF THE FACTORY  0xc2b9E8eC0eB83aCBA2Df9472bEC66284Bc6D87cd
// THE CONTRACT ADDRESS OF THE SOCIAL MEDIA 0x4F1d3d148696d361671cCF2F435683758e992926
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
