test_that("parse_consultar_documento_response parseia a fixture real", {
  doc <- xml2::read_xml(test_path("fixtures", "consultarDocumento.xml"))
  res <- parse_consultar_documento_response(doc)

  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 1L)

  expect_equal(res$IdProcedimento, "67631000")
  expect_equal(res$ProcedimentoFormatado, "5100000007.003029/2024-27")
  expect_equal(res$IdDocumento, "67631331")
  expect_equal(res$DocumentoFormatado, "58769333")
  expect_equal(res$Data, "13/11/2024")

  # niveis de acesso recodificados (0/0) -> ambos "publico" (ASCII-safe)
  expect_false(res$NivelAcessoLocal %in% c("0", "1", "2"))
  expect_match(res$NivelAcessoLocal, "blico")

  # Serie e UnidadeElaboradora desaninhados com prefixo
  expect_equal(res$Serie_IdSerie, "263")
  expect_equal(res$Serie_Nome, "Anexo")
  expect_equal(res$UnidadeElaboradora_IdUnidade, "110008720")
  expect_equal(res$UnidadeElaboradora_Sigla, "SEPE - RH")

  # Numero/Descricao eram xsi:nil -> NA
  expect_true(is.na(res$Numero))
  expect_true(is.na(res$Descricao))

  # colunas-lista
  expect_true(is.list(res$Assinaturas))
  expect_equal(nrow(res$Assinaturas[[1]]), 0L)   # documento sem assinaturas
  expect_true(is.list(res$Campos))
})
