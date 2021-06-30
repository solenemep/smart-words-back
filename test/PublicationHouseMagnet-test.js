/* eslint-disable comma-dangle */
/* eslint-disable no-unused-expressions */
/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('PublicationHouseMagnet', async function () {
  let PublicationMagnet, publicationMagnet, PublishingHouseMagnet, publishingHouseMagnet, dev, author, alice, bob;

  const CONTENT = 'HOLA';
  const HASH = ethers.utils.id(CONTENT);
  const URI = 'https://www.publication.com/nft/1';
  const PRICE = 2;
  const ADMIN = ethers.utils.id('ADMIN');

  beforeEach(async function () {
    [dev, author, alice, bob] = await ethers.getSigners();
    PublicationMagnet = await ethers.getContractFactory('PublicationMagnet');
    publicationMagnet = await PublicationMagnet.connect(dev).deploy();
    await publicationMagnet.deployed();
    PublishingHouseMagnet = await ethers.getContractFactory('PublishingHouseMagnet');
    publishingHouseMagnet = await PublishingHouseMagnet.connect(dev).deploy(publicationMagnet.address);
    await publishingHouseMagnet.deployed();
  });

  describe('Deployment', async function () {
    it('Sets dev as ADMIN', async function () {
      expect(await publishingHouseMagnet.hasRole(ADMIN, dev.address)).to.be.true;
      expect(await publishingHouseMagnet.hasRole(ADMIN, alice.address)).to.be.false;
    });
    it(`Sets PublicationMagnet address`, async function () {
      expect(await publishingHouseMagnet.publicationMagnet()).to.equal(publicationMagnet.address);
    });
  });
  describe('setPrice', async function () {
    it('Reverts if not owner', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      await expect(publishingHouseMagnet.connect(alice).setPrice(1, PRICE)).to.be.revertedWith(
        "PublishingHouseMagnet : you don't own this publication"
      );
    });
    it('Sets price for a publication', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      await publishingHouseMagnet.connect(author).setPrice(1, PRICE);
      expect(await publishingHouseMagnet.getPriceById(1)).to.equal(PRICE);
    });
    it(`Emits PriceSet event`, async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      expect(await publishingHouseMagnet.connect(author).setPrice(1, PRICE))
        .to.emit(publishingHouseMagnet, 'PriceSet')
        .withArgs(1, PRICE);
    });
  });
  describe('buy', async function () {
    it('Reverts if owner', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      await publishingHouseMagnet.connect(author).setPrice(1, PRICE);
      await expect(publishingHouseMagnet.connect(author).buy(1, { value: PRICE, gasPrice: 0 })).to.be.revertedWith(
        'PublishingHouseMagnet : you already own this publication'
      );
    });
    it('Reverts if value is not equal to price', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      await publishingHouseMagnet.connect(author).setPrice(1, PRICE);
      await expect(publishingHouseMagnet.connect(alice).buy(1, { value: PRICE - 1, gasPrice: 0 })).to.be.revertedWith(
        'PublishingHouseMagnet : Please send the right amount according to price'
      );
    });
    it('Reverts if price has not been set', async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      await expect(publishingHouseMagnet.connect(alice).buy(1, { value: 0, gasPrice: 0 })).to.be.revertedWith(
        'PublishingHouseMagnet : Price has not been set'
      );
    });
    it('Transfers Publication to new owner', async function () {});
    it(`Emits Bought event`, async function () {
      await publicationMagnet.connect(author).publish(CONTENT, HASH, '1');
      await expect(publishingHouseMagnet.connect(author).setPrice(1, PRICE));
      expect(await publishingHouseMagnet.connect(author).setPrice(1, PRICE))
        .to.emit(publishingHouseMagnet, 'PriceSet')
        .withArgs(1, PRICE);
    });
  });
});
