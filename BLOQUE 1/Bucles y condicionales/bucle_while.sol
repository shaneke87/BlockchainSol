// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract bucle_while {
    // Suma de los numeros impares menores o iguales a 100
    function suma_impares() public pure returns(uint) {
        uint suma = 0;
        uint contador = 1;

        while(contador<100) {
            if(contador%2!=0) {
                suma = suma + contador;
            }
            contador++;
        }
        return suma;
    }

    //Esperar 5 segundos
    uint tiempo;

    function fijarTiempo() public {
        tiempo = now;
    }

    function Esperar() public view returns(bool) {
        while(now < tiempo + 5 seconds) {
            return false;
        }
        return true;
    }

    //Sigiente numero primo
    //Numero primo es aquel que es divicibele ente 1 y el mismo
    function siguentePrimo(uint _p) public pure returns(uint){
        uint contador = _p+1;
        while(true) {
            //comporbamos si es primo
            uint aux=2;
            bool primo = true;
            while(aux<contador){
                if(contador%aux==0){
                    primo = false;
                    break;
                }
                aux++;
            }
            if(primo == true){
                break;
            }
            contador++;
        }
        return contador;
    }
}