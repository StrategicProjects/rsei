test_that("consultar_documentos empilha resultados e isola erros por linha", {
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(), ...) {
      if (identical(params$ProtocoloDocumento, "BAD")) stop("documento inexistente")
      xml2::read_xml(test_path("fixtures", "consultarDocumento.xml"))
    }
  )

  res <- consultar_documentos(c("0000001", "BAD"), config = sei_config())
  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 2L)
  expect_equal(names(res)[1], "protocolo")
  expect_equal(res$protocolo, c("0000001", "BAD"))

  ok  <- res[res$protocolo == "0000001", ]
  bad <- res[res$protocolo == "BAD", ]
  expect_equal(ok$Serie_Nome, "Anexo")
  expect_true(is.na(ok$erro))
  expect_match(bad$erro, "inexistente")
})
