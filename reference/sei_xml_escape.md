# Escape de texto para XML

Escapa os cinco caracteres reservados de XML (`&`, `<`, `>`, as aspas
duplas e o apóstrofo) em um valor escalar. Usado internamente ao montar
os parâmetros do envelope SOAP.

## Usage

``` r
sei_xml_escape(x)
```

## Arguments

- x:

  Vetor de tamanho 1 (será coagido para character).

## Value

Uma string com os caracteres reservados escapados.
