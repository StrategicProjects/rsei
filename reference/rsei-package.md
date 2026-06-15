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
restricted by the server to previously authorized network addresses.

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

**Maintainer**: Andre Leite <leite@castlab.org>

Authors:

- Marcos Wasilew <marcos.wasilew@gmail.com>

- Hugo Vasconcelos <hugo.vasconcelos@ufpe.br>

- Carlos Amorin <carlos.agaf@ufpe.br>

- Diogo Bezerra <diogo.bezerra@ufpe.br>

- Júlia Nascimento Barreto <juliabarreto@gd.seplag.pe.gov.br>
