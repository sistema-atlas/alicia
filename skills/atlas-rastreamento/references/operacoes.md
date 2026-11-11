# Operações do MCP: rastreamento, origem e anúncios

Conferidas com `describe_operation` em 03/11/2026. Leituras executadas na conta de teste da Atlas (formato das respostas anotado abaixo, sem dados pessoais). Escritas só com `dryRun: true`. `locationId` em toda chamada.

Não existe operação para **colar código de rastreamento** em funil, site, página ou formulário, nem para ler o relatório de atribuição pronto da tela. Isso é navegador.

## Origem do contato (domínio contacts)

### get-contact (read)
- Path `contactId`. Resposta `{ contact }`.
- Campos de origem vistos na resposta real:
  - `source`: texto de origem do contato (ex.: nome do formulário que o criou, ou valor do campo Origem).
  - `attributionSource`: **primeira** atribuição (primeira sessão registrada). Pode vir vazio ou ausente.
  - `lastAttributionSource`: **última** atribuição. Chaves vistas: `sessionSource` (ex.: `Direct traffic`), `url` (página da conversão), `utmSource`, `utmMedium`, `utmContent`, `utmTerm`, `utmKeyword`, `utmMatchtype`, `referrer`, `gclid`, `gbraid`, `wbraid`, `gaClientId`, `gaSessionId`, `medium` (ex.: `form`), `mediumId` (ID do formulário), `adName`, `adGroupId`, `adId`, `userAgent`, `ip`.
  - `createdBy.source` e `createdBy.channel`: como o contato entrou (ex.: `INTEGRATION` e `OAUTH`).
- Contato criado por integração ou importação costuma ter atribuição vazia: não houve sessão no site.

### search-contacts-advanced (read)
- POST `/contacts/search`. Corpo: `filters` (array `{ field, operator, value }`), `sort`, `pageLimit` (1 a 100; não é `limit`), `searchAfter` (cursor devolvido; nunca invente).
- Nomes de campo em camelCase.
- Testado em 03/11/2026:
  - `{ field: "source", operator: "eq", value: "<origem>" }` funciona.
  - `{ field: "source", operator: "exists" }` funciona.
  - `{ field: "dateAdded", operator: "range", value: { gte: "<ISO>", lte: "<ISO>" } }` funciona.
  - `attributionSource` e `lastAttributionSource.utmSource` **não são aceitos como filtro** (400 "Invalid field"). Para contar por UTM, é preciso ler os contatos do período e agrupar (ver `origem-dos-leads.md`) ou usar a tela de relatórios.
- Resposta: `{ contacts: [...], total }`. Cada contato traz `source`, `attributionSource`, `lastAttributionSource`, `tags`, `dateAdded` e, quando há, `opportunities: [{ id, pipelineId, pipelineStageId, status, monetaryValue }]`.
- Para contar: `pageLimit: 1` e leia `total`.
- Filtros aceitos também (conta Atlas, 03/11/2026): `{ field: "tags", operator: "eq", value: "teste-assistente" }`, `{ field: "tags", operator: "not_contains", value: "teste-assistente" }`, `{ field: "firstNameLowerCase", operator: "eq", value: "teste" }`. Use para excluir testes sem ler contatos.

### get-duplicate-contact (read)
- `email` ou `number` (exato; telefone em E.164), mandados **sem codificar** (`_comum/achar-contato.md`). Traz o contato inteiro, com `source` e, quando há, `attributionSource` e `lastAttributionSource`. `contact: null` quando não há.

### get-custom-fields (read)
- `model`: `contact`, `opportunity` ou `all`. Use para ver se já existem campos de UTM (por nome ou `fieldKey`). Resposta grande: leia uma vez.

## Envios com dados da sessão (domínios forms e surveys)

