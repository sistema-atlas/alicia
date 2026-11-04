# Operações do MCP: automações

Com o cliente, nunca diga "API nova" nem "beta": diga "edição automática de automações".

Todas conferidas com `describe_operation` em 03/11/2026. Leituras executadas de verdade só na conta de teste da Atlas. Escritas só com `dryRun: true`.

Observação geral: o `dryRun` devolve `authorizationVerified: false`. A pré-visualização mostra o pedido montado, mas não garante que a conta aceita. A primeira execução real pode falhar por permissão.

## Leitura

### get-workflow
- Faz: lista todas as automações da conta. Funciona mesmo quando a API nova está fechada (testado: devolveu a lista na conta Atlas enquanto as outras davam 403).
- Parâmetros: nenhum além do `locationId`.
- Resposta: `workflows[]` com `id`, `name`, `status` (`draft` ou `published`), `version`, `createdAt`, `updatedAt` e `uiUrl` (link direto do construtor, já no domínio da conta).
- Handoff do conector: mostre nome com link (`uiUrl`) e status. Não mostre IDs sem pedido. Use o `uiUrl` como veio, nunca reescreva.
- Não traz gatilho nem passos. Para isso, `get-workflow-definition` ou navegador.
- kind: read. Aprovação: não.

### search-workflows
- Faz: busca automações por nome, status, tipo, pasta, quem alterou ou datas. Só resumo.
- Corpo: `filters[]` com `field` (`workflowId`, `name`, `status`, `type`, `customObjectType`, `folderId`, `updatedBy`, `createdAt`, `updatedAt`), `operator` (`eq`, `not_eq`, `in`, `contains`, `not_contains`, `gt`, `gte`, `lt`, `lte`) e `value`. Até 20 filtros, combinados com E. `sort[]`, `limit` (padrão 20), `offset` ou `searchAfter` (nunca os dois).
- Exemplo: `{"filters":[{"field":"status","operator":"eq","value":"draft"}],"limit":10}`
- Pegadinha: é POST, mas é leitura. Exige a API nova: na conta Atlas respondeu 403 `WORKFLOW_API_NOT_ENABLED_FOR_LOCATION`. Sem ela, use `get-workflow` e filtre na conversa.
- kind: read. Aprovação: não.

### get-workflow-definition
- Faz: lê a automação completa (gatilhos, passos, filtros, configurações).
- Parâmetro obrigatório: `workflowId` (path).
- Resposta: `definition`, `status`, `warnings[]` (com `message`, `path`, `type`), `workflowId`.
- Pegadinha: o objeto `definition` volta inteiro e é aceito do jeito que veio pela gravação de definição (vai e volta). O campo `version` da definição é o contador da automação: mande de volta sem mexer. É ele que impede sobrescrever uma edição feita no construtor ao mesmo tempo.
- Os `warnings` já apontam problemas: use na auditoria.
- Exige a API nova (403 na conta Atlas).
- kind: read. Aprovação: não.

### get-workflow-step-types
- Faz: lista os gatilhos e ações disponíveis na conta, cada um com o esquema completo de campos e os `assetReferences` (campos que precisam de ID de algo que já existe: tag, calendário, modelo, formulário).
- Parâmetros (query): `kind` (`action` ou `trigger`), `types` (chaves separadas por vírgula; busca parcial só na chave: `email` traz `send_email`), `query` (texto livre em tipo, nome e descrição; ignorado se mandar `types`), `limit` (padrão 20), `skip`.
- Resposta: `stepTypes[]`, `notFound[]` (termos sem resultado), `total`, `warnings`.
- Economia: cada item traz o esquema inteiro. Use `limit` 3 a 5 e `types` ou `query` sempre.
- Exige a API nova (403 na conta Atlas).
- kind: read. Aprovação: não.

