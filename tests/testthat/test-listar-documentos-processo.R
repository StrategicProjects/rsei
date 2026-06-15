test_that("listar_documentos_processo extrai documentos dos andamentos (dedup)", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      xml2::read_xml(test_path("fixtures", "listarAndamentosDocs.xml"))
    }
  )

  docs <- listar_documentos_processo("12.1.077-4", config = sei_config())
  expect_s3_class(docs, "tbl_df")
  # 2 documentos unicos (84230597 aparece em "gerado" e "assinado" -> dedup)
  expect_equal(nrow(docs), 2L)
  expect_equal(docs$documento, c("84230597", "84245389"))
  # 1a ocorrencia = geracao: data/usuario da geracao, nao da assinatura
  expect_equal(docs$DataHora[1], "07/04/2026 11:05:00")
  expect_equal(docs$SiglaUsuario[1], "marcos.wasiliew")   # gerou (nao andreleite, que assinou)
  expect_equal(docs$SiglaUnidade[1], "SEPE - SEM")
})

test_that("listar_documentos_processo com consultar=TRUE anexa detalhes", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      if (operation == "listarAndamentos")
        return(xml2::read_xml(test_path("fixtures", "listarAndamentosDocs.xml")))
      # consultarDocumento
      xml2::read_xml(test_path("fixtures", "consultarDocumento.xml"))
    }
  )
  docs <- listar_documentos_processo("12.1.077-4", config = sei_config(), consultar = TRUE)
  expect_equal(nrow(docs), 2L)
  expect_true("Serie_Nome" %in% names(docs))
  expect_true("documento" %in% names(docs))
  # sem colisao de colunas (documento/DataHora preservados do base)
  expect_equal(docs$documento, c("84230597", "84245389"))
})

test_that("processo sem documentos retorna tibble vazio com schema", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      xml2::read_xml(test_path("fixtures", "listarAndamentos.xml"))  # sem 'documento NNNN'
    }
  )
  docs <- listar_documentos_processo("12.1.077-4", config = sei_config())
  expect_equal(nrow(docs), 0L)
  expect_true(all(c("documento", "DataHora", "SiglaUnidade") %in% names(docs)))
})
