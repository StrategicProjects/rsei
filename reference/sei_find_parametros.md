# Localiza o nó `<parametros>` da Resposta

Helper interno que encontra o nó `parametros` dentro de uma resposta
`<...Response>`, ignorando namespaces. Base para os parsers.

## Usage

``` r
sei_find_parametros(doc, response = NULL)
```

## Arguments

- doc:

  Um `xml2::xml_document` (resposta SOAP).

- response:

  Character opcional. Nome do elemento de resposta (ex.:
  "consultarProcedimentoResponse") para ancorar a busca.

## Value

O nó `parametros`, ou `NULL` se não encontrado.
