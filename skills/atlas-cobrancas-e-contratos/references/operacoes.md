# Operações do MCP: cobranças, produtos e contratos

Conferidas com `describe_operation` em 03/11/2026. Leituras executadas de verdade na conta de teste da Atlas; escritas só com `dryRun: true`. Passe sempre `locationId` no `execute_operation`.

Quase todas as operações de fatura, orçamento, cupom e pagamento pedem `altType: "location"` e `altId` = o `locationId` da conta (no corpo ou na query, conforme a operação).

O `dryRun` mostra a chamada montada, mas **não valida** dados nem permissão (`authorizationVerified: false`). Campo desconhecido ou obrigatório faltando passa no dryRun e só falha na execução real. Use só campos que aparecem no describe.

## Como achar o userId (quem envia)

`send-invoice`, `text2pay-invoice`, `send-estimate` e `send-documents-contracts-template` exigem `userId`. Não há operação que devolva "o usuário conectado" (busca em 03/11/2026). Caminho seguro, testado na conta Atlas:

1. Pergunte ao cliente: "Em nome de quem a fatura sai? Me passa o e-mail de login dessa pessoa na Atlas." (Normalmente é ele mesmo.)
2. `get-location` > `location.companyId`.
3. `search-users` com `companyId`, `query` = esse e-mail exato e `limit: "2"`.
4. Aceite só se vier **um** usuário com esse e-mail e com o `locationId` da conta em `roles.locationIds`. Qualquer outro resultado: não use, diga que não achou e peça para conferir o e-mail.
5. Guarde o `id` na conversa e não mostre os outros campos.

Nunca rode `search-users` sem `query`: a busca é da empresa inteira e pode trazer pessoas de outras contas. Se a busca der 401 ou 403, peça para o cliente abrir Configurações > Usuários (`settings/users`) e copiar o nome; envio pela tela é o plano B.

## Leitura (faz direto)

### products.list-invoices (lista produtos)
- O nome engana: é **List Products**. GET `/products/`.
- Parâmetros: `limit`, `offset`, `search` (nome), `productIds`, `collectionIds`, `availableInStore`, `includedInStore`, `storeId`, `expand`, `sortOrder`.
- Resposta: `{ products: [{ _id, name, description (HTML), productType, image, availableInStore, status, slug, hasPrices, ... }], total: [{ total }] }`.
- Teste na conta Atlas: 7 produtos. Atenção: `hasPrices` veio `false` mesmo em produto com preço cadastrado. Para saber o preço, sempre chame `list-prices-for-product`.

### get-product-by-id
- GET `/products/{productId}`. Vista na busca e usada como leitura simples.

### list-prices-for-product
- GET `/products/{productId}/price`. Parâmetros: `productId`, `limit`, `offset`, `ids`.
- Resposta: `{ prices: [{ _id, name, type: one_time|recurring, currency, amount, recurring: { interval, intervalCount }, trialPeriod, setupFee, ... }], total }`.
- Teste: preço mensal com `currency: "BRL"` e `amount: 50`, que é R$ 50,00 (valor cheio, não centavos).

### invoices.list-invoices
- GET `/invoices/`. Obrigatórios: `altType`, `limit`, `offset` (texto). Filtros: `contactId`, `status`, `search` (id, nome, e-mail, telefone), `startAt` e `endAt` (AAAA-MM-DD), `paymentMode` (`live`, `test`), `sortField: issueDate`, `sortOrder`.
- Resposta: `{ invoices: [{ _id, name, invoiceNumber, status, total, amountDue, amountPaid, currency, issueDate, dueDate, contactDetails, liveMode, ... }], total }`.
- Teste: 0 faturas na conta Atlas.

### list-invoice-templates
- GET `/invoices/template`. Obrigatórios: `altType`, `limit`, `offset`. Resposta `{ data: [{ _id, name, items, currency, total, ... }], totalCount }`.

### list-invoice-schedules
- Faturas recorrentes. GET `/invoices/schedule`. Parâmetros como `list-invoices` (`limit`, `offset`, `status`, `search`, `startAt`, `endAt`). Vista na busca.

