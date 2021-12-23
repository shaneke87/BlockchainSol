// SPDX-License-Identifier: MIT
// Indicacmos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract mas_variables {

    //variables de tipo string
    string mi_primer_string;
    string public saludo = "Hola, como estas";
    string public string_vacio = "";

    //variable booleanas
    bool mi_primer_booleano;
    bool public flag_true = true;
    bool public flag_false = false;

    // variables de tipo bytes
    bytes32 mi_primer_byte;
    bytes4 segundo_bytes;
    string public nombre = "juan";
    bytes32 public hash = keccak256(abi.encodePacked(nombre));
    bytes4  public identificador;
    
    function ejemploBytes4() public {
        identificador = msg.sig;
    }

    // variable address
    address m_primera_direccion;
    address public direccion_local = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public direccion_local2 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

}