### get-contact
- Faz: lê um contato pelo ID (tags, campos, não perturbe, responsável).
- Parâmetro obrigatório: `contactId`.
- Uso aqui: diagnóstico de "por que não entrou". Contato só por nome: `atlas-contatos` (`search-contacts-advanced`), ver `references/_comum/achar-contato.md`. Notas: `atlas-contatos` (`get-all-notes`) (tem a tag? o campo está preenchido? está em não perturbe?).
- kind: read. Aprovação: não.

### get-duplicate-contact
- Faz: acha contato por e-mail ou telefone exato (também nos telefones extras; testado na conta Atlas em 03/11/2026). Padrão de `_comum/achar-contato.md`.
- Parâmetros: `email` ou `number` (formato E.164, ex.: `+5541999999999`), mandados **sem codificar**. Resposta `contact: null` quando não há.
- kind: read. Aprovação: não.

## Escrita (sempre `dryRun: true` antes, depois aprovação)

### add-contact-to-workflow
- Faz: coloca um contato numa automação.
- Obrigatórios (path): `contactId`, `workflowId`.
- Corpo opcional: `eventStartTime` (ISO 8601). Útil em automação que conta tempo a partir de um evento (ex.: data do agendamento).
- Resposta: `succeded` / `succeeded`.
- Uma chamada coloca **um** contato. Mais de 20: não faça um por um. Caminho viável: tag em massa pela `atlas-contatos` (`CONFIRMO MASSA`) e automação com gatilho de tag (receita 5), ou a inscrição em massa da tela do construtor (a conferir no navegador). Contagem do público pela `atlas-contatos` com `pageLimit: 1` e `total`.
- Pegadinha: não diz se o contato já estava na automação, nem se a automação está publicada. Confira o status com `get-workflow` antes. Em rascunho, o contato não anda.
- Se a automação envia mensagem: aprovação reforçada `CONFIRMO ENVIO` (regra 3 do SKILL.md).
- kind: write. idempotencyKey: sim. Aprovação: sim.
- Testado: `dryRun` montou `POST /contacts/{contactId}/workflow/{workflowId}`.

### delete-contact-from-workflow
- Faz: tira um contato de uma automação.
- Obrigatórios (path): `contactId`, `workflowId`. Corpo opcional `eventStartTime`.
- kind: delete (destructiveHint: true). idempotencyKey: sim. Aprovação simples para um contato; reforçada `CONFIRMO MASSA` para mais de 20. Avise que o que já foi enviado não volta.

## Existe no catálogo, esta conexão não tem permissão

Em 03/11/2026, `search_operations` no domínio `workflows` respondeu `scopeFilteredCount: 7`. Buscas por escrita ("update workflow definition publish", kind write) voltaram vazias com `zeroResultReason: scope_filtered`. Ou seja: as operações de criar, alterar definição e publicar automação existem, mas esta conexão não enxerga. Os nomes exatos não foram vistos, então **não cite nome de operação de escrita de automação**.

O que fazer:
1. Se o cliente reconectar o conector dando todas as permissões e a conta tiver a API nova liberada, rode `search_operations` com `domains: ["workflows"]`, `kind: "write"`, `limit: 5` e use o que aparecer, depois de `describe_operation`.
2. Até lá: criar, editar, publicar e pausar é pelo navegador (`telas.md`).

Regras da API nova (do describe e do artigo 155000009502 da central de ajuda do fornecedor, verificado em 03/11/2026): liberada por conta pelo suporte da plataforma (beta fechado); gravação só com a automação em rascunho; a gravação substitui a definição inteira.

## Erros vistos

| Erro | Significado | O que fazer |
| --- | --- | --- |
| 403 `WORKFLOW_API_NOT_ENABLED_FOR_LOCATION` | API nova não liberada nesta conta. "Não é problema de token nem de escopo" (mensagem do servidor) | Navegador. Não repita a chamada na mesma conversa |
| `scope_filtered` na busca | Operação existe, conexão sem permissão | Navegador, ou reconectar com todas as permissões |
