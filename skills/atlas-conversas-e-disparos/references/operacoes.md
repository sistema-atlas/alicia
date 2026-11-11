# Operações do MCP: conversas e disparos

Todas vistas em `search_operations` e conferidas com `describe_operation` em 03/11/2026. Leituras executadas de verdade na conta de teste da Atlas; escritas só com `dryRun: true`. O dryRun só monta a requisição: não valida corpo, IDs nem permissão (`authorizationVerified: false`).

Links: `profilePhoto`, URLs de anexo e mídia podem vir com domínio técnico do fornecedor. Nunca mostre ao cliente; entregue o link da tela no domínio da conta. Passe sempre `locationId` no `execute_operation`.

Resumo: o MCP lê conversas e mensagens, envia uma mensagem por vez (com agendamento), cancela agendamento, marca como lida e lista modelos salvos. **Não existe operação** para criar template de WhatsApp oficial, ver status de aprovação na Meta, criar snippet, nem para disparo em massa.

## Leitura (faz direto)

### search-conversation
- Busca conversas. GET `/conversations/search`. kind: read.
- Parâmetros úteis: `contactId`, `query` (texto livre), `status` (`all`, `read`, `unread`, `starred`, `recents`), `lastMessageDirection` (`inbound`, `outbound`), `lastMessageType` (ex.: `TYPE_WHATSAPP`, `TYPE_SMS`, `TYPE_EMAIL`, `TYPE_INSTAGRAM`, `TYPE_FACEBOOK`, `TYPE_CUSTOM_SMS`), `assignedTo` (IDs de usuário ou `unassigned`), `sortBy` (`last_message_date`, `last_manual_message_date`), `sort` (`asc`, `desc`), `limit` (padrão 20), `startAfterDate` (valor de `sort` do último item, para paginar).
- Resposta: `{ conversations: [...], total }`. Cada item traz `id`, `contactId`, `contactName`, `phone`, `email`, `lastMessageBody`, `lastMessageType`, `lastMessageDirection`, `lastMessageDate` (milissegundos), `unreadCount`, `assignedTo`, `tags`, `lastChannelAccount`, `lastMessageConversationProviderId`.
- **Sem resposta** = última mensagem `inbound` (lida ou não): `lastMessageDirection: inbound`. **Não lidas** = `status: unread`. Não misture os dois sem dizer.
- Para só contar, `limit: 1` e leia `total`. O `total` é de todo o histórico: **não há filtro de data**. Para "hoje" ou "esta semana", use `sortBy: last_message_date`, `sort: desc`, leia em páginas pequenas e pare no primeiro `lastMessageDate` (milissegundos, UTC) anterior ao começo do período em horário de Brasília. Ou conte mensagens recebidas com `export-messages-by-location` e `startDate`.
- Na conta de teste, a busca por não lidas e recebidas voltou `total` 36 (histórico inteiro).
- Conta com WhatsApp pela integração de WhatsApp da Atlas: a conversa aparece com `type: TYPE_PHONE` e `lastMessageType: TYPE_CUSTOM_SMS`, não `TYPE_WHATSAPP`. Não filtre só por `TYPE_WHATSAPP` nessas contas.

### get-conversation
- Detalhe de uma conversa. GET `/conversations/{conversationId}`. Parâmetro obrigatório: `conversationId`.
- Resposta: `id`, `contactId`, `assignedTo`, `inbox`, `starred`, `type`, `unreadCount`, `deleted`.

### get-messages
- Mensagens de uma conversa. GET `/conversations/{conversationId}/messages`.
- Parâmetros: `conversationId` (obrigatório), `limit` (padrão 20), `lastMessageId` (paginar), `type` (lista separada por vírgula: `TYPE_SMS`, `TYPE_WHATSAPP`, `TYPE_EMAIL`, `TYPE_INSTAGRAM`, `TYPE_FACEBOOK`, `TYPE_INTERNAL_COMMENTS` e outros).
- Resposta: `{ messages: { messages: [...], lastMessageId, nextPage } }`. Cada mensagem: `id`, `direction`, `status` (`delivered`, `failed`, `pending`, `read`), `messageType`, `body`, `dateAdded` (ISO), `from`, `to`, `conversationProviderId`, `meta`, `source`.
- Use para: ver a última mensagem recebida (janela de 24 horas), descobrir o canal e o provedor de envio, conferir se a resposta entrou.
- Integração de WhatsApp da Atlas: `messageType` vem `TYPE_CUSTOM_SMS`, `meta.marketplace.appName` vem com o nome do app da integração (sempre em maiúsculas; nunca mostre ao cliente) e o texto termina com `Source: <nome do número>`. Esse nome é o número da integração por onde a conversa passou.

