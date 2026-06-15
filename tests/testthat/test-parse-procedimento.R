test_that("parse_consultar_procedimento_response parseia a fixture real", {
  doc <- xml2::read_xml(test_path("fixtures", "consultarProcedimento.xml"))
  res <- parse_consultar_procedimento_response(doc)

  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 1L)

  # campos escalares
  expect_equal(res$IdProcedimento, "30272383")
  expect_equal(res$ProcedimentoFormatado, "0000000000.000001/2020-11")
  expect_equal(res$DataAutuacao, "30/06/2022")

  # recodificação de nível de acesso (0 -> publico local, 1 -> restrito global)
  # asserções ASCII-safe (evita literal acentuado sob locale "C")
  expect_false(res$NivelAcessoLocal %in% c("0", "1", "2"))
  expect_match(res$NivelAcessoLocal, "blico")          # "público"
  expect_equal(res$NivelAcessoGlobal, "restrito")

  # TipoProcedimento desaninhado com prefixo (ASCII-safe via regex)
  expect_match(res$TipoProcedimento_Nome, "Tomada de Pre")
})

test_that("recodify_access_level mapeia por codepoint", {
  # compara codepoints p/ não depender de encoding de literal no arquivo
  expect_identical(utf8ToInt(recodify_access_level("0")), utf8ToInt(intToUtf8(c(112,250,98,108,105,99,111)))) # "público"
  expect_equal(recodify_access_level("1"), "restrito")
  expect_equal(recodify_access_level("X"), "X")
  expect_equal(recodify_access_level(""), "")
})

test_that("andamentos são ancorados na subárvore correta (bug Sigla/Descricao)", {
  doc <- xml2::read_xml(test_path("fixtures", "consultarProcedimento.xml"))
  res <- parse_consultar_procedimento_response(doc)

  # AndamentoGeracao: Descricao do andamento != Descricao da unidade
  expect_match(res$AndamentoGeracao_Descricao, "Processo p")  # "Processo público gerado"
  expect_equal(res$AndamentoGeracao_SiglaUnidade, "SEINFRA - GGA")
  expect_match(res$AndamentoGeracao_DescricaoUnidade, "Gerencia Geral de Aquisi")
  # SiglaUsuario deve ser do usuário, não da unidade (o bug antigo retornava a sigla da unidade)
  expect_equal(res$AndamentoGeracao_SiglaUsuario, "fulano.gerador")
  expect_equal(res$AndamentoGeracao_NomeUsuario, "Fulano Gerador da Silva")

  # AndamentoConclusao é xsi:nil -> linha de NAs
  expect_true(is.na(res$AndamentoConclusao_Descricao))

  # UltimoAndamento
  expect_equal(res$UltimoAndamento_SiglaUnidade, "DER-ULIC")
  expect_equal(res$UltimoAndamento_SiglaUsuario, "ciclano.conclui")
})

test_that("arrays viram colunas-lista de tibbles", {
  doc <- xml2::read_xml(test_path("fixtures", "consultarProcedimento.xml"))
  res <- parse_consultar_procedimento_response(doc)

  expect_equal(nrow(res$UnidadesProcedimentoAberto[[1]]), 6L)
  expect_equal(nrow(res$Assuntos[[1]]), 4L)
  expect_equal(nrow(res$Interessados[[1]]), 1L)

  # Observacoes / relacionados / anexados vazios (arrayType [0])
  expect_equal(nrow(res$Observacoes[[1]]), 0L)
  expect_equal(nrow(res$ProcedimentosRelacionados[[1]]), 0L)

  # conteúdo de um assunto e do interessado
  expect_true("004" %in% res$Assuntos[[1]]$CodigoEstruturado)
  expect_equal(res$Interessados[[1]]$Sigla, "interessado.exemplo")
})
