test_that("consultar_procedimentos empilha resultados num tibble", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      if (identical(params$ProtocoloProcedimento, "BAD")) stop("falha simulada")
      xml2::read_xml(test_path("fixtures", "consultarProcedimento.xml"))
    }
  )

  res <- consultar_procedimentos(c("0000000000.000001/2020-11", "0000000000.000003/2020-33"),
                                 config = sei_config())
  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 2L)
  expect_equal(res$protocolo,
               c("0000000000.000001/2020-11", "0000000000.000003/2020-33"))
  # coluna 'protocolo' vem primeiro
  expect_equal(names(res)[1], "protocolo")
  # dados parseados presentes
  expect_true("Especificacao" %in% names(res))
  expect_true(all(is.na(res$erro)))
})

test_that("erro em um protocolo não derruba o lote (registra em 'erro')", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      if (identical(params$ProtocoloProcedimento, "BAD")) stop("processo inexistente")
      xml2::read_xml(test_path("fixtures", "consultarProcedimento.xml"))
    }
  )

  res <- consultar_procedimentos(c("0000000000.000001/2020-11", "BAD"),
                                 config = sei_config())
  expect_equal(nrow(res), 2L)
  ok  <- res[res$protocolo != "BAD", ]
  bad <- res[res$protocolo == "BAD", ]
  expect_true(is.na(ok$erro))
  expect_match(bad$erro, "inexistente")
  expect_true(is.na(bad$Especificacao))   # demais colunas viram NA na linha com erro
})

test_that("parar_em_erro = TRUE propaga a falha", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      stop("boom")
    }
  )
  expect_error(
    consultar_procedimentos("X", config = sei_config(), parar_em_erro = TRUE),
    "boom"
  )
})
