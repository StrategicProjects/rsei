# file: R/config.R

#' @title SEI Connection Configuration
#'
#' @description
#' Builds a configuration object holding the values that every SEI Web Service
#' call needs: the endpoint URL, the system sigla (\code{SiglaSistema}), the
#' service access key (\code{IdentificacaoServico}) and the default unit id
#' (\code{IdUnidade}). Values are resolved, in order, from the arguments,
#' \code{options(rsei.*)} and environment variables (\code{RSEI_*}).
#'
#' The package is not tied to any particular SEI installation: set \code{sei_url}
#' to the Web Service endpoint of your own SEI server, e.g.
#' \code{"https://sei.<your-org>.gov.br/sei/ws/SeiWS.php"} (or the
#' \code{controlador_ws.php?servico=sei} form).
#'
#' @param sei_url Character. SEI Web Service endpoint (required for live calls).
#'   Resolves from the argument, \code{getOption("rsei.sei_url")} or
#'   \code{Sys.getenv("RSEI_URL")}. There is no built-in default, so the package
#'   works with any SEI installation.
#' @param sigla_sistema Character. System sigla registered in SEI.
#' @param identificacao_servico Character. Service access key (\emph{chave de acesso}).
#' @param id_unidade Character. Default unit id; many operations accept an empty string.
#'
#' @return An object of class \code{"sei_config"}: a named list with
#'   \code{sei_url}, \code{sigla_sistema}, \code{identificacao_servico} and
#'   \code{id_unidade}.
#'
#' @examples
#' cfg <- sei_config(
#'   sei_url = "https://sei.exemplo.gov.br/sei/ws/SeiWS.php",
#'   sigla_sistema = "MEU_SISTEMA",
#'   identificacao_servico = "minha-chave"
#' )
#' cfg$sei_url
#'
#' @export
sei_config <- function(
    sei_url               = NULL,
    sigla_sistema         = NULL,
    identificacao_servico = NULL,
    id_unidade            = NULL) {

  resolve <- function(arg, option, env, fallback) {
    if (!is.null(arg) && !identical(arg, "")) return(arg)
    opt <- getOption(option, default = NULL)
    if (!is.null(opt) && !identical(opt, "")) return(opt)
    e <- Sys.getenv(env, unset = "")
    if (!identical(e, "")) return(e)
    fallback
  }

  structure(
    list(
      sei_url = resolve(sei_url, "rsei.sei_url", "RSEI_URL", ""),
      sigla_sistema = resolve(sigla_sistema, "rsei.sigla_sistema",
                              "RSEI_SIGLA_SISTEMA", ""),
      identificacao_servico = resolve(identificacao_servico,
                                      "rsei.identificacao_servico",
                                      "RSEI_IDENTIFICACAO_SERVICO", ""),
      id_unidade = resolve(id_unidade, "rsei.id_unidade", "RSEI_ID_UNIDADE", "")
    ),
    class = "sei_config"
  )
}

#' @title Set Default SEI Configuration for the Session
#'
#' @description
#' Stores the given configuration values as \code{options(rsei.*)} so subsequent
#' calls to \code{\link{sei_config}} (and therefore every operation) pick them up
#' without having to pass \code{config} explicitly.
#'
#' @inheritParams sei_config
#'
#' @return Invisibly, the previous options (as returned by \code{options()}).
#'
#' @examples
#' \dontrun{
#' sei_set_default_config(
#'   sigla_sistema = "HORTENSIAS",
#'   identificacao_servico = Sys.getenv("RSEI_IDENTIFICACAO_SERVICO")
#' )
#' }
#'
#' @export
sei_set_default_config <- function(
    sei_url               = NULL,
    sigla_sistema         = NULL,
    identificacao_servico = NULL,
    id_unidade            = NULL) {

  new <- list()
  if (!is.null(sei_url))               new[["rsei.sei_url"]] <- sei_url
  if (!is.null(sigla_sistema))         new[["rsei.sigla_sistema"]] <- sigla_sistema
  if (!is.null(identificacao_servico)) new[["rsei.identificacao_servico"]] <- identificacao_servico
  if (!is.null(id_unidade))            new[["rsei.id_unidade"]] <- id_unidade
  invisible(options(new))
}

# Sobrescreve campos do config com argumentos legados, quando informados.
# Usado pelos wrappers que aceitam sei_url/sigla/etc. soltos por compatibilidade.
.merge_config <- function(config, sei_url = NULL, sigla_sistema = NULL,
                          identificacao_servico = NULL, id_unidade = NULL) {
  if (is.null(config)) config <- sei_config()
  if (!is.null(sei_url))               config$sei_url <- sei_url
  if (!is.null(sigla_sistema))         config$sigla_sistema <- sigla_sistema
  if (!is.null(identificacao_servico)) config$identificacao_servico <- identificacao_servico
  if (!is.null(id_unidade))            config$id_unidade <- id_unidade
  config
}

#' @export
print.sei_config <- function(x, ...) {
  cat("<sei_config>\n")
  cat("  sei_url               :", x$sei_url, "\n")
  cat("  sigla_sistema         :", x$sigla_sistema, "\n")
  cat("  identificacao_servico :",
      if (nzchar(x$identificacao_servico)) "<set>" else "<empty>", "\n")
  cat("  id_unidade            :",
      if (nzchar(x$id_unidade)) x$id_unidade else "<empty>", "\n")
  invisible(x)
}
