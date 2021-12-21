// SPDX-License-Identifier: MIT
// Inociamos la version
pragma solidity >=0.4.4 <0.7.0;
//importar el archivo ERC20.sol que esta en nuestra direccion de trabajo
import "./ERC20.sol";

// @notice contrato basico de prueba
contract PrimerContrato {

    // en esta vatiable se enctuantra la direccion de la persona que desliega el contrato
    address owner;
    // se inicializa la variable token ligada al archivo ERC20.sol adjunto en la carpeta
    ERC20Basic token;


    /*
        Guardamos en la variable owner la direccion de la persona que despliega el contrato
        inicializamos el numero de tokens
    */
    constructor() public {
        owner = msg.sender;
        token = new ERC20Basic(1000);
    }
    
}