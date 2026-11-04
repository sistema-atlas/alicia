# Operações do MCP: redes sociais e reputação

Todas vistas em `search_operations` (domínios `social-planner`, `medias`, `products`) e conferidas com `describe_operation` em 03/11/2026. Leituras (`kind: read`) executadas de verdade na conta de teste da Atlas; o resto só com `dryRun: true`. Passe sempre `locationId` no `execute_operation`.

Resumo: o MCP lê contas, posts, categorias, etiquetas, filas, comentários e estatísticas; cria, edita e apaga posts; mexe em filas; comenta e responde comentários; lê e atualiza avaliações de produto. **Não existe operação** para avaliações do Google, pedidos de avaliação, nem para conectar rede social (há operações de conexão por OAuth, mas elas exigem o login do cliente na rede: use a tela).

**Consultas marcadas como escrita.** `get-posts`, `get-statistics`, `get-comment-list`, `fetchQueues`, `fetchQueueItems`, `fetchCalendarList` usam POST e o conector marca como `kind: write`, `requiresApproval: true`, `idempotencyRequired: true`. O resumo de cada uma é listagem e o escopo é `.readonly` (ex.: `socialplanner/post.readonly`, `comments.readonly`, `category.readonly`, `statistics.readonly`). **Trate como leitura:** execute direto com `locationId` e um `idempotencyKey` (o describe exige), sem dryRun e sem pedir aprovação ao cliente. `get-posts`, `get-comment-list`, `fetchQueues` e `get-statistics` rodaram de verdade na conta de teste em 03/11/2026 (formatos abaixo). Qualquer outra operação POST que não seja só listagem segue como escrita.

**Links.** Avatares (`avatar`), URLs de mídia e o `uiUrl` podem vir com domínio técnico do fornecedor. Não mostre ao cliente. O `handoff` de `fetch-media-content` e `upload-media-content` manda citar o nome da plataforma: troque por "Atlas CRM" e "sua conta".

## Contas

### get-account (leitura)
- GET `/social-media-posting/{locationId}/accounts`. Sem parâmetros.
- Resposta: `results.accounts[]` com `id` (o ID usado em `accountIds`), `name`, `platform` (`facebook`, `instagram`, `linkedin`, `tiktok`, `youtube`, `google`, `pinterest`, `threads`, `bluesky`, `community`), `type` (`page`, `profile`, `business`, `location`, `group`), `active`, `isExpired`, `expire`, `meta`; e `results.groups[]` (grupos de contas com `name` e `accountIds`).
- Conferido na conta de teste: 15 contas e 2 grupos. A conta do Google (perfil da empresa) aparece com `platform: google`, `type: location`. A comunidade aparece com `platform: community`, `type: group` e `meta.groupName`, `meta.channelSlug`.
- Cada conta também traz `originId` (ID na rede, usado em `get-comment-list`) e `profileId` (usado em `get-statistics`). Conferido na conta de teste.
- **Vencimento:** bloqueie a conta se `isExpired: true`, ou se `expire` já passou, ou se `expire` cai antes do horário do post. Na conta de teste (03/11/2026) havia 3 contas com `expire` no passado e `isExpired: false`. O que isso mostra na tela ainda não foi conferido; até lá, trate como vencida e peça reconexão.

## Posts

### get-posts (consulta marcada como escrita)
- POST `/social-media-posting/{locationId}/posts/list`.
- Corpo: `type` (`recent`, `all`, `scheduled`, `draft`, `failed`, `in_review`, `published`, `in_progress`, `pending`, `deleted`), `accounts` (IDs separados por vírgula, em texto), `fromDate`, `toDate`, `skip` e `limit` **como texto** (número em JSON é rejeitado, diz o describe), `postType` (`post`, `story`, `reel`), `includeUsers`.
- Resposta real (conta de teste, `type: published`, `limit: "1"`): `results.posts[]` e `results.count` (51). Cada post: `_id` (ID interno de 24 caracteres, usado em `get-post`, `edit-post` e como `parentId` de comentários), `accountId`, `platform`, `status`, `type`, `summary`, `media`, `scheduleDate`, `publishedAt`, `error`, `insights` (curtidas, comentários, compartilhamentos), `previewLink` (link público na rede, pode mostrar ao cliente), `createdBy` (userId).

