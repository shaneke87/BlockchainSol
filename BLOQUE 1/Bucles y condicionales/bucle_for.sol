// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract bucle_for {
    //suma de los primeros 100 numeros a partir del numemro introducido
    function Suma(uint _numero) public pure returns(uint) {
        uint suma = 0;
        for(uint i = _numero; i<(100+_numero); i++) {
            suma = suma + i;
        }
        return suma;
    }

    // Esto es un array dinamico de direcciones
    address [] direcciones;

    // Añade una direccion al array
    function asociar() public {
        direcciones.push(msg.sender);
    }

    //Comprobar si la direccion esta en el array de direcciones
    function comprobarAsociacion() public view returns(bool, address) {
        for(uint i = 0; i<direcciones.length; i++) {
            if(msg.sender==direcciones[i]){
                return (true, direcciones[i]);
            }
        }
    }

    //Doble for: suma de los 10 prmeros factoriales
    // n! = n*(n-1)*(n-2)*....*2*1
    function sumaFactoriales() public pure returns(uint) {
        uint suma=0;
        for(uint i=1; i<=10; i++){
            uint factorial = 1;
            for(uint j=2; j<=i; j++){
                factorial = factorial*j;
            }
            suma = suma + factorial;
        }
        return suma;
    }
}