### get-forms-submissions e get-surveys-submissions (read)
- Parâmetros: `formId` ou `surveyId`, `startAt`, `endAt` (AAAA-MM-DD), `q`, `limit` (até 100), `page`. Resposta com `meta.total`.
- Em cada envio, `others.eventData` traz a sessão: `source` (ex.: `Direct traffic`), `referrer`, `adSource`, `page.url` (página onde o formulário estava), `medium`, `mediumId`, `fbp`, `fbc` (cookies do Meta), `gaClientId`, `domain`, `documentURL`.
- Bom para responder "de qual página veio este envio" e conferir se o pixel do Meta está gravando cookie (`fbp` preenchido).

## Vendas por origem (domínio opportunities)

### search-opportunity (read)
- GET `/opportunities/search`. Parâmetros: `status` (`open`, `won`, `lost`, `abandoned`, `all`), `pipelineId`, `pipelineStageId`, `assignedTo`, `contactId`, `campaignId`, `date` e `endDate` (formato `mm-dd-yyyy`), `q`, `limit` (até 100), `page`, `order`, `startAfter`, `startAfterId`.
- Resposta: `{ opportunities, meta: { total, ... }, aggregations }`.
- Campos de origem vistos em cada oportunidade:
  - `source`: origem da oportunidade (ex.: `membership`).
  - `attributions`: lista com `utmSessionSource` (ex.: `Social media`), `medium` (ex.: `instagram`), `mediumId`, e `isFirst: true` ou `isLast: true`.
  - `monetaryValue`, `status`, `lastStatusChangeAt`, `pipelineId`, `pipelineStageId`.
- **Data do filtro não documentada**: o describe descreve `date` e `endDate` só como "Start date" e "End date", sem dizer se é criação ou mudança de status. Cada item traz `createdAt` e `lastStatusChangeAt`. Para "vendas do mês", confira `lastStatusChangeAt` de cada ganha e conte só as que viraram ganha no período; diga ao cliente qual data usou. `meta.total` só serve como contagem quando a data de criação é a pedida.
- Exclua testes: nome começando em `TESTE`, tag `teste-assistente` em `contact.tags`.

### search-opportunities-advanced (read)
- POST `/opportunities/search`. Corpo: `query`, `limit`, `page` (começa em 0), `searchAfter`, `additionalDetails`. Resposta com `total`, `aggregations` e `stageAggregations`.

### get-pipelines (read)
- Sem parâmetros. Funis de venda e etapas, para traduzir IDs em nomes.

## Links com UTM (domínio links)

### create-link (write)
- Corpo: `name`, `redirectTo`. dryRun montou a requisição (não valida no servidor) com destino contendo `utm_source`, `utm_medium` e `utm_campaign`: os parâmetros passam intactos.
- Também: `get-links`, `search-trigger-links`, `update-link` (exige `name` e `redirectTo`). Detalhes na skill `atlas-sites-e-blog`.

## Anúncios (domínio ad-publishing)

Leitura. Só funcionam com a conta de anúncios **conectada ao Gerenciador de Anúncios da conta** e a sessão do Facebook ou Google válida.

### fb-get-ad-accounts (read)
- Opcionais: `type` (`INTEGRATION` ou `AD_MANAGER`), `limit`, `fetchAll`, `next`.
- Resposta: lista `{ id, name, accountStatus, currency, fundingType, integrationConnected }`.
- Na conta de teste: 1 conta de anúncios visível, `integrationConnected: false`.

### fb-get-reporting (read)
- Obrigatórios: `startDate`, `endDate` (AAAA-MM-DD), `fields` (lista: `impressions`, `clicks`, `spend`, `cpc`, `conversions`, `results`, `cpm`, `reach`, `frequency`, `ctr`, `cost_per_conversion`, `cost_per_result`), `type` (`AD_MANAGER` ou `INTEGRATION`). Opcional `groupBy` (`day`, `week`, `month`).
- Resposta `{ grouped, totals }`.
- Pegadinhas do describe: em `totals`, `cpm`, `ctr` e `frequency` são **somados**, não ponderados (recalcule: CTR = cliques / impressões; CPM = gasto / impressões x 1000). `cost_per_conversion` e `cost_per_result` sempre vêm 0. Na projeção da resposta aparecem `costPerConversion` e `costPerResultBreakdown` (custo por resultado detalhado). O describe cita também `costPerResult`, mas ele não está na projeção de `fb-get-reporting`: a conferir com conta conectada. Na dúvida, calcule gasto / resultados e diga que foi calculado.
- Na conta de teste: 422 "Ad Account not found for location". Significa conta de anúncios não conectada. Diga isso ao cliente e mande conectar pela tela.

