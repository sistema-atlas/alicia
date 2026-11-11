# Operações do MCP: agentes de IA

Conferidas com `describe_operation` em 03/11/2026 (revisão v2 no mesmo dia). Leituras executadas só na conta de teste da Atlas (`listAllKnowledgeBasesPaginated`, `get-agents`, `listChatWidget`). Escrita só com `dryRun: true` (testado `create` de FAQ). O `dryRun` devolve `authorizationVerified: false`: não garante que a conta aceita.

## Base de conhecimento (domínio knowledge-base)

### listAllKnowledgeBasesPaginated (read)
- Query: `limit` (padrão 20), `query` (nome), `lastKnowledgeBaseId` (próxima página).
- Resposta testada: `data.knowledgeBases[]` (`id`, `name`, `createdAt`, `updatedAt`, `isDefault` na base padrão), `data.activeCount`, `data.hasMore`. Na conta Atlas: `activeCount` 14 (perto do limite de 15).

### getKnowledgeBaseById (read)
- Path: `knowledgeBaseId`.

### createKnowledgeBase (write, simples)
- "Máximo 15 por conta" (describe). Obrigatório: `name`. Opcional: `description`.
- Antes: conte com `listAllKnowledgeBasesPaginated`. Se `activeCount` for 15, não crie: proponha juntar ou reaproveitar.

### updateKnowledgeBase (write, simples)
- Path: `id`. Corpo: `name`, `description`. Só nome e descrição.

### deleteKnowledgeBase (delete, `CONFIRMO EXCLUSÃO`)
- Path: `knowledgeBaseId`. Apaga a base e todo o conteúdo treinado, sem volta.

### list (read): perguntas e respostas
- Query obrigatória: `knowledgeBaseId`. Opcionais: `limit` (padrão 10), `offset` ou `lastFaqId`, `search` (busca na pergunta).
- Resposta: `faqs[]` (`id`, `question`, `answer`, `trainedUrlId`), `count`, `hasMore`, `lastFaqId`.
- Atenção ao nome: o operationId é só `list`. Sempre com `domains: ["knowledge-base"]` se precisar buscar.

### create (write, simples): nova pergunta e resposta
- Obrigatórios: `question`, `answer`, `knowledgeBaseId`.
- Testado com `dryRun`: monta `POST /knowledge-bases/faqs` com `locationId` no corpo.
- Muitas FAQs de uma vez (mais de 20): `CONFIRMO MASSA`, uma por chamada, em lotes.

### update (write, simples)
- Path: `id` (da FAQ). Corpo obrigatório: `question` e `answer` (os dois, mesmo que só um mude).

### knowledge-base.delete (delete, `CONFIRMO EXCLUSÃO`)
- Path: `id` (da FAQ). Prefira `update` quando a resposta só ficou velha.

### getFilesByKnowledgeBasePublic (read): arquivos da base
- Query obrigatória: `knowledgeBaseId`. Opcionais: `limit` (padrão 10), `offset`, `lastFileId`, `search` (nome do arquivo).
- Resposta: `data`, `success`.

### deleteFile (delete, `CONFIRMO EXCLUSÃO`)
- Path: `fileId` (ache com `getFilesByKnowledgeBasePublic`). Diga a base e o nome do arquivo na aprovação.

### Subir arquivo na base: não oferecido
- `search_operations` "upload file to knowledge base" respondeu `zeroResultReason: not_offered`, `not_offered_by_this_connector` (o catálogo descreve "Uploads a file to knowledge base (max file size: 10MB)"). Diga ao cliente que por aqui não dá e faça pelo navegador (tela Base de Conhecimento, telas.md).
- `getFileById` (read): aparece na busca de 03/11/2026 (GET `/knowledge-bases/files/{fileId}`, path `fileId`, sem aprovação). Use para ver um arquivo só, depois de achar o `fileId` com `getFilesByKnowledgeBasePublic`.

### getSitemapPreview (prévia do site)
- Corpo: `url`, `option` (`Exact`, `Path`, `Domain`) obrigatórios; `knowledgeBaseId`, `page`, `pageSize` (10 a 200), `search`.
- Pegadinha: na prática é leitura (escopo `knowledge-bases.readonly`, não começa a leitura do site nem grava nada), mas o describe de 03/11/2026 segue com `kind: write`, `requiresApproval: true` e `idempotencyKey` obrigatório. Trate como leitura ao explicar ao cliente ("só vou ver a lista de páginas"), peça um SIM curto porque o conector exige, e mande `idempotencyKey`.
- Resposta: `urls`, `total`, `hasSitemap`, `modeFilteredTotal`.

