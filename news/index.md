# Changelog

## rsei 0.1.0

Primeira versão do `rsei`, um cliente em R para os Web Services SOAP do
**SEI** (Sistema Eletrônico de Informações) e do **SIP** (Sistema de
Permissões).

> **Acesso restrito por IP.** Os Web Services do SEI/SIP só respondem a
> requisições vindas de hosts previamente autorizados no cadastro do
> serviço. A autenticação adicional usa `SiglaSistema` + chave de
> acesso.

### Infraestrutura

- [`sei_build_envelope()`](https://strategicprojects.github.io/rsei/reference/sei_build_envelope.md)
  /
  [`sei_call()`](https://strategicprojects.github.io/rsei/reference/sei_call.md)
  — montam o envelope SOAP no formato do SEI (escalar, estrutura
  aninhada e arrays `<item>`, com escape de XML) e executam a requisição
  via `httr2`, com `timeout` e falha graciosa, tratando erros HTTP e
  `SOAP Fault`.
- [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md)
  /
  [`sei_set_default_config()`](https://strategicprojects.github.io/rsei/reference/sei_set_default_config.md)
  — configuração (URL, sigla, chave, unidade) resolvida de argumentos,
  `options(rsei.*)`, variáveis `RSEI_*` ou `keyring`.

### Consultas

- [`consultar_procedimento()`](https://strategicprojects.github.io/rsei/reference/consultar_procedimento.md)
  e
  [`consultar_procedimentos()`](https://strategicprojects.github.io/rsei/reference/consultar_procedimentos.md)
  (em lote, empilhando em um `tibble`).
- [`consultar_documento()`](https://strategicprojects.github.io/rsei/reference/consultar_documento.md)
  e
  [`consultar_documentos()`](https://strategicprojects.github.io/rsei/reference/consultar_documentos.md)
  (em lote).
- [`consultar_publicacao()`](https://strategicprojects.github.io/rsei/reference/consultar_publicacao.md)
  e
  [`consultar_publicacoes()`](https://strategicprojects.github.io/rsei/reference/consultar_publicacoes.md)
  (em lote).
- [`consultar_bloco()`](https://strategicprojects.github.io/rsei/reference/consultar_bloco.md),
  [`consultar_procedimento_individual()`](https://strategicprojects.github.io/rsei/reference/consultar_procedimento_individual.md).
- [`listar_andamentos()`](https://strategicprojects.github.io/rsei/reference/listar_andamentos.md)
  e
  [`listar_andamentos_completo()`](https://strategicprojects.github.io/rsei/reference/listar_andamentos_completo.md)
  (linha do tempo do processo, ordenada cronologicamente).
- Derivados do processo (reconstruídos a partir dos andamentos):
  [`listar_documentos_processo()`](https://strategicprojects.github.io/rsei/reference/listar_documentos_processo.md)
  e
  [`listar_publicacoes_processo()`](https://strategicprojects.github.io/rsei/reference/listar_publicacoes_processo.md).

### Listagens

- [`listar_unidades()`](https://strategicprojects.github.io/rsei/reference/listar_unidades.md),
  [`listar_series()`](https://strategicprojects.github.io/rsei/reference/listar_series.md),
  [`listar_tipos_procedimento()`](https://strategicprojects.github.io/rsei/reference/listar_tipos_procedimento.md)
  (e `_ouvidoria`),
  [`listar_usuarios()`](https://strategicprojects.github.io/rsei/reference/listar_usuarios.md),
  [`listar_hipoteses_legais()`](https://strategicprojects.github.io/rsei/reference/listar_hipoteses_legais.md),
  [`listar_paises()`](https://strategicprojects.github.io/rsei/reference/listar_paises.md),
  [`listar_estados()`](https://strategicprojects.github.io/rsei/reference/listar_estados.md),
  [`listar_cidades()`](https://strategicprojects.github.io/rsei/reference/listar_cidades.md),
  [`listar_cargos()`](https://strategicprojects.github.io/rsei/reference/listar_cargos.md),
  [`listar_contatos()`](https://strategicprojects.github.io/rsei/reference/listar_contatos.md),
  [`listar_feriados()`](https://strategicprojects.github.io/rsei/reference/listar_feriados.md),
  [`listar_extensoes_permitidas()`](https://strategicprojects.github.io/rsei/reference/listar_extensoes_permitidas.md),
  [`listar_marcadores_unidade()`](https://strategicprojects.github.io/rsei/reference/listar_marcadores_unidade.md),
  [`listar_tipos_conferencia()`](https://strategicprojects.github.io/rsei/reference/listar_tipos_conferencia.md).

### Escrita

- Processos:
  [`gerar_procedimento()`](https://strategicprojects.github.io/rsei/reference/gerar_procedimento.md),
  [`enviar_processo()`](https://strategicprojects.github.io/rsei/reference/enviar_processo.md),
  [`atribuir_processo()`](https://strategicprojects.github.io/rsei/reference/atribuir_processo.md),
  [`concluir_processo()`](https://strategicprojects.github.io/rsei/reference/concluir_processo.md),
  [`reabrir_processo()`](https://strategicprojects.github.io/rsei/reference/reabrir_processo.md),
  [`bloquear_processo()`](https://strategicprojects.github.io/rsei/reference/bloquear_processo.md)
  /
  [`desbloquear_processo()`](https://strategicprojects.github.io/rsei/reference/desbloquear_processo.md),
  [`excluir_processo()`](https://strategicprojects.github.io/rsei/reference/excluir_processo.md),
  [`anexar_processo()`](https://strategicprojects.github.io/rsei/reference/anexar_processo.md)
  /
  [`desanexar_processo()`](https://strategicprojects.github.io/rsei/reference/desanexar_processo.md),
  [`relacionar_processo()`](https://strategicprojects.github.io/rsei/reference/relacionar_processo.md)
  /
  [`remover_relacionamento_processo()`](https://strategicprojects.github.io/rsei/reference/remover_relacionamento_processo.md),
  [`sobrestar_processo()`](https://strategicprojects.github.io/rsei/reference/sobrestar_processo.md)
  /
  [`remover_sobrestamento_processo()`](https://strategicprojects.github.io/rsei/reference/remover_sobrestamento_processo.md).
- Documentos:
  [`incluir_documento()`](https://strategicprojects.github.io/rsei/reference/incluir_documento.md),
  [`cancelar_documento()`](https://strategicprojects.github.io/rsei/reference/cancelar_documento.md),
  [`excluir_documento()`](https://strategicprojects.github.io/rsei/reference/excluir_documento.md).
- Andamentos:
  [`lancar_andamento()`](https://strategicprojects.github.io/rsei/reference/lancar_andamento.md).
- Blocos:
  [`gerar_bloco()`](https://strategicprojects.github.io/rsei/reference/gerar_bloco.md),
  [`incluir_documento_bloco()`](https://strategicprojects.github.io/rsei/reference/incluir_documento_bloco.md)
  /
  [`incluir_processo_bloco()`](https://strategicprojects.github.io/rsei/reference/incluir_processo_bloco.md),
  [`retirar_documento_bloco()`](https://strategicprojects.github.io/rsei/reference/retirar_documento_bloco.md)
  /
  [`retirar_processo_bloco()`](https://strategicprojects.github.io/rsei/reference/retirar_processo_bloco.md),
  [`disponibilizar_bloco()`](https://strategicprojects.github.io/rsei/reference/disponibilizar_bloco.md)
  /
  [`cancelar_disponibilizacao_bloco()`](https://strategicprojects.github.io/rsei/reference/cancelar_disponibilizacao_bloco.md),
  [`excluir_bloco()`](https://strategicprojects.github.io/rsei/reference/excluir_bloco.md).
- Prazos e marcadores:
  [`definir_controle_prazo()`](https://strategicprojects.github.io/rsei/reference/definir_controle_prazo.md),
  [`concluir_controle_prazo()`](https://strategicprojects.github.io/rsei/reference/concluir_controle_prazo.md),
  [`remover_controle_prazo()`](https://strategicprojects.github.io/rsei/reference/remover_controle_prazo.md),
  [`definir_marcador()`](https://strategicprojects.github.io/rsei/reference/definir_marcador.md).
- E-mail e contatos:
  [`enviar_email()`](https://strategicprojects.github.io/rsei/reference/enviar_email.md),
  [`atualizar_contatos()`](https://strategicprojects.github.io/rsei/reference/atualizar_contatos.md).

### SIP

- [`sip_config()`](https://strategicprojects.github.io/rsei/reference/sip_config.md),
  [`listar_permissao()`](https://strategicprojects.github.io/rsei/reference/listar_permissao.md),
  [`replicar_permissao()`](https://strategicprojects.github.io/rsei/reference/replicar_permissao.md),
  [`replicar_usuario()`](https://strategicprojects.github.io/rsei/reference/replicar_usuario.md)
  (namespace `sipns`).

### Saída

- As funções devolvem `tibble` por padrão (estruturas 1:1 viram colunas
  com prefixo; coleções ficam como colunas-lista). Use `raw = TRUE` para
  o `xml_document` bruto.
