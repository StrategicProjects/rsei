# parse_list_response

Parser genérico para respostas `listar*`: encontra `<parametros>` (que é
um array) e aplica `item_parser` a cada `<item>` filho direto. Para
estruturas planas prefira o caminho vetorizado interno (via mapas de
campo), bem mais rápido em listas grandes.

## Usage

``` r
parse_list_response(doc, response_name, item_parser)
```

## Arguments

- doc:

  Um `xml2::xml_document`.

- response_name:

  Character. Nome do elemento de resposta.

- item_parser:

  Função que parseia um nó `<item>` num tibble de 1 linha.

## Value

Um tibble com uma linha por item (vazio se não houver itens).
