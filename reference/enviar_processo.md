# enviar_processo

Envia (tramita) um processo para outras unidades (`enviarProcesso`).

## Usage

``` r
enviar_processo(
  protocolo_procedimento,
  unidades_destino,
  config = sei_config(),
  sin_manter_aberto_unidade = "N",
  sin_remover_anotacao = "N",
  sin_enviar_email_notificacao = "N",
  data_retorno_programado = NULL,
  dias_retorno_programado = NULL,
  sin_dias_uteis_retorno_programado = "N",
  sin_reabrir = "N",
  verbose = FALSE
)
```

## Arguments

- protocolo_procedimento:

  Character. Número do processo.

- unidades_destino:

  Vetor de ids de unidades de destino.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- sin_manter_aberto_unidade, sin_remover_anotacao,
  sin_enviar_email_notificacao:

  "S"/"N".

- data_retorno_programado, dias_retorno_programado,
  sin_dias_uteis_retorno_programado:

  Retorno programado.

- sin_reabrir:

  "S"/"N".

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
