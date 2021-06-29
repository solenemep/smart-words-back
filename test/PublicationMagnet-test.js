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
  const CONTENT = 'HOLA';
  const HASH = ethers.utils.id(CONTENT);
  const URI = 'https://www.publication.com/nft/1';

  beforeEach(async function () {
    [dev, author, alice, bob] = await ethers.getSigners();
    PublicationMagnet = await ethers.getContractFactory('PublicationMagnet');
    publicationMagnet = await PublicationMagnet.connect(dev).deploy();
    await publicationMagnet.deployed();
  });

  describe('Deployment', async function () {
    it(`Should have name ${NAME}`, async function () {
      expect(await publicationMagnet.name()).to.equal(NAME);
    });
    it(`Should have symbol ${SYMBOL}`, async function () {
      expect(await publicationMagnet.symbol()).to.equal(SYMBOL);
    });
  });

  describe('publish', async function () {
    it('Should revert if hashContent already exists', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      await expect(publicationMagnet.connect(author).publish(CONTENT, HASH, '1')).to.be.revertedWith(
        'PublicationMagnet : this content has already been published'
      );
    });
    it('Should increase the balance of the author', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      expect(await publicationMagnet.balanceOf(author.address)).to.equal(1);
    });
    /*
    it(`Should create Publication with current id`, async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      const blockNumber = await ethers.provider.getBlockNumber();
      const block = await ethers.provider.getBlock(blockNumber);
      const blockTimestamp = block.timestamp;
      expect(await publicationMagnet.getPublicationById(1).to.equal(Publication(...));
    });
    */
    it('Should link id to hash', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      expect(await publicationMagnet.getIdByHash(HASH)).to.equal(1);
    });
    /*
    it('Should link Publication to id', async function () {
      expect(await publicationMagnet.getPublicationById(1)).to.equal(Publication(...));
    });
*/
    it('Should attach author to Publication', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      expect(await publicationMagnet.ownerOf(1)).to.equal(author.address);
    });
    it('Should attach URI to Publication', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      expect(await publicationMagnet.tokenURI(1)).to.equal(URI);
    });
    it(`Should emit Published event`, async function () {
      await expect(publicationMagnet.connect(author).publish(CONTENT, HASH, '1'))
        .to.emit(publicationMagnet, 'Published')
        .withArgs(author.address, CONTENT);
    });
  });
});
