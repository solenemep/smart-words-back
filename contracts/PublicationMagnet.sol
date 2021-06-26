// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract PublicationMagnet is ERC721Enumerable, ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;
    using Strings for uint256;

    struct Publication {
        bytes32 content;
        uint256 date;
    }
    Counters.Counter private _nftIds;
    mapping(uint256 => Publication) private _publication;
    bytes32 public constant AUTHOR = keccak256("AUTHOR");

    event Published(address indexed writer, uint256 uriId);

    constructor() ERC721("Publication", "PUB") {
        _setupRole(AUTHOR, msg.sender);
    }

    function publish(bytes32 content, uint256 uriId) public onlyRole(AUTHOR) returns (uint256) {
        _nftIds.increment();
        uint256 currentId = _nftIds.current();
        _mint(msg.sender, currentId);
        _setTokenURI(currentId, uriId.toString());
        _publication[currentId] = Publication(content, block.timestamp);
        emit Published(msg.sender, uriId);
        return currentId;
    }

    function getPublicationById(uint256 id) public view returns (Publication memory) {
        return _publication[id];
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721Enumerable, ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721URIStorage, ERC721) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721URIStorage, ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _baseURI() internal view virtual override(ERC721) returns (string memory) {
        return "https://www.nftoken.com/nft/";
    }
}

/* getPublicationByWriter
    BalanceOf (own) > num
    tokenOfOwnerByIndex ( 0, 1, ..., num-1 ) > (id1, id2, ..., idnum-1)
    getPublicationById (id1, id2, ..., idnum-1) > (Publication1, Publication2, ..., Publicationnum-1)
    */
