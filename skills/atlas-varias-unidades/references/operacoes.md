# Operações para várias unidades (verificadas)

Conferidas com `search_operations` e `describe_operation` em 03/11/2026. Leituras executadas só na conta de teste da Atlas; escritas só com `dryRun: true`. "dryRun montado" quer dizer que a requisição foi montada: o dryRun não valida o corpo (`authorizationVerified: false`).

Regra de ouro: **toda chamada leva o `locationId` da conta em que age.** Ids de campo, tag, calendário, usuário, base de conhecimento e produto são de uma conta só.

Legenda: **L** leitura, **S** aprovação simples, **R** aprovação reforçada. Escrita exige `idempotencyKey`.

## Contas

| Ferramenta ou operação | O que faz | Notas |
| --- | --- | --- |
| `list_locations` | Lista as contas que o login alcança: `items[]` com `locationId`, `name` (às vezes `address`). Testada com `query: "Atlas"` (4 contas) | Com `query` filtra por nome. Muitas contas e nenhum nome dito: pergunte qual, não pagine tudo. Nunca leia uma conta só porque ela apareceu na lista |
| `get-location` | Dados da conta: `timezone`, `currency` | L. Uma vez por conta comparada. Fusos diferentes: cada conta usa o seu |

## Comparar (as mesmas da skill atlas-relatorios-e-dashboards)

| operationId | Para quê | Notas |
| --- | --- | --- |
| `search-contacts-advanced` | Leads novos e por origem | L. Corpo com `pageLimit` (não `limit`), `filters`; contagem pelo `total` com `pageLimit: 1` |
| `get-pipelines` | Funis e etapas de cada conta | L. Os nomes e ids mudam por conta: escolha o funil de vendas em cada uma |
| `search-opportunity` | Abertos, criados, ganhos, perdidos, valor | L. `pipelineId` da conta, `status`, `date` e `endDate` (mm-dd-aaaa), `limit` até 100; total em `meta.total` |
| `get-calendars` | Agendas da conta | L |
| `get-calendar-events` | Agendamentos e faltas | L. Obrigatórios `startTime` e `endTime` (milissegundos) e um de `calendarId`, `userId` ou `groupId` |

Receitas de cada número: `atlas-relatorios-e-dashboards`, `references/calculos.md`. Não copie as receitas para cá.

## Copiar configuração: leitura na origem e no destino

| operationId | O que traz | Notas |
| --- | --- | --- |
| `get-custom-fields` | Campos de contato e oportunidade: `name`, `dataType`, `model`, `fieldKey`, `picklistOptions`, `placeholder`, `position` | L. Testada em outras skills. `model`: `contact`, `opportunity` ou `all` |
| `get-custom-values` | Valores personalizados: `name`, `value`, `fieldKey` | L |
| `get-location-tags` | Tags: `id`, `name` | L. Testada: a conta Atlas tem "disparo reativacao" e "disparo reativação"; compare sem acento |
| `get-calendars` | Configuração completa de cada agenda (`calendarType`, `teamMembers`, `slotDuration`, `formId`, `slug` e outros) | L |
| `list-email-templates` | Modelos: `id`, `name`, `editorType`, `isPlainText` | L. Testada: `limit` máximo 20, `include: "templates"`, `total` (14 na conta Atlas) |
| `get-email-template` | Um modelo: `subject`, `fromName`, `fromEmail`, `previewText`, `editorType`, `editorContentUrl` | L. Testada. **O conteúdo não vem na resposta**: vem um link de arquivo (`editorContentUrl`). Não mostre esse link ao cliente |
| `listAllKnowledgeBasesPaginated` | Bases de conhecimento | L. Testada: resposta em `data.knowledgeBases[]` (`id`, `name`), `activeCount`, `hasMore` |
| `list` (domínio knowledge-base) | Perguntas e respostas de uma base | L. Obrigatório `knowledgeBaseId`; `limit` (padrão 10), `lastFaqId`, `search`. Itens `question`, `answer`; `hasMore` |
| `products.list-invoices` | Lista **produtos** (o nome engana) | L. Testada: `limit`, `search`; total vem como lista `[{"total": 7}]` |
| `list-prices-for-product` | Preços de um produto | L. Obrigatório `productId` (path) |

## Copiar configuração: criação no destino

