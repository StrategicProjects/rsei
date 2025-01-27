# file: R/structures.R

#########################
# 1) ANDAMENTO
#########################

#' @title Andamento
#' @description Represents the "Andamento" structure in SEI, which tracks process events.
#'
#' @param IdAndamento Character. Internal identifier of the andamento.
#' @param IdTarefa Character. Identifier of the associated task.
#' @param IdTarefaModulo Character. Identifier of the module task.
#' @param Descricao Character. Text describing the andamento.
#' @param DataHora Character. Date/time when the andamento was generated.
#' @param Unidade A \code{\link{Unidade}} object describing the unit that created the andamento.
#' @param Usuario A \code{\link{Usuario}} object describing the user who created the andamento.
#' @param Atributos A list of \code{\link{AtributoAndamento}} objects (can be empty).
#'
#' @return An S3 object of class "Andamento".
#' @export
Andamento <- function(IdAndamento = NULL,
                      IdTarefa = NULL,
                      IdTarefaModulo = NULL,
                      Descricao = NULL,
                      DataHora = NULL,
                      Unidade = NULL,
                      Usuario = NULL,
                      Atributos = list()) {
  structure(
    list(
      IdAndamento    = IdAndamento,
      IdTarefa       = IdTarefa,
      IdTarefaModulo = IdTarefaModulo,
      Descricao      = Descricao,
      DataHora       = DataHora,
      Unidade        = Unidade,
      Usuario        = Usuario,
      Atributos      = Atributos
    ),
    class = "Andamento"
  )
}


#########################
# 2) ANDAMENTOMARCADOR
#########################

#' @title AndamentoMarcador
#' @description Represents the "AndamentoMarcador" structure in SEI (marker events).
#'
#' @param IdAndamentoMarcador Character. Internal ID of the marker event.
#' @param Texto Character. Text associated with the andamento marker.
#' @param DataHora Character. Date/time the marker was generated.
#' @param Usuario A \code{\link{Usuario}} object describing the user who generated the marker.
#' @param Marcador A \code{\link{Marcador}} object used in the marker event (or \code{NULL} if removed).
#'
#' @return An S3 object of class "AndamentoMarcador".
#' @export
AndamentoMarcador <- function(IdAndamentoMarcador = NULL,
                              Texto = NULL,
                              DataHora = NULL,
                              Usuario = NULL,
                              Marcador = NULL) {
  structure(
    list(
      IdAndamentoMarcador = IdAndamentoMarcador,
      Texto               = Texto,
      DataHora            = DataHora,
      Usuario             = Usuario,
      Marcador            = Marcador
    ),
    class = "AndamentoMarcador"
  )
}


#########################
# 3) ARQUIVOEXTENSAO
#########################

#' @title ArquivoExtensao
#' @description Represents a file extension allowed in SEI (e.g., pdf, doc).
#'
#' @param IdArquivoExtensao Character. Internal SEI ID for the extension.
#' @param Extensao Character. The extension text (e.g., "pdf", "doc").
#' @param Descricao Character. Description of the extension.
#'
#' @return An S3 object of class "ArquivoExtensao".
#' @export
ArquivoExtensao <- function(IdArquivoExtensao,
                            Extensao,
                            Descricao) {
  structure(
    list(
      IdArquivoExtensao = IdArquivoExtensao,
      Extensao          = Extensao,
      Descricao         = Descricao
    ),
    class = "ArquivoExtensao"
  )
}


#########################
# 4) ASSINATURA
#########################

#' @title Assinatura
#' @description Represents the "Assinatura" structure (signature information).
#'
#' @param Nome Character. Signatory name.
#' @param CargoFuncao Character. Signatory position or function.
#' @param DataHora Character. Date/time of signature.
#' @param IdUsuario Character. ID of the user.
#' @param IdOrigem Character. Origin ID of the user in the SIP.
#' @param IdOrgao Character. ID of the user's organization.
#' @param Sigla Character. The user's sigla (username).
#'
#' @return An S3 object of class "Assinatura".
#' @export
Assinatura <- function(Nome = NULL,
                       CargoFuncao = NULL,
                       DataHora = NULL,
                       IdUsuario = NULL,
                       IdOrigem = NULL,
                       IdOrgao = NULL,
                       Sigla = NULL) {
  structure(
    list(
      Nome        = Nome,
      CargoFuncao = CargoFuncao,
      DataHora    = DataHora,
      IdUsuario   = IdUsuario,
      IdOrigem    = IdOrigem,
      IdOrgao     = IdOrgao,
      Sigla       = Sigla
    ),
    class = "Assinatura"
  )
}


