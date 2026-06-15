# remover_controle_prazo

Remove o controle de prazo de processos (`removerControlePrazo`).

## Usage

``` r
remover_controle_prazo(
  protocolos_procedimentos,
  config = sei_config(),
  verbose = FALSE
)
```

## Arguments

- protocolos_procedimentos:

  Vetor de números de processos.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
