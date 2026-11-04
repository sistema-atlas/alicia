# Painéis nativos (Dashboards) e relatório por e-mail

Não há operação no conector para painéis. Tudo aqui é navegador ou passo a passo para o cliente.

Fonte: conferência na conta Atlas em 03/11/2026 (`fabrica/telas-conferidas.md` e `telas-conferidas-2.md`): o menu se chama **Painel de controle** (`dashboard`), com seletor do painel, "+ Novo", "Editar painel", ícone "Send as report" e "Mais ações" (barra completa em `telas.md`). Relatórios fica em `reporting/reports`.

**Atenção: em "Editar painel" tudo salva sozinho.** A tela avisa "Your changes save automatically" e não tem botão Salvar. Cada widget adicionado, mudado ou tirado já está no ar para quem vê o painel. Regra 7b do SKILL.md: aprovação antes de cada mudança (`CONFIRMO PUBLICAÇÃO` se o time vê o painel), nunca testar widget em painel real, experimentar num painel novo. O resto vem dos títulos dos artigos da central do fornecedor: os nomes dos recursos são confiáveis, os cliques dentro do editor estão marcados `(a conferir no navegador)`.

## O que existe (pelos artigos)

| Recurso | Artigo de origem |
| --- | --- |
| Criar painel personalizado | how-to-create-a-custom-dashboard |
| Criar e adicionar widgets | how-to-create-add-dashboard-widgets, what-are-dashboard-widgets |
| Editar painel e widgets, duplicar widget | how-to-edit-a-dashboard, edit-widgets-on-the-dashboard, duplicating-widgets-on-a-dashboard |
| Métricas personalizadas | how-to-create-and-use-custom-metrics-for-dashboard-reports |
| Gráfico em tabela | how-to-use-table-charts-for-dashboard-widgets |
| Modelos de painel | how-to-create-dashboard-templates |
| Temas | how-to-customize-dashboard-themes |
| Permissões do painel | how-to-manage-dashboard-permissions |
| Painel padrão | how-to-set-a-default-dashboard |
| Fuso do painel | how-to-change-the-timezone-for-a-dashboard-logged-in-user |
| Só dados atribuídos ao usuário | how-to-use-only-assigned-data-setting-with-dashboard |
| Conteúdo externo embutido | how-to-embed-external-content-on-a-dashboard |
| Widgets de oportunidades (valor, conversão, etapas) | dashboard-opportunities-pipeline-value-conversion-rate-funnel-stages-distribution |
| Widget de pagamentos | payments-widget-dashboard |
| Widget de eficiência de vendas | how-to-add-and-utilize-the-new-sales-efficiency-widget-on-your-dashboard |
| Relatório de agendamentos | appointment-report |
| Resumo por IA do painel | dashboard-summary-ai |
| Relatório agendado por e-mail | configurar-relatorios-automaticos-por-email e o artigo do agendador de relatórios (report scheduler) |

## Receita: criar um painel

Passo a passo para o cliente ou para o Claude in Chrome (barra e editor conferidos em 03/11/2026; dentro de cada widget, a conferir no navegador):

1. Abra Painel de controle no menu (`dashboard`). Confirme o nome da conta.
2. Clique em "+ Novo" e dê um nome claro, por exemplo "Comercial do mês". Para ver os painéis que já existem, use o seletor do painel. Criar painel é escrita: aprovação simples antes.
3. "Editar painel" > aba "Widget" > "Pesquisar widgets" ou "Navegar por categoria". Antes de cada widget, mostre o que vai entrar e peça aprovação (regra 7b). Um widget por vez: ele já fica salvo ao ser adicionado.
4. Ajuste filtros de período e de funil em cada widget (também salva na hora).
5. Quem vê: "Mais ações" > "Gerenciar acesso". Painel padrão: "Mais ações" > "Definir como painel padrão". Os dois mudam o que o time vê: `CONFIRMO PUBLICAÇÃO`.
6. Confira recarregando a tela e comparando um número com o relatório feito pelo conector (ex.: leads do mês).

Quer experimentar um widget antes? Faça num painel novo de rascunho, nunca no painel que o time usa.

## Receitas de widget

Os nomes exatos das opções podem mudar; descreva o objetivo e confira na tela.

| Widget | Fonte de dados | Configuração | Para que serve |
| --- | --- | --- | --- |
| Leads novos | Contatos | Contagem, agrupar por dia ou semana, período do mês | Ver se a entrada está caindo |
| Leads por origem | Contatos | Contagem agrupada por origem (`source`) | Ver de onde vem lead; mostra "sem origem" se o rastreamento falta |
| Funil por etapa | Oportunidades | Contagem e valor por etapa, filtro do funil de vendas | Onde os negócios param |
| Valor ganho | Oportunidades | Soma de valor, status ganho, período | Resultado do mês |
| Taxa de conversão | Oportunidades | Conversão do funil (widget de oportunidades) | Eficiência do funil |
| Agendamentos | Agenda | Contagem por status (comparecido, faltou, cancelado) | Taxa de falta |
| Pagamentos | Pagamentos | Valor recebido no período | Caixa |
| Tabela por vendedor | Oportunidades | Gráfico em tabela, agrupar por responsável | Comparar o time |

Regra: sempre filtre o funil de vendas. Funil de suporte ou entrega distorce ganhos e conversão.

## Tempo de resposta

Não há leitura pelo conector. A galeria de widgets tem as categorias "Conversas" e "Chamadas" e a conta Atlas tem um widget "Eficiência de vendas" (conferido em 03/11/2026); se um deles mostrar tempo de resposta, use o painel (o conteúdo do widget, a conferir no navegador). Não invente o número.

## Painel externo da Atlas

A Atlas oferece um painel externo padrão alimentado pelos dados do CRM e embutido na tela de Dashboards (recurso "conteúdo externo"). Pedido de painel externo ou de ajuste nele vai para o suporte humano da Atlas (`references/_comum/glossario.md`). Não monte por conta própria.

## Relatório agendado por e-mail

Passo a passo (entrada conferida em 03/11/2026; a janela por dentro, a conferir no navegador):

1. Abra o Painel de controle (`dashboard`), escolha o painel e clique no ícone "Send as report" da barra do topo. Não fica em Relatórios.
2. Escolha o que vai no relatório, a frequência (ex.: toda segunda) e o horário.
3. Destinatários: e-mails do time. Para alguém de fora da empresa, `CONFIRMO ENVIO`.
4. Salve e peça para o cliente confirmar o primeiro e-mail recebido.

Se a tela não estiver disponível no plano da conta, diga isso e ofereça o relatório pela conversa toda semana, quando o cliente pedir.
