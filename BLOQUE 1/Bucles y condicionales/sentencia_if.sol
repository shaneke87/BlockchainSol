// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;


contract sentencia_if {
    //Numero ganador
    function probarSuerte(uint _numero) public pure returns(bool) {
        bool ganador = false;
        if(_numero == 100){
            ganador = true;
        }
        return ganador;
    }

    //calculamos el valor absoluto de un numero
    function valorAbsoluto(int _k) public pure returns(uint){
        uint valor_absoluto_numero;
        if(_k<0) {
            valor_absoluto_numero = uint(-_k);
        } else {
            valor_absoluto_numero = uint(_k);
        }

        return valor_absoluto_numero;
    }

    function parTresCifras(uint _numero) public pure returns(bool) {
        bool flag = false;
        if((_numero%2==0)&&(_numero>=100)&&(_numero<999)) {
            flag = true;
        }
        return flag;
    }

    //votacion
    //Solo hay tres candidatos: Oscar, Danna, Antonio

    function votar(string memory _candidato) public pure returns(string memory) {
        string memory mensaje;

        if(keccak256(abi.encodePacked(_candidato)) == keccak256(abi.encodePacked("Oscar"))) {
            mensaje = "Has Votado correctamente a Oscar";
        } else {
            if(keccak256(abi.encodePacked(_candidato)) == keccak256(abi.encodePacked("Danna"))) {
            mensaje = "Has Votado correctamente a Danna";
            } else {
                if(keccak256(abi.encodePacked(_candidato)) == keccak256(abi.encodePacked("Antonio"))) {
            mensaje = "Has Votado correctamente a Antonio";
                } else {
                    mensaje = "No existe ese candidato";
                }
            }
        }
        return mensaje;
    } 
}