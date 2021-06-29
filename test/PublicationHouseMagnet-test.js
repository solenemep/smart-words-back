/* eslint-disable comma-dangle */
/* eslint-disable no-unused-expressions */
/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('PublicationHouseMagnet', async function () {
  let PublicationMagnet,
    publicationMagnet,
    PublicationHouseMagnet,
    publicationHouseMagnet,
    dev,
    author,
    director,
    alice,
    bob;

  const NAME = 'Publication';
  const SYMBOL = 'PUB';
  const AUTHOR = ethers.utils.id('AUTHOR');
  const CONTENT = 'HOLA';
  const HASH = ethers.utils.id(CONTENT);
  const URI = 'https://www.publication.com/nft/1';

  beforeEach(async function () {
    [dev, author, admin, alice, bob] = await ethers.getSigners();
    PublicationMagnet = await ethers.getContractFactory('PublicationMagnet');
    publicationMagnet = await PublicationMagnet.connect(author).deploy();
    await publicationMagnet.deployed();
    PublicationHouseMagnet = await ethers.getContractFactory('PublicationHouseMagnet');
    publicationHouseMagnet = await PublicationHouseMagnet.connect(author).deploy(director.address);
    await publicationMagnet.deployed();
  });

  describe('Deployment', async function () {});
  describe('changeDirector', async function () {});
  describe('publish', async function () {});
  describe('setPrice', async function () {});
  describe('buy', async function () {});
});
