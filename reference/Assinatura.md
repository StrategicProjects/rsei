# Assinatura

Represents the "Assinatura" structure (signature information).

## Usage

``` r
Assinatura(
  Nome = NULL,
  CargoFuncao = NULL,
  DataHora = NULL,
  IdUsuario = NULL,
  IdOrigem = NULL,
  IdOrgao = NULL,
  Sigla = NULL
)
```

## Arguments

- Nome:

  Character. Signatory name.

- CargoFuncao:

  Character. Signatory position or function.

- DataHora:

  Character. Date/time of signature.

- IdUsuario:

  Character. ID of the user.

- IdOrigem:

  Character. Origin ID of the user in the SIP.

- IdOrgao:

  Character. ID of the user's organization.

- Sigla:

  Character. The user's sigla (username).

## Value

An S3 object of class "Assinatura".
