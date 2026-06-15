# parse_retorno_envio_email

Parseia o retorno de `enviarEmail` (`RetornoEnvioEmail`).

## Usage

``` r
parse_retorno_envio_email(doc)
```

## Arguments

- doc:

  Um `xml2::xml_document`.

## Value

Um tibble de 1 linha com `IdDocumento`, `DocumentoFormatado`,
`LinkAcesso`.
