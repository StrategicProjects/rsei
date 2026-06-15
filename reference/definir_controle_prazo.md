# definir_controle_prazo

Define controle de prazo para processos (`definirControlePrazo`).

## Usage

``` r
definir_controle_prazo(definicoes, config = sei_config(), verbose = FALSE)
```

## Arguments

- definicoes:

  Lista de definições (cada uma com `ProtocoloProcedimento` e
  `DataPrazo` OU `Dias`/`SinDiasUteis`).

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