### get-post (leitura)
- GET `/social-media-posting/{locationId}/posts/{id}`. Aceita o ID interno ou o ID nativo da rede.

### create-post (escrita; publica se não for rascunho)
- POST `/social-media-posting/{locationId}/posts`.
- Obrigatório: `type` (`post`, `story`, `reel`).
- Principais: `accountIds` (obrigatório se não for rascunho; o `id` de `get-account`), `summary` (legenda), `media` (`url` e `type`: `image/jpeg`, `image/png`, `image/gif`, `video/mp4`, `video/mov`, `video/webm`), `status` (`draft`, `scheduled`, `in_review`, `published`), `scheduleDate` (ISO; obrigatório em `scheduled` e `in_review`), `userId` (obrigatório para canais conectados fora de rascunho; de `search-users`, ver abaixo), `categoryId`, `tags`, `followUpComment` (comentário logo após publicar; não vale para Google e Pinterest), `postApprovalDetails` (aprovação interna: `approver`).
- Detalhes por rede: `instagramPostDetails`, `facebookPostDetails`, `tiktokPostDetails` (privacidade), `youtubePostDetails` (`title`, `type` `video` ou `short`), `linkedinPostDetails`, `pinterestPostDetails` (`boardIds` obrigatório no Pinterest), `gmbPostDetails` (Google: `gmbEventType` `STANDARD`, `EVENT` ou `OFFER`, `actionType`, `url`), `communityPostDetails` (`title`, `postAsUser`, `notifyAllGroupMembers`).
- Limites de legenda por rede (describe): Facebook 63.206, LinkedIn 3.000, Instagram e TikTok 2.200, Google 1.500, Pinterest 800, Threads 500, Bluesky 300. Uma legenda para várias redes é cortada no limite da mais curta.
- Instagram: mídia obrigatória, até 30 hashtags. Reel: 1 vídeo. Story: sem legenda. Grupo de Facebook não aceita reel. YouTube: vídeo obrigatório, título até 100 caracteres. LinkedIn: até 9 imagens ou vídeos. Pinterest: 1 mídia por pin. Comunidade: até 4 mídias.
- dryRun montou a requisição com `status: draft` sem erro (o dryRun não valida IDs nem permissão).
- `status: draft`: aprovação simples. `scheduled` ou `published`: `CONFIRMO PUBLICAÇÃO`.

### edit-post (escrita)
- PUT `/social-media-posting/{locationId}/posts/{id}`. Mesmo corpo de `create-post`, `type` obrigatório. Post agendado: `CONFIRMO PUBLICAÇÃO`.

### delete-post (exclusão)
- DELETE `/social-media-posting/{locationId}/posts/{id}`. kind: delete, `destructiveHint: true`. `CONFIRMO EXCLUSÃO`, um por vez.
- Existe `bulk-delete-social-planner-posts` (corpo `postIds`; até 50 por chamada, segundo o describe). Atenção: o conector marca como `kind: write` sem `destructiveHint`, mas ela apaga. Trate como exclusão: pedido expresso, lista mostrada item por item, `CONFIRMO EXCLUSÃO`; prefira apagar um por um.

### get-categories-location-id e get-tags-location-id (leitura)
- Categorias e etiquetas do planejador. Parâmetros: `limit`, `skip`, `searchText` (texto). Resposta em `results`. Na conta de teste: 0 categorias.
- Criar categoria: não apareceu operação liberada nesta conexão (`scopeFilteredCount` 3 na busca). Navegador.

