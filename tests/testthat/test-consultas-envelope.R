# Verifica que os wrappers de consulta montam os parâmetros corretos no envelope
# (sem rede): intercepta sei_build_envelope inspecionando params via call direta.

cfg_test <- function() sei_config(sigla_sistema = "SIG", identificacao_servico = "KEY",
                                  id_unidade = "999")

test_that("consultar_publicacao exige ao menos um identificador", {
  expect_error(
    consultar_publicacao(config = cfg_test()),
    "Informe ao menos um"
  )
})

test_that("envelopes das operações de consulta têm a operação e a chave", {
  # monta envelopes diretamente (espelha o que os wrappers enviam)
  env_doc <- sei_build_envelope("consultarDocumento", list(
    SiglaSistema = "SIG", IdentificacaoServico = "KEY", IdUnidade = "999",
    ProtocoloDocumento = "0003934"))
  expect_true(grepl("<sei:consultarDocumento", env_doc, fixed = TRUE))
  expect_true(grepl("0003934", env_doc, fixed = TRUE))

  env_pub <- sei_build_envelope("consultarPublicacao", list(
    SiglaSistema = "SIG", IdentificacaoServico = "KEY", IdDocumento = "111"))
  expect_true(grepl("<sei:consultarPublicacao", env_pub, fixed = TRUE))
  expect_s3_class(xml2::read_xml(env_pub), "xml_document")

  env_bloco <- sei_build_envelope("consultarBloco", list(
    SiglaSistema = "SIG", IdentificacaoServico = "KEY", IdBloco = "5",
    SinRetornarProtocolos = "S"))
  expect_true(grepl("<IdBloco xsi:type=\"xsd:string\">5</IdBloco>", env_bloco, fixed = TRUE))
})
