# Set Default SEI Configuration for the Session

Stores the given configuration values as `options(rsei.*)` so subsequent
calls to
[`sei_config`](https://strategicprojects.github.io/rsei/reference/sei_config.md)
(and therefore every operation) pick them up without having to pass
`config` explicitly.

## Usage

``` r
sei_set_default_config(
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

Invisibly, the previous options (as returned by
[`options()`](https://rdrr.io/r/base/options.html)).

## Examples

``` r
if (FALSE) { # \dontrun{
sei_set_default_config(
  sigla_sistema = "HORTENSIAS",
  identificacao_servico = Sys.getenv("RSEI_IDENTIFICACAO_SERVICO")
)
} # }
```