## Filas por categoria (posts recorrentes)

- `fetchAvailableCategories` (leitura): categorias com status da fila (`available`, `in_queue`, `draft`).
- `fetchQueues` (consulta, trate como leitura): lista filas. Corpo `skip`, `limit` (números). Resposta real: `results.queues[]` e `results.meta.count` (0 na conta de teste).
- `fetchQueueItems` (consulta, trate como leitura): itens de uma fila. `queueId`; corpo `skip`, `limit`, `errorFilter`, `sessionId`, `itemId`.
- `fetchCalendarList` (consulta, trate como leitura): posts agendados das filas ativas. Corpo `startDate` e `endDate` (obrigatórios, ISO), `categoryIds`, `accountIds`.
- `fetchQueueById` (leitura): uma fila, com contagem de posts com erro.
- `createQueue` (escrita): cria em rascunho. Obrigatórios: `categoryId`, `timeSlots` (`dayOfWeek` número e `time` "HH:MM"), `userId`. O describe não diz qual número é domingo (exemplo: 1 e 3, sem legenda). Não chute: confirme na tela da fila depois de criar e corrija com `updateQueue` se precisar. Opcionais: `enableFuturePosts`, `prioritizeNewContent`.
- `updateQueue` (escrita): `status` (`active`, `paused`, `deleted`), `timeSlots`, `skipDateTime`. **Ativar fila publica posts sozinha no horário**: `CONFIRMO PUBLICAÇÃO`. Pausar: aprovação simples.
- `createQueueItem` (escrita): post na fila. `directToQueue: true` dispensa sessão de edição; `modifiedPostPayload` com o post. **Em fila ativa, o item publica sozinho no próximo horário:** `CONFIRMO PUBLICAÇÃO`. Em fila em rascunho ou pausada: aprovação simples.
- Outras operações de fila existem no catálogo, mas não fazem parte desta skill. Para editar ou apagar item de fila, use a tela do planejador.

## Comentários

### get-comment-list (consulta marcada como escrita)
- POST `/social-media-posting/comments/{platform}/list`. `platform`: `facebook`, `instagram`, `linkedin`, `community`, `tiktok`, `bluesky`, `youtube`, `threads`.
- Corpo: `originIds` (**obrigatório**: o campo `originId` da conta em `get-account`), `parentId` (ID interno do post ou do comentário), `fromDate` e `toDate` (os dois juntos), `sortBy` (`top`, `latest`), `search`, `skip`, `limit` (1 a 100).

- Resposta real (conta de teste): `results.comments[]` e `results.meta` (`total`, `totalUnread`, `skip`, `limit`, `hasMore`). Com `parentId` de post sem comentário, voltou **404 "Comment not found"**: trate como "nenhum comentário nesse post", não como erro.

### create-comment (escrita pública)
- POST `/social-media-posting/comments/{platform}`.
- Obrigatórios: `parentId` (ID interno de 24 caracteres), `isParentThread` (verdadeiro: comentário no post; falso: resposta a comentário), `content`.
- Tamanho máximo (describe): Facebook 8.000, Instagram 2.200, LinkedIn 3.000, comunidade 8.000, TikTok 150, Bluesky 300, YouTube 10.000, Threads 500.
- `attachments` só no Facebook. `mentions` só Facebook, LinkedIn e comunidade. `notifyAllGroupMembers` só comunidade (avisa todos).
- `CONFIRMO PUBLICAÇÃO` por resposta.

## Estatísticas

### get-statistics (consulta marcada como escrita)
- POST `/social-media-posting/statistics`. Corpo: `profileIds` (até 100; **é o campo `profileId` de `get-account`, não o `id`**: com o `id` voltou 400 "Invalid connected account ID"), `platforms` (`facebook`, `instagram`, `linkedin`, `google`, `pinterest`, `youtube`, `tiktok`), `currentRange` e `prevRange` (`startDate`, `endDate`). Sem datas: últimos 7 dias, comparando com os 7 anteriores.
- Resposta real: `results.totals` (posts, curtidas, seguidores, impressões, comentários), `results.breakdowns` (alcance, impressões e engajamento por rede, com variação em %), `postPerformance` e `platformTotals` por dia.

