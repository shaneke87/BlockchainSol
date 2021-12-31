// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Modifier {
    // Ejemplo de solo propietario del contato puede ejecutar el contrato

    address public owner;
    constructor() public {
        owner = msg.sender;
    }

    modifier soloPropietario() {
        require(msg.sender==owner, "No tienes los permisos para ejecutar esta funcion");
        _;
    }

    function ejemplo1() public soloPropietario() {
        // codigo de la funcio  parar el propietario del cotrato
    }

    struct cliente {
        address direccion;
        string nombre;
    }

    mapping(string => address) clientes;

    function altaCliente(string memory _nombre) public {
        clientes[_nombre] = msg.sender;
    }

    modifier soloClientes(string memory _nombre){
        require(clientes[_nombre] == msg.sender);
        _;
    }

    function ejemplo2(string memory _nombre) public soloClientes(_nombre) {
        //logica de la funcion para los clientes
    }

    // Ejemplo de Conduccion
    modifier mayorEdad(uint _edadMinima, uint _edadUsuario) {
        require(_edadUsuario>=_edadMinima);
        _;
    }

    function conducir(uint _edad) public mayorEdad(18,_edad) {
        // Codigo a ejecutar áta los mayores de edad
    }
}