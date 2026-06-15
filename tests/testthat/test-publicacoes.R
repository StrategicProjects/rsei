test_that("consultar_publicacoes empilha e usa o identificador de 'por'", {
  captured <- list()
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      captured[[length(captured) + 1]] <<- params
      xml2::read_xml(test_path("fixtures", "consultarPublicacaoCom.xml"))
    }
  )

  res <- consultar_publicacoes(c("84245389", "84230597"), por = "protocolo_documento")
  expect_equal(nrow(res), 2L)
  expect_equal(names(res)[1], "id")
  expect_equal(res$id, c("84245389", "84230597"))
  expect_true("Publicacao_NomeVeiculo" %in% names(res))
  expect_equal(res$Publicacao_NomeVeiculo[1], "Diario Oficial do Estado")
  # 'por' mapeou para ProtocoloDocumento
  expect_equal(captured[[1]]$ProtocoloDocumento, "84245389")
  expect_true(all(is.na(res$erro)))
})

test_that("listar_publicacoes_processo mantém só documentos com publicação", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      if (operation == "listarAndamentos")
        return(xml2::read_xml(test_path("fixtures", "listarAndamentosDocs.xml")))
      # consultarPublicacao: 84245389 tem publicacao; os demais nao (parametros nil)
      if (identical(params$ProtocoloDocumento, "84245389"))
        return(xml2::read_xml(test_path("fixtures", "consultarPublicacaoCom.xml")))
      xml2::read_xml(test_path("fixtures", "consultarPublicacao.xml"))  # nil
    }
  )

  pubs <- listar_publicacoes_processo("12.1.077-4", config = sei_config())
  expect_equal(nrow(pubs), 1L)
  expect_equal(pubs$id, "84245389")
  expect_equal(pubs$Publicacao_IdPublicacao, "555001")
  expect_equal(pubs$Publicacao_Estado, "P")
})

test_that("processo sem publicacoes retorna tibble vazio", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      if (operation == "listarAndamentos")
        return(xml2::read_xml(test_path("fixtures", "listarAndamentosDocs.xml")))
      xml2::read_xml(test_path("fixtures", "consultarPublicacao.xml"))  # todos nil
    }
  )
  pubs <- listar_publicacoes_processo("12.1.077-4", config = sei_config())
  expect_equal(nrow(pubs), 0L)
})
