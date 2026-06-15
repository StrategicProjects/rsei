test_that("envelope SIP usa namespace sipns", {
  env <- sei_build_envelope("listarPermissao",
                            list(ChaveAcesso = "K", IdSistema = "100"),
                            ns_prefix = "sip", ns_uri = "sipns")
  expect_true(grepl('xmlns:sip="sipns"', env, fixed = TRUE))
  expect_true(grepl("<sip:listarPermissao", env, fixed = TRUE))
  expect_s3_class(xml2::read_xml(env), "xml_document")
})

test_that("sip_config resolve defaults", {
  cfg <- sip_config(chave_acesso = "abc", id_sistema = "100")
  expect_s3_class(cfg, "sip_config")
  expect_equal(cfg$chave_acesso, "abc")
  expect_match(cfg$sip_url, "sip")
})

test_that("listar_permissao monta ChaveAcesso/IdSistema e usa ns/soapAction SIP", {
  captured <- NULL
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(),
                        soap_action = "SeiAction", ns_prefix = "sei",
                        ns_uri = "Sei", verbose = FALSE) {
      captured <<- list(op = operation, params = params, soap_action = soap_action,
                        ns_prefix = ns_prefix, ns_uri = ns_uri, url = config$sei_url)
      xml2::read_xml(test_path("fixtures", "listarPermissao.xml"))
    }
  )
  cfg <- sip_config(chave_acesso = "CHAVE", id_sistema = "100000100",
                    sip_url = "https://sip.example/SipWS.php")
  res <- listar_permissao(cfg, id_unidade = "110008720")

  expect_equal(captured$op, "listarPermissao")
  expect_equal(captured$params$ChaveAcesso, "CHAVE")
  expect_equal(captured$params$IdSistema, "100000100")
  expect_equal(captured$soap_action, "sipnsAction")
  expect_equal(captured$ns_uri, "sipns")
  expect_equal(captured$url, "https://sip.example/SipWS.php")

  # parsing da resposta sintética
  expect_equal(nrow(res), 2L)
  expect_named(res, names(.sip_fields_permissao))
  expect_equal(res$IdPerfil, c("5", "3"))
  expect_equal(res$SinSubunidades, c("N", "S"))
  expect_true(is.na(res$IdOrigemUsuario[1]))   # xsi:nil
})

test_that("replicar_permissao/replicar_usuario montam arrays e retornam bool", {
  captured <- NULL
  testthat::local_mocked_bindings(
    sei_call = function(operation, params = list(), config = sei_config(),
                        soap_action = "SeiAction", ns_prefix = "sei",
                        ns_uri = "Sei", verbose = FALSE) {
      captured <<- list(op = operation, params = params)
      xml2::read_xml("<E xmlns:sipns='sipns'><sipns:r><parametros>true</parametros></sipns:r></E>")
    }
  )
  ok <- replicar_permissao(
    list(list(StaOperacao = "A", IdSistema = "100", IdPerfil = "5",
              IdUsuario = "1", IdUnidade = "2", DataInicial = "01/01/2024")),
    config = sip_config(chave_acesso = "K"))
  expect_true(ok)
  env <- sei_build_envelope(captured$op, captured$params, ns_prefix = "sip", ns_uri = "sipns")
  itens <- xml2::xml_find_all(xml2::read_xml(env),
                              "//*[local-name()='Permissoes']/*[local-name()='item']")
  expect_length(itens, 1)
})
