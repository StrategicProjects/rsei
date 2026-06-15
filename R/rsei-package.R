#' @keywords internal
#'
#' @section Acesso restrito por IP:
#' Os Web Services do SEI são protegidos por *firewall* e só respondem a
#' requisições vindas de IPs/servidores previamente autorizados no cadastro do
#' serviço no SEI. As funções deste pacote (consultas, listagens, escrita e SIP)
#' só retornam dados quando executadas a partir de um host autorizado; de um IP
#' não autorizado as chamadas falham por *timeout* ou conexão recusada. A
#' autenticação adicional é feita por `SiglaSistema` + chave de acesso
#' (`IdentificacaoServico`) — ver [sei_config()].
"_PACKAGE"

## Package-level imports (NAMESPACE gerado por roxygen2)

#' @importFrom magrittr %>%
#' @importFrom dplyr bind_rows bind_cols
#' @importFrom tidyr unnest
#' @importFrom purrr map
#' @importFrom tibble tibble as_tibble
#' @importFrom httr2 request req_headers req_body_raw req_perform req_error
#'   resp_status resp_body_xml resp_body_string
#' @importFrom xml2 read_xml xml_find_first xml_find_all xml_text xml_attr
#'   xml_name xml_children write_xml
#' @importFrom stats setNames
NULL

# Reexporta o pipe para uso por quem carrega o pacote
#' Pipe operator
#'
#' Veja \code{magrittr::\link[magrittr:pipe]{\%>\%}} para detalhes.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs Um valor ou o objeto \code{magrittr} placeholder.
#' @param rhs Uma chamada de função usando a semântica do \code{magrittr}.
#' @return O resultado de chamar \code{rhs(lhs)}.
NULL
