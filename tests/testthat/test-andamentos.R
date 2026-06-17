cfg_a <- function() sei_config(sigla_sistema = "SIG", identificacao_servico = "KEY",
                               id_unidade = "100")

test_that("parse_list_response + parse_andamento_item lê a fixture", {
  doc <- xml2::read_xml(test_path("fixtures", "listarAndamentos.xml"))
  res <- parse_list_response(doc, "listarAndamentosResponse", parse_andamento_item)

  expect_equal(nrow(res), 3L)
  expect_true(all(c("IdAndamento", "IdTarefa", "Descricao", "DataHora",
                    "SiglaUnidade", "NomeUsuario", "Atributos") %in% names(res)))
  # usuário ancorado corretamente (não confundir com a unidade)
  ger <- res[res$IdTarefa == "1", ]
  expect_equal(ger$SiglaUnidade, "SEPE - SEM")
  expect_equal(ger$SiglaUsuario, "marcos.wasiliew")
  # Atributos como coluna-lista
  rem <- res[res$IdTarefa == "32", ]
  expect_equal(nrow(rem$Atributos[[1]]), 1L)
  expect_equal(rem$Atributos[[1]]$Nome, "UNIDADE")
})

test_that("listar_andamentos_completo ordena cronologicamente", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      xml2::read_xml(test_path("fixtures", "listarAndamentos.xml"))
    }
  )
  tl <- listar_andamentos_completo("12.1.077-4", config = cfg_a())

  expect_equal(nrow(tl), 3L)
  # ordem cronológica: gerado (10:57) -> remetido (14:10) -> recebido (15:43)
  expect_equal(tl$IdTarefa, c("1", "32", "48"))
  expect_equal(tl$Descricao[1], "Processo gerado")
  expect_equal(tl$Descricao[nrow(tl)], "Processo recebido na unidade")
})

test_that("listar_andamentos_completo monta filtro amplo de tarefas", {
  captured <- NULL
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      captured <<- params
      xml2::read_xml(test_path("fixtures", "listarAndamentos.xml"))
    }
  )
  listar_andamentos_completo("12.1.077-4", config = cfg_a(), tarefas = 1:50)
  expect_equal(captured$ProtocoloProcedimento, "12.1.077-4")
  # Tarefas vira lista (array) com 50 itens
  expect_length(captured$Tarefas, 50L)
})

test_that("parse_andamento_marcador_item lê a fixture", {
  doc <- xml2::read_xml(test_path("fixtures", "listarAndamentosMarcadores.xml"))
  res <- parse_list_response(doc, "listarAndamentosMarcadoresResponse",
                             parse_andamento_marcador_item)

  expect_equal(nrow(res), 2L)
  expect_true(all(c("IdAndamentoMarcador", "Texto", "DataHora", "SiglaUsuario",
                    "NomeUsuario", "IdMarcador", "NomeMarcador") %in% names(res)))
  primeiro <- res[res$IdAndamentoMarcador == "501", ]
  expect_equal(primeiro$Texto, "Aguardando parecer")
  expect_equal(primeiro$NomeMarcador, "Urgente")
  expect_equal(primeiro$SiglaUsuario, "usuario.um")
})

test_that("listar_andamentos_marcadores monta os parâmetros e parseia", {
  captured <- NULL
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      captured <<- params
      xml2::read_xml(test_path("fixtures", "listarAndamentosMarcadores.xml"))
    }
  )
  res <- listar_andamentos_marcadores("12.1.077-4", config = cfg_a(),
                                      marcadores = c("10", "20"))
  expect_equal(captured$ProtocoloProcedimento, "12.1.077-4")
  expect_length(captured$Marcadores, 2L)
  expect_equal(nrow(res), 2L)
  expect_equal(res$NomeMarcador, c("Urgente", "Revisado"))
})
