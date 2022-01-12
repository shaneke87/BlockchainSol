// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

//Oscar Graciano 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//Antonio Graciano 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
//Danna Graciano 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB

//Interface de nuestro token ERC20
interface IERC20 {
    //Devuelve la cantidad de tokens en existencia
    function totalSupply() external view returns(uint);

    //Devuelve la cantidad de tokens para una direccion indicada por parametro
    function balanceOf(address account) external view returns(uint);
    
    //Devuelve el numero de token que el spender podra gastar a nimbre del porpietario (owner)
    function allowance(address owner, address spender) external view returns(uint);

    //devuelve un valor booleano resultado de la ooperacion indicada
    function transfer(address recipient, uint amount) external returns(bool);

    //devuelve un valor booleano resultado de la ooperacion indicada
    function transferencia_disney(address cliente, address receiver, uint amount) external returns(bool);

    //devuelve un valor booleano resultado de la ooperacion indicada
    function transferencia_loteria(address emisor, address receiver, uint amount) external returns(bool);

    //Devuelve un valor booleano co el resultado de la operacion de gasto
    function approve(address spender, uint amount) external returns(bool);

    //Devuelve un valor booleano con el resultado de la operacion de paso de ua catidad de tokens usando el metodo allowance()
    function transferFrom(address sender, address recipient, uint amount) external returns(bool);

    //evento que se debe emitir cuando una canridad de tokens pase de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint value);

    //Eventos que se debe de emitir cuando se establece una asignacion con el metodo allowance()
    event Approval(address indexed owner, address indexed spender, uint value); 

}

//Implementacion de las funciones del token ERC20
contract ERC20Basic is IERC20 {

    string public constant name = "ERC20BlockchainAZ";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 2;

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed owner, address indexed spender, uint tokens);

    using SafeMath for uint;

    mapping (address => uint) balances;
    mapping (address => mapping(address => uint)) allowed;
    uint totalSupply_;

    constructor(uint initialSupply) public {
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns(uint){
        return totalSupply_;
    }

    function increaseTotalSupply(uint newTokensAmount) public {
        totalSupply_ += newTokensAmount;
        balances[msg.sender] += newTokensAmount;
    }

    function balanceOf(address tokenOwner) public override view returns(uint){
        return balances[tokenOwner];
    }

    function allowance(address owner, address delegate) public override view returns(uint) {
        return allowed[owner][delegate];
    }

    function transfer(address recipient, uint numTokens) public override returns(bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[recipient] = balances[recipient].add(numTokens);
        emit Transfer(msg.sender, recipient, numTokens);
        return true;
    }
    
    function transferencia_disney(address _cliente, address receiver, uint numTokens) public override returns(bool) {
        require(numTokens <= balances[_cliente]);
        balances[_cliente] = balances[_cliente].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(_cliente, receiver, numTokens);
        return true;
    }

    function transferencia_loteria(address _emisor, address receiver, uint numTokens) public override returns(bool) {
        require(numTokens <= balances[_emisor]);
        balances[_emisor] = balances[_emisor].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(_emisor, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public override returns(bool){
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function transferFrom(address owner, address buyer, uint numTokens) public override returns(bool){
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}