### fb-get-reporting-list (read)
- Obrigatórios: `startDate`, `endDate`, `listType` (`campaigns`, `adsets`, `ads`), `type`. `campaignId` obrigatório para `adsets` e `ads`. `listType: none` falha com 409.
- Entidades sem dados voltam com uma linha zerada com menos campos.

### fb-get-campaign-reporting (read)
- Path `campaignId`; `startDate`, `endDate`. Só campanha publicada (com `fbCampaignId`).
- Pegadinha: `results.lead` (leads contados pelo Meta) e `leads` (contatos atribuídos no CRM) medem coisas diferentes e costumam divergir. Mostre os dois com o nome certo.

### google-get-ad-accounts (read)
- Opcionais: `type` (`INTEGRATION` padrão, `AD_MANAGER`, `EMAIL`), `email` (obrigatório se `type: EMAIL`).

### google-get-reporting (read)
- Obrigatórios: `startDate`, `endDate`, `fields` (`impressions`, `clicks`, `cost_micros`, `average_cpc`, `conversions`, `average_cpm`, `cost_per_conversion`, `ctr`), `type`. Opcional `groupBy` (`date`, `week`, `month`).
- `cost_micros` é o custo em milionésimos da moeda: divida por 1.000.000.

### google-get-reporting-list (read)
- Obrigatórios: `startDate`, `endDate`, `listType` (`campaigns`, `adGroups`, `ads`, `keywords`), `type`. `campaignId` para `adGroups`, `ads`, `keywords`.

### google-get-campaign-reporting (read)
- Path `campaignId`; `startDate`, `endDate`. Resposta com `grouped`, `leads`, `name`, `objective`, `publishingStatus`.

### fb-get-pixels (read)
- Pixels de conversão do Meta ligados à conta. Opcionais: `channel` (`FACEBOOK` padrão ou `IG`), `limit` (até 100), `after`, `projection` (`name`, `fbPixelId`, `fbPixelCode`, `fbIsCrmPixel`, `type`, `createdAt`), `pageId`, `igUserId`.
- Na conta de teste: 422 "Session invalidated. Please reconnect your Facebook account". Peça para o cliente reconectar o Facebook na tela de integrações.
- Use `projection` sem `fbPixelCode` quando só precisa do ID (resposta menor).

### Escritas de anúncio (não usar nesta skill)
- `fb-upsert-campaign` (cria ou altera campanha, com orçamento e lance) e `fb-publish-campaign` (põe no ar, assíncrono) vêm com `kind: write` no catálogo, mas **gastam dinheiro**. Trate como dinheiro: só com pedido expresso, aprovação reforçada `CONFIRMO COBRANÇA` repetindo orçamento, conta de anúncios e objetivo. Na dúvida, passe para uma pessoa da Atlas.
- `fb-upsert-pixel` cria pixel de conversão (corpo: `type` obrigatório, `LEAD_EVENT`, `FUNNEL_EVENT` ou `INSTAGRAM_DM`; `name`) ou renomeia um existente (`conversionPixelId`). Renomear é a única alteração possível. Cria coisa na conta do Meta do cliente: só com pedido expresso e aprovação simples.

## Busca, se precisar

`search_operations` com `domains: ["ad-publishing"]` e `kind: "read"`, `limit` 5 a 10 (o domínio tem dezenas de operações). Em 03/11/2026 a busca geral de leitura mostrou `scopeFilteredCount` maior que 0 em consultas amplas: alguma operação de leitura existe no catálogo e esta conexão não tem permissão. Se uma leitura de relatório não aparecer, registre como "sem permissão nesta conexão" e use a tela.