### export-messages-by-location
- Mensagens da conta por período e canal. GET `/conversations/messages/export`.
- Parâmetros: `channel` (`Call`, `SMS`, `Email`, `WhatsApp`, `Instagram`, `Facebook`; sem canal vem tudo menos e-mail), `contactId`, `conversationId`, `startDate`, `endDate`, `limit` (mínimo 10, máximo 1000, padrão 100), `cursor`, `sortBy`, `sortOrder`.
- Pegadinhas do describe: e-mail só com `channel=Email`; mensagens de atividade (oportunidade, agendamento) não vêm; o `cursor` vale 2 minutos.
- Uso: "o que chegou ontem no WhatsApp", contagens por período. Leia `total`, não pagine para contar.

### get-message e get-email-by-id
- Uma mensagem pelo ID: `get-message` (`id` no caminho). Um e-mail pelo ID: `get-email-by-id` (`id`), que traz também `subject`, `cc`, `bcc`, `threadId`. Leitura.

### GET-all-or-email-sms-templates
- Modelos salvos da conta (SMS, e-mail e WhatsApp). GET `/locations/{locationId}/templates`.
- Parâmetros: `originId` (**obrigatório**; use o próprio `locationId`, conferido na conta de teste), `type` (`sms`, `email`, `whatsapp`), `limit` (texto, padrão "25"), `skip`, `deleted`.
- Resposta: `{ templates: [...], totalCount }`. Na conta de teste voltou 0 para `sms` e `whatsapp`.
- **Em conta com a integração de WhatsApp da Atlas, os templates oficiais ficam na integração e não aparecem aqui.** Lista vazia não quer dizer que não há template: confira na tela da integração (`whatsapp-da-atlas.md`).
- A busca por "templates" no domínio de contas mostrou `scopeFilteredCount: 1`: existe outra operação de modelos no catálogo que esta conexão não enxerga. Criar ou apagar modelo: navegador.

### search-users e get-location (apoio)
- `get-location` (leitura): traz `location.companyId` e `timezone`. Chame uma vez e guarde na conversa.
- `search-users` (leitura): obrigatório `companyId`; `query` com nome ou e-mail de quem pede; `limit` pequeno. Resposta `users[]` com `id` (o `userId`). Conferido na conta de teste com o e-mail do dono. Mostre só o nome.

### active-numbers
- Números de telefone da conta. GET `/phone-system/numbers/location/{locationId}`. Parâmetros: `pageSize`, `page`, `searchFilter`.
- Na conta de teste voltou 0 números, embora o WhatsApp funcione pela integração de WhatsApp da Atlas. Não serve para descobrir o número de WhatsApp. Use o canal da última mensagem (acima) ou pergunte ao cliente.

## Escrita (dryRun, aprovação)

### send-a-new-message
- Envia uma mensagem. POST `/conversations/messages`. kind: write, `requiresApproval: true`, `idempotencyKey` obrigatório.
- Corpo obrigatório: `type` (`SMS`, `Email`, `WhatsApp`, `IG`, `FB`, `Custom`, `Live_Chat`, `InternalComment`) e `contactId`.
- Campos que importam: `message` (texto), `attachments` (lista de URLs), `scheduledTimestamp` (agendar; segundos UTC), `conversationProviderId` (provedor de envio), `fromNumber` e `toNumber`, `replyMessageId`, `templateId`; e-mail: `subject`, `html`, `emailFrom`, `emailTo`, `emailCc`, `emailBcc`, `threadId`, `emailReplyMode`; WhatsApp com mídia: `whatsapp: { type: "media", media: {...} }`.
- Resposta: `conversationId`, `messageId` (ou `messageIds`), `emailMessageId`, `msg`.
- dryRun montou a requisição sem erro, sem enviar nada. Ele não valida corpo, IDs, canal nem permissão.
- **Toda chamada real a contato é aprovação reforçada `CONFIRMO ENVIO`.**
- `type: InternalComment` não vai para o contato: é nota interna. Aprovação simples. **O describe marca `mentions` como obrigatório para `InternalComment`.** Mande `mentions` (lista de `userId`), a menção no texto no formato `@nome<userId>id</userId>` e `userId` de quem escreve. Sem alguém a mencionar, mencione o próprio usuário que pede (ache o `userId` com `search-users`, abaixo). A chamada real não foi testada nesta construção (regra da fábrica: escrita só em dryRun); se voltar 400, siga o describe e corrija, sem chutar.
- **Integração de WhatsApp da Atlas.** Envio confirmado em 04/11/2026 com mensagem real para número interno: `send-a-new-message` com `type: "SMS"`, `contactId` e `conversationProviderId` igual ao `lastMessageConversationProviderId` da conversa. Resposta 201; `get-message` mostra `from` com o nome do app da integração, `messageType: TYPE_CUSTOM_SMS`, `status: delivered`. Sai pelo número já ligado à conversa; o número não aparece no conector, então confirme com o cliente. Para escolher o número: envio só com `#sw|N`, espera de pelo menos 10 segundos e depois o texto (`whatsapp-da-atlas.md`, seção 3).
- Canal nativo (WhatsApp, SMS, e-mail, IG, FB do próprio CRM): use o `type` do canal e o `conversationProviderId` da última mensagem enviada pela equipe na conversa. Sem mensagem anterior da equipe ou com número de envio incerto: navegador.
- `scheduledTimestamp` é segundos UTC. Brasília é UTC menos 3. Repita a data em horário de Brasília na aprovação.
- Envio de template oficial do WhatsApp por este campo `templateId` não foi confirmado. Fora da janela de 24 horas, use a tela da conversa ou uma automação.

