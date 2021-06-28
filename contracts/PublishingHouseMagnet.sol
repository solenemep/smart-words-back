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

    bytes32 public constant ADMIN = keccak256("ADMIN");
    bytes32 public constant DIRECTOR = keccak256("DIRECTOR");
    bytes32 public constant AUTHOR = keccak256("AUTHOR");

    event DirectorChanged(address indexed account);

    constructor(address director_) {
        _setRoleAdmin(ADMIN, ADMIN);
        _setRoleAdmin(DIRECTOR, ADMIN);
        _setRoleAdmin(AUTHOR, ADMIN);
        _setupRole(ADMIN, msg.sender);
        _setupRole(DIRECTOR, _director);
        _director = director_;
        publicationMagnet = new PublicationMagnet();
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
    ) public onlyRole(AUTHOR) {
        publicationMagnet.publish(content, hashContent, uriId);
    }
}
