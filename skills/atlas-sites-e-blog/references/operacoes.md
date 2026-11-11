# Operações do MCP: sites, blog, mídia, links e marca

Todas conferidas com `describe_operation` em 03/11/2026. Leituras executadas na conta de teste da Atlas; escritas só com `dryRun: true` (o dryRun devolve o pedido montado com `authorizationVerified: false`: ele não testa permissão). `locationId` em toda chamada. Escrita: `idempotencyKey` obrigatório e aprovação.

Não existe operação para criar ou editar **página, funil, site, domínio, SEO ou QR code**. Isso é navegador.

## Funis, sites e páginas (domínio funnels)

### getFunnels (read)
- Lista funis, sites e blogs. GET `/funnels/funnel/list`.
- Parâmetros (texto): `name`, `type`, `category`, `parentId`, `limit`, `offset`.
- Resposta: `{ funnels: [...], count }`. Cada item: `_id`, `name`, `type` (vistos: `funnel`, `website`, `blog`), `url` (caminho base), `domainId`, `steps` (cada etapa com `id`, `name`, `url` do caminho, `pages`, `type`, `sequence`), datas, `isChatWidgetLive`.
- A resposta é grande. Use `name` ou `limit` pequeno. O nome do domínio não vem, só `domainId`.

### getPagesByFunnelId (read)
- Páginas de um funil. GET `/funnels/page`.
- Obrigatórios: `funnelId`, `limit`, `offset`. Opcional: `name`.
- Resposta: `_id`, `funnelId`, `stepId`, `name`, `updatedAt`, `deleted`.

### getPagesCountByFunnelId (read)
- Total de páginas. Obrigatório `funnelId`; opcional `name`. Resposta `{ count }`.

### fetch-redirects-list (read)
- Redirecionamentos de domínio. Obrigatórios: `limit`, `offset`. Opcional `search` (ex.: `dominio.com/caminho`).
- Resposta `{ data: [{ _id, domain, path, target, action, type }] }`.

### create-redirect (write)
- Corpo obrigatório: `domain` (só o host, sem `https://` e sem barra, ex.: `meusite.com.br`; vem do cliente, porque `getFunnels` só traz `domainId`), `path` (ex.: `/promo`), `target` (URL de destino), `action` (`funnel`, `website`, `url` ou `all`).
- Pegadinha: redirecionamento num caminho que já tem página ou visita muda o que o público vê: trate como publicação.

### update-redirect-by-id (write)
- Path `id`. Corpo obrigatório: `target`, `action`. Não muda domínio nem caminho: para isso, apagar e criar.

### delete-redirect-by-id (delete)
- Path `id`. `destructiveHint: true`. Só com pedido expresso e `CONFIRMO EXCLUSÃO`.

## Blog (domínio blogs)

### get-blogs (read)
- Blogs da conta. GET `/blogs/site/all`. Opcionais: `limit`, `skip`, `searchTerm`.
- Resposta `{ data: [{ _id, name }] }`. O `_id` é o `blogId`.
- O blog também aparece no `getFunnels` como `type: blog`, com as etapas Blog Home e Blog Post.

### get-blog-post (read)
- Posts de um blog. GET `/blogs/posts/all`.
- Obrigatórios: `blogId`, `limit` (0 a 50), `offset`. Opcionais: `searchTerm` (título, descrição, slug, categoria), `status` (`ALL`, `DRAFT`, `PUBLISHED`, `SCHEDULED`, `SCHEDULE_FAILED`, `ARCHIVED`, `DELETED`).
- Resposta `{ blogs: [...posts], count }`. Cada post: `_id`, `title`, `description`, `urlSlug`, `status`, `categories`, `imageUrl`, `imageAltText`, `publishedAt`, `updatedAt`. Não traz o corpo nem `tags`, `author` e `canonicalLink` (lido na conta Atlas em 03/11/2026): esses só vêm em `get-blog-post-by-id`.

### get-blog-post-by-id (read)
- Um post com o corpo. Path `postId`. A descrição diz que devolve post **publicado**: rascunho pode não vir por aqui (a conferir).

### get-all-categories-by-location (read)
- Obrigatórios: `limit` (0 a 50), `offset`. Opcional `searchTerm`. Resposta `{ categories: [{ _id, label, urlSlug }], count }`.

