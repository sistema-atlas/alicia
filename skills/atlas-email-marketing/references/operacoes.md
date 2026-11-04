# Operações do MCP: e-mail marketing

Todas vistas em `search_operations` (domínios `emails`, `brand-boards`, `locations`, `users`) e conferidas com `describe_operation` em 03/11/2026. Leituras executadas de verdade na conta de teste da Atlas; escritas só com `dryRun: true`. O dryRun montou cada requisição sem erro, mas **não valida IDs, corpo nem permissão** (aceitou IDs inventados no teste, `authorizationVerified: false`).

`previewUrl` e `editorContentUrl` usam endereço técnico do fornecedor: **nunca mostre ao cliente**. Use para você ler o conteúdo (ferramenta de leitura de página) e entregue ao cliente o caminho da tela. Passe sempre `locationId` no `execute_operation`.

Resumo: o MCP cria, edita, importa e organiza modelos; cria e edita campanhas em rascunho; agenda ou inicia campanha; lê estatísticas; lê e edita a marca. **Não existe operação** para pausar ou cancelar campanha, listar pastas separadamente (use `list-email-templates`), enviar teste pelo editor, nem configurar domínio de envio.

## Modelos

### list-email-templates (leitura)
- GET `/emails/locations/{locationId}/templates`.
- Parâmetros: `include` (`all`, `templates`, `folders`; padrão `all`), `folderId` (`root` para o topo), `search` (nome), `archived`, `limit` (máximo 20, padrão 10), `offset`, `sortBy` (`updatedAt`), `sortOrder`.
- Resposta: `{ items: [{ id, name, type (template ou folder), editorType, isPlainText, parentFolderId, previewUrl, childCount, updatedAt }], total }`.
- `editorType` pode vir `html`, `text` ou **`builder`** (construtor visual de blocos; visto em 2 modelos da conta de teste). `builder` não se cria nem se edita com HTML pelo conector sem perder o layout: navegador.
- Na conta de teste: `total` 14, com pastas e modelos misturados. Pasta vem com `type: folder` e `childCount`.

### get-email-template (leitura)
- GET `/emails/locations/{locationId}/templates/{templateId}`. Obrigatório: `templateId`.
- Resposta: `name`, `subject`, `fromName`, `fromEmail`, `previewText`, `editorType`, `editorContentUrl` (link do conteúdo), `parentFolderId`.

### create-email-template (escrita)
- POST `/emails/locations/{locationId}/templates`. kind: write, aprovação, `idempotencyKey`.
- Obrigatórios: `name`, `editorType` (`html` ou `text`).
- Opcionais: `editorContent` (HTML ou texto), `subjectLine`, `previewText`, `fromName`, `fromEmail`, `parentFolderId`, `userId`.
- Resposta: `id`, `previewUrl` e os campos acima. dryRun montou a requisição (não valida).
- `editorType: html` cria modelo de código. O construtor visual de arrastar blocos é pelo navegador.

### update-email-template (escrita)
- PATCH `/emails/locations/{locationId}/templates/{templateId}`. Obrigatório: `templateId`.
- Corpo: `name`, `subjectLine`, `previewText`, `fromName`, `fromEmail`, `archived`, `parentFolderId` (`null` volta para o topo), `editorContent` com `editorType` (sempre os dois juntos; substitui o conteúdo).
- Uso: mudar assunto, mover de pasta, arquivar. Em modelo `builder`, mude só nome, assunto, prévia, remetente, pasta ou arquivar; conteúdo, pelo navegador.

### create-template-folder (escrita)
- POST `/emails/locations/{locationId}/templates/folders`. Obrigatório: `name`. Opcional: `userId`.

### import-email-template (escrita)
- POST `/emails/locations/{locationId}/templates/import`.
- Obrigatórios: `importProvider` (`mailchimp` ou `active_campaign`), `importUrl` (link público do modelo). Opcionais: `name`, `parentFolderId`.

### delete-email-template (exclusão)
- DELETE `/emails/locations/{locationId}/templates/{templateId}`. kind: delete, `destructiveHint: true`. `CONFIRMO EXCLUSÃO`, um por vez. Prefira arquivar.

## Campanhas

### list-email-campaigns (leitura)
- GET `/emails/locations/{locationId}/campaigns/emails`.
- Parâmetros: `status` (`all`, `sent`, `failed`, `archived`, `draft`, `processing`, `scheduled`, `cancelled`, `paused`), `search`, `limit` (máximo 20), `offset`.
- Resposta: `{ campaigns: [{ id, name, status, campaignType, source, sourceId, variations }], total }`. Na conta de teste: 0 campanhas.

### get-email-campaign (leitura)
- Obrigatório: `campaignId`. Resposta inclui `subject`, `fromName`, `fromEmail`, `replyToAddress`, `previewText`, `status`, `editorContentUrl`.

### create-email-campaign (escrita)
- POST `/emails/locations/{locationId}/campaigns/emails`.
- Obrigatórios: `name`, `editorType`, `timeZone` (use `America/Sao_Paulo` ou o fuso da conta), `userId`.
- Opcionais: `templateId` (criar a partir de um modelo), `editorContent`, `parentFolderId`, `userName`.
- Cria em rascunho. Não envia nada. Aprovação simples.

### update-email-campaign (escrita)
- PATCH `.../campaigns/emails/{campaignId}`. Só rascunho. Corpo: `name`, `editorContent` com `editorType`, `userId`.

