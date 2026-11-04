# Como usar o conector Atlas CRM

O conector tem 4 ferramentas e mais de 550 operações.

| Ferramenta | Uso |
| --- | --- |
| `list_locations` | Lista as contas que este login alcança. Com `query`, filtra por nome |
| `search_operations` | Acha a operação pela intenção, em inglês simples ("search contacts", "update opportunity"). Use `limit` 5 e `domains` para economizar |
| `describe_operation` | Mostra parâmetros, corpo, exemplo e regras de segurança de uma operação |
| `execute_operation` | Executa. `locationId` sempre. `dryRun: true` para pré-visualizar. `idempotencyKey` em escrita |

## Economia de token

1. Comece pelo `references/operacoes.md` da skill: ele já tem o operationId e os parâmetros. Só use `search_operations` se a operação não estiver lá ou der erro de nome.
2. `search_operations` sempre com `limit` de 5 a 10 e `domains` quando souber o domínio. Sem isso, a resposta fica enorme.
3. Em listagens, peça só o necessário: `limit` e filtros. Não pagine a conta inteira para responder uma pergunta de contagem se a resposta já trouxer o total.
4. Guarde na conversa os IDs já descobertos (funil, etapas, campos, calendário). Não busque de novo.

## Consultas que usam POST

Algumas consultas são feitas por POST e o catálogo marca como `write` com `requiresApproval: true` (por exemplo listar posts ou comentários). Se o resumo da operação é claramente de consulta ("Get", "List", "Search") e o escopo exigido termina em `.readonly`, trate como leitura: execute sem pedir aprovação ao cliente, mandando `idempotencyKey` se o describe exigir. Na dúvida, trate como escrita.

## Respostas com handoff

Algumas operações trazem um campo `handoff` com instruções de como responder e um `uiUrl` (link da tela). Siga o handoff, mas nunca repasse ao cliente nome do fornecedor da plataforma nem link com domínio do fornecedor: troque qualquer rótulo como "View in HighLevel" por "Abrir no Atlas CRM". Use o `uiUrl` só se o domínio for da Atlas (crm.atlasoficial.com ou links.atlasoficial.com); se não for, monte o link pelo caminho de `references/telas.md`.

## Erros comuns

| Erro | O que fazer |
| --- | --- |
| 401 ou 403 de autorização | O login venceu ou falta permissão. Peça para o cliente reconectar o conector Atlas CRM |
| 403 `WORKFLOW_API_NOT_ENABLED_FOR_LOCATION` | API de automações não liberada nesta conta. Use o navegador |
| `scope_filtered` na busca | A operação existe, mas esta conexão não tem permissão. Navegador, ou reconectar dando todas as permissões |
| `not_offered_by_this_connector` | O conector não oferece. Diga que não dá por aqui; navegador se a tela existir |
| 400 ou 422 | Parâmetro errado. Rode `describe_operation` e corrija. Não chute |
| 429 | Muitas chamadas. Espere e siga em lotes menores |
