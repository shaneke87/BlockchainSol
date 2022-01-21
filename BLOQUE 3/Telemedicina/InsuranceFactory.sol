// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./OperacionesBasicas.sol";
import "./ERC20.sol";

// Contrato para la copañia de seguros

contract InsuranceFactory is OperacionesBasicas {

    // Instancia del contrato token
    ERC20Basic private token;

    //Decalaraciond e las direcciones
    // Direccion del contrato
    address Insurance;
    // Direccion del owner del contrato
    address payable public Aseguradora;
    
    constructor() public {
        token = new ERC20Basic(100);
        Insurance = address(this);
        Aseguradora = msg.sender;
    }
    
    struct cliente {
        address DireccionCliente;
        bool AutorizacionCliente;
        address DireccionContrato;
    }

    struct servicio {
        string nombreServicio;
        uint precioTokensServicio;
        bool EstadoServicio;
    }

    struct lab {
        address direccionContratoLab;
        bool CalidacionLab;
    }

    // mapeos clientes, servicios y laboratorios 
    mapping(address => cliente) public MappingAsegurados;
    mapping(string => servicio) public MappingServicios;
    mapping(address => lab) public MappingLab;

    // arrays para clientes, servicios y laboratorios
    address [] DireccionesAsegurados;
    string [] private nombreServicios;
    address [] DireccionesLaboratorios;

    function FuncionUnicamenteAsegurados(address _direccionAsegurado) public view {
        require(MappingAsegurados[_direccionAsegurado].AutorizacionCliente == true, "Direccion de asegurado NO autorizada");
    }

    //Modificadores y restricciones sobre asegurados y aseguradoras
    modifier UicamenteAsegurados(address _direccionAsegurado) {
        FuncionUnicamenteAsegurados(_direccionAsegurado);
        _;
    }

    modifier UnicamenteAseguradora(address _direccionAseguradora) {
        require(Aseguradora == _direccionAseguradora, "Direccion de Aseguradora NO Autorizada");
        _;
    }

    modifier Asegurado_o_Aseguradora(address _direccionAsegurado, address _direccionEntrante){
        require((MappingAsegurados[_direccionEntrante].AutorizacionCliente == true && _direccionAsegurado == _direccionEntrante) || Aseguradora == _direccionEntrante,
        "Solamente compañia de seguros y asegurados");
        _;
    }

    //Eventos
    event EventoComprado(uint); // Evento que se dispara al comprar tokens
    event EventoServicioProporcionado(address, string, uint); // Evento que se dispara al recivir un servicio
    event EventoLaboratorioCreado(address, address); // Evento que se dispara al crear un laboratorio
    event EventoAseguradoCreado(address, address); // Evento que se dispara al crear un asegurado
    event EventoBajaAsegurado(address); // Evento que se dispara al dar de baja un asegurado
    event EventoServicioCreado(string, uint); // Evento que se dispara al crear un servicio
    event EventoBajaServicio(string); // Evento que se dispara al dar de baja un servicio

    // Fucnion para crear una laboratorio
    function creacionLab() public {
        DireccionesLaboratorios.push(msg.sender);
        address direccionLab = address(new Laboratorio(msg.sender, Insurance));
        lab memory Laboratorio = lab(direccionLab, true);
        MappingLab[msg.sender] = Laboratorio;
        emit EventoLaboratorioCreado(msg.sender, direccionLab);
    }

    // Funcion para crear un asegurado
    function creacionContratoAsegurado() public {
        DireccionesAsegurados.push(msg.sender);
        address direccionAsegurado = address(new InsuranceHealtRecord(msg.sender, token, Insurance, Aseguradora));
        MappingAsegurados[msg.sender] = cliente(msg.sender, true, direccionAsegurado);
        emit EventoAseguradoCreado(msg.sender, direccionAsegurado);
    }

    // Funion que devuelve el array de los laboratorios
    function Laboratorios() public view UnicamenteAseguradora(msg.sender) returns (address [] memory) {
        return DireccionesLaboratorios;
    }

    // Funion que devuelve el array de los asegurados
    function Asegurados() public view UnicamenteAseguradora(msg.sender) returns (address [] memory) {
        return DireccionesAsegurados;
    }

    function consutlaHistorialAsegurado(address _direccionAsegurado, address _direccionConsultor) public view Asegurado_o_Aseguradora(_direccionAsegurado, _direccionConsultor) returns (string memory) {
        string memory historial = "";
        address  direccionContratoAsegurado = MappingAsegurados[_direccionAsegurado].DireccionContrato;
        for(uint _i=0; _i < nombreServicios.length; _i++){
            if(MappingServicios[nombreServicios[_i]].EstadoServicio && 
                InsuranceHealtRecord(direccionContratoAsegurado).ServiciosEstadoAsegurado(nombreServicios[_i])==true) {
                    (string memory nombreServicio, uint precioServicio) = InsuranceHealtRecord(direccionContratoAsegurado).HistorialAsegurado(nombreServicios[_i]);
                    historial = string(abi.encodePacked(historial, "(", nombreServicio, ", ", uint2str(precioServicio), ") ---- "));
                }
        }
        return historial;
    }

    function darBajaCliente(address _direccionAsegurado) public UnicamenteAseguradora(msg.sender){
        MappingAsegurados[_direccionAsegurado].AutorizacionCliente = false;
        InsuranceHealtRecord(MappingAsegurados[_direccionAsegurado].DireccionContrato).darBaja;
        emit EventoBajaAsegurado(_direccionAsegurado);
    }

    // Funciones para crear, dar de baja, checar el estado y traer el precio y cuales son los servicios activos
    function nuevoServicio(string memory _nombreServicio, uint _precioServicio) public UnicamenteAseguradora(msg.sender) {
        MappingServicios[_nombreServicio] = servicio(_nombreServicio, _precioServicio, true);
        nombreServicios.push(_nombreServicio);
        emit EventoServicioCreado(_nombreServicio, _precioServicio);
    } 

    function darBajaServicio(string memory _nombreServicio) public UnicamenteAseguradora(msg.sender) {
        require(ServicioEstado(_nombreServicio) == true, "No se ha dado de alta el servicio");
        MappingServicios[_nombreServicio].EstadoServicio = false;
        emit EventoBajaServicio(_nombreServicio); 
    }

    function ServicioEstado(string memory _nombreServicio) public view returns(bool){
        return MappingServicios[_nombreServicio].EstadoServicio;
    }

    function getPrecioServicio(string memory _nombreServicio) public view returns(uint tokens) {
        require(ServicioEstado(_nombreServicio) == true, "Servicio no esta sisponible");
        return MappingServicios[_nombreServicio].precioTokensServicio;
    }

    function ConsultarServiciosActivos() public view returns(string [] memory){
        string [] memory ServiciosActivos = new string[](nombreServicios.length);
        uint contador = 0;
        for(uint i = 0; i< nombreServicios.length; i++) {
            if(ServicioEstado(nombreServicios[i]) == true) {
                ServiciosActivos[contador] = nombreServicios[i];
                contador++;
            }
        }
        return ServiciosActivos;
    }

    function compraTokens(address _asegurado, uint _numTokens) public payable UicamenteAsegurados(_asegurado){
        uint Balance = balanceOf();
        require(_numTokens <= Balance, "Compra u numero de tokens inferior");
        require(_numTokens > 0, "Compra un numero positivo de tokens");
        token.transfer(msg.sender, _numTokens);
        emit EventoComprado(_numTokens);
    }

    function balanceOf() public view returns(uint tokens) {
        return (token.balanceOf(Insurance));
    }

    function generarTokens(uint _numTokens) public UnicamenteAseguradora(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }
}