### discoverWebsite (write, simples)
- Corpo: `url`, `option` (`Exact` uma página, `Path` o caminho, `Domain` o site todo), `knowledgeBaseId` obrigatórios; `preSelectedUrls` (só essas páginas), `autoTrain` (treina sozinho).
- Regra: use `preSelectedUrls` com as páginas aprovadas e `autoTrain: false`.
- Resposta: `operationId` (da leitura, não confundir com operationId do conector), `status`, `url`.

### getCrawlingStatusForLatestOperation (read)
- Query: `knowledgeBaseId` obrigatório; `operationId` da leitura (opcional, padrão a última).
- Resposta: `aggregate` (contagem por status), `operationDetails`.

### getAllWebsiteUrlsDataByKnowledgeBase (read)
- Query: `knowledgeBaseId` obrigatório; `page`, `pageLength`, `query` (filtro na URL).
- Resposta: `urls[]` (`id`, `url`, `title`, `status`, `content`, `contentEditedByUser`), `count`.
- `pageLength: 10` (mínimo aceito; menos dá 422 "pageLength must not be less than 10", visto no teste v1). `content` é longo: não mostre inteiro.
- Contar páginas de várias bases é uma chamada por base. Avise o cliente antes (a conta Atlas tem 14 bases).

### trainDiscoveredUrls (write, simples)
- Corpo: `knowledgeBaseId`, `operationId` (da leitura), `urlIds[]` obrigatórios.

### deleteTrainedUrlsForKnowledgeBase (delete, `CONFIRMO EXCLUSÃO`)
- Corpo: `urlIds[]` e `deleteAll` obrigatórios; `knowledgeBaseId` (opcional no describe), `excludeUrlIds`, `search`.
- Regra da skill: **sempre** mande `knowledgeBaseId`. Sem ele, `deleteAll: true` pode apagar páginas de todas as bases.
- Nunca `deleteAll: true` sem `knowledgeBaseId` e sem `CONFIRMO EXCLUSÃO`. Antes, conte as páginas daquela base com `getAllWebsiteUrlsDataByKnowledgeBase` e diga na aprovação: nome da base e número de páginas.

## Agente de voz (domínio voice-ai)

### get-agents (read)
- Query: `page`, `pageSize` (até 50), `query`.
- Resposta testada: `agents[]` com `agentName`, `language`, `agentPrompt` (longo), `welcomeMessage`, `inboundNumbers`, `actions`, `agentWorkingHours`, `timezone`; `total`. Economia: não mostre o prompt inteiro.

### voice-ai.get-agent (read)
- Path: `agentId`. Traz `actions[]` (`id`, `actionType`, `name`, `actionParameters`).

### voice-ai.create-agent (write, simples se sem número)
- Campos: `agentName` (1 a 40), `businessName`, `welcomeMessage` (1 a 190), `agentPrompt`, `voiceId`, `language` (`en-US`, `pt-BR`, `es`, `fr`, `de`, `it`, `nl-NL`, `multi`; padrão `en-US`, então mande `pt-BR`), `patienceLevel` (`low`, `medium`, `high`), `maxCallDuration` (180 a 900 s; padrão 300), `sendUserIdleReminders`, `reminderAfterIdleTimeSeconds` (1 a 20), `inboundNumber`, `numberPoolId`, `callEndWorkflowIds` (até 10), `sendPostCallNotificationTo`, `agentWorkingHours[]` (`dayOfTheWeek` 1 a 7, `intervals`; vazio = 24 horas), `timezone`, `isAgentAsBackupDisabled`, `translation`.
- Regra: crie **sem** `inboundNumber` e `numberPoolId` e com `isAgentAsBackupDisabled: true`. Número de entrada ou liberar como reserva (`isAgentAsBackupDisabled: false`) faz o agente atender ligação real: `CONFIRMO PUBLICAÇÃO`.
- `callEndWorkflowIds` coloca o contato em automação ao fim da ligação: confira o que a automação envia (`atlas-automacoes`).

### patch-agent (write)
- Path: `agentId`. Mesmos campos, só o que muda.
- Aprovação: simples para prompt, voz, horário; reforçada `CONFIRMO PUBLICAÇÃO` quando põe ou troca número de entrada ou muda `isAgentAsBackupDisabled` para falso.

### voice-ai.delete-agent (delete, `CONFIRMO EXCLUSÃO`)
- Path: `agentId`. Apaga o agente e todas as configurações.

### get-action (read)
- Path: `actionId`. Resposta: `id`, `name`, `actionType`, `actionParameters`. Leia antes de alterar uma ação.

