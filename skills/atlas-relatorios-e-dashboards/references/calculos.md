# Cálculos do relatório "como foi meu mês"

Cada indicador tem: definição, operação, parâmetros e o que foi visto no teste real na conta da Atlas (leitura, 03/11/2026, período 01/10/2026 a 31/10/2026, fuso `America/Sao_Paulo`). Os números do teste servem para conferir que a receita funciona, não para mostrar a cliente.

## 0. Período e fuso

- Fuso: `get-location` > `location.timezone`. No Brasil (São Paulo), use `-03:00`.
- Contatos: datas ISO com fuso, ex.: `2026-10-01T00:00:00-03:00` até `2026-10-31T23:59:59-03:00`.
- Oportunidades (`search-opportunity`): `date` e `endDate` no formato `mm-dd-yyyy`, ex.: `10-01-2026` e `10-31-2026`.
- Agenda (`get-calendar-events`): `startTime` e `endTime` em milissegundos. Outubro de 2026 em São Paulo: `1790823600000` a `1793501999999`.
- Transações (`list-transactions`): `startAt` e `endAt` em `AAAA-MM-DD`.

## 0b. Tirar dados de teste

- Contatos: depois do total do período, conte com o mesmo filtro de data mais `{ "field": "firstNameLowerCase", "operator": "eq", "value": "teste" }` e, em outra chamada, mais `{ "field": "tags", "operator": "eq", "value": "teste-assistente" }`. Desconte os dois (se um mesmo contato pode estar nos dois, avise que o desconto é aproximado). Teste em outubro: 1 contato com nome `TESTE`, 0 com a tag. Os dois filtros funcionaram.
- Negócios: ao paginar, descarte os que têm `name` começando em `TESTE` (sem diferenciar maiúsculas). Em contagem com `limit` 1 não dá para descontar: diga "inclui N negócios de teste" só se você os viu; senão, diga que pode haver.
- Agenda: descarte eventos com título ou notas começando em `TESTE`.
- Diga na entrega: "descontei os N registros marcados como teste".

## 1. Leads novos

- Definição: contatos criados no período. **Data filtrada: criação do contato (`dateAdded`).**
- Operação: `search-contacts-advanced`, corpo:
  ```
  { "filters": [ { "field": "dateAdded", "operator": "range",
                   "value": { "gte": "<início ISO>", "lte": "<fim ISO>" } } ],
    "pageLimit": 1 }
  ```
- Resultado: campo `total`.
- Teste: `total` 35. Funcionou com `operator: range` e `value` com `gte` e `lte`.

## 2. Leads por origem

- Definição: leads novos agrupados pelo campo `source` do contato.
- Contagem de quem tem origem: mesmo filtro mais `{ "field": "source", "operator": "exists" }`, `pageLimit: 1`, ler `total`.
- Agrupar: pagine os leads do período (`pageLimit` até 100, `searchAfter` do último item da página anterior; nunca invente o cursor) e conte por `source`. Vazio = "Sem origem registrada". Pode complementar com `tags` se o cliente usa tag de origem.
- Teste: 5 de 35 leads tinham `source`; `attributionSource` veio vazio em todos os vistos. Leitura para o cliente: a maior parte dos leads entra sem origem gravada. Sugira `atlas-rastreamento` (UTM e campos de origem nos formulários).
- Oportunidades trazem `source` e `attributions` (`utmSessionSource`, `medium`). Para "de onde vieram as vendas", agrupe as oportunidades ganhas por `source` ou por `attributions[isFirst].medium`.

## 3. Funil por etapa (abertos agora)

- Definição: negócios abertos em cada etapa de um funil, no momento da leitura. **Sem filtro de data** (é a foto de agora).
- `get-pipelines` (guarde `id` e `stages[].id` e `name`).
- Chamada 1: `search-opportunity` com `pipelineId`, `status: open`, `limit: 1`. Ler `meta.total`.
  - Total 0: todas as etapas estão zeradas. Pare aqui (teste: funil Aquisição, 1 chamada).
  - Total até 100: chamada 2 com `limit: 100` e agrupe por `pipelineStageId` na conversa. Duas chamadas no total.
  - Total acima de 100: aí sim uma chamada por etapa com `pipelineStageId` e `limit: 1`.