### list-estimates e list-estimate-templates
- `list-estimates`: GET `/invoices/estimate/list`. Obrigatórios: `altType`, `limit`, `offset`. Filtros: `contactId`, `status` (`all`, `draft`, `sent`, `accepted`, `declined`, `invoiced`, `viewed`), `search`, `startAt`, `endAt`.
- `list-estimate-templates`: GET `/invoices/estimate/template`. Obrigatórios: `altType`, `limit`, `offset`. Filtro: `search`.

### list-coupons
- GET `/payments/coupon/list`. Obrigatório: `altType`. Filtros: `limit` (padrão 100), `offset`, `search` (nome ou código), `status` (`scheduled`, `active`, `expired`).
- Resposta: `{ data: [{ _id, name, code, discountType, discountValue, startDate, endDate, usageCount, status, ... }], totalCount }`.

### list-transactions (vendas recebidas)
- GET `/payments/transactions`. Obrigatório: `altType`. Filtros: `startAt` e `endAt` (AAAA-MM-DD), `contactId`, `subscriptionId`, `entityId`, `entitySourceType` (ex.: `funnel`), `entitySourceSubType`, `paymentMode` (`live`), `search`, `limit` (padrão 10), `offset`.
- Resposta: `{ data: [{ _id, amount, currency, status, liveMode, contactId, contactName, entityType, entitySourceType, entitySourceName, subscriptionId, amountRefunded, createdAt, fulfilledAt, chargeSnapshot, ... }], totalCount }`.
- Teste na conta Atlas: `totalCount` 19; item com `amount: 400`, `currency: "brl"` (minúsculo), `status: "succeeded"`. Dentro de `chargeSnapshot` o mesmo valor aparece como `40000` (centavos do processador). **Use só `amount`.**
- Resposta muito grande (traz o retrato inteiro da cobrança). Use `limit` pequeno e período. Ela traz e-mail e nome do pagante: não repita sem o cliente pedir.

### list-orders
- GET `/payments/orders`. Filtros: `startAt`, `endAt`, `contactId`, `paymentStatus` (`paid`, `unpaid`, `refunded`, `partially_paid`), `status`, `paymentMode`, `search`, `funnelProductIds`, `sourceId`, `limit` (padrão 10), `offset`.
- Resposta: `{ data: [{ _id, amount, subtotal, discount, currency, status, contactName, sourceName, sourceType, couponCode, createdAt, ... }], totalCount }`.

### list-subscriptions
- GET `/payments/subscriptions`. Obrigatório: `altType`. Filtros: `contactId`, `id`, `entityId`, `entitySourceType`, `paymentMode`, `search`, `startAt`, `endAt`, `limit`, `offset`, `getPaymentsCollectedCount`.
- Resposta: `{ data: [{ _id, amount, currency, status, contactName, entitySourceName, subscriptionId, ... }], totalCount }`.
- Não há filtro por status: para "ativas", leia e filtre `status: active` na conversa (teste: 9 no total, 3 ativas).

### list-documents-contracts-templates
- Modelos de documento e contrato. GET `/proposals/templates`. Filtros: `name`, `type` (`proposal`, `estimate`, `contentLibrary`, separados por vírgula), `limit`, `skip`, `dateFrom`, `dateTo`.
- Resposta: `{ data: [{ _id, id, name, type, documentCount, docFormUrl, updatedAt }], total }`.
- Teste: 0 modelos na conta Atlas.

### list-documents-contracts
- Documentos enviados. GET `/proposals/document`. Filtros: `status` (`draft`, `sent`, `viewed`, `completed`, `accepted`, separados por vírgula), `paymentStatus` (`waiting_for_payment`, `paid`, `no_payment`), `query`, `limit`, `skip`, `dateFrom` e `dateTo` (ISO, os dois juntos).
- Resposta: `{ documents: [{ _id, name, status, paymentStatus, grandTotal, recipients, links, isExpired, ... }], total }`.

### get-location (dados da empresa e moeda)
- GET `/locations/{locationId}`. Use `location.currency` (na Atlas: `BRL`), `location.timezone` e `location.business` (nome, endereço, site, e-mail, logo) para montar `businessDetails` da fatura.

## Escrita (dryRun, aprovação)

Todas: kind `write`, `requiresApproval: true`, `idempotencyKey` obrigatório.

