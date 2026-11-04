# Operações do atendente

Conferidas com `describe_operation` e executadas em leitura na conta de teste da Atlas em 03/11/2026.

O atendente quase não chama operação: ele confirma a conta e entrega o trabalho para a skill da área. Cada skill de área tem o próprio `operacoes.md`.

| Ferramenta ou operação | Tipo | O que faz | Parâmetros | Aprovação |
| --- | --- | --- | --- | --- |
| `list_locations` | ferramenta do conector | Lista as contas que o login alcança | `query` (nome, opcional), `pageToken` | Não |
| `get-location` | leitura (`kind: read`) | Dados da conta: nome, cidade, fuso, domínio, moeda, configurações | `locationId` na chamada | Não |

## list_locations

- Resposta: `items[]` com `locationId`, `name` e às vezes `address`, mais `nextStep`.
- Quando vier mais de uma conta, pergunte qual. Mostre só os nomes. Não liste todas as páginas se o cliente já disse o nome: use `query`.
- Uma conta com "(Demo)", "(Desativada)" ou nome parecido não é a conta do cliente só porque o nome bate. Confirme.

## get-location

- `execute_operation` com `operationId: "get-location"`, `locationId` e `params: {}`.
- Resposta em `data.location`. Campos úteis:
  - `name`, `city`, `state`, `timezone` (ex.: `America/Sao_Paulo`), `currency`, `locale`
  - `domain`: domínio próprio da conta, usado nos links de tela que o conector devolve
  - `companyId`: necessário em `search-users` (skill atlas-conta-e-equipe e atlas-raio-x)
  - `settings.allowDuplicateContact` e `settings.contactUniqueIdentifiers`: regra de contato duplicado
  - `permissions`: módulos ligados na conta (ex.: `workflowsEnabled`, `socialPlanner`)
- A resposta traz e-mail e telefone do dono da conta. Não repita sem necessidade.

## Pegadinhas

- O servidor coloca o `locationId` na chamada. Mesmo assim, passe sempre o confirmado.
- Se a resposta de qualquer operação trouxer `locationId` diferente do confirmado, pare e descarte.