#########################
# 5) ASSUNTO
#########################

#' @title Assunto
#' @description Represents the "Assunto" structure in SEI (subject classification).
#'
#' @param CodigoEstruturado Character. Structured code for the subject (e.g. "00.01.01.01").
#' @param Descricao Character. Description of the subject.
#'
#' @return An S3 object of class "Assunto".
#' @export
Assunto <- function(CodigoEstruturado = NULL,
                    Descricao = NULL) {
  structure(
    list(
      CodigoEstruturado = CodigoEstruturado,
      Descricao         = Descricao
    ),
    class = "Assunto"
  )
}


#########################
# 6) ATRIBUTOANDAMENTO
#########################

#' @title AtributoAndamento
#' @description Represents the "AtributoAndamento" structure (key-value attributes).
#'
#' @param Nome Character. Attribute name.
#' @param Valor Character. Attribute value.
#' @param IdOrigem Character. Auxiliary ID associated with this attribute.
#'
#' @return An S3 object of class "AtributoAndamento".
#' @export
AtributoAndamento <- function(Nome = NULL,
                              Valor = NULL,
                              IdOrigem = NULL) {
  structure(
    list(
      Nome     = Nome,
      Valor    = Valor,
      IdOrigem = IdOrigem
    ),
    class = "AtributoAndamento"
  )
}


#########################
# 7) ATRIBUTOOUVIDORIA
#########################

#' @title AtributoOuvidoria
#' @description Represents the "AtributoOuvidoria" structure (attributes in an ouvidoria context).
#'
#' @param Id Character. Identifier of the attribute (e.g., "P").
#' @param Nome Character. Internal name of the attribute.
#' @param Titulo Character. Title for display in the form.
#' @param Valor Character. Value associated with the title.
#'
#' @return An S3 object of class "AtributoOuvidoria".
#' @export
AtributoOuvidoria <- function(Id = NULL,
                              Nome = NULL,
                              Titulo = NULL,
                              Valor = NULL) {
  structure(
    list(
      Id     = Id,
      Nome   = Nome,
      Titulo = Titulo,
      Valor  = Valor
    ),
    class = "AtributoOuvidoria"
  )
}


#########################
# 8) CARGO
#########################

#' @title Cargo
#' @description Represents a "Cargo" (position) in SEI, with expressions for treatment and vocative.
#'
#' @param IdCargo Character. Internal ID of the cargo.
#' @param ExpressaoCargo Character. Cargo description (e.g., "Governor").
#' @param ExpressaoTratamento Character. Treatment (e.g., "A Sua Excelência o Senhor").
#' @param ExpressaoVocativo Character. Vocative (e.g., "Senhor Governador").
#'
#' @return An S3 object of class "Cargo".
#' @export
Cargo <- function(IdCargo = NULL,
                  ExpressaoCargo = NULL,
                  ExpressaoTratamento = NULL,
                  ExpressaoVocativo = NULL) {
  structure(
    list(
      IdCargo              = IdCargo,
      ExpressaoCargo       = ExpressaoCargo,
      ExpressaoTratamento  = ExpressaoTratamento,
      ExpressaoVocativo    = ExpressaoVocativo
    ),
    class = "Cargo"
  )
}


#########################
# 9) CIDADE
#########################

#' @title Cidade
#' @description Represents the "Cidade" structure in SEI.
#'
#' @param IdCidade Character. Identifier of the city.
#' @param IdEstado Character. Identifier of the state.
#' @param IdPais Character. Identifier of the country.
#' @param Nome Character. Name of the city.
#' @param CodigoIbge Character. IBGE code of the city.
#' @param SinCapital "S" or "N", indicates if the city is a state capital.
#' @param Latitude Character. Latitude of the city.
#' @param Longitude Character. Longitude of the city.
#'
#' @return An S3 object of class "Cidade".
#' @export
Cidade <- function(IdCidade,
                   IdEstado,
                   IdPais,
                   Nome,
                   CodigoIbge = NULL,
                   SinCapital = NULL,
                   Latitude = NULL,
                   Longitude = NULL) {
  structure(
    list(
      IdCidade   = IdCidade,
      IdEstado   = IdEstado,
      IdPais     = IdPais,
      Nome       = Nome,
      CodigoIbge = CodigoIbge,
      SinCapital = SinCapital,
      Latitude   = Latitude,
      Longitude  = Longitude
    ),
    class = "Cidade"
  )
}


