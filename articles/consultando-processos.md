# Consultando processos no SEI

O `rsei` conversa com os Web Services SOAP do SEI (Sistema Eletrônico de
Informações) e devolve os resultados como `tibble`.

> **Acesso restrito por IP.** Os Web Services do SEI só respondem a
> requisições vindas de IPs/servidores previamente autorizados no
> cadastro do serviço. Os exemplos abaixo só retornam dados quando
> executados a partir de um host autorizado. Por isso, os blocos de
> código desta vignette não são executados.

## Configuração

Toda função aceita um objeto `config` criado por
[`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).
Os valores podem vir de argumentos, de `options(rsei.*)` ou de variáveis
de ambiente (`RSEI_*`). A `IdentificacaoServico` é a chave de acesso do
serviço.

``` r

library(rsei)

# O pacote serve a qualquer instalação do SEI: informe `sei_url` com o
# endpoint do Web Service do seu servidor.
cfg <- sei_config(
  sei_url               = "https://sei.exemplo.gov.br/sei/ws/SeiWS.php",
  sigla_sistema         = "MEU_SISTEMA",
  identificacao_servico = Sys.getenv("RSEI_IDENTIFICACAO_SERVICO")
)

# Alternativa: fixar como padrão da sessão (dispensa passar `config`)
sei_set_default_config(
  sei_url               = "https://sei.exemplo.gov.br/sei/ws/SeiWS.php",
  sigla_sistema         = "MEU_SISTEMA",
  identificacao_servico = Sys.getenv("RSEI_IDENTIFICACAO_SERVICO")
)
```

## Consultar um processo

[`consultar_procedimento()`](https://strategicprojects.github.io/rsei/reference/consultar_procedimento.md)
retorna um `tibble` de uma linha. Campos escalares e estruturas 1:1
(tipo de processo, andamentos) viram colunas; coleções (assuntos,
interessados, unidades onde o processo está aberto) ficam como
*colunas-lista* de tibbles.

``` r

proc <- consultar_procedimento("0000000000.000001/2020-11", config = cfg)

proc$Especificacao
proc$NivelAcessoGlobal            # recodificado: "público"/"restrito"/"sigiloso"
proc$TipoProcedimento_Nome
proc$UltimoAndamento_DataHora

# colunas-lista
proc$Assuntos[[1]]
proc$Interessados[[1]]
proc$UnidadesProcedimentoAberto[[1]]
```

Para obter o XML bruto (sem parse), use `raw = TRUE`:

``` r

doc <- consultar_procedimento("0000000000.000001/2020-11", config = cfg, raw = TRUE)
```

## Consultar vários processos

[`consultar_procedimentos()`](https://strategicprojects.github.io/rsei/reference/consultar_procedimentos.md)
(plural) consulta um vetor de protocolos e empilha tudo num único
`tibble`, com uma coluna `protocolo` e uma coluna `erro` (`NA` quando
deu certo). Um protocolo inválido não interrompe o lote:

``` r

protocolos <- c("0000000000.000001/2020-11", "0000000000.000003/2020-33")
processos  <- consultar_procedimentos(protocolos, config = cfg)

processos[, c("protocolo", "Especificacao", "NivelAcessoGlobal", "erro")]

# processos que falharam
subset(processos, !is.na(erro), c("protocolo", "erro"))
```

## Documentos e publicações

``` r

doc <- consultar_documento("0000001", config = cfg)
doc$Serie_Nome
doc$Assinaturas[[1]]

pub <- consultar_publicacao(id_documento = "20000002", config = cfg)
```

## Listagens

As funções `listar_*` devolvem um `tibble` com uma linha por item.

``` r

unidades <- listar_unidades(cfg)        # todas as unidades acessíveis ao serviço
series   <- listar_series(cfg)
tipos    <- listar_tipos_procedimento(cfg)
estados  <- listar_estados(cfg)
```

## Tratamento de erros

Falhas de SOAP (`SOAP Fault`) viram erros de R com a mensagem do
servidor:

``` r

tryCatch(
  consultar_bloco("999999", config = cfg),
  error = function(e) conditionMessage(e)
)
#> "SOAP Fault em 'consultarBloco' [SOAP-ENV:Client]: Unidade ... não tem acesso ..."
```

## Operações de escrita

[`gerar_procedimento()`](https://strategicprojects.github.io/rsei/reference/gerar_procedimento.md),
[`incluir_documento()`](https://strategicprojects.github.io/rsei/reference/incluir_documento.md),
[`enviar_processo()`](https://strategicprojects.github.io/rsei/reference/enviar_processo.md),
[`lancar_andamento()`](https://strategicprojects.github.io/rsei/reference/lancar_andamento.md)
e correlatas **alteram dados** no SEI. Valide-as em ambiente de
homologação/treino antes de usar em produção.

``` r

novo <- gerar_procedimento(
  Procedimento(
    IdTipoProcedimento = "100000368",
    Especificacao      = "Processo de teste",
    Assuntos           = list(Assunto(CodigoEstruturado = "00.01.01"))
  ),
  config = cfg
)
novo$ProcedimentoFormatado
```
