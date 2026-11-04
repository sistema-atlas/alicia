# Rotina comercial e negócios parados

## Negócios parados

Não existe filtro pronto de "parado" no MCP. Calcule pelos campos da busca:

1. Antes de contar, pergunte ou exclua etapas de espera proposital (ex.: Incubação, Reciclagem). Mostre essas à parte: "mais 13 em Incubação, que ficam paradas de propósito".
2. `search-opportunity` com `status: open`, `pipelineId` (e `pipelineStageId` se o cliente pedir uma etapa), `limit: 100`. Pagine com `meta.startAfter` e `meta.startAfterId`. Pare quando `meta.nextPage` vier vazio, quando a página trouxer menos itens que o `limit` ou quando a soma lida chegar a `meta.total`. Nunca passe de 10 páginas sem avisar o cliente.
3. Para cada item, dias parado = hoje menos `lastStageChangeAt` (se vier vazio, use `createdAt`).
4. Separe os que passam do limite que o cliente pediu. Se ele não disse, pergunte ("parado há quantos dias?"). Não invente um padrão.
5. Responda com números por etapa e por responsável (nome do responsável, nunca o id; ver `operacoes.md`, Usuários): "12 negócios parados há mais de 7 dias: 5 em Proposta (Carlos), 7 em Follow-up 2 (Ana)".
6. Ofereça a ação: criar uma tarefa de follow-up para cada responsável, mover para Reciclagem os que o cliente decidir, ou marcar perdido com motivo. Cada ação com sua aprovação; acima de 20 itens, `CONFIRMO MASSA`.

## Valor em aberto

- `search-opportunity` com `status: open` e o funil, paginando com a mesma regra de parada acima, somando `monetaryValue`.
- Mostre total e por etapa. Avise quantas oportunidades estão sem valor (ex.: "18 de 40 sem valor preenchido").

## Rotina do vendedor

Sugestão do método Atlas, adaptável:

| Momento | O que o vendedor faz | Como o assistente ajuda |
| --- | --- | --- |
| Começo do dia | Ver tarefas vencidas e do dia | `task-search` com `assignedTo` e `completed: false` |
| Cada contato feito | Registrar o que aconteceu e marcar a próxima data | `create-note` e `create-task` no contato |
| Avanço real | Mover o card | `update-opportunity` com a etapa |
| Fechou | Marcar ganho e valor final | `update-opportunity` com `status: won` e `monetaryValue` numa chamada só (o describe aceita os dois), uma aprovação |
| Perdeu | Marcar perdido com motivo | `update-opportunity-status` `lost` com `lostReasonId` |
| Fim da semana | Revisar parados | seção acima |

Tarefa recorrente (ex.: revisão semanal toda segunda às 9h de Brasília): `create-recurring-task` com `rruleOptions` `{ "intervalType": "weekly", "interval": 1, "dayOfWeek": "MO", "startDate": "2026-11-09T12:00:00.000Z", "dueAfterSeconds": 3600 }`. Mostre ao cliente em palavras simples antes de criar.

Horário: os campos de data vão em UTC. Brasília é UTC menos 3 horas.

## Campos personalizados de oportunidade

- Ler quais existem: `get-custom-fields` com `model: opportunity` (skill `atlas-campos-e-dados`).
- Preencher: `update-opportunity` com `customFields: [{"id": "<id do campo>", "fieldValue": "<valor>"}]`. Para campo de lista, o valor tem que ser exatamente uma das opções (`picklistOptions`).
- Campo novo: skill `atlas-campos-e-dados`.

## Mais de uma oportunidade por contato

A mesma pessoa pode ter mais de um card (fonte do fornecedor: artigo "Multiple Opportunities For The Same Person In The Same Pipeline", só título). Antes de criar, procure com `search-opportunity` e `contactId`. Se já houver card aberto no mesmo funil, pergunte se é negociação nova ou a mesma.
