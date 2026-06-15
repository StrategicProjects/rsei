# file: R/escrita.R
#
# Wrappers das operações de ESCRITA do SEI sobre o core. Estas operações
# ALTERAM dados — valide em servidor de homologação/treino, não em produção.
# As que retornam apenas confirmação devolvem TRUE/FALSE; as que retornam
# estruturas devolvem um tibble.

# Parâmetros padrão presentes em quase toda operação.
.std_params <- function(config, ...) {
  c(list(SiglaSistema = config$sigla_sistema,
         IdentificacaoServico = config$identificacao_servico,
         IdUnidade = config$id_unidade),
    list(...))
}

# Converte vetor -> lista (array de <item>); NULL permanece NULL (omitido).
.as_item_list <- function(x) if (is.null(x)) NULL else as.list(as.character(x))

#' @title gerar_procedimento
#' @description Gera um novo processo (`gerarProcedimento`). Operação de escrita.
#' @param procedimento Lista nomeada / objeto [Procedimento()] com os dados do processo.
#' @param config Um objeto [sei_config()].
#' @param documentos Lista de documentos a gerar junto (objetos [Documento()]); ou `list()`.
#' @param procedimentos_relacionados,unidades_envio Vetores de ids (opcionais).
#' @param sin_manter_aberto_unidade,sin_enviar_email_notificacao "S"/"N".
#' @param data_retorno_programado,dias_retorno_programado,sin_dias_uteis_retorno_programado Retorno programado.
#' @param id_marcador,texto_marcador Marcador opcional.
#' @param data_controle_prazo,dias_controle_prazo,sin_dias_uteis_controle_prazo Controle de prazo opcional.
#' @param raw,verbose Logical.
#' @return Um `tibble` ([parse_retorno_geracao_procedimento]) ou `xml_document` se `raw=TRUE`.
#' @export
gerar_procedimento <- function(procedimento, config = sei_config(),
                               documentos = list(),
                               procedimentos_relacionados = NULL, unidades_envio = NULL,
                               sin_manter_aberto_unidade = "S",
                               sin_enviar_email_notificacao = "N",
                               data_retorno_programado = NULL, dias_retorno_programado = NULL,
                               sin_dias_uteis_retorno_programado = "N",
                               id_marcador = NULL, texto_marcador = NULL,
                               data_controle_prazo = NULL, dias_controle_prazo = NULL,
                               sin_dias_uteis_controle_prazo = "N",
                               raw = FALSE, verbose = FALSE) {
  params <- .std_params(config,
    Procedimento                = procedimento,
    Documentos                  = unname(documentos),
    ProcedimentosRelacionados   = .as_item_list(procedimentos_relacionados),
    UnidadesEnvio               = .as_item_list(unidades_envio),
    SinManterAbertoUnidade      = sin_manter_aberto_unidade,
    SinEnviarEmailNotificacao   = sin_enviar_email_notificacao,
    DataRetornoProgramado       = data_retorno_programado,
    DiasRetornoProgramado       = dias_retorno_programado,
    SinDiasUteisRetornoProgramado = sin_dias_uteis_retorno_programado,
    IdMarcador                  = id_marcador,
    TextoMarcador               = texto_marcador,
    DataControlePrazo           = data_controle_prazo,
    DiasControlePrazo           = dias_controle_prazo,
    SinDiasUteisControlePrazo   = sin_dias_uteis_controle_prazo)
  doc <- sei_call("gerarProcedimento", params, config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  parse_retorno_geracao_procedimento(doc)
}

#' @title incluir_documento
#' @description Inclui um documento em um processo (`incluirDocumento`). Escrita.
#' @param documento Lista nomeada / objeto [Documento()].
#' @param config Um objeto [sei_config()].
#' @param raw,verbose Logical.
#' @return Um `tibble` ([parse_retorno_inclusao_documento]) ou `xml_document`.
#' @export
incluir_documento <- function(documento, config = sei_config(),
                              raw = FALSE, verbose = FALSE) {
  params <- .std_params(config, Documento = documento)
  doc <- sei_call("incluirDocumento", params, config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  parse_retorno_inclusao_documento(doc)
}

#' @title enviar_processo
#' @description Envia (tramita) um processo para outras unidades (`enviarProcesso`).
#' @param protocolo_procedimento Character. Número do processo.
#' @param unidades_destino Vetor de ids de unidades de destino.
#' @param config Um objeto [sei_config()].
#' @param sin_manter_aberto_unidade,sin_remover_anotacao,sin_enviar_email_notificacao "S"/"N".
#' @param data_retorno_programado,dias_retorno_programado,sin_dias_uteis_retorno_programado Retorno programado.
#' @param sin_reabrir "S"/"N".
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
enviar_processo <- function(protocolo_procedimento, unidades_destino, config = sei_config(),
                            sin_manter_aberto_unidade = "N", sin_remover_anotacao = "N",
                            sin_enviar_email_notificacao = "N",
                            data_retorno_programado = NULL, dias_retorno_programado = NULL,
                            sin_dias_uteis_retorno_programado = "N",
                            sin_reabrir = "N", verbose = FALSE) {
  params <- .std_params(config,
    ProtocoloProcedimento = protocolo_procedimento,
    UnidadesDestino       = .as_item_list(unidades_destino),
    SinManterAbertoUnidade = sin_manter_aberto_unidade,
    SinRemoverAnotacao    = sin_remover_anotacao,
    SinEnviarEmailNotificacao = sin_enviar_email_notificacao,
    DataRetornoProgramado = data_retorno_programado,
    DiasRetornoProgramado = dias_retorno_programado,
    SinDiasUteisRetornoProgramado = sin_dias_uteis_retorno_programado,
    SinReabrir            = sin_reabrir)
  sei_parse_bool(sei_call("enviarProcesso", params, config, verbose = verbose))
}

#' @title lancar_andamento
#' @description Lança um andamento em um processo (`lancarAndamento`). Escrita.
#' @param protocolo_procedimento Character. Número do processo.
#' @param config Um objeto [sei_config()].
#' @param id_tarefa,id_tarefa_modulo Identificador da tarefa (informe um). `id_tarefa`
#'   deve ser >= 1000, ou 65 (atualização de andamento, com atributo DESCRICAO).
#' @param atributos Lista de atributos (cada um `list(Nome=, Valor=, IdOrigem=)`).
#' @param raw,verbose Logical.
#' @return Um `tibble` do andamento gerado ([parse_andamento_response]).
#' @export
lancar_andamento <- function(protocolo_procedimento, config = sei_config(),
                             id_tarefa = NULL, id_tarefa_modulo = NULL,
                             atributos = list(), raw = FALSE, verbose = FALSE) {
  params <- .std_params(config,
    ProtocoloProcedimento = protocolo_procedimento,
    IdTarefa              = id_tarefa,
    IdTarefaModulo        = id_tarefa_modulo,
    Atributos             = unname(atributos))
  doc <- sei_call("lancarAndamento", params, config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  parse_andamento_response(doc)
}

# ---- operações simples sobre processo (retornam TRUE) -----------------------

#' @title atribuir_processo
#' @description Atribui um processo a um usuário na unidade (`atribuirProcesso`).
#' @param protocolo_procedimento Character. Número do processo.
#' @param id_usuario Character. Id do usuário no SIP.
#' @param config Um objeto [sei_config()].
#' @param sin_reabrir "S"/"N".
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
atribuir_processo <- function(protocolo_procedimento, id_usuario, config = sei_config(),
                              sin_reabrir = "N", verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento = protocolo_procedimento,
                        IdUsuario = id_usuario, SinReabrir = sin_reabrir)
  sei_parse_bool(sei_call("atribuirProcesso", params, config, verbose = verbose))
}

#' @title concluir_processo
#' @description Conclui um processo na unidade (`concluirProcesso`).
#' @param protocolo_procedimento Character. Número do processo.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
concluir_processo <- function(protocolo_procedimento, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento = protocolo_procedimento)
  sei_parse_bool(sei_call("concluirProcesso", params, config, verbose = verbose))
}

#' @title reabrir_processo
#' @description Reabre um processo na unidade (`reabrirProcesso`).
#' @param protocolo_procedimento Character. Número do processo.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
reabrir_processo <- function(protocolo_procedimento, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento = protocolo_procedimento)
  sei_parse_bool(sei_call("reabrirProcesso", params, config, verbose = verbose))
}

