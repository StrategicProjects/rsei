# Recodify SEI Access Level

Converte os códigos numéricos de nível de acesso do SEI em texto: "0"
-\> "público", "1" -\> "restrito", "2" -\> "sigiloso". Valores ausentes,
vazios ou fora de `c("0","1","2")` são devolvidos inalterados.

## Usage

``` r
recodify_access_level(val)
```

## Arguments

- val:

  Character, geralmente "0", "1" ou "2".

## Value

"público", "restrito", "sigiloso", ou o valor original.

## Examples

``` r
recodify_access_level("0")  # "público"
#> [1] "público"
recodify_access_level("2")  # "sigiloso"
#> [1] "sigiloso"
```
