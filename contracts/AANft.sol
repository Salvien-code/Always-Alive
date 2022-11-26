// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @author Simon Samuel
 * @dev This file is HEAVILY inspired by https://github.com/oceans404/mutable-nfts-tableland-polygon
 */
contract AliveAliveNFT is ERC721 {
    string public baseURIString;
    uint256 private _tokenIdCounter;
    uint256 private _maxTokens;

    string public mainTable;
    string public attributesTable;

    constructor(
        string memory _baseURIString,
        string memory _mainTable,
        string memory _attributesTable
    ) ERC721("AlwaysAliveNFT", "AANFT") {
        _tokenIdCounter = 0;
        _maxTokens = 30;
        baseURIString = _baseURIString;
        mainTable = _mainTable;
        attributesTable = _attributesTable;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURIString;
    }

    function totalSupply() public view returns (uint256) {
        return _maxTokens;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory _tokenURI)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        if (bytes(baseURI).length == 0) {
            return "";
        }

        // TODO: Understand what this does.
        string memory query = string(
            abi.encodePacked(
                "SELECT%20json_object%28%27id%27%2Cid%2C%27name%27%2Cname%2C%27image%27%2Cimage%2C%27description%27%2Cdescription%2C%27attributes%27%2Cjson_group_array%28json_object%28%27trait_type%27%2Ctrait_type%2C%27value%27%2Cvalue%29%29%29%20FROM%20",
                mainTable,
                "%20JOIN%20",
                attributesTable,
                "%20ON%20",
                mainTable,
                "%2Eid%20%3D%20",
                attributesTable,
                "%2Emain_id%20WHERE%20id%3D"
            )
        );

        return
            string(
                abi.encodePacked(
                    baseURI,
                    query,
                    Strings.toString(tokenId),
                    "%20group%20by%20id"
                )
            );
    }

    function mint() public {
        require(
            _tokenIdCounter < _maxTokens,
            "Maximum number of tokens have been minted."
        );
        _safeMint(msg.sender, _tokenIdCounter);
        _tokenIdCounter++;
    }
}
