# parse_retorno_inclusao_documento

Parseia o retorno de `incluirDocumento` (`RetornoInclusaoDocumento`).

## Usage

``` r
parse_retorno_inclusao_documento(doc)
```

## Arguments

- doc:

  Um `xml2::xml_document`.

## Value

Um tibble de 1 linha com `IdDocumento`, `DocumentoFormatado`,
`LinkAcesso`.
