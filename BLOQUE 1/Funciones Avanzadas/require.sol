// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Require {
    // funcion que verifique la contraseña
    function password(string memory _pas) public pure returns(string memory) {
        require(keccak256(abi.encodePacked(_pas))==keccak256(abi.encodePacked("12345")), "Contraseña incorrecta");
        return "Contraseña correcta";
    }

    //funcion de pago
    uint tiempo = 0;
    uint public cartera = 0;
    function pagar(uint _cantidad) public returns(uint) {
        require(now> tiempo + 5 seconds, "Aun no puedes pagar");
        tiempo = now;
        cartera = cartera + _cantidad;
        return cartera;
    }

    //funcion co una lista 

    string [] nombres;

    function nuevoNombre(string memory _nombre) public {
        for(uint i=0; i<nombres.length; i++) {
            require(keccak256(abi.encodePacked(_nombre))!=keccak256(abi.encodePacked(nombres[i])), "Ya esta en la lista");
        }
        nombres.push(_nombre);
    }
}