### create-product e update-product-by-id
- POST `/products/`. Obrigatórios: `name`, `productType` (`DIGITAL`, `PHYSICAL`, `SERVICE`, `PHYSICAL/DIGITAL`).
- Opcionais: `description`, `image`, `availableInStore`, `medias`, `variants`, `collectionIds`, `isTaxesEnabled` com `taxes`, `slug`, `seo`, `taxInclusive`, `statementDescriptor`.
- `update-product-by-id` (PUT `/products/{productId}`): `name` e `productType` também são obrigatórios. Leia o produto antes e mande os dois.
- O preço é outra chamada.

### create-price-for-product e update-price-by-id-for-product
- POST `/products/{productId}/price`. Obrigatórios: `name`, `type` (`one_time`, `recurring`), `currency` (use `BRL`), `amount` (valor cheio, mínimo 0).
- Recorrente: `recurring: { interval: day|week|month|year, intervalCount }`, `trialPeriod`, `totalCycles`, `setupFee`.
- Outros: `compareAtPrice`, `sku`, `trackInventory`, `availableQuantity`, `membershipOffers`.
- `update-price-by-id-for-product`: PUT `/products/{productId}/price/{priceId}`. Obrigatórios no corpo: `name`, `type`, `currency`, `amount`. É substituição: leia o preço com `list-prices-for-product` e mande todos os campos.

### create-invoice (rascunho)
- POST `/invoices/`. Obrigatórios: `altId`, `altType`, `name`, `businessDetails`, `currency`, `items` (cada um: `name`, `currency`, `amount`, `qty`; opcionais `productId`, `priceId`, `type`, `taxes`), `discount` (`type`: `percentage` ou `fixed`, `value`), `contactDetails` (`id`, `name`, `phoneNo`, `email`), `issueDate` (AAAA-MM-DD), `sentTo` (`email` obrigatório; `phoneNo` opcional), `liveMode`.
- Opcionais: `dueDate`, `title`, `termsNotes` (HTML), `invoiceNumber`, `invoiceNumberPrefix`, `paymentSchedule` (parcelas), `lateFeesConfiguration`, `tipsConfiguration`, `attachments`, `paymentMethods`.
- Resposta: fatura com `_id`, `status`, `total`, `amountDue`, `invoiceNumber`.
- dryRun montou a requisição (não valida no servidor) em 03/11/2026 com `currency: BRL`, item de 800, `liveMode: false`.
- Criar não envia. O envio é `send-invoice`.

### send-invoice
- POST `/invoices/{invoiceId}/send`. Obrigatórios: `altId`, `altType`, `userId` (usuário da conta que envia; ver "Como achar o userId" acima), `action` (`email`, `sms`, `sms_and_email`, `send_manually`), `liveMode`.
- Opcionais: `sentFrom` (`fromName`, `fromEmail`), `autoPayment` (cobrança automática com cartão salvo: nunca ligue sem pedido expresso).
- Manda mensagem ao cliente final e cobra: `CONFIRMO COBRANÇA`.

### text2pay-invoice (criar e enviar, link de pagamento)
- POST `/invoices/text2pay`. Mesmos campos de `create-invoice`, mais: `action` (`draft` ou `send`, obrigatório), `userId` (obrigatório), `id` (para atualizar uma existente), `includeTermsNote`. `businessDetails` e `discount` ficam opcionais aqui.
- Resposta: `{ invoice, invoiceUrl }`. O `invoiceUrl` é o **link de pagamento** que o cliente pode mandar por onde quiser.
- Para só gerar o link sem enviar: `action: draft`. Mesmo assim, é dinheiro: `CONFIRMO COBRANÇA` antes de entregar o link ao cliente final.

### create-invoice-schedule e schedule-invoice-schedule (recorrente)
- `create-invoice-schedule`: POST `/invoices/schedule`. Obrigatórios: `altId`, `altType`, `name`, `contactDetails`, `schedule` (`executeAt` ou `rrule: { intervalType: monthly|weekly|daily|yearly..., interval, startDate, startTime, endDate, count, dayOfMonth, dayOfWeek, ... }`), `liveMode`, `businessDetails`, `currency`, `items`, `discount`.
- Criar não começa a enviar. `schedule-invoice-schedule` (POST `/invoices/schedule/{scheduleId}/schedule`, corpo `altId`, `altType`, `liveMode`, `autoPayment` opcional) é que liga o envio.
- `cancel-invoice-schedule` (POST `.../cancel`, corpo `altId`, `altType`): para a recorrência.