#########################
# 10) CONTATO
#########################

#' @title Contato
#' @description Represents the "Contato" structure in SEI, storing personal or organizational contact data.
#'
#' @param StaOperacao Character. Operation code: "A", "E", "D", "R", or NULL.
#' @param IdContato Character. Internal ID of the contact.
#' @param IdTipoContato Character. Internal ID for the type of contact.
#' @param Nome Character. Name of the contact.
#' @param NomeSocial Character. Social name of the contact.
#' @param StaNatureza Character. "F" (individual) or "J" (company).
#' @param Endereco Character. Address of the contact.
#' @param Bairro Character. Neighborhood.
#' @param Cep Character. Postal code.
#' @param Cpf Character. Contact's CPF.
#' @param Cnpj Character. Contact's CNPJ.
#' @param Rg Character. Contact's RG.
#' @param OrgaoExpedidor Character. RG Issuing authority.
#' @param TelefoneFixo Character. Landline phone.
#' @param TelefoneCelular Character. Mobile phone.
#' @param Email Character. Email of the contact.
#' @param ... Additional fields (e.g., city, cargo, passaporte).
#'
#' @return An S3 object of class "Contato".
#' @export
Contato <- function(StaOperacao = NULL,
                    IdContato,
                    IdTipoContato = NULL,
                    Nome = NULL,
                    NomeSocial = NULL,
                    StaNatureza = NULL,
                    Endereco = NULL,
                    Bairro = NULL,
                    Cep = NULL,
                    Cpf = NULL,
                    Cnpj = NULL,
                    Rg = NULL,
                    OrgaoExpedidor = NULL,
                    TelefoneFixo = NULL,
                    TelefoneCelular = NULL,
                    Email = NULL,
                    ...) {
  structure(
    list(
      StaOperacao    = StaOperacao,
      IdContato      = IdContato,
      IdTipoContato  = IdTipoContato,
      Nome           = Nome,
      NomeSocial     = NomeSocial,
      StaNatureza    = StaNatureza,
      Endereco       = Endereco,
      Bairro         = Bairro,
      Cep            = Cep,
      Cpf            = Cpf,
      Cnpj           = Cnpj,
      Rg             = Rg,
      OrgaoExpedidor = OrgaoExpedidor,
      TelefoneFixo   = TelefoneFixo,
      TelefoneCelular= TelefoneCelular,
      Email          = Email,
      dots           = list(...)
    ),
    class = "Contato"
  )
}


#########################
# 11) DEFINICAOCONTROLEPRAZO
#########################

#' @title DefinicaoControlePrazo
#' @description Represents the "DefinicaoControlePrazo" structure for deadline control.
#'
#' @param ProtocoloProcedimento Character. Visible process number, e.g. "12.1.000000077-4".
#' @param DataPrazo Character. The date for defining the deadline.
#' @param Dias Character. Number of days for the deadline.
#' @param SinDiasUteis "S" or "N", indicating if the days are business days.
#'
#' @return An S3 object of class "DefinicaoControlePrazo".
#' @export
DefinicaoControlePrazo <- function(ProtocoloProcedimento,
                                   DataPrazo = NULL,
                                   Dias = NULL,
                                   SinDiasUteis = NULL) {
  structure(
    list(
      ProtocoloProcedimento = ProtocoloProcedimento,
      DataPrazo             = DataPrazo,
      Dias                  = Dias,
      SinDiasUteis          = SinDiasUteis
    ),
    class = "DefinicaoControlePrazo"
  )
}


#########################
# 12) DEFINICAOMARCADOR
#########################

