// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Arrays {
    // Array de enetero de longitud fija 5
    uint32[5] public array_enteros = [1,2,3];

    // Array de enteros de 32 bsts de longitud fija de 7 posisciones
    uint32[7] array_enteros_32_bits;

    // Array de strings de longitud fija 15
    string[15] array_strings;

    // Array dinamico de enteros
    uint [] public array_dinamico_enteros;

    struct Persona {
        string nombre;
        uint32 edad;
    }

    // Array dinamico de tipo de persona
    Persona [] public array_dinamico_personas;

    function modificar_array(uint _numero) public {
        array_dinamico_enteros.push(_numero);
    }

    function array_persona( string memory _nombre, uint32 _edad) public {
        array_dinamico_personas.push(Persona(_nombre,_edad));
    }

    uint public test = array_enteros[2];
}   