### record-invoice (dar baixa manual)
- POST `/invoices/{invoiceId}/record-payment`. Obrigatórios: `altId`, `altType`, `mode` (`cash`, `card`, `cheque`, `bank_transfer`, `other`), `notes`. O describe marca `card` (`brand`, `last4`) e `cheque` (`number`) como obrigatórios; use só o objeto do modo escolhido e confira no dryRun.
- Opcionais: `amount` (parcial), `paymentScheduleIds`, `fulfilledAt`.
- Nunca peça o número completo do cartão. Bandeira e 4 últimos dígitos só se o cliente disser.

### void-invoice (anular)
- POST `/invoices/{invoiceId}/void`. Corpo: `altId`, `altType`. A descrição do conector diz "delete invoice": trate como irreversível. Palavra de confirmação: **`CONFIRMO EXCLUSÃO`** (a mesma do SKILL.md), repetindo número, valor e cliente da fatura.

### create-new-estimate e send-estimate (orçamento)
- `create-new-estimate`: POST `/invoices/estimate`. Obrigatórios: `altId`, `altType`, `name`, `businessDetails`, `currency`, `items`, `discount`, `contactDetails`, `frequencySettings` (`{ enabled: false, schedule: {} }` para orçamento único).
- Opcionais: `issueDate`, `expiryDate`, `estimateNumber`, `termsNotes`, `sentTo`, `autoInvoice` (vira fatura quando aceito), `paymentScheduleConfig`, `sendEstimateDetails` (envia ao salvar: não use; envie separado).
- Pegadinha: `liveMode` padrão **true**. Diga isso ao cliente.
- `send-estimate`: POST `/invoices/estimate/{estimateId}/send`. Obrigatórios: `altId`, `altType`, `action`, `liveMode`, `userId`. `CONFIRMO COBRANÇA`.

### create-coupon e update-coupon
- POST `/payments/coupon`. Obrigatórios: `altId`, `altType`, `name`, `code`, `discountType` (`percentage` ou `amount`), `discountValue`, `startDate` (ISO).
- Opcionais: `endDate`, `usageLimit`, `productIds`, `priceIds`, `applyToFuturePayments` (padrão `true`: vale também nas próximas cobranças de assinatura), `applyToFuturePaymentsConfig`, `limitPerCustomer`.
- `update-coupon`: PUT `/payments/coupon`, mesmos obrigatórios mais `id`. Leia o cupom e mande todos os campos.
- Pegadinha: `applyToFuturePayments` ligado por padrão. Pergunte se o desconto é só na primeira cobrança.

### send-documents-contracts-template (contrato para assinar)
- POST `/proposals/templates/send`. Obrigatórios: `templateId`, `userId`, `contactId`. Opcionais: `sendDocument` (`true` envia ao contato), `opportunityId`.
- Resposta: `{ success, links: [{ documentId, recipientId, referenceId, ... }] }`.
- Envia para pessoa real: `CONFIRMO ENVIO`; se o contrato tem cobrança, `CONFIRMO COBRANÇA`.

### create-shipping-zone
- Zona de frete da loja. POST `/store/shipping-zone`. Obrigatórios: `altId`, `altType`, `name`, `countries`. O describe tem esquema inválido e não gera exemplo: prefira a tela Pagamentos > Configurações > Envio e entrega.

### create-store-setting
- Configurações da loja (origem do frete, e-mails de pedido). POST `/store/store-setting`. O describe avisa que o esquema do campo de estado tem itens repetidos e não gera exemplo. Prefira a tela.

## Exclusão

- `delete-coupon`: DELETE `/payments/coupon`, corpo `altId`, `altType`, `id`. kind `delete`, irreversível. Só com pedido expresso e `CONFIRMO EXCLUSÃO`.

## Nunca pelo assistente

- Reembolso e cobrança automática com cartão salvo (`autoPayment`): o cliente faz na tela.

## O que o MCP não faz (navegador)

- Conectar ou trocar meio de pagamento, impostos, recibos.
- Criar e editar o modelo de contrato ou documento (o editor é tela).
- Link de pagamento da tela Pagamentos (o equivalente pelo MCP é o `invoiceUrl` do `text2pay-invoice`).
- Reembolso.
