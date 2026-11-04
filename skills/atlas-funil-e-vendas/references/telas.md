# Telas de funil e vendas (plano B no navegador)

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Confirme o nome da conta na tela antes de clicar.

| Tela | Endereço ou cliques | Fonte |
| --- | --- | --- |
| Funis e etapas (criar, editar, reordenar) | `crm-settings`, ou Configurações > Oportunidades & Pipelines (conferido em 03/11/2026). Também Oportunidades > Pipelines (`opportunities/pipeline`) (conferido em 03/11/2026) | Guia de construção do repositório Atlas; Central de ajuda "Como criar um pipeline" |
| Motivos de perda | Cadastrar ou editar: não disponível nas telas conferidas em 03/11/2026 (não há tela de motivos de perda em Configurações > Oportunidades & Pipelines nem na busca global). Ler: pelo conector (`get-lost-reason`) | telas-conferidas-2.md |
| Oportunidades (quadro) | Menu lateral > Oportunidades > seletor do funil. Endereço `opportunities/list` (redireciona para `opportunities`); abas "Oportunidades", "Previsão", "Pipelines", "Ações em massa"; botões "Importar", "Adicionar oportunidade", "Filtros avançados", "Gerenciar campos" (conferido em 03/11/2026) | Central de ajuda "Como criar uma oportunidade" |
| Visualização em lista | Oportunidades > opção de lista | Central de ajuda "Como usar a visualização em lista" |
| Filtros | Oportunidades > painel de filtros: funil, etapa, status, responsável, valor, data, tags | Central de ajuda "Como filtrar oportunidades" |
| Campos da oportunidade | Abrir a oportunidade > lateral esquerda > Adicionar/Gerenciar campos | Central de ajuda "Como criar campos personalizados em oportunidades" |
| Permissões de funil | Configurações do funil > seção de acesso por usuário ou equipe | Central de ajuda "Permissões de pipeline" |
| Tarefas | Área de tarefas do CRM, filtrar por responsável e status | Central de ajuda "Gestão unificada de tarefas" e "Tarefas recorrentes" |

## Passo a passo: criar funil

1. Abra **Configurações > Oportunidades & Pipelines** (`crm-settings`) (conferido em 03/11/2026).
2. Aba "Pipelines" (`settings/pipeline`) > "Criar pipeline" (conferido em 03/11/2026) e dê um nome claro para a equipe.
3. Adicione as etapas na ordem da venda. Cada etapa é um avanço real (entrada, primeiro contato, proposta, fechamento).
4. Não crie etapa Perdido: perdido é status com motivo (ver `funil-modelo-atlas.md`).
5. Salve. Me avise: eu confiro o funil aqui na conversa e crio uma oportunidade de teste, se você quiser.

## Cadastrar motivos de perda

Tela não disponível nas telas conferidas em 03/11/2026 (não há tela de motivos de perda em Configurações > Oportunidades & Pipelines nem na busca global). Não entregue passo a passo de tela.

1. Mostre ao cliente os motivos que já existem (`get-lost-reason`).
2. Se um deles serve, use. Se não, anote o detalhe na oportunidade e peça ao suporte da Atlas o cadastro do motivo novo (`references/_comum/glossario.md`).
3. Depois do cadastro, eu confiro a lista aqui na conversa.
