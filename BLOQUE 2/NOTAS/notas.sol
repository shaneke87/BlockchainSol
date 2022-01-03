// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

//-------------------------------------
// ALUMNO   /     ID     /     NOTA
//-------------------------------------
// Marcos  |    77755N   |       5
// Joan    |    12345X   |       9
// Maria   |    02468T   |       2
// Martha  |    13579U   |       3
// Alba    |    98765Z   |       5

contract notas {
    // Direccio del profesor
    address public profesor;

    // Constructor
    constructor() public {
        profesor = msg.sender;
    }

    // Mapping para relacionar el hash de la identidas del alumno con su nota del examen
    mapping (bytes32 => uint) Notas;

    // Array de los alumnos que pidan revisiones de examen
    string [] revisiones;

    // Eventos
    event alumno_evaluado(bytes32);
    event evento_revision(string);

    // funcion para evaluar al alumno
    function Evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender) {
        // Hash_idAlumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        //realacion entre al hash de la identificacion del alumno y su nota
        Notas[hash_idAlumno] = _nota;
        //Emision del evento
        emit alumno_evaluado(hash_idAlumno);
    }

    //control de las funciones ejecutables por wl profesor
    modifier UnicamenteProfesor(address _direccion) {
        //Requiere que la direccion introduccida por parametro sea igual al owner del contrato
        require(_direccion == profesor, "No tienes permisos para ejecutar esta fucncion");
        _;
    }

    // Funcion para ver las notas de un alumno
    function VarNotas(string memory _idAlumno) public view returns(uint) {
        // Hash_idAlumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        // Nota asociada al has del alumno
        uint nota_alumno = Notas[hash_idAlumno];
        // visualizar nota
        return nota_alumno;
    }

    // Funcion para pedir una revision del examen
    function Revision(string memory _idAlumno) public {
        // Almacenamiento de la identidad del alumno
        revisiones.push(_idAlumno);
        // Emision del evento
        emit evento_revision(_idAlumno);
    }

    // Funcion par aver a los alumnos que han soliciatado revision de examen
    function VerRevisiones() public view UnicamenteProfesor(msg.sender) returns (string [] memory) {
        //devolver las identidades de los alumnos
        return revisiones;
    }
}