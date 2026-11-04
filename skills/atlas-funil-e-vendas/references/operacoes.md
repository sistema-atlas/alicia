# Operações de funil e vendas (verificadas)

Conferidas com `search_operations` e `describe_operation` em 03/11/2026, na conta de teste da Atlas. "Testada" quer dizer leitura executada de verdade; escritas só com `dryRun: true`.

"dryRun montado" quer dizer só que a requisição foi montada. O dryRun não valida o corpo (`authorizationVerified: false`). Use apenas campos que aparecem no describe.

Todas pedem `locationId`. Escrita exige `idempotencyKey`. Legenda: **L** leitura, **S** aprovação simples, **R** aprovação reforçada.

## Funis e etapas

| operationId | O que faz | Obrigatórios | Resposta | Aprovação |
| --- | --- | --- | --- | --- |
| `get-pipelines` | Lista funis com etapas. Testada | nenhum | `pipelines[]`: `id`, `name`, `stages[]` (`id`, `name`, `position`, `stageWinProbability`), `showInFunnel` | L |

Escondidas por permissão nesta conexão (o `describe_operation` respondeu 403 "not available for this session"):

| operationId | Permissão que falta | Plano B |
| --- | --- | --- |
| `create-pipeline` | `pipelines.create` | Navegador `crm-settings` (conferido em 03/11/2026) |
| `update-pipeline` | `pipelines.write` | Navegador `crm-settings` (conferido em 03/11/2026) |
| `delete-pipeline` | `pipelines.write` | Navegador `crm-settings` (conferido em 03/11/2026) |

A busca no domínio opportunities respondeu `scopeFilteredCount: 4` (12 visíveis de 16). Se o cliente reconectar o Atlas CRM dando todas as permissões, rode `describe_operation` nessas três antes de usar.

## Motivos de perda

| operationId | O que faz | Parâmetros | Resposta | Aprovação |
| --- | --- | --- | --- | --- |
| `get-lost-reason` | Lista motivos. Testada | `limit` (padrão 100), `skip`, `query`, `name`, `getCount`, `deleted` | `lostReasons[]` com **`_id`** (não `id`), `name`; `total` | L |

Os nomes podem ter aspas curvas e barras (ex.: Achou “caro”, Distância / Geográfico). Leia a lista toda (`limit: 100`) e compare sem aspas, acento, barra e maiúscula. Não use o filtro `name` exato.

Criar ou editar motivo: não existe operação no catálogo (procurado em 03/11/2026) e a tela não foi encontrada na conferência de 03/11/2026. Alternativa na regra 4 do SKILL.md.

## Buscar e ler oportunidades

| operationId | O que faz | Parâmetros | Aprovação |
| --- | --- | --- | --- |
| `search-opportunity` | Busca com filtros. Testada | `id` (um card pelo id), `pipelineId`, `pipelineStageId`, `status` (`open`, `won`, `lost`, `abandoned`, `all`), `assignedTo`, `contactId`, `q` (texto, até 75 caracteres), `date` e `endDate` (formato `mm-dd-yyyy`), `order` (`added_asc`, `added_desc`, `name_asc`, `name_desc`), `limit` (até 100, padrão 20), `page`, `startAfter` e `startAfterId` (paginação), `getNotes`, `getTasks`, `getCalendarEvents` | L |
| `search-opportunities-advanced` | Busca por texto com detalhes | `query`, `limit`, `page` (começa em 0), `searchAfter`, `additionalDetails` (`notes`, `tasks`, `calendarEvents`, `unReadConversations`, os quatro obrigatórios se mandar o objeto) | L |
| `get-opportunity` | Uma oportunidade | `id` | L |

Resposta de `search-opportunity` (testada):
- `meta.total`: total que bate com o filtro. Para contar, use `limit: 1` e leia `meta.total`.
- Cada item: `id`, `name`, `monetaryValue`, `pipelineId`, `pipelineStageId`, `status`, `assignedTo`, `contactId`, `lostReasonId`, `lastStageChangeAt`, `lastStatusChangeAt`, `createdAt`, `updatedAt`, `customFields` (`id` e `fieldValueString`), `followers`, `contact` (resumo do contato).
- Próxima página: mande `startAfter` e `startAfterId` com os valores de `meta.startAfter` e `meta.startAfterId`.
- **Regra de parada:** pare quando `meta.nextPage` vier vazio, quando a página trouxer menos itens que o `limit` ou quando a soma lida chegar a `meta.total`. Não use `meta.startAfter` preenchido como sinal de que há mais: ele vem preenchido também na última página (testado: funil com 1 card, `nextPage` vazio e `startAfter` preenchido). Nunca passe de 10 páginas sem avisar o cliente.
- A resposta traz `meta.nextPageUrl` e outros links com domínio técnico. **Nunca mostre esses links ao cliente.** Link para o cliente só de `telas.md`.
- `q` casa também com tags e dados do contato: traz falsos positivos. Prefira `contactId`; se usar `q`, filtre pelo `name` exato do card.
- O item traz dados do contato. Use para responder, nunca grave.

