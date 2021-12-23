// SPDX-License-Identifier: MIT
// Indicacmos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract public_private_internal {
    // Modificador public
    uint public mi_entero = 45;
    string public mi_string = "Oscar";
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    // modificador private
    uint private mi_entero_privado = 10;
    bool private flag = true;

    function testSet(uint _k) public {
        mi_entero_privado = _k;
    }

    function testGet() public view returns (uint) {
        return mi_entero_privado;
    }

    //modificador internal
    bytes32 internal hash = keccak256(abi.encodePacked("hola"));
    address internal direccion = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
}