#' @title bloquear_processo
#' @description Bloqueia um processo (`bloquearProcesso`).
#' @param protocolo_procedimento Character. Número do processo.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
bloquear_processo <- function(protocolo_procedimento, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento = protocolo_procedimento)
  sei_parse_bool(sei_call("bloquearProcesso", params, config, verbose = verbose))
}

#' @title desbloquear_processo
#' @description Desbloqueia um processo (`desbloquearProcesso`).
#' @param protocolo_procedimento Character. Número do processo.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
desbloquear_processo <- function(protocolo_procedimento, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento = protocolo_procedimento)
  sei_parse_bool(sei_call("desbloquearProcesso", params, config, verbose = verbose))
}

#' @title excluir_processo
#' @description Exclui um processo (`excluirProcesso`). Irreversível.
#' @param protocolo_procedimento Character. Número do processo.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
excluir_processo <- function(protocolo_procedimento, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento = protocolo_procedimento)
  sei_parse_bool(sei_call("excluirProcesso", params, config, verbose = verbose))
}

#' @title anexar_processo
#' @description Anexa um processo a outro (`anexarProcesso`).
#' @param protocolo_principal,protocolo_anexado Números dos processos.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
anexar_processo <- function(protocolo_principal, protocolo_anexado, config = sei_config(),
                            verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimentoPrincipal = protocolo_principal,
                        ProtocoloProcedimentoAnexado = protocolo_anexado)
  sei_parse_bool(sei_call("anexarProcesso", params, config, verbose = verbose))
}

