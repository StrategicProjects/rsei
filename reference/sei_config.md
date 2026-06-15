# SEI Connection Configuration

Builds a configuration object holding the values that every SEI Web
Service call needs: the endpoint URL, the system sigla (`SiglaSistema`),
the service access key (`IdentificacaoServico`) and the default unit id
(`IdUnidade`). Defaults are resolved, in order, from the arguments,
`options(rsei.*)`, environment variables (`RSEI_*`) and finally the
built-in fallbacks.

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

  Character. SEI Web Service endpoint. Default resolves from
  `getOption("rsei.sei_url")` / `Sys.getenv("RSEI_URL")` /
  `"https://sei.pe.gov.br/sei/ws/SeiWS.php"`.

- sigla_sistema:

  Character. System sigla registered in SEI (e.g. "HORTENSIAS").

- identificacao_servico:

  Character. Service access key (*chave de acesso*).

- id_unidade:

  Character. Default unit id; many operations accept an empty string.

## Value

An object of class `"sei_config"`: a named list with `sei_url`,
`sigla_sistema`, `identificacao_servico` and `id_unidade`.

## Examples

``` r
cfg <- sei_config(sigla_sistema = "HORTENSIAS", identificacao_servico = "minha-chave")
cfg$sei_url
#> [1] "https://sei.pe.gov.br/sei/ws/SeiWS.php"
```
