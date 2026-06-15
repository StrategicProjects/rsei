# gerar_procedimento

Gera um novo processo (`gerarProcedimento`). Operação de escrita.

## Usage

``` r
gerar_procedimento(
  procedimento,
  config = sei_config(),
  documentos = list(),
  procedimentos_relacionados = NULL,
  unidades_envio = NULL,
  sin_manter_aberto_unidade = "S",
  sin_enviar_email_notificacao = "N",
  data_retorno_programado = NULL,
  dias_retorno_programado = NULL,
  sin_dias_uteis_retorno_programado = "N",
  id_marcador = NULL,
  texto_marcador = NULL,
  data_controle_prazo = NULL,
  dias_controle_prazo = NULL,
  sin_dias_uteis_controle_prazo = "N",
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- procedimento:

  Lista nomeada / objeto
  [`Procedimento()`](https://strategicprojects.github.io/rsei/reference/Procedimento.md)
  com os dados do processo.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- documentos:

  Lista de documentos a gerar junto (objetos
  [`Documento()`](https://strategicprojects.github.io/rsei/reference/Documento.md));
  ou [`list()`](https://rdrr.io/r/base/list.html).

- procedimentos_relacionados, unidades_envio:

  Vetores de ids (opcionais).

- sin_manter_aberto_unidade, sin_enviar_email_notificacao:

  "S"/"N".

- data_retorno_programado, dias_retorno_programado,
  sin_dias_uteis_retorno_programado:

  Retorno programado.

- id_marcador, texto_marcador:

  Marcador opcional.

- data_controle_prazo, dias_controle_prazo,
  sin_dias_uteis_controle_prazo:

  Controle de prazo opcional.

- raw, verbose:

  Logical.

## Value

Um `tibble`
([parse_retorno_geracao_procedimento](https://strategicprojects.github.io/rsei/reference/parse_retorno_geracao_procedimento.md))
ou `xml_document` se `raw=TRUE`.