///////////////////////////////////////////////////////////
/////////////// CONTRATO ASEGURADOS ///////////////////////
///////////////////////////////////////////////////////////

contract InsuranceHealtRecord is OperacionesBasicas {
    // Enumeracion para el estado del asegurado si esta dado de alta a o esta dado de baja
    enum Estado {alta,baja}

    // Estructura del dueño del contrato(Asegurado)
    struct Owner {
        address direccionPropietario;
        uint saldoPropietario;
        Estado estado;
        IERC20 tokens;
        address Insurance;
        address payable aseguradora;
    }

    // Definimos la estructura owner
    Owner porpietario;

    constructor( address _owner, IERC20 _token, address _insurance, address payable _aseguradora) public {
        porpietario.direccionPropietario = _owner;
        porpietario.saldoPropietario = 0;
        porpietario.estado = Estado.alta;
        porpietario.tokens = _token;
        porpietario.Insurance = _insurance;
        porpietario.aseguradora = _aseguradora;
    }

    struct ServiciosSolicitados{
        string nombreServicio;
        uint precioServicio;
        bool estadoServicio;
    }

    struct ServiciosSolicitadosLab {
        string nombreServicio;
        uint precioServicio;
        address direccionLab;
    }

    mapping(string => ServiciosSolicitados) historialAsegurado;
    ServiciosSolicitadosLab [] historialAseguradoLaboratorio;
    // ServiciosSolicitados [] serviciosSolicitados;

    modifier Unicamente(address _direccion) {
        require(_direccion == porpietario.direccionPropietario, "No eres el Asegurado de la poliza");
        _;
    }

    event EventoSelfDestruct(address);
    event EventoDevolverTokens(address, uint);
    event EventoServicioPagado(address, string, uint);
    event EventoPetcionServicioLab(address, address, string);

    function HistorialAseguradoLaboratorio() public view returns (ServiciosSolicitadosLab[] memory) {
        return historialAseguradoLaboratorio;
    }

    function HistorialAsegurado( string memory _servicio) public view returns(string memory nombreServicio, uint precioServicio) {
        return (historialAsegurado[_servicio].nombreServicio, historialAsegurado[_servicio].precioServicio);
    }

    function ServiciosEstadoAsegurado(string memory _servicio) public view returns(bool) {
        return historialAsegurado[_servicio].estadoServicio;
    }

    function darBaja() public Unicamente(msg.sender){
        emit EventoSelfDestruct(msg.sender);
        selfdestruct(msg.sender);
    }

    function compraTokens(uint _numTokens) payable public Unicamente(msg.sender) {
        require(_numTokens > 0, "Neceitas comprar un numero de tokens positivo");
        uint coste = calcularPrecioToken(_numTokens);
        require(msg.value >= coste, "Compra mas o pon mas ethers");
        uint returnValue = msg.value - coste;
        msg.sender.transfer(returnValue);
        InsuranceFactory(porpietario.Insurance).compraTokens(msg.sender, _numTokens);
    }

    function balanceOf() public view Unicamente(msg.sender) returns (uint _balance){
        return (porpietario.tokens.balanceOf(address(this)));
    }

    function devolverTokens(uint _numTokens) public payable Unicamente(msg.sender) {
        require(_numTokens > 0, "Neceitas devolver un numero positivo de tokens");
        require(_numTokens <= balanceOf(), "No tienes los tokens que deses devolver");
        porpietario.tokens.transfer(porpietario.aseguradora, _numTokens);
        msg.sender.transfer(calcularPrecioToken(_numTokens));
        emit EventoDevolverTokens(msg.sender, _numTokens);
    }

    function peticionServicio(string memory _servicio) public Unicamente(msg.sender) {
        require(InsuranceFactory(porpietario.Insurance).ServicioEstado(_servicio) == true, "El servicio no de ha dado de alra en la aseguradora");
        uint pagoTokens = InsuranceFactory(porpietario.Insurance).getPrecioServicio(_servicio);
        require(pagoTokens <= balanceOf(), "Necesitas comprar mas tokens para opatar a este servicio");
        porpietario.tokens.transfer(porpietario.aseguradora, pagoTokens);
        historialAsegurado[_servicio] = ServiciosSolicitados(_servicio, pagoTokens, true);
        emit EventoServicioPagado(msg.sender, _servicio, pagoTokens);
    }

    function peticionServicioLab(address _direccionLab, string memory _servicio) public payable Unicamente(msg.sender){
        Laboratorio contratoLab = Laboratorio(_direccionLab);
        require(msg.value == contratoLab.ConsultaPrecioServicios(_servicio)* 1 ether, "Operacion Invalida");
        contratoLab.DarServicio(msg.sender, _servicio);
        payable(contratoLab.direccionLab()).transfer(contratoLab.ConsultaPrecioServicios(_servicio)* 1 ether);
        historialAseguradoLaboratorio.push(ServiciosSolicitadosLab(_servicio, contratoLab.ConsultaPrecioServicios(_servicio), _direccionLab));
        emit EventoPetcionServicioLab(_direccionLab, msg.sender, _servicio);
    }
}



