# Operações do MCP: relatórios

Conferidas com `describe_operation` em 03/11/2026 e executadas (só leitura) na conta de teste da Atlas. Todas são kind `read`, sem aprovação. Passe `locationId` sempre.

Não há operação de painel nativo (dashboard) nem de relatório pronto no conector. Busca por "dashboard", "reporting", "response time" em 03/11/2026 só devolveu relatórios de anúncios e estatísticas de e-mail. A busca avisou operações escondidas por permissão (`scopeFilteredCount` 1 e 2); se um dia aparecer operação de painel, registre aqui.

### get-location
- GET `/locations/{locationId}`. Use `location.timezone`, `location.currency`.

### search-contacts-advanced
- POST `/contacts/search`. Corpo: `filters` (`field` em camelCase, `operator`: `eq`, `not_eq`, `contains`, `exists`, `not_exists`, `range`, `gt`, `gte`, `lt`, `lte`, ...; `value`), `sort`, `pageLimit` (1 a 100; não é `limit`), `searchAfter` (eco do cursor do último item).
- Resposta: `{ contacts: [{ id, dateAdded, source, tags, type, attributionSource, lastAttributionSource, assignedTo, searchAfter, ... }], total }`.
- Testado: `dateAdded` com `range` `{ gte, lte }`; `source` com `exists`.

### get-pipelines
- GET `/opportunities/pipelines`. Resposta `{ pipelines: [{ id, name, showInFunnel, stages: [{ id, name, position, stageWinProbability }] }] }`.

### search-opportunity
- GET `/opportunities/search`. Filtros: `pipelineId`, `pipelineStageId`, `status` (`open`, `won`, `lost`, `abandoned`, `all`), `date` e `endDate` (`mm-dd-yyyy`), `assignedTo`, `contactId`, `q`, `limit` (até 100, padrão 20), `page`, `startAfter`, `startAfterId`, `order`.
- Resposta: `{ opportunities: [{ id, name, monetaryValue, pipelineId, pipelineStageId, status, source, createdAt, lastStatusChangeAt, lastStageChangeAt, assignedTo, attributions, contact, ... }], meta: { total, startAfter, startAfterId, nextPage } }`.
- Cada item traz o contato com e-mail, telefone e tags: não reproduza.

### search-opportunities-advanced
- POST `/opportunities/search`. O describe só lista `query`, `limit`, `page`, `searchAfter`, `additionalDetails`; não há filtro por funil documentado. Para relatório, prefira `search-opportunity`. Teste sem filtro: `total` 83 na conta.

### get-lost-reason
- GET `/opportunities/lost-reason`. Motivos de perda para agrupar perdidos. Vista na busca.

### list-transactions
- Ver `atlas-cobrancas-e-contratos` > `references/operacoes.md`. Valor em `amount` (reais cheios).

### get-calendars
- GET `/calendars/`. Parâmetros: `groupId`, `showDrafted`. Resposta `{ calendars: [{ id, name, calendarType, isActive, teamMembers, ... }] }`.

### get-calendar-events
- GET `/calendars/events`. Obrigatórios: `startTime`, `endTime` (ms, texto) e um entre `calendarId`, `userId`, `groupId`.
- Resposta: `{ events: [{ id, calendarId, contactId, assignedUserId, appointmentStatus, startTime, endTime, dateAdded, deleted, title, ... }] }`.
- Teste: funcionou com `userId`. Traz dados de quem marcou em `appointmentMeta`: não reproduza.
