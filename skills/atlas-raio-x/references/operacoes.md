# Operações do raio-x

Todas `kind: read`, `requiresApproval: false`. Conferidas com `search_operations` e `describe_operation` e executadas de verdade na conta de teste da Atlas (`aWKi2JLBXM9BUyv83t0A`) em 03/11/2026. Os números da coluna "Teste" são dessa leitura, só para mostrar o formato.

Limites de `limit` citados vêm do `describe_operation` de cada operação.

Sempre: `execute_operation` com `locationId` confirmado. Parâmetros de consulta vão em `params.query`; corpo em `params.body`; caminho em `params.path`.

| Verificação | operationId | Parâmetros usados | Onde está o número | Paginação | Teste |
| --- | --- | --- | --- | --- | --- |
| Conta | `get-location` | nenhum | `data.location` (`name`, `timezone`, `companyId`, `domain`, `settings.allowDuplicateContact`, `settings.contactUniqueIdentifiers`, `permissions`) | não | ok |
| Funis | `get-pipelines` | nenhum | `data.pipelines[]`, cada um com `stages[]` (`name`, `position`) | não, vem tudo | 5 funis |
| Motivos de perda | `get-lost-reason` | `query: {limit: 3, getCount: true}` | `data.total`; itens em `data.lostReasons[]` (`name`) | `limit`, `skip` | 28 |
| Campos de oportunidade | `get-custom-fields` | `query: {model: "opportunity"}` | tamanho de `data.customFields[]` | não | 13 |
| Campos de contato | `get-custom-fields` | `query: {model: "contact"}` | tamanho de `data.customFields[]` | não | conferido o formato com `opportunity`; `contact` usa o mesmo formato (enum do describe: `contact`, `opportunity`, `all`) |
| Tags | `get-location-tags` | nenhum | tamanho de `data.tags[]` (`name`). Não vem total | não, vem tudo | 119 |
| Formulários | `get-forms` | `query: {limit: 2}` | `data.total` | `limit` (até 50), `skip` | 3 |
| Pesquisas | `get-surveys` | `query: {limit: 2}` | `data.total` | `limit` (até 50), `skip` | 1 |
| Automações | `get-workflow` | nenhum | `data.workflows[]` com `name`, `status` (`published` ou `draft`), `uiUrl` | não, vem tudo numa resposta | dezenas, publicadas e rascunhos |
| Definição da automação | `get-workflow-definition` | `path: {workflowId}` | definição completa | não | 403 `WORKFLOW_API_NOT_ENABLED_FOR_LOCATION` |
| Agendas | `get-calendars` | nenhum (`showDrafted` opcional) | `data.calendars[]` com `name`, `isActive`, `teamMembers` | não | 7 |
| Usuários | `search-users` | `query: {companyId: <de get-location>, limit: "50"}` | tamanho de `data.users[]`; `roles.role` (`admin` ou `user`) | `limit`, `skip` (texto) | 3 |
| Conversas sem resposta | `search-conversation` | `query: {status: "unread", lastMessageDirection: "inbound", limit: 1}` | `data.total` | `limit`, `startAfterDate` | 36 |
| Oportunidades abertas | `search-opportunity` | `query: {status: "open", limit: 100}` | `data.meta.total`; datas em `lastStageChangeAt` de cada item | `meta.startAfter` e `meta.startAfterId` (passe em `startAfter` e `startAfterId`); para quando `meta.nextPage` vier nulo ou vazio (no teste veio `""`), ou quando já tiver lido `meta.total` itens | 14 abertas |
| Contatos (total) | `search-contacts-advanced` | `body: {pageLimit: 1}` | `data.total` | `searchAfter` | 2794 |
| Contatos sem telefone | `search-contacts-advanced` | `body: {pageLimit: 1, filters: [{field: "phone", operator: "not_exists"}]}` | `data.total` | | 12 |
| Contatos sem e-mail | `search-contacts-advanced` | `body: {pageLimit: 1, filters: [{field: "email", operator: "not_exists"}]}` | `data.total` | | 240 |
| Contatos sem os dois | `search-contacts-advanced` | os dois filtros juntos (são combinados com E) | `data.total` | | 7 |
| Kit da marca | `list-design-kits` | `query: {limit: 3}` | `data.total`; `items[].isDefault` | `limit` (até 20), `offset` | 1, padrão |
| Base de conhecimento | `listAllKnowledgeBasesPaginated` | `query: {limit: 3}` | `data.data.activeCount` | `lastKnowledgeBaseId`, `hasMore` | 14 |
| Widget de chat | `listChatWidget` | `query: {limit: "10", offset: "0"}` (os dois constam como obrigatórios no describe, em texto; o teste só com `limit` também respondeu) | `data.totalCount` | `limit`, `offset` | 1 |
| WhatsApp (indício) | `search-conversation` | `query: {lastMessageType: "TYPE_WHATSAPP", limit: 1}` e `query: {lastMessageType: "TYPE_CUSTOM_SMS", limit: 1}` | soma dos `data.total` | | 0 e 219 |
| Números de telefone | `active-numbers` | `query: {pageSize: 5}` | `data.data.total` | `page`, `pageSize` | 0 |
| Redes sociais | `get-account` | nenhum | `data.results.total`; `accounts[]` com `platform`, `isExpired`, `expire`, `active` | não | 15 |

## Pegadinhas

- **Dados pessoais nas respostas.** `search-conversation`, `search-opportunity` e `search-contacts-advanced` trazem nome, telefone e e-mail. Use `limit` 1 quando só precisa do total e não repita esses dados.
- **`search-contacts-advanced` usa `pageLimit`**, não `limit`, e o nome do campo nos filtros é camelCase. O teste com `not_exists` em `phone` e `email` funcionou.
- **`search-opportunities-advanced`** (POST) existe, mas o describe não mostra campo de filtro por status. Para o raio-x use `search-opportunity` (GET), que filtra por `status`.
- **Usuários:** `search-users` exige `companyId` (vem de `get-location`). O servidor acrescenta o `locationId` da conta na consulta (visto no `dryRun`), então a lista vem só da conta. Os usuários têm e-mail e telefone: conte, não liste.
- **`search-users`:** `count` veio igual ao tamanho da página. Use `limit` "50" e conte os itens; se vierem 50, pagine com `skip`.
- **Automações:** `search-workflows` (com filtros por status) deu 403 `WORKFLOW_API_NOT_ENABLED_FOR_LOCATION` na conta de teste. Use `get-workflow` e conte `status` na resposta.
- **Agendas:** a resposta de `get-calendars` é grande (configuração completa de cada agenda). Chame uma vez só.
- **Duplicados:** não existe operação que liste contatos duplicados. `get-duplicate-contact` só confere um e-mail ou telefone por vez. No raio-x, olhe a regra em `get-location` (`settings.allowDuplicateContact`) e, se o cliente quiser, atlas-contatos investiga casos pontuais.
- **WhatsApp:** não há operação de leitura do estado da conexão. Faça duas consultas `search-conversation` com `limit: 1`: `lastMessageType: "TYPE_WHATSAPP"` (oficial) e `lastMessageType: "TYPE_CUSTOM_SMS"` (WhatsApp por integração). Some os `total`. Na conta de teste da Atlas, oficial deu 0 e integração deu 219: olhar só a primeira gera falso alarme.
- **Busca de operação com permissão filtrada:** em `opportunities` e `workflows` o `search_operations` respondeu `scopeFilteredCount` maior que zero: existem operações no catálogo que esta conexão não enxerga. As leituras do raio-x listadas acima apareceram e funcionaram.
