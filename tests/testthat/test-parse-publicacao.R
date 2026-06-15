test_that("parse_consultar_publicacao_response trata parametros xsi:nil", {
  # fixture: documento sem publicação -> <parametros xsi:nil="true"/>
  doc <- xml2::read_xml(test_path("fixtures", "consultarPublicacao.xml"))
  res <- parse_consultar_publicacao_response(doc)

  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 1L)
  expect_true(is.na(res$Publicacao_IdPublicacao))
  expect_true(is.na(res$Andamento_Descricao))
  expect_true(is.list(res$Assinaturas))
  expect_equal(nrow(res$Assinaturas[[1]]), 0L)
})