#' @title DefinicaoMarcador
#' @description Represents the "DefinicaoMarcador" structure for applying markers to a process.
#'
#' @param ProtocoloProcedimento Character. Visible process number.
#' @param IdMarcador Character. The marker's ID available to the unit.
#' @param Texto Character. Text associated with the marker usage.
#'
#' @return An S3 object of class "DefinicaoMarcador".
#' @export
DefinicaoMarcador <- function(ProtocoloProcedimento,
                              IdMarcador,
                              Texto = NULL) {
  structure(
    list(
      ProtocoloProcedimento = ProtocoloProcedimento,
      IdMarcador            = IdMarcador,
      Texto                 = Texto
    ),
    class = "DefinicaoMarcador"
  )
}


#########################
# 13) DESTINATARIO
#########################

#' @title Destinatario
#' @description Represents the "Destinatario" structure in SEI.
#'
#' @param Sigla Character. The sigla of the recipient.
#' @param Nome Character. The name of the recipient.
#'
#' @return An S3 object of class "Destinatario".
#' @export
Destinatario <- function(Sigla = NULL,
                         Nome = NULL) {
  structure(
    list(
      Sigla = Sigla,
      Nome  = Nome
    ),
    class = "Destinatario"
  )
}


#########################
# 14) DOCUMENTO
#########################

#' @title Documento
#' @description Represents the "Documento" structure in SEI, for generated or external documents.
#'
#' @param Tipo Character. "G" (generated) or "R" (received).
#' @param IdProcedimento Character. SEI process ID (optional).
#' @param ProtocoloProcedimento Character. Visible process number (optional).
#' @param IdSerie Character. The document type in SEI.
#' @param Numero Character. Document number (optional).
#' @param NomeArvore Character. Display name in the process tree (optional).
#' @param Data Character. Document date (required for external docs).
#' @param Descricao Character. Document description (required for generated docs).
#' @param IdTipoConferencia Character. Conference type ID (for external docs).
#' @param SinArquivamento "S" or "N". Indicates if document should be archived.
#' @param Remetente A \code{\link{Remetente}} object (null for generated docs).
#' @param Interessados A list of \code{\link{Interessado}} objects.
#' @param Destinatarios A list of \code{\link{Destinatario}} objects.
#' @param Observacao Character. Unit observation, if any.
#' @param NomeArquivo Character. File name (required for external docs).
#' @param NivelAcesso Character. "0"=public, "1"=restricted, "2"=secret, or NULL.
#' @param IdHipoteseLegal Character. Hypothesis ID for restricted/secret docs, if any.
#' @param Conteudo Character. Base64-encoded file content (required for docs).
#' @param ConteudoMTOM Raw or base64 for large files (optional).
#' @param IdArquivo Character. If using \code{adicionarArquivo} approach, reference ID.
#' @param Campos A list of \code{\link{Campo}} objects for form fields, if any.
#' @param SinBloqueado "S" or "N". If blocked, the doc cannot be changed or removed.
#'
#' @return An S3 object of class "Documento".
#' @export
Documento <- function(Tipo,
                      IdProcedimento = NULL,
                      ProtocoloProcedimento = NULL,
                      IdSerie,
                      Numero = NULL,
                      NomeArvore = NULL,
                      Data = NULL,
                      Descricao = NULL,
                      IdTipoConferencia = NULL,
                      SinArquivamento = NULL,
                      Remetente = NULL,
                      Interessados = list(),
                      Destinatarios = list(),
                      Observacao = NULL,
                      NomeArquivo = NULL,
                      NivelAcesso = NULL,
                      IdHipoteseLegal = NULL,
                      Conteudo = NULL,
                      ConteudoMTOM = NULL,
                      IdArquivo = NULL,
                      Campos = list(),
                      SinBloqueado = NULL) {
  structure(
    list(
      Tipo                 = Tipo,
      IdProcedimento       = IdProcedimento,
      ProtocoloProcedimento= ProtocoloProcedimento,
      IdSerie              = IdSerie,
      Numero               = Numero,
      NomeArvore           = NomeArvore,
      Data                 = Data,
      Descricao            = Descricao,
      IdTipoConferencia    = IdTipoConferencia,
      SinArquivamento      = SinArquivamento,
      Remetente            = Remetente,
      Interessados         = Interessados,
      Destinatarios        = Destinatarios,
      Observacao           = Observacao,
      NomeArquivo          = NomeArquivo,
      NivelAcesso          = NivelAcesso,
      IdHipoteseLegal      = IdHipoteseLegal,
      Conteudo             = Conteudo,
      ConteudoMTOM         = ConteudoMTOM,
      IdArquivo            = IdArquivo,
      Campos               = Campos,
      SinBloqueado         = SinBloqueado
    ),
    class = "Documento"
  )
}


