// SPDX-License-Identifier: MIT
// Indicacmos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract enteros {

    // variables enteras sin signo
    uint mi_primer_entero;
    uint mi_primer_entero_inicializado = 3;
    uint cota = 5000;

    // variables enteras sin signo con un numeroespecifico de bits
    uint8 entero_8_bits;
    uint64 entero_64_bits = 7000;
    uint16 entero_16_bits;
    uint256 entero_256_bits;

    //variables enteras con signo
    int mi_primer_entero_con_signo;
    int mi_numero = -32;
    int mi_primer_entero_2 = 65;


    // variables enteras con signo con un numero especifico de bits
    int72 entero_con_signo_72_bits;
    int240 entero_con_240_bits;
    int256 entero_con_256_bits = 9000;
}