///////////////////////////////////////////////////////////
/////////////// CONTRATO LABORATORIOS /////////////////////
///////////////////////////////////////////////////////////

contract Laboratorio is OperacionesBasicas {
    address public direccionLab;
    address contratoAseguradora;

    constructor(address _account, address _direccionContratoAseguradora) public {
        direccionLab = _account;
        contratoAseguradora = _direccionContratoAseguradora;
    }

    mapping(address => string) public ServicioSolicitado;

    address [] public PeticionesServicios;

    mapping(address => ResultadoServicio) ResultadosServiciosLab;

    struct ResultadoServicio {
        string diagnostico_servicio;
        string codigo_IPFS;
    }

    string [] nombreServiciosLab;

    mapping(string => ServicioLab) public serviciosLab;

    struct ServicioLab {
        string nombreServicio;
        uint precio;
        bool enFuncionamiento;
    }

    event EventoServicioFuncionando(string, uint);
    event EventoDarServicio(address, string);

    modifier UnicamenteLab(address _direccion) {
        require(_direccion == direccionLab, "No existen permisos en el sistema para ejecutar esta funcion");
        _;
    }

    function NuevoServicioLab(string memory _servicio, uint _precio) public UnicamenteLab(msg.sender) {
        serviciosLab[_servicio] = ServicioLab(_servicio, _precio, true);
        nombreServiciosLab.push(_servicio);
        emit EventoServicioFuncionando(_servicio,_precio);
    }

    function ConsultarServicios() public view returns (string[] memory) {
        return nombreServiciosLab;
    }

    function ConsultaPrecioServicios(string memory _servicio) public view returns(uint) {
        return serviciosLab[_servicio].precio;
    }

    function DarServicio(address _direccionAsegurado, string memory _servicio) public {
        InsuranceFactory IF = InsuranceFactory(contratoAseguradora);
        IF.FuncionUnicamenteAsegurados(_direccionAsegurado);
        require(serviciosLab[_servicio].enFuncionamiento == true, "El sercivio no esta activo actualmente");
        ServicioSolicitado[_direccionAsegurado] = _servicio;
        PeticionesServicios.push(_direccionAsegurado);
        emit EventoDarServicio(_direccionAsegurado, _servicio);
    }

    function DarResultados(address _direccionAsegurado, string memory _diagnostio, string memory _codigo_IPFS) public UnicamenteLab(msg.sender) {
        ResultadosServiciosLab[_direccionAsegurado] = ResultadoServicio(_diagnostio, _codigo_IPFS);
    }

    function VisualizarResultado(address _direccionAsegurado) public view returns(string memory _diagnostio, string memory _codigo_IPFS) {
        _diagnostio = ResultadosServiciosLab[_direccionAsegurado].diagnostico_servicio;
        _codigo_IPFS = ResultadosServiciosLab[_direccionAsegurado].codigo_IPFS;
    }
}