#########################
# 15) ESTADO
#########################

#' @title Estado
#' @description Represents the "Estado" structure in SEI (state info).
#'
#' @param IdEstado Character. ID of the state.
#' @param IdPais Character. ID of the country.
#' @param Sigla Character. State sigla.
#' @param Nome Character. Name of the state.
#' @param CodigoIbge Character. IBGE code of the state.
#'
#' @return An S3 object of class "Estado".
#' @export
Estado <- function(IdEstado,
                   IdPais,
                   Sigla,
                   Nome,
                   CodigoIbge = NULL) {
  structure(
    list(
      IdEstado   = IdEstado,
      IdPais     = IdPais,
      Sigla      = Sigla,
      Nome       = Nome,
      CodigoIbge = CodigoIbge
    ),
    class = "Estado"
  )
}


#########################
# 16) FERIADO
#########################

#' @title Feriado
#' @description Represents the "Feriado" structure (holiday).
#'
#' @param Data Character. Date of the holiday.
#' @param Descricao Character. Description of the holiday.
#'
#' @return An S3 object of class "Feriado".
#' @export
Feriado <- function(Data,
                    Descricao) {
  structure(
    list(
      Data      = Data,
      Descricao = Descricao
    ),
    class = "Feriado"
  )
}


#########################
# 17) HIPOTESELEGAL
#########################

#' @title HipoteseLegal
#' @description Represents the "HipoteseLegal" structure (legal hypothesis for restricted/sigilo).
#'
#' @param IdHipoteseLegal Character. ID of the legal hypothesis.
#' @param Nome Character. Name of the legal hypothesis.
#' @param BaseLegal Character. Description of the base legal.
#' @param NivelAcesso Character. "1"=restricted, "2"=secret, etc.
#'
#' @return An S3 object of class "HipoteseLegal".
#' @export
HipoteseLegal <- function(IdHipoteseLegal,
                          Nome,
                          BaseLegal,
                          NivelAcesso) {
  structure(
    list(
      IdHipoteseLegal = IdHipoteseLegal,
      Nome            = Nome,
      BaseLegal       = BaseLegal,
      NivelAcesso     = NivelAcesso
    ),
    class = "HipoteseLegal"
  )
}


#########################
# 18) INTERESSADO
#########################

#' @title Interessado
#' @description Represents the "Interessado" structure in SEI (interested party in a process or document).
#'
#' @param Sigla Character. The sigla of the interested party.
#' @param Nome Character. The name of the interested party.
#'
#' @return An S3 object of class "Interessado".
#' @export
Interessado <- function(Sigla = NULL,
                        Nome = NULL) {
  structure(
    list(
      Sigla = Sigla,
      Nome  = Nome
    ),
    class = "Interessado"
  )
}


#########################
# 19) MARCADOR
#########################

#' @title Marcador
#' @description Represents the "Marcador" structure (markers associated with a process).
#'
#' @param IdMarcador Character. ID of the marker.
#' @param Nome Character. Name of the marker.
#' @param Icone Character. PNG icon (Base64-encoded).
#' @param SinAtivo "S" or "N" indicating if the marker is active.
#'
#' @return An S3 object of class "Marcador".
#' @export
Marcador <- function(IdMarcador,
                     Nome,
                     Icone = NULL,
                     SinAtivo = NULL) {
  structure(
    list(
      IdMarcador = IdMarcador,
      Nome       = Nome,
      Icone      = Icone,
      SinAtivo   = SinAtivo
    ),
    class = "Marcador"
  )
}


#########################
# 20) OBSERVACAO
#########################

