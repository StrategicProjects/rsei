# parse_protocolo_bloco

Parseia uma estrutura `ProtocoloBloco`.

## Usage

``` r
parse_protocolo_bloco(node)
```

## Arguments

- node:

  Nó `xml2` (um `<item>` de `Protocolos`).

## Value

Um tibble de 1 linha com `ProtocoloFormatado`, `Identificacao` e
`Assinaturas` (coluna-lista).