| operationId | Obrigatórios | Campos que importam | Aprovação |
| --- | --- | --- | --- |
| `locations.create-custom-field` | `name`, `dataType` | `model`, `placeholder`, `position`, `acceptedFormat`, `textBoxListOptions`. **Sem campo de opções**: campo de lista vai pelo navegador (regra da `atlas-campos-e-dados`). dryRun montado | S por conta; R se mais de uma conta |
| `create-custom-value` | `name`, `value` | só esses dois. Valor com endereço, telefone ou link da unidade A quase nunca serve em B: pergunte o valor de B | S; R se mais de uma conta |
| `create-tag` | `name` | só `name`. dryRun montado | S; R se mais de uma conta |
| `create-calendar` | `name` | `calendarType`, `teamMembers[]` (`userId` **da conta B**), `slotDuration`, `slotInterval`, `slotBuffer`, `allowBookingAfter`, `allowBookingFor`, `autoConfirm`, `formId` (só um formulário de B), `slug`, `isActive`. Agenda pessoal precisa de exatamente um membro; rodízio, coletiva, classe e serviço precisam de membros | S; R se mais de uma conta |
| `create-email-template` | `name`, `editorType` (`html` ou `text`) | `editorContent`, `subjectLine`, `fromName`, `fromEmail`, `previewText`. dryRun montado | S; R se mais de uma conta |
| `createKnowledgeBase` | `name` | `description`. Máximo 15 bases por conta (describe) | S |
| `create` (domínio knowledge-base) | `question`, `answer`, `knowledgeBaseId` (da conta B) | dryRun montado (o servidor acrescenta o `locationId`) | S por lote de uma conta; R acima de 20 perguntas |
| `create-product` | `name`, `productType` (`DIGITAL`, `PHYSICAL`, `SERVICE`, `PHYSICAL/DIGITAL`) | `description`, `image`, `availableInStore`, `slug`. Não cobra ninguém | S; R se mais de uma conta |
| `create-price-for-product` | `productId` (o novo, de B), `name`, `type` (`one_time` ou `recurring`), `currency`, `amount` | `recurring` (`interval`, `intervalCount`), `trialPeriod`, `setupFee`. Mostre valor e moeda na aprovação | S; R se mais de uma conta |

## Regra de tag nas contas (contatos de cada conta)

| operationId | O que faz | Notas |
| --- | --- | --- |
| `search-contacts-advanced` | Conta e lista quem entra na regra, em cada conta | L |
| `add-tags` | Tag em um contato | S. `contactId` (path), `tags` |
| `contacts.create-association` | **Tags em massa** (o nome engana) | Path `type`: `add` ou `remove`; corpo `contacts` (ids da mesma conta), `tags`. dryRun montado: o servidor põe o `locationId` da chamada no corpo. R `CONFIRMO MASSA` acima de 20 contatos ou em mais de uma conta. Antes, veja em cada conta se a tag inicia automação que envia mensagem (regra 10 do SKILL.md) |

## Contatos (só com pedido expresso)

| operationId | O que faz | Notas |
| --- | --- | --- |
| `search-contacts-advanced` | Lê os contatos escolhidos na conta A | L. Só os campos necessários; nada vai para arquivo |
| `upsert-contact` | Cria ou atualiza o contato na conta B | Segue a regra de duplicidade de B. Identidade: `email` ou `phone`. **`tags` substitui todas as tags** do contato encontrado: não mande `tags` no upsert; aplique depois com `add-tags`. `customFields` precisa dos ids de B. R `CONFIRMO MASSA` sempre, com aviso de LGPD |

## O que não existe ou está fechado nesta conexão

| Item | Situação em 03/11/2026 | Plano B |
| --- | --- | --- |
| Criar funil e etapas | `search_operations` (opportunities, write) respondeu `scopeFilteredCount: 2`: existe no catálogo, esta conexão não tem permissão | Navegador (`telas.md`) |
| Criar, alterar ou publicar automação | Busca em workflows (write) voltou vazia com `zeroResultReason: scope_filtered` (4 filtradas). Leitura `get-workflow` existe | Navegador |
| Criar ou clonar página, funil de páginas, site | Domínio funnels só tem leituras (`getFunnels`, `getPagesByFunnelId`) e redirecionamentos | Navegador |
| Criar formulário ou pesquisa | Domínio forms só tem `get-forms` e `get-forms-submissions` | Navegador |
| Painéis | Nenhuma operação de painel no catálogo | Navegador |
| Copiar modelo de e-mail do construtor visual | `create-email-template` só aceita `html` ou `text`, e a leitura não traz o conteúdo | Navegador |
