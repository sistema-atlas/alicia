# Telas para várias unidades (plano B no navegador)

Endereço base de cada conta: `https://crm.atlasoficial.com/v2/location/<locationId>/`. O `locationId` muda por conta: confira o nome da conta na tela antes de clicar, em cada aba.

| O que | Tela | Recurso de cópia | Fonte |
| --- | --- | --- | --- |
| Trocar de conta | Seletor de conta no topo do menu lateral (conferido em 04/11/2026): abre "Procurar por uma subconta", "Mudar para Exibição da Agência" e as listas "RECENTE" e "TODAS AS CONTAS" | | |
| Painel | `dashboard` > "Mais ações" > "Duplicar em outra conta" | Existe na tela (conferido em 03/11/2026). Widgets cujos dados não existem na outra conta aparecem com erro e precisam ser trocados ou apagados | `atlas-relatorios-e-dashboards/references/telas.md`; artigo do fornecedor 155000001571 (duplicar painel em outra conta) |
| Funil e etapas | `opportunities/pipeline` (Oportunidades > aba Pipelines) (conferido em 04/11/2026) | Oportunidades > aba "Pipelines" (`opportunities/pipeline`) > menu de três pontos do funil > "Copiar para subcontas" (aparece para usuário da agência, a equipe da Atlas). A janela avisa que copia as fases e a visibilidade do gráfico e não copia registros, campos personalizados, permissões, tags inteligentes e automações; pede "Nome do pipeline" e "Selecionar subcontas"; botões "Cancelar" e "Copiar" (conferido em 04/11/2026 na conta Demo), sem copiar | artigo do fornecedor 155000007506 (copiar funil para outras contas) |
| Automação | `automation/workflows` (conferido em 03/11/2026) | Fica na lista de automações, não no construtor: menu de três pontos da linha > "Copiar para subconta" (usuário da agência, a equipe da Atlas). Abre "Selecionar subconta", "O fluxo de trabalho será copiado para a subconta selecionada", botões "Cancelar" e "Enviar" (conferido em 04/11/2026 na conta Demo), sem copiar. Pelo fornecedor, chega como rascunho e leva tags, campos, valores personalizados, funis e modelos de texto; o resto sai da automação (essa parte não aparece na tela) | `atlas-automacoes/references/telas.md`; artigo do fornecedor 155000001229 (copiar automação para outra conta) |
| Funil de páginas e site | `funnels-websites/funnels` | Menu de três pontos do funil > "Clonar" abre "Clonar funil" com "Nome do funil" e "Localização (selecione até 3 locais)", botões "Cancelar" e "Confirmar" (conferido em 04/11/2026), sem confirmar. Formulários e pesquisas usados na página podem precisar ser refeitos | `atlas-sites-e-blog/references/telas.md`; artigo do fornecedor 48001076117 (clonar funis e sites) |
| Formulário e pesquisa | `form-builder/main` (conferido em 03/11/2026) | Cópia entre contas não confirmada. Plano: recriar em B pela skill `atlas-formularios` | `atlas-formularios/references/telas.md` |
| Campo de lista | `settings/fields` > Criar campo (conferido em 04/11/2026) | Criar em B com as opções lidas em A | `atlas-campos-e-dados/references/telas.md` |
| Modelo de e-mail do construtor | `marketing/emails/all` (conferido em 03/11/2026) | Sem cópia direta para outra conta: no menu de três pontos do modelo, "Clonar" copia só dentro da mesma conta; "Compartilhar" gera um link ("Qualquer pessoa com o link", "Copiar link") que dá uma cópia do modelo a quem abrir (conferido em 04/11/2026), sem salvar | `atlas-email-marketing/references/telas.md` |
| Agenda | `settings/calendars` (conferido em 03/11/2026) | Conferir a agenda criada em B antes de ativar | `atlas-agenda/references/telas.md` |
| Base de conhecimento | `ai-agents/knowledge-base` | | `atlas-agentes-ia/references/telas.md` |
| Produtos | `payments/products` (conferido em 03/11/2026) | | `atlas-cobrancas-e-contratos/references/telas.md` |

## Quando o recurso de cópia não aparece para o cliente

Diga: "A cópia direta entre contas costuma ficar só com a equipe da Atlas. Posso montar em <Nome de B> pelo seu navegador, ou você pede a cópia ao suporte da Atlas." Entregue o contato do suporte de `_comum/glossario.md` e um resumo pronto (conta de origem, conta de destino, item). Não prometa prazo.

## Passo a passo: recriar em B pelo navegador

1. Abra a tela do item na conta A e leia (texto da página, sem print) o que precisa ser copiado.
2. Abra a mesma tela na conta B, em outra aba, e confira o nome da conta B.
3. Monte o item em B. Antes de salvar, publicar ou ativar: aprovação com o nome da conta B.
4. Salve como rascunho quando houver essa opção.
5. Confira pelo conector (quando houver leitura) ou recarregando a tela em B.
