# Solicitando acesso aos Web Services do SEI

Antes de conseguir qualquer resposta do `rsei`, é preciso que o **órgão
gestor da sua instalação do SEI** (em geral a área de TI, autarquia de
tecnologia ou empresa de informática do governo) habilite o consumo dos
Web Services para o seu sistema. Esta vignette descreve **o que pedir**
e **quais dados enviar**, com base no fluxo típico de solicitação. Os
valores aqui são **fictícios e genéricos** — substitua-os pelos do seu
ambiente.

> **Por que isso é necessário.** Os Web Services do SEI são fechados por
> padrão. O acesso é liberado por *sistema* (uma sigla cadastrada) e
> restrito aos endereços de rede previamente autorizados. Sem esse
> cadastro e a liberação de IP, todas as chamadas falham —
> independentemente do `rsei`.

## Visão geral do fluxo

1.  **Abrir o pedido** com a área gestora do SEI (normalmente via
    chamado).
2.  **Enviar os dados de cadastro** do sistema (lista abaixo).
3.  A área **cadastra o sistema** e solicita a **liberação dos IPs** no
    firewall (costuma ser um chamado separado, em outra equipe).
4.  **Testar no ambiente de treinamento/homologação** primeiro.
5.  Após validar, **solicitar a réplica da configuração em produção**.

Cada instalação do SEI é independente: a sigla, a chave, os endpoints e
os métodos liberados valem **apenas** para aquele ambiente.

## Dados a enviar no pedido

A área gestora normalmente pede os seguintes itens. Um modelo de
mensagem:

    Prezados, solicitamos a habilitacao do consumo dos Web Services do SEI
    para o nosso sistema, nos ambientes de treinamento e producao:

    1) Cadastro do Sistema (sigla do "servico")
       Sigla sugerida: MEU_SISTEMA

    2) IP(s) do servidor de integracao (IP de saida do orgao)
       - <IP publico do servidor que fara as chamadas>
       - <IP adicional, se houver>
       (sao os enderecos que precisam ser liberados no firewall)

    3) Unidades que serao cadastradas
       - Todas  (ou liste as unidades especificas)

    4) Tipos de operacao (metodos a liberar) — ver lista abaixo

    5) Tipos de processo
       - Todos  (ou liste os tipos especificos)

    6) Tipos de documento
       - Todos  (ou deixar em branco)

    Faremos os testes primeiro em treinamento e, apos validacao,
    solicitaremos a migracao para producao.

### 1. Sigla do sistema (`SiglaSistema`)

Um identificador curto do seu sistema, definido por você e cadastrado
pela área gestora (ex.: `MEU_SISTEMA`). É o primeiro parâmetro de toda
chamada.

### 2. IPs de saída (liberação de firewall)

> **Atenção (privacidade/LGPD).** Informe **endereços de rede do
> servidor**, não dados pessoais. Evite enviar nomes de usuários, logins
> de VPN ou qualquer identificador de pessoa física no pedido — eles não
> são necessários para a liberação e ampliam desnecessariamente o
> tratamento de dados pessoais. A liberação é por **IP de saída** do
> host que fará as chamadas.

Se o seu ambiente sai por um IP dinâmico ou por VPN, alinhe com a equipe
de rede uma faixa fixa ou um IP dedicado.

### 3. Tipos de operação (métodos)

Liste os métodos que pretende usar. Peça apenas o necessário (princípio
da minimização). Exemplos comuns:

    consultarProcedimento
    consultarProcedimentoIndividual
    consultarDocumento
    listarAndamentos
    listarUsuarios
    listarUnidades
    gerarProcedimento      # operacoes de escrita — peca so se for usar
    incluirDocumento
    lancarAndamento
    enviarProcesso
    definirMarcador

Nem todo método existe em toda instalação: dependendo da configuração do
servidor, alguns (p. ex. certas listagens) podem **não estar
disponíveis**. Confirme com a área gestora quais foram efetivamente
habilitados.

## A `IdentificacaoServico` (chave de acesso)

Além da sigla, cada chamada exige uma `IdentificacaoServico` — a **chave
de acesso** do serviço, gerada/definida no cadastro do sistema pela área
gestora. Trate-a como segredo:

- **não** a escreva diretamente no código nem a versione no Git;
- prefira variável de ambiente (`RSEI_IDENTIFICACAO_SERVICO`) ou o
  keyring
  ([`store_sei_credentials()`](https://strategicprojects.github.io/rsei/reference/store_sei_credentials.md)).

> O manual do SEI menciona um modo legado baseado em “Endereço” que será
> descontinuado. Prefira já solicitar a **Chave de Acesso** para evitar
> retrabalho.

## Endpoints (treinamento e produção)

Peça à área gestora a URL do Web Service de cada ambiente. O formato
costuma ser:

    https://<host-do-seu-sei>/sei/ws/SeiWS.php        # SEI principal
    https://<host-do-seu-sei>/sip/ws/...              # SIP (permissoes)

Use **treinamento/homologação** para validar tudo — sobretudo as
operações de escrita — antes de tocar em produção.

## Configurando o `rsei` com o que foi liberado

Com a sigla, a chave e a URL em mãos:

``` r

library(rsei)

# Guarde a sigla e a chave fora do código (keyring); faça isso uma vez por máquina.
store_sei_credentials(
  service_name = "SEI_WS",
  username     = "MEU_SISTEMA",        # sigla do sistema (SiglaSistema)
  password     = "SUA_CHAVE_DE_ACESSO" # chave de acesso (IdentificacaoServico)
)

# Recupere as credenciais guardadas quando precisar montar a configuração.
creds <- get_sei_credentials("SEI_WS")

cfg <- sei_config(
  sei_url               = "https://sei.exemplo.gov.br/sei/ws/SeiWS.php",
  sigla_sistema         = creds$username,
  identificacao_servico = creds$password
)

# Teste rápido: uma listagem leve confirma sigla + chave + liberação de IP.
listar_unidades(cfg)
```

Se a chamada retornar dados, o trio **sigla + chave + IP liberado** está
correto. Erros comuns:

- *SOAP Fault* de autenticação → sigla ou chave incorretas;
- *timeout* / conexão recusada → IP ainda não liberado no firewall, ou
  você está chamando de um host diferente do autorizado;
- método “não encontrado” → operação não habilitada naquela instalação.

## Boas práticas de privacidade e segurança (LGPD)

Os processos e documentos do SEI frequentemente contêm **dados
pessoais** e até **dados sensíveis**. Ao automatizar consultas com o
`rsei`:

- **Minimize**: solicite e consulte apenas os métodos e processos
  necessários à sua finalidade.
- **Não exponha segredos**: chaves de acesso e credenciais nunca devem
  ir para o código-fonte, logs ou repositórios. Use keyring ou variáveis
  de ambiente.
- **Cuidado ao salvar respostas**: os `tibble` retornados podem conter
  nomes, e-mails e teores de documentos. Trate-os como dados pessoais —
  controle acesso, evite cópias desnecessárias e não os publique.
- **Anonimização em exemplos**: ao compartilhar código, relatórios ou
  abrir *issues*, use protocolos e identificadores **fictícios** (como
  nesta vignette), nunca dados reais.
- **Respeite o nível de acesso**: o campo `NivelAcessoGlobal`
  (`público`/`restrito`/`sigiloso`) indica a classificação do processo
  no SEI. Não use o Web Service para contornar restrições de acesso.

Documente a **base legal** e a finalidade do tratamento junto à área de
privacidade/encarregado (DPO) do seu órgão antes de colocar a integração
em produção.
