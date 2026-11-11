# Telas: relatórios e painéis

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Se o cliente usa outro domínio, use o que aparece na aba dele. Confirme o nome da conta na tela antes de clicar.

Fonte: conferência na conta Atlas em 03/11/2026 (`fabrica/telas-conferidas.md` e `telas-conferidas-2.md`) e `docs/navegacao-crm/sites-e-funis.md` (05/10/2026).

| Tela | Endereço direto | Cliques a partir do menu | Estado |
| --- | --- | --- | --- |
| Painel de controle (painéis nativos) | `dashboard` | Painel de controle | (conferido em 03/11/2026); seletor do painel, "+ Novo", "Últimos 30 dias", "Resumo do painel", "Editar painel", ícone "Send as report", "Mais ações" ("Duplicar", "Duplicar em outra conta", "Carregar modelo de painel", "Definir como painel padrão", "Gerencie o fuso horário do painel", "Gerenciar acesso", "Excluir"), "Filtros rápidos" |
| Editar painel e adicionar widget | `dashboard/<dashboardId>/edit` | Painel de controle > "Editar painel" | (conferido em 03/11/2026); aviso "Your changes save automatically" (salva sozinho, sem botão Salvar); abas "Widget" e "Temas"; subabas "Incorporado", "Estatísticas personalizadas", "Elementos"; "Pesquisar widgets"; "Navegar por categoria"; "Explorar métricas personalizadas" |
| Relatórios | `reporting/reports` | Relatórios | (conferido em 03/11/2026); abas "Relatórios personalizados", "Google Ads report", "Relatório de anúncios Meta (Anúncios do Facebook)", "Relatório de atribuição", "Relatório de ligações", "Relatório de agente", "Relatório de compromissos" |
| Relatório agendado por e-mail | `dashboard` | Painel de controle > ícone "Send as report" | caminho (conferido em 03/11/2026) (fica no painel, não em Relatórios); janela "Send as report" (ícone de aviãozinho no topo do painel) (conferido em 04/11/2026): "Envie por e-mail ou programe este painel como um relatório"; os widgets viram um relatório novo em relatórios personalizados, e mudanças no painel não o atualizam; opções "Personalizar", "Exportar", "Envie ou agende"; botões "Cancelar" e "Create and send" |
| Analytics de páginas e funis | `analytics` | Sites > Analytics | visto em 05/10/2026 |
| Analíticos de formulários | `form-builder/main`, subaba Analíticos | Sites > Formulários > Analíticos | visto em 05/10/2026 |

Analytics de Sites mostra visualizações, inscrições, vendas (R$) e taxa de conversão das páginas feitas no CRM, com filtro de período (padrão últimos 14 dias). Use para "quantas visitas a página teve".
