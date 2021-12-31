// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

contract caluclosSeguros {
    // debemos declarar para que datos usuaremos lalibreria
    using SafeMath for uint;

    //suncion suma segura
    function suma(uint _a, uint _b) public pure returns(uint) {
        return _a.add(_b);
    }

    //suncion resta segura
    function resta(uint _a, uint _b) public pure returns(uint) {
        return _a.sub(_b);
    }

    //suncion multimplicacion segura
    function multiplicacion(uint _a, uint _b) public pure returns(uint) {
        return _a.mul(_b);
    }


}