#' @title Observacao
#' @description Represents the "Observacao" structure in SEI (unit notes).
#'
#' @param Descricao Character. The text of the observation.
#' @param Unidade A \code{\link{Unidade}} object that added this observation.
#'
#' @return An S3 object of class "Observacao".
#' @export
Observacao <- function(Descricao = NULL,
                       Unidade = NULL) {
  structure(
    list(
      Descricao = Descricao,
      Unidade   = Unidade
    ),
    class = "Observacao"
  )
}


#########################
# 21) PAIS
#########################

#' @title Pais
#' @description Represents the "Pais" structure in SEI (country).
#'
#' @param IdPais Character. The ID of the country.
#' @param Nome Character. The name of the country.
#'
#' @return An S3 object of class "Pais".
#' @export
Pais <- function(IdPais,
                 Nome) {
  structure(
    list(
      IdPais = IdPais,
      Nome   = Nome
    ),
    class = "Pais"
  )
}


#########################
# 22) PROCEDIMENTO
#########################

#' @title Procedimento
#' @description Represents the "Procedimento" structure in SEI (process definition).
#'
#' @param IdTipoProcedimento Character. ID of the process type.
#' @param NumeroProtocolo Character. Process number (optional).
#' @param DataAutuacao Character. Process creation date (optional).
#' @param Especificacao Character. Process specification (optional).
#' @param Assuntos A list of \code{\link{Assunto}} objects.
#' @param Interessados A list of \code{\link{Interessado}} objects.
#' @param Observacao Character. Unit observation (optional).
#' @param NivelAcesso "0"=public, "1"=restricted, "2"=secret, or NULL.
#' @param IdHipoteseLegal Character. If restricted/secret, link to a legal hypothesis.
#'
#' @return An S3 object of class "Procedimento".
#' @export
Procedimento <- function(IdTipoProcedimento,
                         NumeroProtocolo = NULL,
                         DataAutuacao = NULL,
                         Especificacao = NULL,
                         Assuntos = list(),
                         Interessados = list(),
                         Observacao = NULL,
                         NivelAcesso = NULL,
                         IdHipoteseLegal = NULL) {
  structure(
    list(
      IdTipoProcedimento = IdTipoProcedimento,
      NumeroProtocolo    = NumeroProtocolo,
      DataAutuacao       = DataAutuacao,
      Especificacao      = Especificacao,
      Assuntos           = Assuntos,
      Interessados       = Interessados,
      Observacao         = Observacao,
      NivelAcesso        = NivelAcesso,
      IdHipoteseLegal    = IdHipoteseLegal
    ),
    class = "Procedimento"
  )
}


#########################
# 23) PROCEDIMENTORESUMIDO
#########################

#' @title ProcedimentoResumido
#' @description Represents a "ProcedimentoResumido" structure (summary of a process).
#'
#' @param IdTipoProcedimento Character. ID of the process type.
#' @param ProcedimentoFormatado Character. Visible process number.
#' @param TipoProcedimento A \code{\link{TipoProcedimento}} object with details about the process type.
#'
#' @return An S3 object of class "ProcedimentoResumido".
#' @export
ProcedimentoResumido <- function(IdTipoProcedimento,
                                 ProcedimentoFormatado,
                                 TipoProcedimento = NULL) {
  structure(
    list(
      IdTipoProcedimento     = IdTipoProcedimento,
      ProcedimentoFormatado  = ProcedimentoFormatado,
      TipoProcedimento       = TipoProcedimento
    ),
    class = "ProcedimentoResumido"
  )
}


#########################
# 24) PROTOCOLOBLOCO
#########################

#' @title ProtocoloBloco
#' @description Represents a "ProtocoloBloco" structure (process/document in a block).
#'
#' @param ProtocoloFormatado Character. Visible process or document number.
#' @param Identificacao Character. Type of the process or document.
#' @param Assinaturas A list of \code{\link{Assinatura}} objects (empty if none).
#'
#' @return An S3 object of class "ProtocoloBloco".
#' @export
ProtocoloBloco <- function(ProtocoloFormatado,
                           Identificacao,
                           Assinaturas = list()) {
  structure(
    list(
      ProtocoloFormatado = ProtocoloFormatado,
      Identificacao      = Identificacao,
      Assinaturas        = Assinaturas
    ),
    class = "ProtocoloBloco"
  )
}


#########################
# 25) PUBLICACAO
#########################