#' @title desanexar_processo
#' @description Desanexa um processo (`desanexarProcesso`).
#' @param protocolo_principal,protocolo_anexado Números dos processos.
#' @param motivo Character. Motivo da desanexação.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
desanexar_processo <- function(protocolo_principal, protocolo_anexado, motivo,
                               config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimentoPrincipal = protocolo_principal,
                        ProtocoloProcedimentoAnexado = protocolo_anexado, Motivo = motivo)
  sei_parse_bool(sei_call("desanexarProcesso", params, config, verbose = verbose))
}

#' @title relacionar_processo
#' @description Relaciona dois processos (`relacionarProcesso`). Bilateral.
#' @param protocolo1,protocolo2 Números dos processos.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
relacionar_processo <- function(protocolo1, protocolo2, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento1 = protocolo1,
                        ProtocoloProcedimento2 = protocolo2)
  sei_parse_bool(sei_call("relacionarProcesso", params, config, verbose = verbose))
}

#' @title remover_relacionamento_processo
#' @description Remove o relacionamento entre dois processos.
#' @param protocolo1,protocolo2 Números dos processos.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
remover_relacionamento_processo <- function(protocolo1, protocolo2, config = sei_config(),
                                            verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento1 = protocolo1,
                        ProtocoloProcedimento2 = protocolo2)
  sei_parse_bool(sei_call("removerRelacionamentoProcesso", params, config, verbose = verbose))
}

#' @title sobrestar_processo
#' @description Sobresta um processo (`sobrestarProcesso`).
#' @param protocolo_procedimento Character. Número do processo.
#' @param motivo Character. Motivo do sobrestamento.
#' @param protocolo_vinculado Character opcional. Processo vinculado.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
sobrestar_processo <- function(protocolo_procedimento, motivo, protocolo_vinculado = NULL,
                               config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento = protocolo_procedimento,
                        ProtocoloProcedimentoVinculado = protocolo_vinculado, Motivo = motivo)
  sei_parse_bool(sei_call("sobrestarProcesso", params, config, verbose = verbose))
}

#' @title remover_sobrestamento_processo
#' @description Remove o sobrestamento de um processo.
#' @param protocolo_procedimento Character. Número do processo.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
remover_sobrestamento_processo <- function(protocolo_procedimento, config = sei_config(),
                                           verbose = FALSE) {
  params <- .std_params(config, ProtocoloProcedimento = protocolo_procedimento)
  sei_parse_bool(sei_call("removerSobrestamentoProcesso", params, config, verbose = verbose))
}

# ---- documentos -------------------------------------------------------------

#' @title cancelar_documento
#' @description Cancela um documento (`cancelarDocumento`).
#' @param protocolo_documento Character. Número do documento.
#' @param motivo Character. Motivo do cancelamento.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
cancelar_documento <- function(protocolo_documento, motivo, config = sei_config(),
                               verbose = FALSE) {
  params <- .std_params(config, ProtocoloDocumento = protocolo_documento, Motivo = motivo)
  sei_parse_bool(sei_call("cancelarDocumento", params, config, verbose = verbose))
}

