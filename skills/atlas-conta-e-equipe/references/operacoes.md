# Operações do MCP: conta, equipe e marca

Conferidas com `describe_operation` em 03/11/2026. Leituras executadas de verdade na conta de teste da Atlas; escritas só com `dryRun: true` (nenhum usuário criado, nenhum número comprado). Passe sempre `locationId`.

## Leitura (faz direto)

### get-location
- GET `/locations/{locationId}`.
- Resposta (conta Atlas): `location: { id, companyId, name, address, city, state, country, postalCode, website, timezone, locale, email, phone, logoUrl, currency, domain, business: { name, address, city, state, country, postalCode, website, timezone, logoUrl, email }, social: { facebookUrl, instagram, ... }, settings: { allowDuplicateContact, allowDuplicateOpportunity, contactUniqueIdentifiers, ... }, permissions: { ...Enabled } }`.
- Visto: `currency: "BRL"`, `timezone: "America/Sao_Paulo"`, `locale: "pt_BR"`.
- `settings` tem dados de assinatura do plano: não mostre ao cliente.
- Não há operação de **escrita** dos dados da conta nesta conexão (busca em 03/11/2026 com `scopeFilteredCount` 31: pode existir com outra permissão). Mudar dados: tela.

### get-timezones
- GET `/locations/{locationId}/timezones`. Lista de fusos aceitos. Vista na busca.

### get-user
- GET `/users/{userId}`.
- Resposta: `{ id, name, firstName, lastName, email, phone, deleted, roles: { type, role: admin|user, locationIds, ... }, permissions: { contactsEnabled, opportunitiesEnabled, assignedDataOnly, settingsEnabled, paymentsEnabled, ... }, scopes: [...], scopesAssignedToOnly: [...], platformLanguage }`.
- Testado com o usuário dono da conta Atlas.

### search-users
- GET `/users/search`. Obrigatório: `companyId` (de `get-location` > `location.companyId`). Filtros: `query` (nome, e-mail ou telefone), `role`, `type`, `ids`, `limit` (padrão 25), `skip`, `sort`, `sortDirection`.
- Resposta: `{ users: [{ id, name, email, roles: { type, role, locationIds }, permissions, ... }], count }`.
- `companyId` é a empresa inteira: **não existe filtro por conta**. Busca sem `query` pode trazer pessoas de outras contas. Nunca rode sem `query`.

## Achar um usuário desta conta (receita segura)

Testada em 03/11/2026 na conta Atlas com o e-mail do dono: 1 resultado, com o `locationId` da conta em `roles.locationIds`.

1. Peça o e-mail de login da pessoa.
2. `get-location` > `location.companyId`.
3. `search-users` com `companyId`, `query` = o e-mail exato, `limit: "2"`.
4. Use só se vier um usuário com o mesmo e-mail **e** com o `locationId` da conta em `roles.locationIds`. Senão, diga que não achou nesta conta.
5. Sem e-mail, outro caminho seguro: o `assignedTo` de contatos e negócios desta conta é o `userId` de quem cuida deles; leia com `get-user` e confira `roles.locationIds`.
6. Lista completa da equipe: tela Configurações > Usuários (`settings/users`). Pelo conector não dá sem risco de ver outras contas.

O mesmo vale para achar o `userId` de quem envia fatura, orçamento ou contrato (skill `atlas-cobrancas-e-contratos`).

### active-numbers
- GET `/phone-system/numbers/location/{locationId}`. Parâmetros: `page` (padrão 0), `pageSize` (padrão 50, máximo 1000), `searchFilter`, `skipNumberPool`, `includeRcsSenderIds`.
- Resposta: `{ status, data: { numbers: [...], total }, message, statusCode }`.
- Teste na conta Atlas: 0 números. WhatsApp conectado por integração não aparece aqui.

### listAvailableNumbersForACountry
- GET `/phone-system/numbers/location/{locationId}/available`. Busca números à venda. Segundo o describe, **todos** os parâmetros são obrigatórios: `anywhere`, `countryCode`, `firstPart`, `lastPart`, `mmsEnabled`, `numberTypes`, `smsEnabled`, `voiceEnabled`. Só leitura, mas leva à compra: prefira a tela Sistema telefônico (`settings/phone_system`).

### list-design-kits e get-design-kit
- `list-design-kits`: GET `/brand-boards/locations/{locationId}/design-kits`. `limit`, `offset`, `search`, `deleted`. Resposta `{ items: [{ id, name, isDefault }], total }`. Teste: 1 kit, padrão.
- `get-design-kit`: GET `.../design-kits/{designKitId}`. Resposta: `logos: [{ id, url, label }]`, `colors: [{ id, label, hex, hexa, rgb, rgba }]`, `fonts: [{ id, font, fallback, label }]`. Teste: 2 logos, 9 cores, 1 fonte.

### list-brand-voices
- GET `/brand-boards/locations/{locationId}/brand-voices`. `limit`, `offset`, `search`, `deleted`. Resposta `{ items: [{ id, name, isDefault }], total }`. Teste: 1 tom de voz, padrão. A lista **não traz** as respostas.

