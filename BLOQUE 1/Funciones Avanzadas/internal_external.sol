// SPDX-License-Identifier: MIT
// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Comida {
    struct plato {
        string nombre;
        string ingredientes;
        uint tiempo;
    }

    //Declarar un array dinamico de platos
    plato[] platos;
    // Relacionamos con un mapping el nombre del plato con sus ingrediente
    mapping(string => string) ingredientes;

    //funcion que nos permite dear de alta un nuevo plato
    function nuevoPlato(string memory _nombre, string memory _ingredientes, uint _tiempo) internal {
        platos.push(plato(_nombre,_ingredientes,_tiempo));
        ingredientes[_nombre] = _ingredientes;
    }

    function getIngredientes(string memory _nombre) internal view returns(string memory) {
        return ingredientes[_nombre];
    }

}

contract Sandwitch is Comida {
    function sandwitch(string memory _ingredientes, uint _tiempo) external {
        nuevoPlato("Sandwitch", _ingredientes, _tiempo);
    }

    function verIngredientes() external view returns(string memory) {
        return getIngredientes("Sandwitch");
    }
}