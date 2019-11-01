pragma solidity >=0.5.12;

contract PregaoEletronico {
    
    struct Licitante { 
        string razaoSocial;
        string cnpj;
        address contaLicitante;
    }
    
    address public contaTesouro;
    uint horarioTermino;
    Licitante public licitanteVencedor;
    uint public menorPreco;

    
    bool encerrado;

    
    event MenorPrecoApresentado(address Ofertante, uint valor);
    event FinaldoPregao(address Vencedor, uint valor);

    
    constructor(address _contaTesouro, uint256 _horarioTermino)
        public {
        horarioTermino = now + _horarioTermino;
        contaTesouro = _contaTesouro;
    } 

    
    function lance(uint256 valorLance, string memory _razaoSocial, string memory _cnpj) public {
        
        require(now <= horarioTermino, "Pregão já foi encerrado");
        require (valorLance>0);
        require(
            valorLance < menorPreco,
            "Já existe um lance com preço menor"
        );

        Licitante memory ll = Licitante(_razaoSocial, _cnpj, msg.sender);
        licitanteVencedor = ll;
        menorPreco = valorLance;
        emit MenorPrecoApresentado(msg.sender, valorLance);
    }

    
    
    
    function finalizaPregao() public {
        
        require(now >= horarioTermino, "Pregão ainda não terminou");
        require(!encerrado, "Pregão já foi encerrado");

        encerrado = true;
        emit FinaldoPregao(licitanteVencedor.contaLicitante, menorPreco);

    }
}