## Usuário que publica

### get-location e search-users (leitura)
- `get-location`: `location.companyId`. Chame uma vez e guarde.
- `search-users`: `companyId` obrigatório, `query` com o e-mail de login de quem publica, `limit: "1"`. O `users[0].id` é o `userId` de `create-post` e `createQueue`. Conferido na conta de teste. Pergunte o e-mail uma vez e guarde o `userId`.

## Comunidade

### get-community-users (leitura)
- GET `/social-media-posting/{locationId}/community/accounts/{accountId}/users`. Membros que podem publicar no canal (ativos e com papel). Parâmetros: `limit` (até 100), `pageNo`, `searchText` (2 letras ou mais).
- O `contactId` que volta vai em `communityPostDetails.postAsUser[accountId].id` no `create-post`. Liste por canal; não reaproveite entre canais.

## Mídia

### fetch-media-content (leitura)
- GET `/medias/files`. Obrigatórios: `altType: location`, `type` (`file` ou `folder`), `sortBy` (ex.: `updatedAt`), `sortOrder`. Opcionais: `query`, `parentId`, `limit`, `offset` (texto).
- Resposta: `files[]` com `name`, `url`, `contentType`, `width`, `height`; `count`; e `uiUrl` (link da tela de Mídia; não mostre ao cliente, use o caminho de `telas.md`). Conferido na conta de teste: 19 arquivos.
- Use a `url` do arquivo em `media[].url` do post.

### upload-media-content (escrita)
- POST `/medias/upload-file`. `file: { fileName, mimeType, base64 }` com os bytes exatos, ou `hosted: true` com `fileUrl` público HTTPS. Limite pelo conector: 25 MB, inclusive vídeo.
- Pegadinha do describe: anexo do chat não chega sozinho ao conector. Sem os bytes exatos, mande o cliente subir pela tela de Mídia com o caminho de `references/telas.md` (menu Mídia Drive, `media-storage` no domínio da conta), não pelo `uiUrl`, que pode vir com domínio técnico. Nunca invente base64.

## Avaliações de produto (loja)

### get-product-reviews (leitura)
- GET `/products/reviews`. Obrigatório: `altType: location`. Filtros: `productId`, `storeId`, `rating`, `startDate`, `endDate`, `sortField` (`createdAt`, `rating`), `sortOrder`, `limit`, `offset`.

### get-reviews-count (leitura)
- GET `/products/reviews/count`. Obrigatório: `altType: location`. Contagem por status. Na conta de teste voltou vazio (sem avaliações).

### update-product-review (escrita)
- PUT `/products/reviews/{reviewId}`. Obrigatórios: `altId` (o `locationId`), `altType: location`, `productId`, `status` (ex.: `approved`). Opcional: `reply` (lista com `headline` até 200, `comment` até 5.000, `user`).
- Aprovar avaliação mostra na loja; responder é público: `CONFIRMO PUBLICAÇÃO`.

### bulk-update-product-review e delete-product-review
- Em lote (`reviews` com `reviewId`, `productId`, `storeId`; `status`): mais de 20, `CONFIRMO MASSA`.
- Apagar (`reviewId`, `altType`, `productId`): `CONFIRMO EXCLUSÃO`, item por item.

## Não existe no conector

| Pedido | Caminho |
| --- | --- |
| Ler ou responder avaliação do Google | Navegador, Reputação |
| Enviar pedido de avaliação | Navegador (Reputação) ou automação |
| Contestar avaliação no Google | Navegador |
| Conectar ou reconectar rede | Navegador, planejador social |
| Criar categoria do planejador | Navegador |
