# replicar_usuario

Replica (cadastra/altera/desativa/reativa) usuários no SIP
(`replicarUsuario`).

## Usage

``` r
replicar_usuario(
  usuarios,
  config = sip_config(),
  sin_considerar_orgao = "N",
  verbose = FALSE
)
```

## Arguments

- usuarios:

  Lista de usuários; cada um uma lista nomeada (ao menos `StaOperacao` e
  `IdOrigem`).

- config:

  Um objeto
  [`sip_config()`](https://strategicprojects.github.io/rsei/reference/sip_config.md).

- sin_considerar_orgao:

  "S"/"N".

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