### schedule-campaign (escrita que envia)
- POST `.../campaigns/emails/{campaignId}/schedule`. A campanha precisa estar em rascunho, cancelada ou pausada.
- Obrigatórios: `scheduleType` (`immediate`, `scheduled`, `batch`, `rss`, `smart_send`), `timeZone`, `userId`, `emailMeta` (`subject`, `fromName`, `fromEmail` obrigatórios; `replyToAddress`, `previewText`, `attachments`), `recipients`.
- `recipients.type`: `contact` (com `contactIds`), `tag` (com `tagIds`) ou `segment` (`engaged_last_7_days`, `engaged_last_30_days`, `engaged_last_60_days`, `engaged_last_5_campaigns`, `unengaged_last_5_campaigns`). `freezeList` (padrão verdadeiro) congela a lista no momento do agendamento.
- `scheduleConfig.sendAt` no formato `AAAA-MM-DD HH:MM AM` (exemplo do describe: `2026-04-01 09:00 AM`). Obrigatório exceto em `rss`. `sendDays` para `batch` e `rss`. `abTestConfig` para teste A/B de assunto ou conteúdo.
- dryRun montou a requisição com `recipients.type: tag` (não valida IDs).
- **Não existe "todos os contatos"** em `recipients.type`. Use uma tag que reúne o público ou um segmento de engajados.
- **Sempre `CONFIRMO ENVIO`** (e `CONFIRMO MASSA` antes, se mais de 20 destinatários). `immediate` sai na hora.

### Resultado de envios: olhe as três listas
- E-mail pode sair por campanha, por automação ou por ação em massa. Para "como foram meus e-mails": `list-email-campaigns` (`status: sent`), `list-workflow-campaigns` e `list-bulk-action-campaigns`, `limit` pequeno. Diga de onde veio cada número. Só diga "nenhum envio" quando as três vierem vazias.
- Conta de teste (03/11/2026): 0 campanhas, 6 campanhas de automação (`list-workflow-campaigns` com `total` 6; itens com `id`, `sourceId`, `name`, `status` `published` ou `draft`).

### get-campaign-stats (leitura)
- GET `.../campaigns/stats/{source}/{sourceId}`. `source`: `email-campaigns`, `workflow-campaigns` ou `bulk-actions`. `sourceId` vem da campanha. `subSourceId` só para automação (ID da etapa).

### list-bulk-action-campaigns e list-workflow-campaigns (leitura)
- E-mails enviados por ação em massa ou por automação. Filtros: `status`, `search`, `limit` (máximo 20), datas (`dateFrom`, `dateTo` na ação em massa). `get-bulk-action-campaign` e `get-workflow-campaign` leem um.

### delete-campaign (exclusão)
- DELETE `.../campaigns/emails/{campaignId}`. `CONFIRMO EXCLUSÃO`.

## IDs de apoio

### get-location (leitura)
- Dados da conta: `location.companyId`, `timezone`, `email`, `domain`. Conferido na conta de teste: traz `companyId` e `timezone: America/Sao_Paulo`. A resposta é grande: chame **uma vez** e guarde `companyId` e fuso na conversa. Não mostre o `domain` técnico ao cliente.

### search-users (leitura)
- Obrigatório: `companyId` (de `get-location`). `query` com nome ou e-mail de quem pede, `limit: "1"`. Resposta `users[]` com `id` (o `userId`). Conferido na conta de teste.
- De onde tirar o e-mail: pergunte uma vez ("Qual o seu e-mail de login no Atlas CRM?"), ou use um `assignedTo` já visto na conversa como `ids`. Guarde o `userId`; não busque de novo. Mostre só o nome.
- Não há operação de "usuário atual" neste conector (busca feita em 03/11/2026).

### get-location-tags (leitura)
- `{ tags: [{ id, name }] }`. Para `recipients.type: tag`, passe os IDs, não os nomes.

## Marca (Brand Board)

### list-design-kits e get-design-kit (leitura)
- `list-design-kits`: `limit` (máximo 20), `offset`, `search`. Use o kit com `isDefault: true`.
- `get-design-kit`: `designKitId`. Resposta: `colors` (com `id`, `hex`, `label`), `fonts`, `logos`.

### update-design-kit (escrita)
- PATCH `/brand-boards/locations/{locationId}/design-kits/{designKitId}`.
- Corpo: `name`, `colors` (`value`, `label`, `id`), `fonts` (`font`, `fallback`, `label`, `id`), `logos` (`url`, `label`, `id`).
- **Pegadinha do describe:** mandar `colors`, `fonts` ou `logos` **substitui a lista inteira**. Para manter um item, inclua com o `id`. Leia antes, monte a lista completa, mostre a diferença.
- `create-design-kit` (escrita): `name`, `colors`, `fonts`, `logos`; `type: url` com `url` extrai a marca de um site.
- `set-default-design-kit` (escrita): `designKitId`; troca o kit padrão da conta e desmarca o anterior. Aprovação simples, avisando que muda o padrão.
- `delete-design-kit`: DELETE, caminho `designKitId`, kind `delete`, `destructiveHint: true` (describe em 03/11/2026). Exclusão: `CONFIRMO EXCLUSÃO`.
- `list-brand-voices` (leitura): tom de voz salvo (`limit` até 20).

## Envio de teste

### send-a-new-message (de `atlas-conversas-e-disparos`)
- Com `type: Email`, `contactId` do contato do próprio cliente, `subject`, `html`, `emailTo` (precisa ser um e-mail desse contato). É envio real: `CONFIRMO ENVIO`.
- Use só quando o teste pelo editor (navegador) não for possível.
- Passo a passo: 1) ache o contato do próprio cliente pelo e-mail dele (`references/_comum/achar-contato.md`); se não existir, ofereça criar um contato com nome `TESTE ...` e tag `teste-assistente` (skill `atlas-contatos`), avisando que pode disparar automações. 2) Pegue o HTML do modelo abrindo o `editorContentUrl` de `get-email-template` com a ferramenta de leitura de página (não mostre o link). 3) Modelo `builder`: só teste pelo editor no navegador.
