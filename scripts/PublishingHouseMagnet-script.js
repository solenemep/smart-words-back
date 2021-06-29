/* eslint-disable space-before-function-paren */
/* eslint-disable no-undef */
const hre = require('hardhat');
const { deployed } = require('./deployed');
const { getContract } = require('./getContract');

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  const publicationMagnetAddress = await getContract('PublicationMagnet', 'kovan');

  // We get the contract to deploy
  PublishingHouseMagnet = await ethers.getContractFactory('PublishingHouseMagnet');
  publishingHouseMagnet = await PublishingHouseMagnet.deploy(publicationMagnetAddress);
  await publishingHouseMagnet.deployed();

  // Afficher l'adresse de déploiement
  await deployed('PublishingHouseMagnet', hre.network.name, publishingHouseMagnet.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
