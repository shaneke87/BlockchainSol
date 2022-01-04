// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

//-------------------------------------
// CANDIDATO /     EDAD   /     ID
//-------------------------------------
// Toni    |       20    |       12345X
// Alberto |       23    |       54321T
// Joan    |       21    |       98765P
// Javier  |       19    |       56789W

contract votacion {
    // Direccion del propietario de contrato
    address owner;

    // contructor
    constructor() public {
        owner = msg.sender;
    }

    // Relacion entre el nombre del candidato y el hash de ss datos personales
    mapping(string=>bytes32) ID_Candidato;

    // Relacion entre el nombre del candidato y el numero de votos
    mapping(string=>uint) votos_Candidato;

    // Lista para almacenar los nombres de candidatos
    string [] candidatos;

    // Lista de los hashes de la identidad de los votantes
    bytes32 [] votantes;

    //Cualquier persona pueda usuar esta funcion para presentarse a las elecciones
    function Representar(string memory _nombrePersona, uint _edadPersona, string memory _idPersona) public {
        //Calcular el hash de los datos del candidato
        bytes32 hash_candidato = keccak256(abi.encodePacked(_nombrePersona, _edadPersona, _idPersona));
        //Almacenar el hash de los datos del candidato ligados a su nombre
        ID_Candidato[_nombrePersona] = hash_candidato;
        // Actuañizar la lista de los candidatos
        candidatos.push(_nombrePersona);
    }

    //Mostrar la lista de candidatos que se han registrado
    function VerCandidatos() public view returns(string [] memory) {
        //retornamos la lista de candidatos
        return candidatos;
    }

    // Los votantes van a poder votar
    function Votar(string memory _candidato) public {
        //Hash de la direccion de la persona que ejecuta esta funcion
        bytes32 hash_votante = keccak256(abi.encodePacked(msg.sender));
        //Verificamos si el votante ya ha votado
        for(uint i = 0; i<votantes.length; i++) {
            require(votantes[i] != hash_votante, "Ya has votado previemente");
        }
        //ALmacenamos el hash del vontante dentro del array de otantes
        votantes.push(hash_votante);
        //Añadmos un voto al candidato seleccionado
        votos_Candidato[_candidato]++;
    }

    //Dado el nombre de un candidato nos devuelve el numero de votos que tiene
    function VerVotos(string memory _candidato) public view returns(uint) {
        //devolviendo el nuemro de votos del candidato _candidato
        return votos_Candidato[_candidato];
    }

    // funcion auxiliar que transforma un uint a un string
    function uint2string(uint _i) internal pure returns(string memory _uintAsString) {
        if(_i == 0){
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while(_i != 0){ 
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    //Ver los votos de cada uno de los candidatos
    function VerResultados() public view returns(string memory){
        //Guardams en una variable string los candidatos don sus respectivos votos
        string memory resultados="";
        for(uint i=0; i<candidatos.length; i++) {
            //Acutalizamos el string resultados y añadimos el candidato que ocupa la posicion "i" del array candidatos 
            resultados = string(abi.encodePacked(resultados, "(",candidatos[i], ", ",uint2string(VerVotos(candidatos[i])),") -----"));
        }
        //devolvemos los resulatados
        return resultados;
    }

    //Proporcionar el nombre del candidato ganador
    function Ganador() public view returns(string memory) {
        //La variable ganador va a contener el nombre del candidato ganador
        string memory ganador=candidatos[0];
        //La variable flag nos sirve para la situacion de empate
        bool flag;
        //Recorreos el array de candidatos para determinar el candidato con un numero mayor de votos
        for(uint i=1; i<candidatos.length; i++){
            //comparamos si nustro ganador ha sido superaado por otro condidato
            if(votos_Candidato[ganador]<votos_Candidato[candidatos[i]]){
                ganador = candidatos[i];
                flag=false;
            } else {
                //Miaramos si hay empate entre los candidatos
                if(votos_Candidato[ganador]==votos_Candidato[candidatos[i]]){
                    flag=true;
                }
            }
        }
        //Comprobamos si ha habido un empate entre los candidatos
        if(flag==true){
            //Informamos del empate
            ganador="¡Hay un empate entre los candidatos!";
        }
        //Devolvemos el ganador
        return ganador;
    }

}