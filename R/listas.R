# file: R/listas.R
#
# Wrappers das operações `listar*` (read-only) sobre o core. Todas devolvem um
# tibble (uma linha por item) por padrão; `raw = TRUE` devolve o xml_document.
#
# Estruturas planas usam o caminho VETORIZADO (`fields`), rápido em listas
# grandes; `listar_andamentos` usa um item-parser por ter coluna-lista.

# Motor genérico. Informe `fields` (vetorizado) OU `item_parser`.
sei_listar <- function(operation, response_name, config,
                       fields = NULL, item_parser = NULL,
                       extra = list(), include_unidade = TRUE,
                       raw = FALSE, verbose = FALSE) {
  params <- c(
    list(SiglaSistema = config$sigla_sistema,
         IdentificacaoServico = config$identificacao_servico),
    if (include_unidade) list(IdUnidade = config$id_unidade) else NULL,
    extra
  )
  doc <- sei_call(operation, params = params, config = config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  if (!is.null(fields)) parse_list_struct(doc, response_name, fields)
  else parse_list_response(doc, response_name, item_parser)
}

#' @title listar_unidades
#' @description Lista as unidades acessíveis ao serviço (`listarUnidades`).
#' @param config Um objeto [sei_config()].
#' @param id_tipo_procedimento,id_serie Filtros opcionais.
#' @param raw Logical. Se `TRUE`, devolve o `xml_document` bruto.
#' @param verbose Logical.
#' @param sei_url,sigla_sistema,identificacao_servico Compatibilidade: sobrescrevem `config`.
#' @return Um `tibble` de unidades (ou `xml_document` se `raw = TRUE`).
#' @export
listar_unidades <- function(config = sei_config(), id_tipo_procedimento = NULL,
                            id_serie = NULL, raw = FALSE, verbose = FALSE,
                            sei_url = NULL, sigla_sistema = NULL,
                            identificacao_servico = NULL) {
  config <- .merge_config(config, sei_url, sigla_sistema, identificacao_servico)
  sei_listar("listarUnidades", "listarUnidadesResponse", config,
             fields = .sei_fields$unidade,
             extra = list(IdTipoProcedimento = id_tipo_procedimento, IdSerie = id_serie),
             include_unidade = FALSE, raw = raw, verbose = verbose)
}

#' @title listar_series
#' @description Lista os tipos de documento (séries) liberados ao serviço.
#' @param config Um objeto [sei_config()].
#' @param id_unidade,id_tipo_procedimento Filtros opcionais.
#' @param raw,verbose Logical.
#' @return Um `tibble` de séries.
#' @export
listar_series <- function(config = sei_config(), id_unidade = NULL,
                          id_tipo_procedimento = NULL, raw = FALSE, verbose = FALSE) {
  sei_listar("listarSeries", "listarSeriesResponse", config, fields = .sei_fields$serie,
             extra = list(IdUnidade = id_unidade, IdTipoProcedimento = id_tipo_procedimento),
             include_unidade = FALSE, raw = raw, verbose = verbose)
}

#' @title listar_tipos_procedimento
#' @description Lista os tipos de processo liberados ao serviço.
#' @param config Um objeto [sei_config()].
#' @param id_unidade,id_serie Filtros opcionais.
#' @param raw,verbose Logical.
#' @return Um `tibble` de tipos de processo.
#' @export
listar_tipos_procedimento <- function(config = sei_config(), id_unidade = NULL,
                                      id_serie = NULL, raw = FALSE, verbose = FALSE) {
  sei_listar("listarTiposProcedimento", "listarTiposProcedimentoResponse", config,
             fields = .sei_fields$tipo_procedimento,
             extra = list(IdUnidade = id_unidade, IdSerie = id_serie),
             include_unidade = FALSE, raw = raw, verbose = verbose)
}

#' @title listar_tipos_procedimento_ouvidoria
#' @description Lista os tipos de processo sinalizados como de Ouvidoria.
#' @param config Um objeto [sei_config()].
#' @param raw,verbose Logical.
#' @return Um `tibble` de tipos de processo.
#' @export
listar_tipos_procedimento_ouvidoria <- function(config = sei_config(),
                                                raw = FALSE, verbose = FALSE) {
  sei_listar("listarTiposProcedimentoOuvidoria", "listarTiposProcedimentoOuvidoriaResponse",
             config, fields = .sei_fields$tipo_procedimento, include_unidade = FALSE,
             raw = raw, verbose = verbose)
}

#' @title listar_usuarios
#' @description Lista os usuários com perfil "Básico" na unidade.
#' @param config Um objeto [sei_config()].
#' @param id_usuario Filtro opcional.
#' @param raw,verbose Logical.
#' @return Um `tibble` de usuários.
#' @export
listar_usuarios <- function(config = sei_config(), id_usuario = NULL,
                            raw = FALSE, verbose = FALSE) {
  sei_listar("listarUsuarios", "listarUsuariosResponse", config,
             fields = .sei_fields$usuario,
             extra = list(IdUsuario = id_usuario), raw = raw, verbose = verbose)
}

#' @title listar_hipoteses_legais
#' @description Lista as hipóteses legais.
#' @param config Um objeto [sei_config()].
#' @param nivel_acesso Filtro opcional (1 - restrito, 2 - sigiloso).
#' @param raw,verbose Logical.
#' @return Um `tibble` de hipóteses legais.
#' @export
listar_hipoteses_legais <- function(config = sei_config(), nivel_acesso = NULL,
                                    raw = FALSE, verbose = FALSE) {
  sei_listar("listarHipotesesLegais", "listarHipotesesLegaisResponse", config,
             fields = .sei_fields$hipotese_legal,
             extra = list(NivelAcesso = nivel_acesso), raw = raw, verbose = verbose)
}

#' @title listar_paises
#' @description Lista os países.
#' @param config Um objeto [sei_config()].
#' @param raw,verbose Logical.
#' @return Um `tibble` de países.
#' @export
listar_paises <- function(config = sei_config(), raw = FALSE, verbose = FALSE) {
  sei_listar("listarPaises", "listarPaisesResponse", config, fields = .sei_fields$pais,
             raw = raw, verbose = verbose)
}

#' @title listar_estados
#' @description Lista os estados (UF).
#' @param config Um objeto [sei_config()].
#' @param id_pais Filtro opcional.
#' @param raw,verbose Logical.
#' @return Um `tibble` de estados.
#' @export
listar_estados <- function(config = sei_config(), id_pais = NULL,
                           raw = FALSE, verbose = FALSE) {
  sei_listar("listarEstados", "listarEstadosResponse", config, fields = .sei_fields$estado,
             extra = list(IdPais = id_pais), raw = raw, verbose = verbose)
}

#' @title listar_cidades
#' @description Lista as cidades.
#' @param config Um objeto [sei_config()].
#' @param id_pais,id_estado Filtros opcionais.
#' @param raw,verbose Logical.
#' @return Um `tibble` de cidades.
#' @export
listar_cidades <- function(config = sei_config(), id_pais = NULL, id_estado = NULL,
                           raw = FALSE, verbose = FALSE) {
  sei_listar("listarCidades", "listarCidadesResponse", config, fields = .sei_fields$cidade,
             extra = list(IdPais = id_pais, IdEstado = id_estado),
             raw = raw, verbose = verbose)
}

#' @title listar_cargos
#' @description Lista os cargos.
#' @param config Um objeto [sei_config()].
#' @param id_cargo Filtro opcional.
#' @param raw,verbose Logical.
#' @return Um `tibble` de cargos.
#' @export
listar_cargos <- function(config = sei_config(), id_cargo = NULL,
                          raw = FALSE, verbose = FALSE) {
  sei_listar("listarCargos", "listarCargosResponse", config, fields = .sei_fields$cargo,
             extra = list(IdCargo = id_cargo), raw = raw, verbose = verbose)
}

#' @title listar_contatos
#' @description Lista contatos (paginado).
#' @param config Um objeto [sei_config()].
#' @param id_tipo_contato,sigla,nome,cpf,cnpj,matricula Filtros opcionais.
#' @param pagina_registros,pagina_atual Paginação (1-1000; padrão 1).
#' @param raw,verbose Logical.
#' @return Um `tibble` de contatos.
#' @export
listar_contatos <- function(config = sei_config(), id_tipo_contato = NULL,
                            pagina_registros = NULL, pagina_atual = NULL,
                            sigla = NULL, nome = NULL, cpf = NULL, cnpj = NULL,
                            matricula = NULL, raw = FALSE, verbose = FALSE) {
  sei_listar("listarContatos", "listarContatosResponse", config, fields = .sei_fields$contato,
             extra = list(IdTipoContato = id_tipo_contato,
                          PaginaRegistros = pagina_registros, PaginaAtual = pagina_atual,
                          Sigla = sigla, Nome = nome, CPF = cpf, CNPJ = cnpj,
                          Matricula = matricula),
             raw = raw, verbose = verbose)
}

#' @title listar_feriados
#' @description Lista os feriados.
#' @param config Um objeto [sei_config()].
#' @param id_orgao,data_inicial,data_final Filtros opcionais.
#' @param raw,verbose Logical.
#' @return Um `tibble` de feriados.
#' @export
listar_feriados <- function(config = sei_config(), id_orgao = NULL,
                            data_inicial = NULL, data_final = NULL,
                            raw = FALSE, verbose = FALSE) {
  sei_listar("listarFeriados", "listarFeriadosResponse", config, fields = .sei_fields$feriado,
             extra = list(IdOrgao = id_orgao, DataInicial = data_inicial,
                          DataFinal = data_final), raw = raw, verbose = verbose)
}

#' @title listar_extensoes_permitidas
#' @description Lista as extensões de arquivo permitidas.
#' @param config Um objeto [sei_config()].
#' @param id_arquivo_extensao Filtro opcional.
#' @param raw,verbose Logical.
#' @return Um `tibble` de extensões.
#' @export
listar_extensoes_permitidas <- function(config = sei_config(), id_arquivo_extensao = NULL,
                                        raw = FALSE, verbose = FALSE) {
  sei_listar("listarExtensoesPermitidas", "listarExtensoesPermitidasResponse", config,
             fields = .sei_fields$arquivo_extensao,
             extra = list(IdArquivoExtensao = id_arquivo_extensao),
             raw = raw, verbose = verbose)
}

#' @title listar_marcadores_unidade
#' @description Lista os marcadores da unidade.
#' @param config Um objeto [sei_config()].
#' @param raw,verbose Logical.
#' @return Um `tibble` de marcadores.
#' @export
listar_marcadores_unidade <- function(config = sei_config(), raw = FALSE, verbose = FALSE) {
  sei_listar("listarMarcadoresUnidade", "listarMarcadoresUnidadeResponse", config,
             fields = .sei_fields$marcador, raw = raw, verbose = verbose)
}

#' @title listar_tipos_conferencia
#' @description Lista os tipos de conferência.
#' @param config Um objeto [sei_config()].
#' @param id_unidade Filtro opcional.
#' @param raw,verbose Logical.
#' @return Um `tibble` de tipos de conferência.
#' @export
listar_tipos_conferencia <- function(config = sei_config(), id_unidade = NULL,
                                     raw = FALSE, verbose = FALSE) {
  sei_listar("listarTiposConferencia", "listarTiposConferenciaResponse", config,
             fields = .sei_fields$tipo_conferencia, extra = list(IdUnidade = id_unidade),
             include_unidade = FALSE, raw = raw, verbose = verbose)
}

#' @title listar_andamentos
#' @description Lista andamentos de um processo (`listarAndamentos`). É preciso
#'   informar ao menos um filtro: `andamentos`, `tarefas` ou `tarefas_modulos`.
#' @param protocolo_procedimento Character. Número do processo.
#' @param config Um objeto [sei_config()].
#' @param sin_retornar_atributos "S" ou "N".
#' @param andamentos,tarefas,tarefas_modulos Vetores de identificadores (filtro).
#' @param raw,verbose Logical.
#' @return Um `tibble` de andamentos (`Atributos` como coluna-lista).
#' @export
listar_andamentos <- function(protocolo_procedimento, config = sei_config(),
                              sin_retornar_atributos = "N",
                              andamentos = NULL, tarefas = NULL, tarefas_modulos = NULL,
                              raw = FALSE, verbose = FALSE) {
  if (is.null(andamentos) && is.null(tarefas) && is.null(tarefas_modulos)) {
    stop("Informe ao menos um de: andamentos, tarefas ou tarefas_modulos.", call. = FALSE)
  }
  as_list <- function(x) if (is.null(x)) NULL else as.list(as.character(x))
  sei_listar("listarAndamentos", "listarAndamentosResponse", config,
             item_parser = parse_andamento_item,
             extra = list(
               ProtocoloProcedimento = protocolo_procedimento,
               SinRetornarAtributos  = sin_retornar_atributos,
               Andamentos            = as_list(andamentos),
               Tarefas               = as_list(tarefas),
               TarefasModulos        = as_list(tarefas_modulos)
             ),
             raw = raw, verbose = verbose)
}

#' @title listar_andamentos_completo
#'
#' @description
#' Conveniência sobre [listar_andamentos()] que recupera a **linha do tempo
#' completa** de um processo e a ordena cronologicamente. Como a operação
#' `listarAndamentos` do SEI exige um filtro de tarefas, esta função usa por
#' padrão um intervalo amplo de identificadores de tarefa (que cobre as tarefas
#' internas do SEI: geração, documentos, assinaturas, envio, recebimento,
#' conclusão, blocos, etc.).
#'
#' @param protocolo_procedimento Character. Número do processo.
#' @param config Um objeto [sei_config()].
#' @param tarefas Vetor de identificadores de tarefa a recuperar (padrão
#'   `1:200`, que abrange as tarefas internas do SEI).
#' @param sin_retornar_atributos "S" ou "N".
#' @param ordenar Logical. Se `TRUE` (padrão), ordena por `DataHora` (mais antigo
#'   primeiro).
#' @param raw,verbose Logical.
#'
#' @return Um `tibble` de andamentos ordenado por data/hora (ver
#'   [parse_andamento_item]).
#'
#' @examples
#' \dontrun{
#'   linha <- listar_andamentos_completo("12.1.000000077-4", config = sei_config())
#'   linha[, c("DataHora", "Descricao", "SiglaUnidade", "NomeUsuario")]
#' }
#'
#' @export
listar_andamentos_completo <- function(protocolo_procedimento, config = sei_config(),
                                       tarefas = 1:200, sin_retornar_atributos = "N",
                                       ordenar = TRUE, raw = FALSE, verbose = FALSE) {
  res <- listar_andamentos(protocolo_procedimento, config = config,
                           sin_retornar_atributos = sin_retornar_atributos,
                           tarefas = as.character(tarefas), raw = raw, verbose = verbose)
  if (isTRUE(raw) || !isTRUE(ordenar) || nrow(res) == 0) return(res)
  dh <- as.POSIXct(res$DataHora, format = "%d/%m/%Y %H:%M:%S", tz = "UTC")
  res[order(dh), , drop = FALSE]
}