### cancel-scheduled-message
- Cancela mensagem agendada. DELETE `/conversations/messages/{messageId}/schedule`. Parâmetro obrigatório: `messageId`.
- kind: delete, `destructiveHint: true`, `idempotencyKey` obrigatório. Aprovação reforçada `CONFIRMO EXCLUSÃO`, item por item.
- O `messageId` vem da resposta do agendamento feito nesta conversa ou de `get-messages` da conversa.
- **O conector não lista as mensagens agendadas da conta.** Para cancelar, o cliente diz quais (contato ou conversa), ou o cliente abre a conversa na tela. Nunca varra todas as conversas para achar agendamentos.

### cancel-scheduled-email-message
- Mesmo para e-mail agendado. DELETE `/conversations/messages/email/{emailMessageId}/schedule`. Parâmetro: `emailMessageId`. kind: delete.

### update-conversation
- Marca como lida ou favorita. PUT `/conversations/{conversationId}`. Obrigatório: `conversationId`.
- Corpo: `unreadCount` (0 marca como lida), `starred` (verdadeiro ou falso), `feedback`.
- kind: write, `requiresApproval: true`. Aprovação simples. Em várias conversas de uma vez (mais de 20), aprovação reforçada `CONFIRMO MASSA`.

### add-contact-to-workflow (de outra área)
- Coloca um contato numa automação. POST `/contacts/{contactId}/workflow/{workflowId}`. Obrigatórios: `contactId`, `workflowId`. Opcional: `eventStartTime` (ISO). kind: write, aprovação, `idempotencyKey`.
- Se a automação envia mensagem, é disparo: passe pela trava e use `CONFIRMO ENVIO`. Detalhe na skill `atlas-automacoes`.

## Operações que existem e esta skill não usa

- `delete-conversation` (apagar conversa; `conversationId`; kind delete, `destructiveHint: true`): só com pedido expresso, item por item, `CONFIRMO EXCLUSÃO`. Prefira não apagar histórico.
- Operações de integração, conferidas com `describe_operation` em 03/11/2026. Todas kind write, `requiresApproval`, `idempotencyKey` obrigatório. Servem para integrações e registros externos. **Não use para responder cliente**: nenhuma delas envia mensagem ao contato.
  - `create-conversation`: POST `/conversations/`; corpo `contactId` (obrigatório). Abre conversa vazia.
  - `add-an-inbound-message`: POST `/conversations/messages/inbound`; obrigatórios `type` (`SMS`, `Email`, `WhatsApp`, `GMB`, `IG`, `FB`, `Custom`, `WebChat`, `Live_Chat`, `Call`) e `conversationProviderId`, mais `conversationId` ou `contactId`. Registra mensagem como se o contato tivesse mandado: pode disparar automação de "Cliente respondeu".
  - `add-an-outbound-message`: POST `/conversations/messages/outbound`; só `type: Call` (registro de ligação externa), `conversationProviderId` obrigatório.
  - `update-message-status`: PUT `/conversations/messages/{messageId}/status`; `status` (`delivered`, `failed`, `pending`, `read`) obrigatório. Muda o status mostrado, não reenvia.
  - `add-message-attachments`: PUT `/conversations/messages/{messageId}/attachments`; `attachments` (até 5 URLs) substitui os anexos; só para mensagem de ligação personalizada.

## O que o MCP não faz (navegador ou outro caminho)

| Pedido | Caminho |
| --- | --- |
| Criar ou editar template de WhatsApp oficial | Navegador, tela de templates de WhatsApp (`telas.md`) |
| Ver status do template (em análise, aprovado, rejeitado) | Navegador |
| Listar mensagens agendadas da conta | Navegador (abrir a conversa); o conector não lista |
| Ver templates da integração de WhatsApp da Atlas | Navegador, tela da integração |
| Grupos, mensagem agendada ou recorrente em grupo, campanha e status do número da integração | Navegador, painel da integração (`whatsapp-da-atlas.md`, seção 4) |
| Responder conversa da integração de WhatsApp da Atlas | MCP, `type: SMS` com o `conversationProviderId` da conversa |
| Mandar template aprovado fora da janela | Navegador (conversa) ou automação |
| Criar snippet ou modelo de SMS | Navegador |
| Disparo em massa | Automação ou ação em massa na lista de contatos, sempre pela trava |
| Qualidade do número de WhatsApp | Navegador, configurações de WhatsApp |