### get-all-blog-authors-by-location (read)
- Obrigatórios: `limit` (0 a 50), `offset`. Opcional `searchTerm`. Resposta `{ authors: [{ _id, name, role }], count }`.

### check-url-slug-exists (read)
- Obrigatório `urlSlug`. Opcional `postId` (exclui o próprio post da checagem, use ao editar).
- Resposta `{ exists: true|false, reason }` (visto: `reason: "post"`). A descrição pede para chamar antes de publicar.

### create-blog-post (write)
- POST `/blogs/posts`. Obrigatórios: `blogId`, `rawHTML` (corpo em HTML), `status` (`DRAFT`, `PUBLISHED`, `SCHEDULED`, `ARCHIVED`, `DELETED`).
- Importantes: `title`, `description` (resumo e SEO), `urlSlug`, `imageUrl` (capa, use URL da Mídia), `imageAltText`, `categories` (IDs), `author` (ID), `tags`, `canonicalLink`, `publishedAt`, `wordCount`, `readTimeInMinutes`.
- Regra: crie com `status: DRAFT`. `PUBLISHED` ou `SCHEDULED` só com `CONFIRMO PUBLICAÇÃO`.
- dryRun montou a requisição (não valida no servidor) em 03/11/2026.

### update-blog-post (write)
- PUT `/blogs/posts/{postId}`. Obrigatórios: `postId` (path), `blogId`, `rawHTML`, `status`.
- Pegadinha: é PUT. Leia o post (`get-blog-post` para metadados; `get-blog-post-by-id` para `rawHTML`, `tags`, `author` e `canonicalLink`, que a lista não traz) e reenvie TODOS os campos atuais: `blogId`, `rawHTML`, `status`, `title`, `description`, `urlSlug`, `imageUrl`, `imageAltText`, `categories`, `author`, `tags`, `canonicalLink`, `publishedAt`. Mude só o pedido. Compare o dryRun com o post lido antes de pedir aprovação. Post publicado ou agendado: `CONFIRMO PUBLICAÇÃO`.
- Extras: `scheduledAt` (data de agendamento), `externalFonts`, `tocStyle`.

## Mídia (domínio medias)

### fetch-media-content (read)
- Lista arquivos e pastas. Obrigatórios: `altType: "location"`, `type` (`file` ou `folder`), `sortBy` (ex.: `updatedAt`, `name`), `sortOrder` (`asc` ou `desc`). Opcionais: `query` (nome), `parentId` (pasta), `limit`, `offset`, `fetchAll`.
- Resposta `{ files: [{ _id, name, url, contentType, size, width, height, parentId }], count, uiUrl }`. `uiUrl` é o link da tela de Mídia da conta.
- Handoff: em pedido de navegar, mostre nomes com o link do arquivo; guarde IDs. Não liste arquivos à toa.
- O handoff e o `nextStep` do conector trazem texto e rótulo de link em inglês, com nome do fornecedor. **Nunca repasse.** Use sempre: "[Abrir a Mídia na Atlas](<link>)". O link é o `uiUrl` se o domínio for o da Atlas ou do cliente; se não for, monte com o domínio da aba do cliente e `/v2/location/<locationId>/media-storage`.

### upload-media-content (write)
- POST `/medias/upload-file`, multipart.
- Modo bytes: `file: { fileName, mimeType, base64 }` com os bytes exatos; `hosted` falso ou ausente.
- Modo URL: `hosted: true`, `fileUrl` (HTTPS pública, porta 443). O arquivo continua hospedado fora; não cria cópia na conta.
- Opcionais: `name`, `parentId` (pasta; sem ele vai para a raiz).
- Limites: arquivo até 25 MB; vídeo até 500 MB na plataforma, mas pelo conector o limite é 25 MB inclusive vídeo (fonte: descrição da operação).
- Handoff: anexo do chat não chega sozinho ao conector. Se não der para obter os bytes exatos com ferramenta de arquivo, responda exatamente em português: "Não consigo passar o anexo do chat direto. [Abrir a Mídia na Atlas](<link>) e subir <arquivo>." Link conforme a regra do `fetch-media-content`. Nunca use o texto de link sugerido pelo conector. Não peça outra rota, não procure substituto.
- Resposta `{ fileId, url }`.

