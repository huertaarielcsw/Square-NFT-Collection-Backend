// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 MAX_MINT_COUNT = 15;

    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Shenanigans",
        "Bamboozle",
        "Bazinga",
        "Bodacius",
        "Boruhaha",
        "Canoodle",
        "Gnarly",
        "Goggle",
        "Gubbins",
        "Muggle",
        "Malarkey",
        "Nincompoop",
        "Phalanges",
        "Badger",
        "Bumfuzzle"
    ];
    string[] secondWords = [
        "Pachanga",
        "Rumba",
        "Perreo",
        "Jangeo",
        "Fiesta",
        "Chanchucho",
        "Cachivache",
        "Floripondio",
        "Fulano",
        "Trabuco",
        "Zarrapastroso",
        "Bocachancla",
        "Almocafre",
        "Jurutungo",
        "Ringorrango"
    ];
    string[] thirdWords = [
        "Cartman",
        "Stan",
        "Kyle",
        "Kenny",
        "Randy",
        "Lorde",
        "Butter",
        "Timmy",
        "Jimmy",
        "Satan",
        "Jesus",
        "Hanky",
        "Tweak",
        "Craig",
        "Garrison"
    ];

    string[] colors = [
        "red",
        "#08C2A8",
        "black",
        "yellow",
        "blue",
        "green",
        "#FFD700",
        "#DAA520",
        "#808080",
        "#8A2BE2",
        "green",
        "#7FFF00",
        "#BDB76B",
        "#E9967A",
        "#FF8C00"
    ];

    mapping(address => uint256) nftCount;

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COLOR", Strings.toString(tokenId)))
        );
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. My NFT are epic!");
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
        return nftCount[msg.sender];
    }

    function makeAnEpicNFT() public {
        require(
            getTotalNFTsMintedSoFar() < MAX_MINT_COUNT,
            "Error: You have reached the maximum number of NFTs allowed"
        );

        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory randomColor = pickRandomColor(newItemId);
        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomColor,
                svgPartTwo,
                combinedWord,
                "</text></svg>"
            )
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        nftCount[msg.sender]++;

        _tokenIds.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