- As respostas não trazem agregação por etapa (conferido em 03/11/2026 em `search-opportunity` e `search-opportunities-advanced`).
- Valor parado na etapa: pagine (`limit` até 100) e some `monetaryValue`. Se tudo vier 0, diga que os negócios estão sem valor preenchido.
- Teste: 5 funis na conta Atlas, um deles de tickets de suporte (`showInFunnel: false`). Não misture funil de suporte com vendas.

## 4. Negócios criados no período

- `search-opportunity` com `pipelineId`, `status: all`, `date`, `endDate`, `limit: 1`. Ler `meta.total`.
- **Data filtrada: criação do negócio.**
- Pelo que foi visto no teste, o filtro de data trabalha sobre a **criação** (`createdAt`) do negócio. O conector não documenta isso; confira o `createdAt` dos itens devolvidos.
- Teste: funil de vendas com 1 negócio criado em outubro (um teste interno). Sem `pipelineId`, `status: won` no mesmo período devolveu 14, quase todos do funil de suporte.

## 5. Ganhos e valor ganho

- Definição: negócios que viraram ganho dentro do período, no funil de vendas.
- **Data filtrada: quando virou ganho (`lastStatusChangeAt`).**
- `search-opportunity` com `pipelineId`, `status: won`, `order: added_desc`, `limit: 100`, paginando por `meta.startAfter` e `meta.startAfterId`. Mantenha só os que têm `lastStatusChangeAt` dentro do período (o filtro `date` é de criação, não de ganho).
- Limite de custo: primeiro leia o total de ganhos do funil (`limit: 1`). Até 300, pagine (3 chamadas no máximo). Acima disso, avise o cliente e ofereça a alternativa barata: ganhos **criados** no período (com `date` e `endDate`, 1 chamada), dizendo claramente que é outra definição.
- Valor ganho = soma de `monetaryValue` desses negócios, em reais.
- Ticket médio = valor ganho ÷ quantidade de ganhos (só se houver valor).
- Se o cliente cobra pelo Atlas CRM, compare com a receita recebida (item 7): valor ganho é o que foi fechado; receita é o que entrou.

## 6. Taxa de conversão

Use uma definição e diga qual:
- **Conversão do funil no mês** = ganhos no mês (item 5) ÷ negócios criados no mês (item 4).
- **Lead para venda** = ganhos no mês ÷ leads novos no mês (item 1).
- Perdidos: `status: lost` com a mesma lógica do item 5; motivos com `get-lost-reason`.
- Amostra pequena (menos de 10 criados): mostre os números absolutos e avise que a taxa ainda não diz muito.

## 7. Receita recebida

- `list-transactions` com `altType: location`, `startAt`, `endAt`, `limit` pequeno, paginando por `offset` até `totalCount`.
- Soma de `amount` com `status: "succeeded"`, menos `amountRefunded`. Nunca `chargeSnapshot.amount` (centavos).
- **Data filtrada: data da transação** (filtro `startAt` e `endAt`).
- Teste: 19 transações no total da conta; valores em reais (`400` = R$ 400,00).

## 8. Agendamentos e faltas

- **Data filtrada: data e hora da reunião (`startTime`).**
- `get-calendars` e veja os responsáveis (`teamMembers`). Faça uma chamada de `get-calendar-events` por **pessoa** (`userId`), não por calendário: na conta Atlas, 7 calendários do mesmo usuário viraram 1 chamada. Use `calendarId` só para calendário sem responsável. Junte os eventos sem repetir `id`.
- Conte por `appointmentStatus`. Vistos no teste: `cancelled` e `noshow`. Outros valores possíveis aparecem na própria resposta; liste o que vier.
- Marcados no período = eventos com `startTime` no período, sem `deleted: true`.
- Taxa de falta = `noshow` ÷ (`noshow` + `showed`). Se não houver nenhum `showed`, diga que o time não está marcando comparecimento na agenda.
- Teste: pelo `userId` do dono, 2 eventos em outubro (1 `cancelled`, 1 `noshow`), ambos de teste interno.
- Agendamentos criados no período (`dateAdded`) é outra conta. Diga qual usou.

## 9. Tempo de resposta

- Não há operação de relatório de tempo de resposta no conector (busca feita em 03/11/2026). Calcular mensagem a mensagem é caro e impreciso.
- Responda: "Esse número sai do painel nativo do Atlas CRM" e ofereça montar o widget (ver `paineis-nativos.md`).

## Comparação com o mês anterior

Rode as mesmas receitas para o período anterior de mesmo tamanho. Mostre a variação em número e em %. Variação sobre base menor que 5: mostre só o número.
