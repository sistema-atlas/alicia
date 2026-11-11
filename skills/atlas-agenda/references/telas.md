# Telas: agenda (plano B no navegador)

Endereço base do painel: `https://crm.atlasoficial.com/v2/location/<locationId>/` (conferido em 03/11/2026, fabrica/telas-conferidas.md). Se o cliente usa outro domínio, use o da aba dele. Link público de agendamento: `links.atlasoficial.com/widget/bookings/<slug>`.

| Tarefa | Endereço | Cliques | Rótulos vistos | Status |
| --- | --- | --- | --- | --- |
| Ver a agenda | `<base>calendars/view` | Menu lateral > Calendários > Visualização de calendário | "Hoje", "Visualização semanal", "Gerenciar visualização", "Novo"; filtros "Usuários", "Calendários", "Grupos" | (conferido em 03/11/2026) |
| Lista de compromissos | `<base>calendars/appointments` | Calendários > Visualização da lista de compromissos | não aberto | caminho (conferido em 03/11/2026) |
| Configurar calendários | `<base>settings/calendars` | Calendários > Configurações do calendário (ou Configurações > Calendários) | abas "Calendários", "Preferências", "Disponibilidade", "Conexões"; subabas "Calendários", "Menu de serviços", "Sala", "Equipamentos"; "+ Novo", "+ Novo grupo" | (conferido em 03/11/2026) |
| Editor de um calendário | mesma URL `settings/calendars` | lápis na linha do calendário | "Detalhes básicos", "Equipe e localização", "Disponibilidade", "Regras de reserva", "Configurações avançadas" (Formulário e Confirmação, Pagamentos, Notificações e Políticas, Aparência do widget, Canais de reserva); "Salvar alterações", "Voltar para a lista de calendários" | (conferido em 03/11/2026) |
| Lembretes e confirmações (plano B) | editor do calendário | lápis > Configurações avançadas > Notificações e Políticas | conteúdo não aberto | local (conferido em 03/11/2026) |
| Aparência do widget | editor do calendário | lápis > Configurações avançadas > Aparência do widget | conteúdo não aberto | local (conferido em 03/11/2026) |
| Código para pôr no site, link, QR | modal na lista | Configurações > Calendários > ícone de compartilhar na linha > "Compartilhar calendário" | abas "Link de programação", "Link único", "Incorporar código", "Código QR"; botão "Copiar" | (conferido em 03/11/2026) |
| Ligar Google Agenda ou Zoom | `<base>settings/calendars/connections` | Configurações > Calendários > Conexões | "Adicionar novo", blocos "Calendários conectados", "Google Agenda", aba "Videoconferência" | (conferido em 03/11/2026) |
| Agendas de conflito (não marcar em cima da agenda pessoal) | `<base>settings/calendars/connections` | Conexões > "Calendários de verificação de conflitos" | "Editar" | (conferido em 03/11/2026) |
| Permissões de calendário por usuário | `<base>settings/users` | Configurações > Usuários | não aberto | não verificado |

## Passo a passo: ligar o Google Agenda

Quem faz é o próprio usuário, logado na conta Google dele. O assistente não digita senha.

1. Abra `<base>settings/calendars/connections` (Configurações > Calendários > Conexões). Confirme o nome da conta no topo.
2. Clique em "Adicionar novo" e escolha Google Agenda.
3. Na janela do Google, o usuário escolhe a conta dele e aceita as permissões.
4. De volta à tela, confira o Google Agenda em "Calendários conectados".
5. Em "Calendários de verificação de conflitos", clique em "Editar" e marque a agenda pessoal para a Atlas não oferecer horário em cima de compromisso dela.
6. Para Google Meet nas reuniões: aba "Videoconferência" (conferido em 04/11/2026): título "Videoconferência", botão "+ Adicionar novo", blocos "Sala de conferência" e "Google meet" (com o e-mail conectado); ao lado fica a aba "Agendamento orgânico do Google" e, no calendário, `locationConfigurations` com `google_conference` (pelo MCP, `update-calendar`).
7. Confira pelo MCP: `get-slots` do calendário num dia em que a agenda pessoal tem compromisso; o horário ocupado não deve aparecer.

## Passo a passo: pôr a agenda no site

1. Configurações > Calendários > ícone de compartilhar na linha do calendário > "Compartilhar calendário".
2. Aba "Incorporar código" > "Copiar". Para link simples, aba "Link de programação".
3. Colar o código na página (skill `atlas-sites-e-blog`). Página no ar é `CONFIRMO PUBLICAÇÃO`.

## Sem navegador (Codex)

Entregue o passo a passo numerado com o endereço direto e peça ao cliente para avisar quando terminar. Depois, confira pelo MCP (`get-calendar`, `get-event-notification`, `get-slots`).
