test_that("sei_build_envelope produz o formato do SEI", {
  env <- sei_build_envelope("listarUnidades", list(
    SiglaSistema = "HORTENSIAS",
    IdentificacaoServico = "publicacao"
  ))
  expect_true(grepl('xmlns:sei="Sei"', env, fixed = TRUE))
  expect_true(grepl("soapenv:encodingStyle", env, fixed = TRUE))
  expect_true(grepl('<sei:listarUnidades', env, fixed = TRUE))
  expect_true(grepl('<SiglaSistema xsi:type="xsd:string">HORTENSIAS</SiglaSistema>',
                    env, fixed = TRUE))
  # deve ser XML válido
  expect_s3_class(xml2::read_xml(env), "xml_document")
})

test_that("escape de caracteres reservados de XML", {
  expect_equal(sei_xml_escape("a & b < c > d"), "a &amp; b &lt; c &gt; d")
  env <- sei_build_envelope("op", list(Campo = "A & B <x>"))
  expect_true(grepl("A &amp; B &lt;x&gt;", env, fixed = TRUE))
  expect_s3_class(xml2::read_xml(env), "xml_document")
})

test_that("parâmetros NULL são omitidos e NA viram xsi:nil", {
  env <- sei_build_envelope("op", list(A = "1", B = NULL, C = NA))
  expect_true(grepl("<A xsi:type=\"xsd:string\">1</A>", env, fixed = TRUE))
  expect_false(grepl("<B", env, fixed = TRUE))
  expect_true(grepl("<C xsi:nil=\"true\"/>", env, fixed = TRUE))
})

test_that("estruturas aninhadas e arrays de <item>", {
  env <- sei_build_envelope("gerarProcedimento", list(
    Procedimento = list(IdTipoProcedimento = "100", Especificacao = "x"),
    Assuntos = list(
      list(CodigoEstruturado = "00.01"),
      list(CodigoEstruturado = "00.02")
    )
  ))
  doc <- xml2::read_xml(env)
  # estrutura aninhada
  expect_equal(
    xml2::xml_text(xml2::xml_find_first(doc, "//*[local-name()='IdTipoProcedimento']")),
    "100"
  )
  # array com 2 itens
  items <- xml2::xml_find_all(doc, "//*[local-name()='Assuntos']/*[local-name()='item']")
  expect_length(items, 2)
})

test_that("sei_config resolve defaults e overrides", {
  cfg <- sei_config(sigla_sistema = "ABC", identificacao_servico = "k")
  expect_s3_class(cfg, "sei_config")
  expect_equal(cfg$sigla_sistema, "ABC")
  expect_equal(cfg$identificacao_servico, "k")
  expect_match(cfg$sei_url, "^https?://")
})
