test_that("parse_list_struct (vetorizado) parseia listarPaises", {
  doc <- xml2::read_xml(test_path("fixtures", "listarPaises.xml"))
  res <- parse_list_struct(doc, "listarPaisesResponse", .sei_fields$pais)

  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 204L)
  expect_named(res, c("IdPais", "Nome"))
  # primeiro país (Afeganistão), acento via codepoint p/ robustez de locale
  expect_equal(res$IdPais[1], "4")
  expect_match(res$Nome[1], "^Afeganist")
  expect_false(any(is.na(res$IdPais)))
})

test_that("parse_list_struct parseia listarEstados com campos ausentes -> NA", {
  doc <- xml2::read_xml(test_path("fixtures", "listarEstados.xml"))
  res <- parse_list_struct(doc, "listarEstadosResponse", .sei_fields$estado)

  expect_equal(nrow(res), 53L)
  expect_named(res, c("IdEstado", "IdPais", "Sigla", "Nome", "CodigoIbge"))
  # vários estados estrangeiros não têm Sigla/CodigoIbge -> NA
  expect_true(any(is.na(res$Sigla)))
  expect_true(all(!is.na(res$IdEstado)))
})

test_that("parse_struct_nodeset devolve 0 linhas com colunas corretas p/ array vazio", {
  empty <- parse_struct_nodeset(list(), .sei_fields$pais)
  expect_equal(nrow(empty), 0L)
  expect_named(empty, c("IdPais", "Nome"))
})

test_that("mapas de campo são fonte única (parse_unidade usa .sei_fields)", {
  # parse_unidade deve produzir as mesmas colunas do mapa
  doc <- xml2::read_xml(test_path("fixtures", "consultarBloco.xml"))
  nd <- xml2::xml_find_first(doc, "//*[local-name()='Unidade']")
  u <- parse_unidade(nd)
  expect_named(u, names(.sei_fields$unidade))
  expect_equal(u$Sigla, "SEPE - RH")
})

test_that("listar_andamentos exige ao menos um filtro", {
  expect_error(
    listar_andamentos("12.1.000000077-4", config = sei_config()),
    "Informe ao menos um"
  )
})
