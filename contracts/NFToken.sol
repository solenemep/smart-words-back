// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract NFToken is ERC721, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _nftIds;

    struct Publication {
        address writer;
        string content;
        uint256 date;
    }
    mapping(uint256 => Publication) private _publication;
    bytes32 public constant CREATOR = keccak256("CREATOR");

    constructor() ERC721("NFToken", "NFT") {
        _setupRole(CREATOR, msg.sender);
    }

    function publish(string memory content) public onlyRole(CREATOR) returns (uint256) {
        _nftIds.increment();
        uint256 currentId = _nftIds.current();
        _mint(msg.sender, currentId);
        _publication[currentId] = Publication(msg.sender, content, block.timestamp);
        return currentId;
    }

    function getPublicationById(uint256 id) public view returns (Publication memory) {
        return _publication[id];
    }

    /* ??
    function getPublicationByWriter(address writer) public view returns (Publication memory){
        return 
    }
    */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
