# SEI Connection Configuration

Builds a configuration object holding the values that every SEI Web
Service call needs: the endpoint URL, the system sigla (`SiglaSistema`),
the service access key (`IdentificacaoServico`) and the default unit id
(`IdUnidade`). Values are resolved, in order, from the arguments,
`options(rsei.*)` and environment variables (`RSEI_*`).

The package is not tied to any particular SEI installation: set
`sei_url` to the Web Service endpoint of your own SEI server, e.g.
`"https://sei.<your-org>.gov.br/sei/ws/SeiWS.php"` (or the
`controlador_ws.php?servico=sei` form).

## Usage

``` r
sei_config(
  sei_url = NULL,
  sigla_sistema = NULL,
  identificacao_servico = NULL,
  id_unidade = NULL
)
```

## Arguments

- sei_url:

  Character. SEI Web Service endpoint (required for live calls).
  Resolves from the argument, `getOption("rsei.sei_url")` or
  `Sys.getenv("RSEI_URL")`. There is no built-in default, so the package
  works with any SEI installation.

- sigla_sistema:

  Character. System sigla registered in SEI.

- identificacao_servico:

  Character. Service access key (*chave de acesso*).

- id_unidade:

  Character. Default unit id; many operations accept an empty string.

## Value

An object of class `"sei_config"`: a named list with `sei_url`,
`sigla_sistema`, `identificacao_servico` and `id_unidade`.

## Examples

``` r
cfg <- sei_config(
  sei_url = "https://sei.exemplo.gov.br/sei/ws/SeiWS.php",
  sigla_sistema = "MEU_SISTEMA",
  identificacao_servico = "minha-chave"
)
cfg$sei_url
#> [1] "https://sei.exemplo.gov.br/sei/ws/SeiWS.php"
```
