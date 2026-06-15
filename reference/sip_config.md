# Configuração de conexão SIP

Objeto com os dados das chamadas SIP: URL do Web Service, Chave de
Acesso e `IdSistema`. Valores resolvem de argumentos,
`options(rsei.sip_*)` e variáveis `RSEI_SIP_*`. Sem URL embutida — serve
a qualquer instalação do SIP.

## Usage

``` r
sip_config(sip_url = NULL, chave_acesso = NULL, id_sistema = NULL)
```

## Arguments

- sip_url:

  Character. Endpoint do SIP (ex.:
  `"https://sei.<seu-orgao>.gov.br/sip/controlador_ws.php?servico=sip"`).

- chave_acesso:

  Character. Chave de Acesso do SIP.

- id_sistema:

  Character. Id do sistema no SIP.

## Value

Um objeto de classe `sip_config`.