### get-brand-voice
- GET `/brand-boards/locations/{locationId}/brand-voices/{brandVoiceId}`. Resposta `{ id, name, isDefault, answers: { ... } }`. Use sempre antes de `update-brand-voice`.

## Escrita (dryRun, aprovação)

Todas: kind `write`, `requiresApproval: true`, `idempotencyKey` obrigatório.

### update-design-kit
- PATCH `/brand-boards/locations/{locationId}/design-kits/{designKitId}`. Campos: `name`, `logos: [{ id?, url, label }]`, `colors: [{ id?, value, label }]`, `fonts: [{ id?, font, fallback, label }]`.
- Pegadinha do describe: mandar `colors`, `fonts` ou `logos` **substitui a lista inteira**. Para manter, mande o item com `id`.
- Pegadinha da resposta: a leitura devolve a cor em `hex`; a escrita pede `value`. Ao manter uma cor, copie `hex` para `value`.
- Mande só a lista que muda (ex.: só `fonts`); as outras ficam como estão.
- Usado com sucesso pela Atlas em 05/10/2026 (`docs/navegacao-crm/mcp-atlas-crm.md`).

### create-design-kit
- POST `.../design-kits`. Campos: `name`, `logos`, `colors`, `fonts`, `type` (`blank` ou `url`), `url` (site de onde puxar a marca, quando `type: url`).

### set-default-design-kit
- POST `.../design-kits/{designKitId}/default`. Sem corpo. O padrão anterior deixa de ser padrão. Vista na busca.

### update-brand-voice
- PATCH `/brand-boards/locations/{locationId}/brand-voices/{brandVoiceId}`. Campos: `name`, `answers: { brandName, toneOfVoice, targetAudience, customerPainPoints, businessType, companyWebsite, companyEmail, companyAddress, phone, businessHours, brandPromise, brandValues, brandPurpose, competitiveAdvantage, risksOfInaction, uniqueSellingProposition, callToAction }`.
- Não está confirmado se o servidor mescla ou substitui `answers`. Por segurança: leia com `get-brand-voice`, mande **todas** as respostas atuais com só as pedidas trocadas.
- `create-brand-voice`: `type` obrigatório (`manual`, `url`, `description`); no modo manual, `answers.brandName`, `toneOfVoice`, `targetAudience` e `customerPainPoints` são obrigatórios (conferido pelo testador em 03/11/2026).
- `set-default-brand-voice`: POST `.../brand-voices/{brandVoiceId}/default`, sem corpo.

### update-user (nível acesso: CONFIRMO ACESSO)
- PUT `/users/{userId}`. Campos: `firstName`, `lastName`, `phone`, `role` (`admin` ou `user`), `type`, `locationIds`, `permissions` (objeto com chaves `...Enabled`, `assignedDataOnly`, ...), `scopes`, `scopesAssignedToOnly`, `platformLanguage` (`pt_BR`), `profilePhoto`, `twilioPhone`, `password`.
- **Como mandar `permissions`**: cada chave tem `default` no describe. Leia o usuário com `get-user`, copie o objeto `permissions` inteiro, troque só a chave pedida e mande o objeto completo. Nunca mande só `{ assignedDataOnly: true }`.
- O describe lista `parameterNames` vazio, mas o caminho tem `{userId}`: passe `userId` em `path` (o dryRun montou certo).
- Pegadinhas do describe:
  - `email` não pode mais ser trocado.
  - `scopes` ou `scopesAssignedToOnly` vazios **desligam todos**.
  - `twilioPhone` enviado substitui o mapa inteiro.
  - `locationIds` é a lista completa de contas do usuário.
- Nunca envie `password`.

### create-user (não usar)
- POST `/users/`. Exige `password` no corpo, além de `companyId`, `email`, `type`, `role`, `locationIds`, `firstName`, `lastName`. Como a senha não pode passar pela conversa, crie pela tela.

## Exclusão

### delete-user
- DELETE `/users/{userId}`. kind `delete`, `destructiveHint: true`. Resposta `{ succeeded, message }`.
- **Apaga o usuário inteiro, de todas as contas em que ele está**, não só desta. Antes, `get-user`: se `roles.locationIds` tiver qualquer outra conta, ou `roles.type` não for de conta, **não use**; tire o acesso pela tela `settings/users`, de preferência desativando.
- Só quando a pessoa existe apenas nesta conta e o dono pede a exclusão (não a desativação): `CONFIRMO ACESSO`, depois de decidir para quem passam os contatos e negócios dela (tela ou skill `atlas-contatos`).

## Dinheiro: nunca pelo conector

### purchase-number-for-location
- POST `/phone-system/numbers/location/{locationId}/purchase`. Exige identificadores de pagamento e de cadastro (pagamento, conta de cobrança, endereço, pacote regulatório). O assistente não tem e não deve pedir esses dados. Compra de número: tela, o cliente clica.
