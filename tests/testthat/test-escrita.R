cfg_w <- function() sei_config(sigla_sistema = "SIG", identificacao_servico = "KEY",
                               id_unidade = "100")

test_that("gerar_procedimento monta Procedimento aninhado + array e parseia retorno", {
  captured <- NULL
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      captured <<- list(op = operation, params = params)
      xml2::read_xml(test_path("fixtures", "gerarProcedimento.xml"))
    }
  )

  proc <- Procedimento(IdTipoProcedimento = "100000368", Especificacao = "Teste & cia",
                       Assuntos = list(Assunto(CodigoEstruturado = "00.01.01"),
                                       Assunto(CodigoEstruturado = "00.01.08")))
  res <- gerar_procedimento(proc, config = cfg_w())

  # params capturados
  expect_equal(captured$op, "gerarProcedimento")
  expect_equal(captured$params$SiglaSistema, "SIG")
  expect_equal(captured$params$Procedimento$IdTipoProcedimento, "100000368")

  # o envelope correspondente renderiza estrutura aninhada + array + escape
  env <- sei_build_envelope(captured$op, captured$params)
  d <- xml2::read_xml(env)
  expect_equal(
    xml2::xml_text(xml2::xml_find_first(d, "//*[local-name()='IdTipoProcedimento']")),
    "100000368")
  assuntos <- xml2::xml_find_all(d, "//*[local-name()='Assuntos']/*[local-name()='item']")
  expect_length(assuntos, 2)
  expect_true(grepl("Teste &amp; cia", env, fixed = TRUE))

  # retorno parseado
  expect_equal(res$ProcedimentoFormatado, "12.1.000000077-4")
  expect_equal(nrow(res$RetornoInclusaoDocumentos[[1]]), 1L)
  expect_equal(res$RetornoInclusaoDocumentos[[1]]$DocumentoFormatado, "0003934")
})

test_that("incluir_documento parseia RetornoInclusaoDocumento", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      xml2::read_xml(test_path("fixtures", "incluirDocumento.xml"))
    }
  )
  doc <- Documento(Tipo = "G", IdSerie = "3", Descricao = "x")
  res <- incluir_documento(doc, config = cfg_w())
  expect_equal(res$IdDocumento, "1140000000872")
  expect_equal(res$DocumentoFormatado, "0003934")
})

test_that("operações booleanas devolvem TRUE", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      xml2::read_xml(test_path("fixtures", "retornoBoolTrue.xml"))
    }
  )
  expect_true(enviar_processo("12.1.000000077-4", unidades_destino = c("110", "120"),
                              config = cfg_w()))
  expect_true(concluir_processo("12.1.000000077-4", config = cfg_w()))
  expect_true(relacionar_processo("12.1.0001-1", "11.1.0002-2", config = cfg_w()))
})

test_that("enviar_processo monta UnidadesDestino como array e une Para por ';'", {
  captured <- NULL
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      captured <<- params
      xml2::read_xml(test_path("fixtures", "retornoBoolTrue.xml"))
    }
  )
  enviar_processo("12.1.077-4", unidades_destino = c("110", "120"), config = cfg_w())
  env <- sei_build_envelope("enviarProcesso", captured)
  itens <- xml2::xml_find_all(xml2::read_xml(env),
                              "//*[local-name()='UnidadesDestino']/*[local-name()='item']")
  expect_length(itens, 2)

  enviar_email("12.1.077-4", de = "a@x", para = c("b@x", "c@x"),
               assunto = "s", mensagem = "m", config = cfg_w())
})

test_that("sei_parse_bool interpreta variações", {
  mk <- function(v) xml2::read_xml(sprintf(
    "<E xmlns:ns1='Sei'><ns1:r><parametros>%s</parametros></ns1:r></E>", v))
  expect_true(sei_parse_bool(mk("true")))
  expect_false(sei_parse_bool(mk("false")))
})
