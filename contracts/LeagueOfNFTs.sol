// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "./libraries/Base64.sol";

contract LeagueOfNFTs is ERC721 {
    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
        uint attackSpeed;
        uint armor;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharacterAttributes[] private defaultCharacters;

    mapping (uint256 => CharacterAttributes) public nftHolderAttributes;
    mapping (address => uint256) public nftHolders;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg,
        uint[] memory characterAttackSpeed,
        uint[] memory characterArmor
    ) ERC721("Champions", "CHMP") {
        for(uint i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDmg[i],
                attackSpeed: characterAttackSpeed[i],
                armor: characterArmor[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
        }

        _tokenIds.increment();
    }

    function mintCharacterNFT(uint _characterIndex) external {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].hp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage,
            attackSpeed: defaultCharacters[_characterIndex].attackSpeed,
            armor: defaultCharacters[_characterIndex].armor
        });

        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

        nftHolders[msg.sender] = newItemId;

        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);
        string memory strAttackSpeed = Strings.toString(charAttributes.attackSpeed);
        string memory strArmor = Strings.toString(charAttributes.armor);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        "{\"name\": \"",
                        charAttributes.name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        "\", \"description\": \"This is an NFT that lets people play in the game League of NFTs!\", \"image\": \"",
                        charAttributes.imageURI,
                        "\", \"attributes\": [ { \"trait_type\": \"Health Points\", \"value\": ",strHp,", \"max_value\":", strMaxHp,"}, { \"trait_type\": \"Attack Damage\", \"value\": ",strAttackDamage,"}, { \"trait_type\": \"Attack Speed\", \"value\": ",strAttackSpeed,"}, { \"trait_type\": \"Armor\", \"value\": ",strArmor,"} ]}"
                    )
                )
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }
}
