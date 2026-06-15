test_that("parse_consultar_documento_response parseia a fixture", {
  doc <- xml2::read_xml(test_path("fixtures", "consultarDocumento.xml"))
  res <- parse_consultar_documento_response(doc)

  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 1L)

  expect_equal(res$IdProcedimento, "20000001")
  expect_equal(res$ProcedimentoFormatado, "0000000000.000002/2020-22")
  expect_equal(res$IdDocumento, "20000002")
  expect_equal(res$DocumentoFormatado, "0000001")
  expect_equal(res$Data, "01/02/2020")

  # niveis de acesso recodificados (0/0) -> ambos "publico" (ASCII-safe)
  expect_false(res$NivelAcessoLocal %in% c("0", "1", "2"))
  expect_match(res$NivelAcessoLocal, "blico")

  # Serie e UnidadeElaboradora desaninhados com prefixo
  expect_equal(res$Serie_IdSerie, "100")
  expect_equal(res$Serie_Nome, "Anexo")
  expect_equal(res$UnidadeElaboradora_IdUnidade, "110000020")
  expect_equal(res$UnidadeElaboradora_Sigla, "ORG - RH")

  # Numero/Descricao eram xsi:nil -> NA
  expect_true(is.na(res$Numero))
  expect_true(is.na(res$Descricao))

  # colunas-lista
  expect_true(is.list(res$Assinaturas))
  expect_equal(nrow(res$Assinaturas[[1]]), 0L)   # documento sem assinaturas
  expect_true(is.list(res$Campos))
})
