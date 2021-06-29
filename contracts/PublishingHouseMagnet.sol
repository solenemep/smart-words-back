//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./PublicationMagnet.sol";

contract PublishingHouseMagnet is AccessControl {
    using Counters for Counters.Counter;

    address private _director;
    Counters.Counter private _publishingHouseIds;

    PublicationMagnet public publicationMagnet;

    mapping(uint256 => uint256) public priceById;

    bytes32 public constant ADMIN = keccak256("ADMIN");
    bytes32 public constant DIRECTOR = keccak256("DIRECTOR");

    event DirectorChanged(address indexed account);
    event PriceSet(uint256 idPub, uint256 price);
    event Bought(address indexed sender, uint256 idPub);

    constructor(address director_) {
        _setRoleAdmin(ADMIN, ADMIN);
        _setRoleAdmin(DIRECTOR, ADMIN);
        _setupRole(ADMIN, msg.sender);
        _setupRole(DIRECTOR, _director);
        _director = director_;
        publicationMagnet = new PublicationMagnet();
    }

    modifier onlyOwner(uint256 idPub) {
        require(
            publicationMagnet.ownerOf(idPub) == msg.sender,
            "PublicationHouseMagnet : you don't own this publication"
        );
        _;
    }
    modifier notOwner(uint256 idPub) {
        require(
            publicationMagnet.ownerOf(idPub) != msg.sender,
            "PublicationHouseMagnet : you already own this publication"
        );
        _;
    }

    function changeDirector(address director) public onlyRole(ADMIN) {
        revokeRole(DIRECTOR, _director);
        _director = director;
        grantRole(DIRECTOR, _director);
        emit DirectorChanged(director);
    }

    function publish(
        string memory content,
        bytes32 hashContent,
        uint256 uriId
    ) public {
        publicationMagnet.publish(content, hashContent, uriId);
    }

    function setPrice(uint256 idPub, uint256 price) public onlyRole(DIRECTOR) onlyOwner(idPub) {
        priceById[idPub] = price;
        emit PriceSet(idPub, price);
    }

    function buy(uint256 idPub) public payable {
        _buy(msg.sender, msg.value, idPub);
    }

    function _buy(
        address sender,
        uint256 value,
        uint256 idPub
    ) private notOwner(idPub) {
        require(value == priceById[idPub], "PublicationHouseMagnet : Please send the right amount according to price");
        address owner = publicationMagnet.ownerOf(idPub);
        publicationMagnet.transferFrom(owner, sender, idPub);
        emit Bought(sender, idPub);
    }
}
