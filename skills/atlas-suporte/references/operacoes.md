# Operações do suporte

Esta skill responde pela central de ajuda e não precisa do conector para isso. Quando o cliente quer que o assistente faça a tarefa, quem chama as operações é a skill da área.

| Operação | Tipo | Uso aqui | Conferida |
| --- | --- | --- | --- |
| `list_locations` | ferramenta do conector | Saber o nome da conta para o resumo de handoff, se o atendente ainda não confirmou | executada em 03/11/2026 |
| `get-location` | leitura | Nome da conta e domínio para montar link de tela (`data.location.name`, `data.location.domain`) | `describe` e execução em 03/11/2026 |

Nenhuma escrita. Se o cliente pedir "faz para mim", a skill da área pede `dryRun` e aprovação.