#' @title Publicacao
#' @description Represents the "Publicacao" structure in SEI (publication data).
#'
#' @param IdPublicacao Character. Internal ID of the publication.
#' @param IdDocumento Character. Internal ID of the associated document.
#' @param StaMotivo Character. "1"=Publication, "2"=Rectification, "3"=Republication, "4"=Apostilament.
#' @param Resumo Character. Summary text of the publication.
#' @param IdVeiculoPublicacao Character. Internal ID of the publication vehicle.
#' @param NomeVeiculo Character. Name of the publication vehicle.
#' @param StaTipoVeiculo Character. "I"=Internal, "E"=External, "M"=Module.
#' @param Numero Character. Publication number.
#' @param DataDisponibilizacao Character. Date of availability.
#' @param DataPublicacao Character. Date of publication.
#' @param Estado Character. "A"=Scheduled or "P"=Published.
#' @param ImprensaNacional A \code{\link{PublicacaoImprensaNacional}} object or NULL.
#'
#' @return An S3 object of class "Publicacao".
#' @export
Publicacao <- function(IdPublicacao = NULL,
                       IdDocumento = NULL,
                       StaMotivo = NULL,
                       Resumo = NULL,
                       IdVeiculoPublicacao = NULL,
                       NomeVeiculo = NULL,
                       StaTipoVeiculo = NULL,
                       Numero = NULL,
                       DataDisponibilizacao = NULL,
                       DataPublicacao = NULL,
                       Estado = NULL,
                       ImprensaNacional = NULL) {
  structure(
    list(
      IdPublicacao         = IdPublicacao,
      IdDocumento          = IdDocumento,
      StaMotivo            = StaMotivo,
      Resumo               = Resumo,
      IdVeiculoPublicacao  = IdVeiculoPublicacao,
      NomeVeiculo          = NomeVeiculo,
      StaTipoVeiculo       = StaTipoVeiculo,
      Numero               = Numero,
      DataDisponibilizacao = DataDisponibilizacao,
      DataPublicacao       = DataPublicacao,
      Estado               = Estado,
      ImprensaNacional     = ImprensaNacional
    ),
    class = "Publicacao"
  )
}


#########################
# 26) PUBLICACAOIMPRESSANACIONAL
#########################

#' @title PublicacaoImprensaNacional
#' @description Represents the "PublicacaoImprensaNacional" structure in SEI.
#'
#' @param IdVeiculo Character. ID of the vehicle.
#' @param SiglaVeiculo Character. e.g., "DOU".
#' @param DescricaoVeiculo Character. e.g., "Diário Oficial da União".
#' @param Pagina Character. Page number of the publication.
#' @param IdSecao Character. ID of the section.
#' @param Secao Character. Section name.
#' @param Data Character. Publication date.
#'
#' @return An S3 object of class "PublicacaoImprensaNacional".
#' @export
PublicacaoImprensaNacional <- function(IdVeiculo = NULL,
                                       SiglaVeiculo = NULL,
                                       DescricaoVeiculo = NULL,
                                       Pagina = NULL,
                                       IdSecao = NULL,
                                       Secao = NULL,
                                       Data = NULL) {
  structure(
    list(
      IdVeiculo        = IdVeiculo,
      SiglaVeiculo     = SiglaVeiculo,
      DescricaoVeiculo = DescricaoVeiculo,
      Pagina           = Pagina,
      IdSecao          = IdSecao,
      Secao            = Secao,
      Data             = Data
    ),
    class = "PublicacaoImprensaNacional"
  )
}


#########################
# 27) REMETENTE
#########################

#' @title Remetente
#' @description Represents the "Remetente" structure in SEI (sender info).
#'
#' @param Sigla Character. Participant sigla.
#' @param Nome Character. Participant name.
#'
#' @return An S3 object of class "Remetente".
#' @export
Remetente <- function(Sigla = NULL,
                      Nome = NULL) {
  structure(
    list(
      Sigla = Sigla,
      Nome  = Nome
    ),
    class = "Remetente"
  )
}


#########################
# 28) SERIE
#########################

