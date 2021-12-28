// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract funciones {
    // Añadir dentro de un array de direcciones la direccion de la persona que llame la funcion
    address[] public direcciones;

    function nuevaDirecion() public {
        direcciones.push(msg.sender);
    }

    // computar al hash de los datos proporcionados como parametro
    bytes32 public hash;

    function Hash(string memory _datos) public {
        hash = keccak256(abi.encodePacked(_datos));
    }

    //Declaramos en tipo de dato complejo, que es comida
    struct comida {
        string nombre;
        string ingredientes;
    }

    comida public hamburgesa;
    function Hamburgesas(string memory _ingredientes) public {
        hamburgesa = comida("Hamburgesa", _ingredientes);
    }

    //Declaramos un tipo complejo, alumno
    struct alumno {
        string nombre;
        address direccion;
        uint edad;
    }

    bytes32 public hash_id_alumno;

    //calculamos el hash del alumno
    function hashIdAlumno(string memory _nombre, address _direccion, uint _edad) private {
        hash_id_alumno = keccak256(abi.encodePacked(_nombre, _direccion, _edad));
    }

    //Guardamos con la fucion publica dentro de una lista de alumnos
    alumno[] public lista;
    mapping(string => bytes32) public alumnos;

    function nuevoAlumno(string memory _nombre, uint _edad) public {
        lista.push(alumno(_nombre, msg.sender, _edad));
        hashIdAlumno(_nombre, msg.sender, _edad);
        alumnos[_nombre] = hash_id_alumno;
    }
}
