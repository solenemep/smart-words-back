//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./PublicationMagnet.sol";

contract PublishingHouseMagnet is AccessControl {
    using Counters for Counters.Counter;
    using Address for address payable;

    Counters.Counter private _publishingHouseIds;

    PublicationMagnet private _publicationMagnet;

    mapping(uint256 => uint256) private _priceById;

    bytes32 public constant ADMIN = keccak256("ADMIN");

    event PriceSet(uint256 idPub, uint256 price);
    event Bought(address indexed sender, uint256 idPub);

    constructor(address publicationMagnetAddress) {
        _setRoleAdmin(ADMIN, ADMIN);
        _setupRole(ADMIN, msg.sender);
        _publicationMagnet = PublicationMagnet(publicationMagnetAddress);
    }

    modifier onlyOwner(uint256 idPub) {
        require(
            _publicationMagnet.ownerOf(idPub) == msg.sender,
            "PublishingHouseMagnet : you don't own this publication"
        );
        _;
    }
    modifier notOwner(uint256 idPub) {
        require(
            _publicationMagnet.ownerOf(idPub) != msg.sender,
            "PublishingHouseMagnet : you already own this publication"
        );
        _;
    }

    function setPrice(uint256 idPub, uint256 price) public onlyOwner(idPub) {
        _priceById[idPub] = price;
        emit PriceSet(idPub, price);
    }

    function buy(uint256 idPub) public payable notOwner(idPub) {
        require(
            msg.value == _priceById[idPub],
            "PublishingHouseMagnet : Please send the right amount according to price"
        );
        require(_priceById[idPub] != 0, "PublishingHouseMagnet : Price has not been set");
        address owner = _publicationMagnet.ownerOf(idPub);
        _publicationMagnet.transferFrom(owner, msg.sender, idPub);
        payable(owner).sendValue(msg.value);
        emit Bought(msg.sender, idPub);
    }

    function getPriceById(uint256 idPub) public view returns (uint256) {
        return _priceById[idPub];
    }

    function publicationMagnet() public view returns (PublicationMagnet) {
        return _publicationMagnet;
    }
}