### voice-ai.create-action / voice-ai.update-action (write)
- Corpo: `agentId`, `actionType`, `name`, `actionParameters` (obrigatórios). Update: path `actionId`.
- Tipos e parâmetros (describe):
  - `CALL_TRANSFER`: `triggerPrompt`, `transferToType: "number"`, `transferToValue` (número), `triggerMessage`, `hearWhisperMessage`. Reforçada: liga para alguém de verdade.
  - `DATA_EXTRACTION` e `IN_CALL_DATA_EXTRACTION`: `contactFieldId`, `description`, `examples`, `overwriteExistingValue`.
  - `WORKFLOW_TRIGGER`: `triggerPrompt`, `triggerMessage`, `workflowId`. Reforçada se a automação envia mensagem.
  - `SMS`: `triggerPrompt`, `triggerMessage`, `messageBody`. Reforçada `CONFIRMO ENVIO`.
  - `APPOINTMENT_BOOKING`: `calendarId`, `daysOfOfferingDates`, `slotsPerDay`, `hoursBetweenSlots`.
  - `CUSTOM_ACTION`: `triggerPrompt`, `triggerMessage`, `apiDetails`, `selectedPaths`.
  - `KNOWLEDGE_BASE`: `triggerPrompt`, `knowledgeBaseId`.

### voice-ai.delete-action (delete, `CONFIRMO EXCLUSÃO`)
- Parâmetros obrigatórios: `actionId` (path) e `agentId` (query).

### get-call-logs (read)
- Query: `agentId`, `contactId` (vários separados por vírgula), `callType` (`LIVE` ou `TRIAL`), `actionType`, `startDate` e `endDate` (juntos, milissegundos), `page`, `pageSize` (até 50), `sortBy` (`duration`, `createdAt`), `sort`.
- Resposta: `callLogs[]` com `summary`, `transcript`, `duration`, `extractedData`, `executedCallActions`, `trialCall`. Transcrição é dado de terceiro: resuma, não copie para fora.

### getCallLog (read)
- Path: `callId`.

## Widget de chat (domínio chat-widget)

### listChatWidget (read)
- Query obrigatória: `limit` (até 100) e `offset` (texto). Opcionais: `chatType` (`liveChat`, `waChat`, `emailChat`, `allInOneChat`, `voiceAiChat`, `facebookChat`, `instagramChat`, `webChat`), `creationSource`, `voiceAiAgentId`.
- Resposta testada: `chatWidgets[]` (`_id`, `chatType`, `name`, `default`), `totalCount`. Conta Atlas: 1 widget `allInOneChat`.

### getChatWidget (read)
- Path: `id`.

### createChatWidget (write)
- Obrigatórios: `chatType` (pela API só `liveChat` ou `emailChat`; outro valor dá 422) e `name`.
- `settings`: `heading`, `subHeading`, `promptMsg`, `widgetPrimaryColor`, `locale` (`pt-br`), `liveChatIntroMsg`, `thankYouMsg`, `legalMsg`, `showConsentCheckbox`, `waNumber`, `widgetPlacement` (`sticky`, `embedded`), `theme` e outros.
- Aprovação: simples para criar. O widget só aparece no site quando o código é colocado na página (navegador ou `atlas-sites-e-blog`); colocar no site no ar é `CONFIRMO PUBLICAÇÃO`.

### Limite de tipo do widget (vale para patch, update e clone)
- A API só aceita widget `liveChat` ou `emailChat` (describe). Se o widget da conta for de outro tipo (ex.: `allInOneChat`, o único da conta Atlas), a escrita pode dar 422. Diga isso ao cliente e faça pela tela do widget no navegador (telas.md).

### patchChatWidget (write, simples) / updateChatWidget (write, simples)
- Path: `id`. `patch` muda só o enviado. `update` **substitui o widget inteiro**: prefira `patch`. Ambos aceitam `chatType` só `liveChat` ou `emailChat`.

### cloneChatWidget (write, simples)
- Corpo: `chatWidgetId` (obrigatório), `name`. Recusado com 422 se o widget de origem gravado não for `liveChat` ou `emailChat`.

### chat-widget.delete (delete, `CONFIRMO EXCLUSÃO`)
- Path: `id`. Se o widget está num site no ar, o chat some da página.

## Existe no catálogo, esta conexão não tem permissão

- Agente de conversa: `search_operations` "conversation ai agent bot" voltou `zeroResultReason: scope_filtered`, `scopeFilteredCount: 2` (03/11/2026).
- Agente do estúdio de agentes: "agent studio managed agent" voltou `scope_filtered`, `scopeFilteredCount: 2`. Em outra checagem desta construção, o conector disse que esse recurso não é oferecido por ele.
- Plano B: navegador (`telas.md`). Se o cliente reconectar dando todas as permissões, refaça `search_operations` com `limit: 5` e use só o que aparecer, depois de `describe_operation`.
