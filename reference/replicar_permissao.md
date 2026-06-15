# replicar_permissao

Replica (cadastra/altera/exclui) permissões no SIP
(`replicarPermissao`).

## Usage

``` r
replicar_permissao(permissoes, config = sip_config(), verbose = FALSE)
```

## Arguments

- permissoes:

  Lista de permissões; cada uma uma lista nomeada com campos da
  estrutura `Permissao` (ao menos `StaOperacao`, `IdSistema`,
  `IdPerfil`).

- config:

  Um objeto
  [`sip_config()`](https://strategicprojects.github.io/rsei/reference/sip_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
