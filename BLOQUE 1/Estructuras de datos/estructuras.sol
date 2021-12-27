// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Estructuras {
    // Cliente de una pagina web de pago
    struct cliente {
        uint id;
        string name;
        string dni;
        string mail;
        uint phone_number;
        uint creit_number;
        uint secret_number;
    }

    cliente public cliente_1 = cliente(1, "oscar", "123456789", "oscar@mail.com", 123456789, 987654321, 8262);

    struct producto{
        string nombre;
        uint precio;
    }

    producto public movil = producto("samsung", 300);

    struct ONG {
        address ong;
        string nombre;
    }

    ONG public caritas = ONG(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, "Caritas");

    struct causa {
        uint id;
        string nombre;
        uint precio_obejetivo;
    }

    causa public medicamentos = causa(1, "medicamentos", 1000);

}
