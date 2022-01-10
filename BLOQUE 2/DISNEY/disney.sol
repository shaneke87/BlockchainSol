// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "../ERC20/ERC20.sol";

contract Disney {
    // ----------- Declaraciones Iniciales ----------- //
    // Instancia del contrato token
    ERC20Basic private token;

    //Direccio de Disney(owner)
    address payable public owner;

    //constructor
    constructor() public {
        token = new ERC20Basic(10000);
        owner = msg.sender;
    }

    // Estructura de datos para almacenar los clientes
    struct cliente {
        uint tokens_comprados;
        string [] atracciones_disfrutadas;
    }

    // mapping para el registro de clientes
    mapping(address => cliente) public Clientes;
    // ----------- Gestion de Tokens ----------- //

    // Funcion para establecer el precio de un Token
    function PrecioTokens(uint _numTokens) internal pure returns(uint){ 
        // Conversion de Tokens a Ethers: 1 Token -> 1 ether
        return _numTokens*(1 ether);
    }

    // Funcion para comprar tokens en disney y disfrutar de las atracciones
    function ComprarTokens(uint _numTokens) public payable {
        //Establecer el precio de los tokens
        uint coste = PrecioTokens(_numTokens);
        // Se evalua el dinero que el clientepaga por los tokens
        require(msg.value >= coste, "Compra menos Tokens o paga con mas ethers");
        // Diferencia de los que el cliente paga
        uint returnValue = msg.value - coste;
        // Disney retorna la cantidad de ethers al cliente
        msg.sender.transfer(returnValue);
        // Obtencion de el numero de tokens siponibles
        uint Balance = balanceOf();
        require(_numTokens <= Balance, "Copra un numero menor de Tokens");
        // se transffiere el numero de tokens al cliente
        token.transfer(msg.sender, _numTokens);
        // Resgistro de tokens tokens_comprados
        Clientes[msg.sender].tokens_comprados += _numTokens;
    }

    //Balance de tokens en el contrato disney
    function balanceOf() public view returns(uint) {
        return token.balanceOf(address(this));
    }

    // Visualizar el numero de tokens restantes del cliente
    function MisTokens() public view returns(uint) {
        return token.balanceOf(msg.sender);
    }

    //Funcion para generar mas tokens
    function GeneraTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }

    // Modificador para controlar las fucnciones ejecutables de disney
    modifier Unicamente(address _direccion) {
        require(_direccion == owner, "No tienes permisos para ejecutar esta funcion");
        _;
    }

    // ----------- Gestion de Disney ----------- //
    // Eventos
    event disfruta_atraccion(string, uint, address);
    event nueva_atraccion(string, uint);
    event baja_atraccion(string);

    event disfruta_comida(string, uint, address);
    event nueva_comida(string, uint);
    event baja_comida(string);

    //Estructura de la atraccion
    struct atraccion {
        string nombre_atraccion;
        uint precio_atraccion;
        bool estado_atraccion;
    }

    // Estructura Comida
    struct comida {
        string nombre_comida;
        uint precio_comida;
        bool estado_comida;
    }


    // mapping para relacionar un nombre de una atraccion con una estructura de la atracion
    mapping (string => atraccion) public MappingAtracciones;
    mapping (string => comida) public MappingComidas;

    // Array para almacenar el nombre de las atracciones
    string [] Atracciones;
    string [] Comidas;

    // Mapping relacionar una identidad (cliente) con su historial en disney
    mapping (address => string []) HistorialAtracciones;
    mapping (address => string []) HistorialComidas;

    //crear nuevas atracciones para Disney (Solo es ejecutable por el dueño del contrato en este caso Disney)
    function NuevaAtraccion(string memory _nombreAtraccion, uint _precio) public Unicamente(msg.sender) {
        //Creacion de una atraccion en disney
        MappingAtracciones[_nombreAtraccion] = atraccion(_nombreAtraccion, _precio, true);
        // Almacenar en u array el nombre de la atraccion
        Atracciones.push(_nombreAtraccion);
        // Emision del evento para la nueva atraccion
        emit nueva_atraccion(_nombreAtraccion, _precio);
    }

    function NuevaComida(string memory _nombreComida, uint _precio) public Unicamente(msg.sender) {
        //Creacion de una comida en disney
        MappingComidas[_nombreComida] = comida(_nombreComida, _precio, true);
        // Almacenar en u array el nombre de la atraccion
        Comidas.push(_nombreComida);
        // Emision del evento para la nueva atraccion
        emit nueva_comida(_nombreComida, _precio);
    }

    // Dar de baja a las atracciones en Disney
    function BajaAtraccion(string memory _nombreAtraccion) public Unicamente(msg.sender) {
        // El estado de la atraccion pasa a false => no esta en uso
        MappingAtracciones[_nombreAtraccion].estado_atraccion = false;
        //emitimos el evento para la baja de la atraccion
        emit baja_atraccion(_nombreAtraccion);
    }

    function BajaComida(string memory _nombreComida) public Unicamente(msg.sender) {
        // El estado de la atraccion pasa a false => no esta en uso
        MappingComidas[_nombreComida].estado_comida = false;
        //emitimos el evento para la baja de la atraccion
        emit baja_comida(_nombreComida);
    }

    //Visualizar las atraciones de disney
    function AtraccionesDisponibles() public view returns(string [] memory) {
        return Atracciones;
    }

    function ComidasDisponibles() public view returns(string [] memory) {
        return Comidas;
    }

    // funcion para subirse a una atraccio de disney y pagar en tokens
    function SubirseAtraccion(string memory _nombreAtraccion) public {
        // Precio de la atraccion en tokens
        uint tokens_atraccion = MappingAtracciones[_nombreAtraccion].precio_atraccion;
        // Verifica el estado de la atraccion (si esta sisponiblepara su uso)
        require(MappingAtracciones[_nombreAtraccion].estado_atraccion == true, "La atraccion no esta disponible en estos momentos");
        // Verifica el numero de tokens que tiene el cliente para subirse a la atraccion
        require(tokens_atraccion <= MisTokens(), "Necesitas mas tokens para suirte a esta atraccion");
        /*
            El cliente paga la atraccion en tokens:
            - Ha sido necesario crear una funcion en ERC20.sol con el nombre de : 'transferencia _disney'
            debido a que en el caso de user Transfer o transferForm las direcciones que se escogian
            para realizar la transaccion eran equivocadas. ya que msg.sender que recibia el metodo Transfer o 
            TransferFrom era la direccion del contrato 
        */ 
        token.transferencia_disney(msg.sender, address(this), tokens_atraccion);
        //Almacenamiento en el historial de atracciones del cliente
        HistorialAtracciones[msg.sender].push(_nombreAtraccion);
        // Emision del evento para disfrutar de la atraccion
        emit disfruta_atraccion(_nombreAtraccion, tokens_atraccion, msg.sender);
    }

    function OrdenarComida(string memory _nombreComida) public {
        // Precio de la comida en tokens
        uint tokens_comida = MappingComidas[_nombreComida].precio_comida;
        // Verifica el estado de la comida (si esta disponible para su uso)
        require(MappingComidas[_nombreComida].estado_comida == true, "La atraccion no esta disponible en estos momentos");
        // Verifica el numero de tokens que tiene el cliente para subirse a la atraccion
        require(tokens_comida <= MisTokens(), "Necesitas mas tokens para suirte a esta atraccion");
        /*
            El cliente paga la atraccion en tokens:
            - Ha sido necesario crear una funcion en ERC20.sol con el nombre de : 'transferencia _disney'
            debido a que en el caso de user Transfer o transferForm las direcciones que se escogian
            para realizar la transaccion eran equivocadas. ya que msg.sender que recibia el metodo Transfer o 
            TransferFrom era la direccion del contrato 
        */ 
        token.transferencia_disney(msg.sender, address(this), tokens_comida);
        //Almacenamiento en el historial de comidas del cliente
        HistorialComidas[msg.sender].push(_nombreComida);
        // Emision del evento para disfrutar de la comida
        emit disfruta_comida(_nombreComida, tokens_comida, msg.sender);
    }

    // Visualiza el historial completo de atracciones disfrutadas por un cliente
    function historialAtracciones() public view returns(string [] memory) {
        return HistorialAtracciones[msg.sender];
    }

    function historialComidas() public view returns(string [] memory) {
        return HistorialComidas[msg.sender];
    }

    // Funcion para que un cliente de disney pueda devolver tokens
    function DevolverTokens(uint _numTokens) public payable {
        // EL numero de tokens a sevolver es positivo
        require(_numTokens > 0, " Necesitas devolver una cantidad positiva de tokens");
        // El suaurio debe tener el numero de tokens que desa devolver
        require(_numTokens <= MisTokens(), "No tienes los tokens que deseas devolver");
        // cleinte devuelve los tokens
        token.transferencia_disney(msg.sender, address(this), _numTokens);
        //Devolucion de los ethers al cleinte
        msg.sender.transfer(PrecioTokens(_numTokens));
    }
}