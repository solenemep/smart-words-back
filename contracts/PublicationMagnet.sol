// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract PublicationMagnet is ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;

    struct Publication {
        string content;
        bytes32 hashContent;
        uint256 date;
    }
    Counters.Counter private _publicationIds;
    mapping(bytes32 => uint256) private _idByHash;
    mapping(uint256 => Publication) private _publicationById;

    event Published(address indexed writer, string content);

    constructor() ERC721("Publication", "PUB") {}

    function publish(
        string memory content,
        bytes32 hashContent,
        uint256 uriId
    ) public returns (uint256) {
        require(_isAuthentic(hashContent) == true, "PublicationMagner : this content has already been published");
        _publicationIds.increment();
        uint256 currentId = _publicationIds.current();
        _mint(msg.sender, currentId);
        _setTokenURI(currentId, uriId.toString());
        _idByHash[hashContent] = currentId;
        _publicationById[currentId] = Publication(content, hashContent, block.timestamp);
        emit Published(msg.sender, content);
        return currentId;
    }

    function _isAuthentic(bytes32 hashContent) private returns (bool) {
        return true;
        // _idByHash[hashContent] == 0
    }

    function getIdByHash(bytes32 hashContent) public view returns (uint256) {
        return _idByHash[hashContent];
    }

    function getPublicationById(uint256 id) public view returns (Publication memory) {
        return _publicationById[id];
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, ERC721)
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
        return "https://www.publication.com/nft/";
    }
}

/* getPublicationByWriter
    BalanceOf (own) > num
    tokenOfOwnerByIndex ( 0, 1, ..., num-1 ) > (id1, id2, ..., idnum-1)
    getPublicationById (id1, id2, ..., idnum-1) > (Publication1, Publication2, ..., Publicationnum-1)
    */
