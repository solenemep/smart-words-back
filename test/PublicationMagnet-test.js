/* eslint-disable comma-dangle */
/* eslint-disable no-unused-expressions */
/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('PublicationMagnet', async function () {
  let PublicationMagnet, publicationMagnet, dev, author, alice, bob;

  const NAME = 'Publication';
  const SYMBOL = 'PUB';
  const AUTHOR = ethers.utils.id('AUTHOR');
  const CONTENT = 'HOLA';
  const URI = 'https://www.nftoken.com/nft/1';
  const HASH = ethers.utils.id(CONTENT);

  beforeEach(async function () {
    [dev, author, admin, alice, bob] = await ethers.getSigners();
    PublicationMagnet = await ethers.getContractFactory('PublicationMagnet');
    publicationMagnet = await PublicationMagnet.connect(author).deploy();
    await publicationMagnet.deployed();
  });

  describe('Deployment', async function () {
    it(`Should have name ${NAME}`, async function () {
      expect(await publicationMagnet.name()).to.equal(NAME);
    });
    it(`Should have symbol ${SYMBOL}`, async function () {
      expect(await publicationMagnet.symbol()).to.equal(SYMBOL);
    });
    it(`Should set author as AUTHOR`, async function () {
      expect(await publicationMagnet.hasRole(AUTHOR, author.address)).to.be.true;
    });
  });

  describe('publish', async function () {
    beforeEach(async function () {
      await publicationMagnet.connect(author).publish(HASH, '1');
    });
    it('Should increase the balance of the author', async function () {
      expect(await publicationMagnet.balanceOf(author.address)).to.equal(1);
    });
    /*
    it(`Should create Publication with current id`, async function () {
      const blockNumber = await ethers.provider.getBlockNumber();
      const block = await ethers.provider.getBlock(blockNumber);
      const blockTimestamp = block.timestamp;
      expect(await publicationMagnet.getPublicationById(1).to.equal(??);
    });
    */
    it('Should attach author to Publication', async function () {
      expect(await publicationMagnet.ownerOf(1)).to.equal(author.address);
    });
    it('Should attach URI to Publication', async function () {
      expect(await publicationMagnet.tokenURI(1)).to.equal(URI);
    });
    it(`Should emit Published event`, async function () {
      await expect(publicationMagnet.connect(author).publish(HASH, '1'))
        .to.emit(publicationMagnet, 'Published')
        .withArgs(author.address, '1');
    });
  });
});
