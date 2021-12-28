// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract ValoresDeRetorno {
    //funcuion que nos devuelva un saludo
    function saludos() public pure returns(string memory) {
        return "Saludos";
    }

    //Esta funcion calcula el resultado de una multiplicacio de dos numeros enteros
    function Multiplicacion(uint _a, uint _b) public pure returns (uint) {
        return _a*_b;
    }

    // funcion que retorna una booleano si el numero es par o no
    function par_impar(uint _a) public pure returns(bool) {
        bool flag;
        if(_a%2==0) {
            flag=true;
        }else {
            flag=false;
        }
        return flag;
    }

    // Realizamos una funcion que nos devuelve el cociente y el residuo de una division
    // ademas de una variable booleana que es true si el residuo es 0 y false en caso contrario
    function division(uint _a, uint _b) public pure returns (uint, uint, bool) {
        uint q = _a/_b;
        uint r = _a%_b;
        bool multiplo=false;

        if(r==0) {
            multiplo = true;
        }

        return (q,r,multiplo);
    }

    // Practica para el manejo de los valores devueltos
    function numeros() public pure returns (uint,uint,uint,uint,uint,uint) {
        return (1,2,3,4,5,6);
    }

    //Asignacion multiple
    function todos_los_valores() public pure {
        //Declaramos las variables donde se guardan los calores de retorno de la fucnion numeros()
        uint a;
        uint b;
        uint c;
        uint d;
        uint e;
        uint f;
        //realizamos la asignacion multiple
        (a,b,c,d,e,f) = numeros(); 
    }

    function ultimo_valor() public pure returns (uint) {
        (,,,,, uint ultimo) = numeros();
        return ultimo;
    }

}