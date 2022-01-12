// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "../ERC20/ERC20.sol";

contract loteria {
    // Inctancia del contrato token
    ERC20Basic private token;

    // Direcciones
    address public owner;
    address public contrato;

    // Numero de tokens a crear
    uint public tokens_creados = 10000;

    //Evento de compra de tokens
    event ComprandoTokens(uint, address);

    //constructor
    constructor() public {
        token = new ERC20Basic(tokens_creados);
        owner = msg.sender;
        contrato = address(this);
    }

    // ----------------- TOKEN ----------------- //
    // Establecer el precio de los tokens en ethers
    function PrecioTokens(uint _numTokens) internal pure returns(uint) {
        return _numTokens*(1 ether);
    }

    // Generar mas Tokens por la loteria
    function GeneraTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }

    // Modificador para hacer fucnciones solamente accesiles por el owner del contrato
    modifier Unicamente(address _direccion) {
        require(_direccion == owner, "No tienes permisos para ejecutar esta funcion");
        _;
    }

    // Comprear tokens para coprar boletos/tickets parala loteria
    function ComprarTokens(uint _numTokens) public payable {
        //calcular el coste de los tokens
        uint coste = PrecioTokens(_numTokens);
        //Se requiere que el valor de ethers pagasos sea el equivalente al coste
        require(msg.value >= coste, "Compra menos tokens o paga con mas ethers");
        //Diferencia apagar
        uint returnValue = msg.value - coste;
        // Transferencia de la Diferencia
        msg.sender.transfer(returnValue);
        // Obtener el balance de tokens del contrato
        uint Balance = TokensDisponibles();
        // flitro para evaluar los tokens a comprar con los token TokensDisponibles
        require(_numTokens <= Balance, "Compra un numero de Tokens adecuado.");
        // Transferencia de tokens a comprador
        token.transfer(msg.sender, _numTokens);
        // Emitir el evento compra tokens
        emit ComprandoTokens(_numTokens, msg.sender);
    }

    // Balcance de tokens en el contrato de la loteria
    function TokensDisponibles() public view returns(uint) {
        return token.balanceOf(contrato);
    }

    // Obgtener el balane de tokens acumulados en el bote
    function Bote() public view returns(uint) {
        return token.balanceOf(owner);
    }

    // balance de tokens de una persona
    function MisTokens() public view returns(uint){
        return token.balanceOf(msg.sender);
    }

    // ----------------- LOTERIA ----------------- //
    // Precio boletos
    uint public PrecioBoleto = 5;
    //Relacion entre la persona que compra los boletos y los numeros de los boletos
    mapping(address => uint[]) idPersona_boletos;
    // Relacion necesaria para idetificar al ganador
    mapping(uint => address) ADN_boleto;
    // Numero aleatorio
    uint randNonce = 0;
    // Boletos generados
    uint [] boletos_comprados;
    //Eventos
    event boleto_comprado(uint, address); // Eveno cuando se compra un boletos
    event boleto_ganador(uint); // Eento del Ganador
    event tokens_devueltos(uint, address); //Evento para devolver tokens

    // Funcion para comprar boletos de loteria
    function CompraBoleto(uint _boletos) public {
        // Preco total de los boletos a comprar
        uint precio_total = _boletos*PrecioBoleto;
        // Filtarado de los tokens a comprar
        require(precio_total <= MisTokens(), "Necesitas comprar mas tokens");
        // Transferencia de tokens al owner -> bote/permisos
        /*
            El cliente paga la atraccion en tokens:
            - Ha sido necesario crear una funcion en ERC20.sol con el nombre de : 'transferencia _loteria'
            debido a que en el caso de user Transfer o transferForm las direcciones que se escogian
            para realizar la transaccion eran equivocadas. ya que msg.sender que recibia el metodo Transfer o 
            TransferFrom era la direccion del contrato y debe ser la direccion de la persona fisica
        */   
        token.transferencia_loteria(msg.sender,owner,precio_total);
        /*
            Lo que esto haria es tomar la marca de tiempo now, el msg.sender y un nonce 
            (Un numero que solo se utiliza una vez, para que no ejecutemos dos veces la misma 
            funcion de hash con los mismos parametros de entrada) en incremento.
            Luego se utiliza keccak256 par convertir estas entradas a un hash aleatorio.
            convertir ese hash a un uint y luego utilizamos % 10000 para romar los utimoscuatro digitos
            Sanso un valor aleatorio entre 0 - 9999.
        */
        for(uint i=0; i<_boletos; i++) {
            uint random = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 10000;
            randNonce++;
            // ALmacenamos los datos de los boletos
            idPersona_boletos[msg.sender].push(random);
            // Numero de boleto comprador
            boletos_comprados.push(random);
            // asignacion del ADN del boleto para tener un ganador
            ADN_boleto[random] = msg.sender;
            // Emision del evento
            emit boleto_comprado(random, msg.sender);
        }
    }

    // Visualizar el numero de boletos de una persona
    function TusBoletos() public view returns(uint[] memory) {
        return idPersona_boletos[msg.sender];
    }

    //Funcion para generar un ganador e ingresarle los tokens
    function GeneraGanador() public Unicamente(msg.sender) {
        //Debe Haber boletos comprados para generar un ganador
        require(boletos_comprados.length > 0, "No hay boletos comprados");
        // Declaracion de la longitud del array
        uint longitud = boletos_comprados.length;
        //Aleatoriamente elijo un numero ente : 0 - longitud
        //1 - eleccion de la posocion aleatoriadel array
        uint posicion_array = uint(uint(keccak256(abi.encodePacked(now))) % longitud);
        //2 - seleccion del nmero aleatoriao mediante la posiion del array aleatoria
        uint eleccion = boletos_comprados[posicion_array];
        // Emision del evento del ganador
        emit boleto_ganador(eleccion);
        // Recuperar la direccion del ganador
        address direccion_ganador = ADN_boleto[eleccion];
        //Enviarle los tokens del premio al ganador
        token.transferencia_loteria(msg.sender, direccion_ganador, Bote());
    }

    // Devolucon de los tokens
    function DevolverTokens(uint _numTokens) public payable {
        // El numero de tokens a devolver debe ser mayor a 0
        require(_numTokens > 0, "Necesitas devolver un numero positivo de tokens");
        // El usuario/cliente debe tener los tokens que sesa devolver
        require(_numTokens <= MisTokens(), "No tienes los tokens que deseas devolver");
        //DEVOLUCION:
        // 1 El cliente devuelve los tokens
        // 2. La loteria paga los tokens devueltos en ethers
        token.transferencia_loteria(msg.sender, address(this), _numTokens);
        msg.sender.transfer(PrecioTokens(_numTokens));
        // Emision del eento
        emit tokens_devueltos(_numTokens, msg.sender);
    }

}