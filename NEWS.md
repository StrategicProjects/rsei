# rsei 0.1.0

Primeira versão do `rsei`, um cliente em R para os Web Services SOAP do
**SEI** (Sistema Eletrônico de Informações) e do **SIP** (Sistema de Permissões).

> **Acesso restrito por IP.** Os Web Services do SEI/SIP só respondem a
> requisições vindas de hosts previamente autorizados no cadastro do serviço.
> A autenticação adicional usa `SiglaSistema` + chave de acesso.

## Infraestrutura

* `sei_build_envelope()` / `sei_call()` — montam o envelope SOAP no formato do
  SEI (escalar, estrutura aninhada e arrays `<item>`, com escape de XML) e
  executam a requisição via `httr2`, com `timeout` e falha graciosa, tratando
  erros HTTP e `SOAP Fault`.
* `sei_config()` / `sei_set_default_config()` — configuração (URL, sigla, chave,
  unidade) resolvida de argumentos, `options(rsei.*)`, variáveis `RSEI_*` ou
  `keyring`.

## Consultas

* `consultar_procedimento()` e `consultar_procedimentos()` (em lote, empilhando
  em um `tibble`).
* `consultar_documento()` e `consultar_documentos()` (em lote).
* `consultar_publicacao()` e `consultar_publicacoes()` (em lote).
* `consultar_bloco()`, `consultar_procedimento_individual()`.
* `listar_andamentos()` e `listar_andamentos_completo()` (linha do tempo do
  processo, ordenada cronologicamente).
* Derivados do processo (reconstruídos a partir dos andamentos):
  `listar_documentos_processo()` e `listar_publicacoes_processo()`.

## Listagens

* `listar_unidades()`, `listar_series()`, `listar_tipos_procedimento()`
  (e `_ouvidoria`), `listar_usuarios()`, `listar_hipoteses_legais()`,
  `listar_paises()`, `listar_estados()`, `listar_cidades()`, `listar_cargos()`,
  `listar_contatos()`, `listar_feriados()`, `listar_extensoes_permitidas()`,
  `listar_marcadores_unidade()`, `listar_tipos_conferencia()`.

## Escrita

* Processos: `gerar_procedimento()`, `enviar_processo()`, `atribuir_processo()`,
  `concluir_processo()`, `reabrir_processo()`, `bloquear_processo()` /
  `desbloquear_processo()`, `excluir_processo()`, `anexar_processo()` /
  `desanexar_processo()`, `relacionar_processo()` /
  `remover_relacionamento_processo()`, `sobrestar_processo()` /
  `remover_sobrestamento_processo()`.
* Documentos: `incluir_documento()`, `cancelar_documento()`, `excluir_documento()`.
* Andamentos: `lancar_andamento()`.
* Blocos: `gerar_bloco()`, `incluir_documento_bloco()` /
  `incluir_processo_bloco()`, `retirar_documento_bloco()` /
  `retirar_processo_bloco()`, `disponibilizar_bloco()` /
  `cancelar_disponibilizacao_bloco()`, `excluir_bloco()`.
* Prazos e marcadores: `definir_controle_prazo()`, `concluir_controle_prazo()`,
  `remover_controle_prazo()`, `definir_marcador()`.
* E-mail e contatos: `enviar_email()`, `atualizar_contatos()`.

## SIP

* `sip_config()`, `listar_permissao()`, `replicar_permissao()`,
  `replicar_usuario()` (namespace `sipns`).

## Saída

* As funções devolvem `tibble` por padrão (estruturas 1:1 viram colunas com
  prefixo; coleções ficam como colunas-lista). Use `raw = TRUE` para o
  `xml_document` bruto.
