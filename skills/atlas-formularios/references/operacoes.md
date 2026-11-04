# Operações do MCP: formulários, pesquisas e quizzes

Todas conferidas com `describe_operation` em 03/11/2026. Leituras executadas de verdade na conta de teste da Atlas; escritas só com `dryRun: true`. Passe sempre `locationId` no `execute_operation`.

Resumo: o MCP **lê** formulários, pesquisas e envios. **Não existe operação para criar, editar, duplicar ou publicar** formulário, pesquisa ou quiz. Isso é navegador.

## Leitura (faz direto)

### get-forms
- Lista formulários da conta. GET `/forms/`.
- Parâmetros: `limit` (padrão 10, máximo 50), `skip`, `type` (ex.: `folder` para listar pastas).
- Resposta: `{ forms: [{ id, locationId, name }], total }`.
- Uso: pegar o `formId` pelo nome. Guarde na conversa.

### get-surveys
- Lista pesquisas. GET `/surveys/`.
- Parâmetros: `limit` (padrão 10, máximo 50), `skip`, `type`.
- Resposta: `{ surveys: [{ id, locationId, name }], total }`.
- Quizzes: não confirmado se aparecem nesta lista. Na conta de teste não havia quiz para conferir. Se o quiz não aparecer, diga que a leitura do quiz é pela tela (Sites > Testes > Envios).

### get-forms-submissions
- Envios de formulário. GET `/forms/submissions`.
- Parâmetros (todos opcionais): `formId`, `startAt` e `endAt` (AAAA-MM-DD; padrão: último mês até hoje), `q` (contactId, nome, e-mail ou telefone), `limit` (padrão 20, máximo 100), `page`. Para o histórico inteiro, mande `startAt` 2020-01-01 e `endAt` de hoje. A ordem dos envios não está documentada: para a data do último envio com total maior que 1, confira o `createdAt` mais recente da página lida.
- Resposta: `{ submissions: [...], meta: { total, currentPage, nextPage, prevPage } }`.
- Cada envio traz `contactId`, `formId`, `createdAt`, `name`, `email` e `others`. Em `others`: as respostas por chave do campo (campos nativos por nome, como `full_name`, `phone`, `email`; campos personalizados pelo **ID do campo**), `eventData` (origem da sessão: `source`, `referrer`, `page.url`, `medium`, `fbp`, `fbc`, `gaClientId`), `Timezone`, `fieldsOriSequance` (ordem dos campos).
- Para contar envios, use `limit: 1` e leia `meta.total`. Não pagine para contar.
- Para traduzir ID de campo em nome, cruze com `get-custom-fields`.
- Dados pessoais vêm na resposta. Mostre só o que o cliente pediu.
- Respostas de upload trazem a URL do arquivo num domínio técnico. Não mostre a URL crua: diga "arquivo enviado" e, se o cliente pedir, entregue o caminho da tela de Envios (Sites > Formulários > Envios) no domínio da conta.
- Para achar o contato de um envio pelo nome, e-mail ou telefone: `references/_comum/achar-contato.md`.

### get-surveys-submissions
- Respostas de pesquisa. GET `/surveys/submissions`.
- Parâmetros: `surveyId`, `startAt`, `endAt`, `q`, `limit` (máximo 100), `page`.
- Resposta: `{ submissions: [{ id, contactId, surveyId, name, email, createdAt, others }], meta }`.

### get-custom-fields
- Campos personalizados. GET `/locations/{locationId}/customFields`.
- Parâmetro: `model` (`contact`, `opportunity`, `all`).
- Resposta grande: `{ customFields: [{ id, name, fieldKey, dataType, picklistOptions, ... }] }`. Leia uma vez e guarde.
- **Não traz os campos padrão do contato** (nome, sobrenome, e-mail, telefone, data de nascimento, endereço, cidade, estado, CEP, país, empresa, site, origem). Confira a lista padrão na aba Adicionar campos de objeto antes de dizer que um campo não existe ou de pedir um campo novo.
- Se o pedido é só contar ou listar envios e o total é 0, não leia os campos.
- Uso: conferir se o campo de cada pergunta existe e quais opções ele tem, antes de montar. Se a opção do cliente for diferente de `picklistOptions`, pergunte.

### list-design-kits e get-design-kit
- Marca da conta (cores, fontes e logo). `list-design-kits`: `limit` (máximo 20), `offset`, `search`, `deleted`. Resposta `{ items: [{ id, name, isDefault }], total }`.
- `get-design-kit`: `designKitId` (obrigatório). Resposta com `colors` (hex, label), `fonts`, `logos`.
- Use o kit com `isDefault: true`. Não edite a marca por aqui: isso é pedido separado.

### get-contact e get-duplicate-contact
- `get-contact`: `contactId` (obrigatório). Use para conferir o contato criado no envio de teste: campos, `source`, tags.
- `get-duplicate-contact`: `email` ou `number` (exato; telefone em E.164), mandados **sem codificar**. Resposta `contact: null` quando não há. Ver `_comum/achar-contato.md`.

## Escrita (dryRun, aprovação)

### upload-media-content
- Sobe arquivo para a Mídia da conta (logo, banner do formulário). POST `/medias/upload-file`, multipart.
- Dois modos: `file: { fileName, mimeType, base64 }` com os **bytes exatos** do arquivo, ou `hosted: true` com `fileUrl` (URL pública HTTPS; o arquivo continua hospedado fora).
- Limite pelo conector: 25 MB por arquivo, inclusive vídeo (fonte: descrição da operação).
- Pegadinha do describe: anexo do chat **não chega sozinho** ao conector. Se não houver como obter os bytes exatos com uma ferramenta de arquivo, não invente base64: responda em português: "Não consigo passar o anexo do chat direto. [Abrir a Mídia no Atlas CRM](<link>) e subir <arquivo>." O link é o `uiUrl` de `fetch-media-content`, só se o domínio for o da Atlas ou do cliente; se não for, monte com o domínio da aba do cliente e `/v2/location/<locationId>/media-storage`. Nunca use o rótulo de link nem o texto sugerido pelo conector (vem em inglês e com nome do fornecedor).
- kind: write, `requiresApproval: true`, `idempotencyKey` obrigatório. dryRun montou a requisição (não valida no servidor).
- Detalhes de Mídia: skill `atlas-sites-e-blog`.

## O que o MCP não faz (navegador)

| Tarefa | Onde |
| --- | --- |
| Criar, editar, duplicar, renomear, excluir formulário | Sites > Formulários (`telas.md`) |
| Criar e editar pesquisa, layout uma por tela, ramificação | Sites > Pesquisas |
| Quiz: perguntas, pontos, faixas, páginas de resultado | Sites > Testes |
| CSS personalizado, cores, temas | Painel Estilos e Opções do construtor |
| Redirecionar após envio, mensagem final, notificações | Configurações do construtor |
| Código de incorporação e link | Menu do formulário > Compartilhar (ou Integrar) |
| Configurações gerais (criar chat, PDF, contato fixo) | Sites > Formulários > Configurações |

## Busca, se precisar

`search_operations` com `domains: ["forms"]` ou `["surveys"]`, `limit: 5`. Em 03/11/2026 os dois domínios tinham só estas 4 operações, todas de leitura, sem `scopeFilteredCount`.