#' @title excluir_documento
#' @description Exclui um documento (`excluirDocumento`).
#' @param protocolo_documento Character. Número do documento.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
excluir_documento <- function(protocolo_documento, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, ProtocoloDocumento = protocolo_documento)
  sei_parse_bool(sei_call("excluirDocumento", params, config, verbose = verbose))
}

# ---- e-mail e contatos ------------------------------------------------------

#' @title enviar_email
#' @description Envia um e-mail vinculado a um processo (`enviarEmail`).
#' @param protocolo_procedimento Character. Número do processo.
#' @param de Character. Endereço do remetente.
#' @param para Vetor de destinatários (serão unidos por ";").
#' @param assunto,mensagem Character.
#' @param cco Vetor de destinatários em cópia oculta (opcional).
#' @param id_documentos Vetor de ids de documentos a anexar (opcional).
#' @param config Um objeto [sei_config()].
#' @param raw,verbose Logical.
#' @return Um `tibble` ([parse_retorno_envio_email]).
#' @export
enviar_email <- function(protocolo_procedimento, de, para, assunto, mensagem,
                         cco = NULL, id_documentos = NULL, config = sei_config(),
                         raw = FALSE, verbose = FALSE) {
  params <- .std_params(config,
    ProtocoloProcedimento = protocolo_procedimento,
    De = de,
    Para = paste(para, collapse = ";"),
    CCO = if (is.null(cco)) NULL else paste(cco, collapse = ";"),
    Assunto = assunto, Mensagem = mensagem,
    IdDocumentos = .as_item_list(id_documentos))
  doc <- sei_call("enviarEmail", params, config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  parse_retorno_envio_email(doc)
}

#' @title atualizar_contatos
#' @description Atualiza (cadastra/altera) um conjunto de contatos (`atualizarContatos`).
#' @param contatos Lista de contatos (objetos [Contato()] / listas nomeadas).
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
atualizar_contatos <- function(contatos, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, Contatos = unname(contatos))
  sei_parse_bool(sei_call("atualizarContatos", params, config, verbose = verbose))
}

# ---- controle de prazo e marcadores ----------------------------------------

#' @title definir_controle_prazo
#' @description Define controle de prazo para processos (`definirControlePrazo`).
#' @param definicoes Lista de definições (cada uma com `ProtocoloProcedimento` e
#'   `DataPrazo` OU `Dias`/`SinDiasUteis`).
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
definir_controle_prazo <- function(definicoes, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, Definicoes = unname(definicoes))
  sei_parse_bool(sei_call("definirControlePrazo", params, config, verbose = verbose))
}

#' @title concluir_controle_prazo
#' @description Conclui o controle de prazo de processos (`concluirControlePrazo`).
#' @param protocolos_procedimentos Vetor de números de processos.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
concluir_controle_prazo <- function(protocolos_procedimentos, config = sei_config(),
                                    verbose = FALSE) {
  params <- .std_params(config,
                        ProtocolosProcedimentos = .as_item_list(protocolos_procedimentos))
  sei_parse_bool(sei_call("concluirControlePrazo", params, config, verbose = verbose))
}

#' @title remover_controle_prazo
#' @description Remove o controle de prazo de processos (`removerControlePrazo`).
#' @param protocolos_procedimentos Vetor de números de processos.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
remover_controle_prazo <- function(protocolos_procedimentos, config = sei_config(),
                                   verbose = FALSE) {
  params <- .std_params(config,
                        ProtocolosProcedimentos = .as_item_list(protocolos_procedimentos))
  sei_parse_bool(sei_call("removerControlePrazo", params, config, verbose = verbose))
}

#' @title definir_marcador
#' @description Define marcadores em processos (`definirMarcador`).
#' @param definicoes Lista de definições (cada uma `list(ProtocoloProcedimento=,
#'   IdMarcador=, Texto=)`).
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
definir_marcador <- function(definicoes, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, Definicoes = unname(definicoes))
  sei_parse_bool(sei_call("definirMarcador", params, config, verbose = verbose))
}

# ---- blocos -----------------------------------------------------------------