#' @title Serie
#' @description Represents the "Serie" structure in SEI (document type).
#'
#' @param IdSerie Character. ID of the document type.
#' @param Nome Character. Name of the document type.
#' @param Aplicabilidade Character. "T"=internal/external, "I"=internal, "E"=external, "F"=forms.
#'
#' @return An S3 object of class "Serie".
#' @export
Serie <- function(IdSerie,
                  Nome,
                  Aplicabilidade = NULL) {
  structure(
    list(
      IdSerie         = IdSerie,
      Nome            = Nome,
      Aplicabilidade  = Aplicabilidade
    ),
    class = "Serie"
  )
}


#########################
# 29) TIPOPROCEDIMENTO
#########################

#' @title TipoProcedimento
#' @description Represents the "TipoProcedimento" structure in SEI (process type info).
#'
#' @param IdTipoProcedimento Character. Identifier of the process type.
#' @param Nome Character. Name of the process type.
#'
#' @return An S3 object of class "TipoProcedimento".
#' @export
TipoProcedimento <- function(IdTipoProcedimento,
                             Nome) {
  structure(
    list(
      IdTipoProcedimento = IdTipoProcedimento,
      Nome               = Nome
    ),
    class = "TipoProcedimento"
  )
}


#########################
# 30) TIPOCONFERENCIA
#########################

#' @title TipoConferencia
#' @description Represents the "TipoConferencia" structure in SEI (conference type info).
#'
#' @param IdTipoConferencia Character. Identifier of the conference type.
#' @param Descricao Character. Description of the conference type.
#'
#' @return An S3 object of class "TipoConferencia".
#' @export
TipoConferencia <- function(IdTipoConferencia,
                            Descricao) {
  structure(
    list(
      IdTipoConferencia = IdTipoConferencia,
      Descricao         = Descricao
    ),
    class = "TipoConferencia"
  )
}


#########################
# 31) UNIDADE
#########################

#' @title Unidade
#' @description Represents the "Unidade" structure in SEI (organizational unit).
#'
#' @param IdUnidade Character. Identifier of the unit.
#' @param Sigla Character. Unit sigla.
#' @param Descricao Character. Unit description.
#' @param SinProtocolo "S" or "N" if it's a protocol unit.
#' @param SinArquivamento "S" or "N" if it's an archive unit.
#' @param SinOuvidoria "S" or "N" if it's an ombudsman unit.
#'
#' @return An S3 object of class "Unidade".
#' @export
Unidade <- function(IdUnidade,
                    Sigla,
                    Descricao,
                    SinProtocolo = NULL,
                    SinArquivamento = NULL,
                    SinOuvidoria = NULL) {
  structure(
    list(
      IdUnidade       = IdUnidade,
      Sigla           = Sigla,
      Descricao       = Descricao,
      SinProtocolo    = SinProtocolo,
      SinArquivamento = SinArquivamento,
      SinOuvidoria    = SinOuvidoria
    ),
    class = "Unidade"
  )
}


#########################
# 32) UNIDADEPROCEDIMENTOABERTO
#########################

#' @title UnidadeProcedimentoAberto
#' @description Represents the "UnidadeProcedimentoAberto" structure (where a process is open).
#'
#' @param Unidade A \code{\link{Unidade}} object (the open unit).
#' @param UsuarioAtribuicao A \code{\link{Usuario}} object to which the process is assigned (optional).
#'
#' @return An S3 object of class "UnidadeProcedimentoAberto".
#' @export
UnidadeProcedimentoAberto <- function(Unidade,
                                      UsuarioAtribuicao = NULL) {
  structure(
    list(
      Unidade           = Unidade,
      UsuarioAtribuicao = UsuarioAtribuicao
    ),
    class = "UnidadeProcedimentoAberto"
  )
}


#########################
# 33) USUARIO
#########################

#' @title Usuario
#' @description Represents the "Usuario" structure in SEI (user info).
#'
#' @param IdUsuario Character. Identifier of the user.
#' @param Sigla Character. The user's sigla.
#' @param Nome Character. The user's full name.
#'
#' @return An S3 object of class "Usuario".
#' @export
Usuario <- function(IdUsuario,
                    Sigla,
                    Nome) {
  structure(
    list(
      IdUsuario = IdUsuario,
      Sigla     = Sigla,
      Nome      = Nome
    ),
    class = "Usuario"
  )
}
