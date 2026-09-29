# rsei: Client for the 'SEI' Electronic Information System Web Services

Toolkit to interact with the 'SOAP' web services of the 'SEI' (Sistema
Eletronico de Informacoes), the electronic system for document and
process management widely used by Brazilian public administration
bodies. Provides functions to build the 'SOAP' envelopes, perform the
requests, handle 'SOAP' faults, and parse the 'XML' responses into data
frames. Covers process and document queries, listing services, write
operations (creating processes and documents, sending and signing off
processes, blocks, deadlines and markers) and the permission services of
the companion 'SIP' system. Note that access to the web services is
restricted by the server to previously authorized network addresses. For
more information about the 'SEI' system and its web services see
<https://www.gov.br/gestao/pt-br/assuntos/processo-eletronico-nacional>.

## Acesso restrito por IP

Os Web Services do SEI são protegidos por *firewall* e só respondem a
requisições vindas de IPs/servidores previamente autorizados no cadastro
do serviço no SEI. As funções deste pacote (consultas, listagens,
escrita e SIP) só retornam dados quando executadas a partir de um host
autorizado; de um IP não autorizado as chamadas falham por *timeout* ou
conexão recusada. A autenticação adicional é feita por `SiglaSistema` +
chave de acesso (`IdentificacaoServico`) — ver
[`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

## See also

Useful links:

- <https://github.com/StrategicProjects/rsei>

- <https://strategicprojects.github.io/rsei/>

- Report bugs at <https://github.com/StrategicProjects/rsei/issues>

## Author

**Maintainer**: André Leite <leite@castlab.org>
([ORCID](https://orcid.org/0000-0002-4718-9766))

Authors:

- André Leite <leite@castlab.org>
  ([ORCID](https://orcid.org/0000-0002-4718-9766))

- Marcos Wasiliew <marcos.wasiliew@gmail.com>
  ([ORCID](https://orcid.org/0009-0004-4694-3159))

- Hugo Vasconcelos <hugo.vasconcelos@ufpe.br>
  ([ORCID](https://orcid.org/0000-0001-6249-0920))

- Carlos Amorim <carlos.agaf@ufpe.br>
  ([ORCID](https://orcid.org/0000-0001-6315-8305))

- Diogo Bezerra <diogo.bezerra@ufpe.br>
  ([ORCID](https://orcid.org/0000-0002-1216-8674))

- Júlia Nascimento Barreto <juliabarreto@gd.seplag.pe.gov.br>
  ([ORCID](https://orcid.org/0009-0004-2851-7770))
