// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Banco {
    //Definimos un tipo de dato complejo cliente
    struct cliente {
        string nombre;
        address direccion;
        uint dinero;
    }

    //maping que nos relaciona el nombre del cliente con el tipo de dato cliente
    mapping(string => cliente) clientes;

    //funcion que nos permita dar de alta un nuevo cliente
    function nuevoCliente(string memory _nombre) internal {
        clientes[_nombre] = cliente(_nombre, msg.sender, 0);
    }
}

contract Banco2 {

}

contract Banco3 {
    
}