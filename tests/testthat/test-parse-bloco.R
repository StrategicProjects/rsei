test_that("parse_consultar_bloco_response parseia a fixture sintética", {
  doc <- xml2::read_xml(test_path("fixtures", "consultarBloco.xml"))
  res <- parse_consultar_bloco_response(doc)

  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 1L)

  expect_equal(res$IdBloco, "123")
  expect_equal(res$Descricao, "Bloco de teste")
  expect_equal(res$Tipo, "A")
  expect_equal(res$Estado, "A")

  # Unidade/Usuario desaninhados com prefixo
  expect_equal(res$Unidade_Sigla, "SEPE - RH")
  expect_equal(res$Usuario_Sigla, "fulano.silva")
  # UsuarioAtribuicao era xsi:nil -> NA
  expect_true(is.na(res$UsuarioAtribuicao_IdUsuario))

  # arrays
  expect_equal(nrow(res$UnidadesDisponibilizacao[[1]]), 1L)
  expect_equal(res$UnidadesDisponibilizacao[[1]]$Sigla, "SEMOBI - SEMINF")

  protocolos <- res$Protocolos[[1]]
  expect_equal(nrow(protocolos), 2L)
  expect_equal(protocolos$ProtocoloFormatado, c("0003934", "12.1.000000077-4"))
  # assinaturas aninhadas no primeiro protocolo
  expect_equal(nrow(protocolos$Assinaturas[[1]]), 1L)
  expect_equal(protocolos$Assinaturas[[1]]$Nome, "Fulano da Silva")
  expect_equal(nrow(protocolos$Assinaturas[[2]]), 0L)
})
