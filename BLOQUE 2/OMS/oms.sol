// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract OMS_COVID {

    //Direccion de la OMS -> Owner / Dueño del contrato
    address public OMS;
    address public contrato;

    // constructor del contrato
    constructor() public {
        OMS = msg.sender;
        contrato = address(this);
    }

    // Mapping para relacionar los centros de salud(drireccion/address) con la valides del sistema de gestion
    mapping(address => bool) public Validacion_CentrosSalud;

    // Relacionar una direccion de un centro de salud con su contrato
    mapping(address => address) public CentroSalud_Contrato;

    // Ejemplo 1: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 -> true = TIENE LOS PERMISOS PARA CREAR SU SMART CONTRACT
    // Ejemplo 2: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 -> false = NO TIENE LOS PERMISOS PARA CREAR SU SMART CONTRACT

    //Array de direcciones que almacene los contratos d los centros de salud validados
    address[] public direcciones_contratos_salud;

    // Array de las direcciones que solicitan acceso
    address[] Solicitudes;

    // Eventos a emitir
    event SolicitudAcceso(address);
    event NuevoContratoValidado(address);
    event NuevoContrato(address, address);

    //Modificador que permita unicamente la ejecucion de las fucniones por la OMS
    modifier UnicamenteOMS(address _direccion) {
        require(_direccion == OMS, "No tienes permisos para ejecutar esta funcion");
        _;
    }

    //Funcion para solicitar acceso al sistema medico
    function SolicictarAcceso() public {
        //Almacenar la direccion en un array de Solicitudes
        Solicitudes.push(msg.sender);
        // Emitimos el evento
        emit SolicitudAcceso(msg.sender);
    }

    // FUncion que visualiza las direcciones que han solicitado acceso
    function VisualizarSolicitudes() public view UnicamenteOMS(msg.sender) returns(address[] memory) {
        return Solicitudes;
    }

    // Funcion para validar nuevos centros de salud que puedan autogestionarse -> UnicamenteOMS
    function CentrosSalud(address _centroSalud)public UnicamenteOMS(msg.sender){
        //Asignacion del estado de valides al centro de salud
        Validacion_CentrosSalud[_centroSalud] = true;
        //Emision del evento
        emit NuevoContratoValidado(_centroSalud);
    }

    // Funcion que permita crear un contrato inteligente de un centro de salud
    function FactoryCentroSalud() public {
        // Flitrado para que unicamente los centros de salud validados sean capaces de ejecutar esta fucnciones
        require(Validacion_CentrosSalud[msg.sender] == true, "No tienes permisos para ejecutar esta fucnion");
        // Generar un Smart Contract -> generar su direccion
        address contrato_CentroSalud = address(new CentroSalud(msg.sender));
        // Almacenamos la direccion del contrato en el Array
        direcciones_contratos_salud.push(contrato_CentroSalud);
        // Relacion entre el centro de salud y su contrato
        CentroSalud_Contrato[msg.sender] = contrato_CentroSalud;
        // Emitimos el evento
        emit NuevoContrato(contrato_CentroSalud, msg.sender);
    }


}

/////////////////////////////////////////////////////////////////
contract CentroSalud {
    address public DireccionContrato;
    address public DireccionContratoSalud;

    constructor(address _direccion) public {
        DireccionContratoSalud = _direccion;
        DireccionContrato = address(this);
    }

    // Mapping que relacione un ID con un resultadi con una prueba COVID
    //mapping(bytes32 => true) ResultadoCOVID;

    //Mapping Para relacionar el hash de la prueba co el codigo IPFS
    //mapping (bytes32 => string) ResultadoCOVID_IPFS;

    //mapping para poder relacionar el hash de la persona co los resultados (diagnostico, CODIGO IPFS)
    mapping (bytes32 => Resultados) ResultadosCOVID;

    //estructura de los resultados
    struct Resultados{
        bool diagnostico;
        string COdigoIPFS;
    }

    // Eventos
    event NuevoResultado(bool, string);

    // Filtrar la funciones a ejecuar por el centro de salud
    modifier UnicamenteCentroSalud(address _direccion) {
        require(_direccion == DireccionContratoSalud, "No tienes permisos para ejecutar esta funcion");
        _;
    }

    // function ppara emitir un resultaso de una prueba de COVID Campos de entrada: | 12345X | true | QmPn4JNfaKodYbBMin2XYVuim4k1vsU5U7epPFvAez7uvs
    function ResultadoPruebaCovid(string memory _idPersona, bool _resultadoCOVID, string memory _codigoIPFS) public UnicamenteCentroSalud(msg.sender) {
        // Hash de la identificacion de la persona
        bytes32 hash_idPersona = keccak256(abi.encodePacked(_idPersona));
        //Relacion entre el hash de la persona con el resultasi de la prueba COVID
        //ResultadoCOVID[hash_idPersona] = _resultadoCOVID;
        //Relacion con el codigo IPFS
        //ResultadoCOVID_IPFS[hash_idPersona] = _codigoIPFS;
        //relacion del hash de la persona co la estructura de resultados
        ResultadosCOVID[hash_idPersona] = Resultados(_resultadoCOVID, _codigoIPFS);
        //Emitir evento
        emit NuevoResultado(_resultadoCOVID,_codigoIPFS);
    }

    // Funcion que permita la vicualizacion de los resultados
    function VisualizacionResultados(string memory _idPersona) public view returns(string memory _resultadoPrueba, string memory _codigoIPFS) {
        //Hash de la identidad de la persona
        bytes32 hash_idPersona = keccak256(abi.encodePacked(_idPersona));
        // Retorno de un boolea no como un string
        string memory resultadoPrueba;
        if(ResultadosCOVID[hash_idPersona].diagnostico == true) {
            resultadoPrueba = "Positivo";
        } else {
            resultadoPrueba = "Negativo";
        }
        // Retorno de los parametros necesarios
        _resultadoPrueba = resultadoPrueba;
        _codigoIPFS = ResultadosCOVID[hash_idPersona].COdigoIPFS;
    }



}