### create-media-folder (write)
- Corpo: `altType: "location"`, `name`; opcional `parentId`. Reaproveite pasta com o mesmo nome se já existir.

### update-media-object (write)
- Path `id`. Corpo: `name`, `altType: "location"`. Só **renomeia**; não move arquivo de pasta.

### bulk-update-media-objects (write)
- Renomeia vários de uma vez. Corpo: `altType: "location"`, `filesToBeUpdated: [{ id, name }]`. Handoff: não prometa mover arquivo nem mudança de status não documentada. Mais de 20 arquivos: aprovação reforçada (`CONFIRMO MASSA`).

### bulk-delete-media-objects (write, mas apaga)
- Corpo: `filesToBeDeleted: [{ _id }]`, `altType: "location"`, `status` (`trashed` = lixeira; `deleted` = definitivo).
- Use `trashed`. `deleted` só com pedido expresso de exclusão definitiva e `CONFIRMO EXCLUSÃO`.

### delete-media-content (delete)
- Path `id`, query `altType: "location"`. Definitivo. Item por item, `CONFIRMO EXCLUSÃO`.

## Links rastreáveis (domínio links)

### get-links (read)
- Sem parâmetros. Resposta `{ links: [{ id, name, redirectTo, fieldKey }] }`.

### search-trigger-links (read)
- Opcionais: `query`, `limit` (padrão 20), `skip`.

### get-link-by-id (read)
- Path `linkId`. Resposta `{ link }`.

### create-link (write)
- Corpo obrigatório: `name`, `redirectTo` (URL ou variável). dryRun montou a requisição (não valida no servidor) com URL com UTM em 03/11/2026.
- O link curto gerado e o `fieldKey` (para usar em mensagens) vêm na resposta.

### update-link (write)
- Path `linkId`. Corpo obrigatório: `name` e `redirectTo` (mande os dois, mesmo se só um muda).
- Mudar o destino de um link que já está em anúncio ou mensagem enviada é publicação: `CONFIRMO PUBLICAÇÃO`.

### delete-link (delete)
- Path `linkId`. Links já enviados param de funcionar. `CONFIRMO EXCLUSÃO`.

## Marca (domínio brand-boards)

### list-design-kits (read)
- Opcionais: `limit` (1 a 20), `offset`, `search`, `deleted`. Resposta `{ items: [{ id, name, isDefault }], total }`.

### get-design-kit (read)
- Path `designKitId`. Resposta com `colors` (`hex`, `label`, `id`), `fonts`, `logos`.

### list-brand-voices (read)
- Lista os tons de voz. Opcionais: `limit` (1 a 20), `offset`, `search`, `deleted`. Resposta `{ items: [{ id, name, isDefault }], total }`: só id e nome, sem o conteúdo.

### get-brand-voice (read)
- Path `brandVoiceId` (obrigatório). Conferido com `describe_operation` em 03/11/2026. Resposta com `answers` (o conteúdo do tom), `name`, `isDefault`.
- Ordem: `list-brand-voices`, escolher o `isDefault: true` (ou o que o cliente indicar), `get-brand-voice`. Use para escrever post e textos de página no tom do cliente.

Alterar a marca da conta não faz parte desta skill (pedido separado, com aprovação). Registro do projeto: a operação de atualização da marca substitui a lista inteira de cores, fontes ou logos enviada.

## Widget de chat (domínio chat-widget)

### listChatWidget (read)
- Obrigatórios: `limit` (texto, até 100), `offset` (texto). Opcionais: `chatType` (ex.: `liveChat`, `allInOneChat`, `waChat`), `creationSource`.
- Resposta `{ chatWidgets: [{ _id, name, chatType, default, settings }], totalCount }`.
- `createChatWidget` (write) existe: corpo obrigatório `chatType` (pela API só `liveChat` ou `emailChat`; outro valor dá 422) e `name`, mais `settings` (textos, cor `widgetPrimaryColor`, `locale` com `pt-br`, `widgetPlacement` `sticky` ou `embedded`). A configuração do chat é das skills de conversas; aqui só se coloca o widget na página (navegador).

## Busca, se precisar

`search_operations` com `domains` `funnels`, `blogs`, `medias`, `links`, `brand-boards` ou `chat-widget`, `limit` 5 a 10. Nenhuma operação desta lista veio com `scopeFilteredCount` em 03/11/2026.