## Criar e atualizar

| operationId | O que faz | Obrigatórios | Campos que importam | Aprovação |
| --- | --- | --- | --- | --- |
| `create-opportunity` | Cria | `pipelineId`, `name`, `status`, `contactId` | `pipelineStageId` (sem ele cai na primeira etapa, a conferir), `monetaryValue` (número), `assignedTo` (id de usuário), `forecastExpectedCloseDate`, `forecastProbability`, `customFields` (`[{id, fieldValue}]`) | S |
| `Upsert-opportunity` | Cria ou atualiza | `pipelineId`, `contactId` | `id` (para atualizar uma certa), `name`, `status`, `pipelineStageId`, `monetaryValue`, `assignedTo`, `lostReasonId`, `followers`, `followersActionType` (`add` ou `remove`), `isRemoveAllFollowers`. Resposta traz `new` | S |
| `update-opportunity` | Muda etapa, funil, valor, status, responsável, campos. dryRun montado | `id` | Exatamente os do describe: `pipelineId`, `name`, `pipelineStageId`, `status`, `monetaryValue`, `forecastExpectedCloseDate`, `forecastProbability`, `assignedTo`, `customFields`. Não tem `contactId` nem `lostReasonId` (perdido com motivo: `update-opportunity-status`) | S |
| `update-opportunity-status` | Muda só o status. dryRun montado | `id`, `status` | `lostReasonId` | S; R em massa |
| `delete-opportunity` | Apaga | `id` | nenhum | R `CONFIRMO EXCLUSÃO`, uma por vez |

Exemplos (dryRun montado):

```json
{"path": {"id": "<oportunidade>"}, "body": {"pipelineId": "<funil>", "pipelineStageId": "<etapa>", "monetaryValue": 1500}}
{"path": {"id": "<oportunidade>"}, "body": {"status": "lost", "lostReasonId": "<_id do motivo>"}}
```

`status: all` aparece na lista do describe, mas serve para busca. Não grave `all` numa oportunidade.

## Seguidores

| operationId | O que faz | Obrigatórios | Aprovação |
| --- | --- | --- | --- |
| `add-followers-opportunity` | Acrescenta seguidores | `id`, `followers` (até 10 ids de usuário) | S |
| `remove-followers-opportunity` | Tira seguidores. `kind: delete` | `id`, `followers` (corpo). `isRemoveAllFollowers: true` vai na **query** (`params.query`), não no corpo, e tira todos | S; com `isRemoveAllFollowers`, aprovação simples explícita dizendo quantos seguidores saem (leia `followers` do card antes) |

## Tarefas e notas da negociação

Não há operação de nota nem de tarefa na oportunidade. Elas ficam no contato da oportunidade (`contactId`), pelas operações da skill `atlas-contatos`:

| operationId | Uso aqui |
| --- | --- |
| `create-task` | Follow-up do vendedor: `contactId`, `title`, `dueDate` (ISO 8601 UTC), `completed: false`, `assignedTo` |
| `task-search` | Tarefas pendentes de um vendedor: `assignedTo: [id]`, `completed: false` |
| `update-task-completed` | Marcar feita |
| `create-note` | Registrar o que aconteceu na negociação |
| `create-recurring-task` | Tarefa que se repete: `title`, `rruleOptions` (`intervalType`: `daily`, `weekly`, `monthly`, `yearly`, `hourly`; `interval`; `startDate`; `dueAfterSeconds`; opcional `dayOfWeek`: `MO` a `SU`), `owners`, `contactIds` |

## Usuários (responsável e seguidores)

O card traz só o id do responsável (`assignedTo`). Para mostrar o nome, peça a lista de usuários à `atlas-conta-e-equipe` uma vez e guarde na conversa. Se não houver, mostre "responsável 1, responsável 2" e pergunte ao cliente quem é quem. Nunca mostre o id cru ao cliente. (`search-users` exige `companyId`, que o cliente comum não tem à mão.)