#' @title gerar_bloco
#' @description Gera um bloco (`gerarBloco`). Retorna o número do bloco.
#' @param tipo Character. "A" (assinatura), "R" (reunião) ou "I" (interno).
#' @param descricao Character. Descrição do bloco.
#' @param config Um objeto [sei_config()].
#' @param unidades_disponibilizacao Vetor de ids de unidades (ou `NULL`).
#' @param documentos Vetor de protocolos de documentos (ou `NULL`).
#' @param sin_disponibilizar "S"/"N".
#' @param verbose Logical.
#' @return Character com o `IdBloco` gerado.
#' @export
gerar_bloco <- function(tipo, descricao, config = sei_config(),
                        unidades_disponibilizacao = NULL, documentos = NULL,
                        sin_disponibilizar = "N", verbose = FALSE) {
  params <- .std_params(config,
    Tipo = tipo, Descricao = descricao,
    UnidadesDisponibilizacao = .as_item_list(unidades_disponibilizacao),
    Documentos = .as_item_list(documentos),
    SinDisponibilizar = sin_disponibilizar)
  doc <- sei_call("gerarBloco", params, config, verbose = verbose)
  np <- sei_find_parametros(doc, "gerarBlocoResponse")
  if (is.null(np)) return(NA_character_)
  xml2::xml_text(np)
}

#' @title incluir_documento_bloco
#' @description Inclui um documento em um bloco (`incluirDocumentoBloco`).
#' @param id_bloco Character. Número do bloco.
#' @param protocolo_documento Character. Número do documento.
#' @param anotacao Character opcional.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
incluir_documento_bloco <- function(id_bloco, protocolo_documento, anotacao = NULL,
                                    config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, IdBloco = id_bloco, ProtocoloDocumento = protocolo_documento,
                        Anotacao = anotacao)
  sei_parse_bool(sei_call("incluirDocumentoBloco", params, config, verbose = verbose))
}

#' @title incluir_processo_bloco
#' @description Inclui um processo em um bloco (`incluirProcessoBloco`).
#' @param id_bloco Character. Número do bloco.
#' @param protocolo_procedimento Character. Número do processo.
#' @param anotacao Character opcional.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
incluir_processo_bloco <- function(id_bloco, protocolo_procedimento, anotacao = NULL,
                                   config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, IdBloco = id_bloco,
                        ProtocoloProcedimento = protocolo_procedimento, Anotacao = anotacao)
  sei_parse_bool(sei_call("incluirProcessoBloco", params, config, verbose = verbose))
}

#' @title retirar_documento_bloco
#' @description Retira um documento de um bloco (`retirarDocumentoBloco`).
#' @param id_bloco,protocolo_documento Identificadores.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
retirar_documento_bloco <- function(id_bloco, protocolo_documento, config = sei_config(),
                                    verbose = FALSE) {
  params <- .std_params(config, IdBloco = id_bloco, ProtocoloDocumento = protocolo_documento)
  sei_parse_bool(sei_call("retirarDocumentoBloco", params, config, verbose = verbose))
}

#' @title retirar_processo_bloco
#' @description Retira um processo de um bloco (`retirarProcessoBloco`).
#' @param id_bloco,protocolo_procedimento Identificadores.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
retirar_processo_bloco <- function(id_bloco, protocolo_procedimento, config = sei_config(),
                                   verbose = FALSE) {
  params <- .std_params(config, IdBloco = id_bloco,
                        ProtocoloProcedimento = protocolo_procedimento)
  sei_parse_bool(sei_call("retirarProcessoBloco", params, config, verbose = verbose))
}

#' @title disponibilizar_bloco
#' @description Disponibiliza um bloco (`disponibilizarBloco`).
#' @param id_bloco Character. Número do bloco.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
disponibilizar_bloco <- function(id_bloco, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, IdBloco = id_bloco)
  sei_parse_bool(sei_call("disponibilizarBloco", params, config, verbose = verbose))
}

#' @title cancelar_disponibilizacao_bloco
#' @description Cancela a disponibilização de um bloco (`cancelarDisponibilizacaoBloco`).
#' @param id_bloco Character. Número do bloco.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
cancelar_disponibilizacao_bloco <- function(id_bloco, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, IdBloco = id_bloco)
  sei_parse_bool(sei_call("cancelarDisponibilizacaoBloco", params, config, verbose = verbose))
}

#' @title excluir_bloco
#' @description Exclui um bloco (`excluirBloco`).
#' @param id_bloco Character. Número do bloco.
#' @param config Um objeto [sei_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
excluir_bloco <- function(id_bloco, config = sei_config(), verbose = FALSE) {
  params <- .std_params(config, IdBloco = id_bloco)
  sei_parse_bool(sei_call("excluirBloco", params, config, verbose = verbose))
}
