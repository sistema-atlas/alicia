# Telas do raio-x

Endereço base: `https://<domínio da conta>/v2/location/<locationId>/`. O domínio vem de `get-location` (`domain`) ou do `uiUrl` das automações. Use as telas para dar link ao cliente e para as verificações que o conector não alcança.

| Área | Caminho | Fonte |
| --- | --- | --- |
| Funis e etapas (configuração) | `crm-settings` (Configurações > Oportunidades & Pipelines) (conferido em 03/11/2026) | tela |
| Motivos de perda | sem tela própria encontrada na conferência de 03/11/2026; ler pelo conector (`get-lost-reason`), cadastrar pelo suporte da Atlas | telas-conferidas-2.md |
| Campos personalizados | `settings/fields` (Configurações > Campos personalizados) (conferido em 03/11/2026) | tela; artigo "Como criar campos personalizados em oportunidades" (Configurações > Campos personalizados) |
| Uma automação | `automation/workflow/<id>` | `uiUrl` devolvido por `get-workflow` |
| Formulários | `form-builder/main` (conferido em 03/11/2026) | tela |
| Pesquisas | `survey-builder/main` (conferido em 03/11/2026) | tela |
| Widget de chat | `funnels-websites/chat-widget` (conferido em 03/11/2026) | tela |
| Kit da marca (logo, cores e fontes) | `marketing/brand-boards`, Configurações > Brand Boards (conferido em 03/11/2026) | tela |
| Contatos | menu Contatos, `contacts/smart_list/All` (conferido em 03/11/2026) | artigo "Como criar um novo contato" |
| Oportunidades | menu Oportunidades, `opportunities/list` (conferido em 03/11/2026) | artigo "Como filtrar oportunidades" |
| Conversas | menu Conversas, filtro "Não lidos", `conversations/conversations` (conferido em 03/11/2026) | artigo "Como filtrar conversas" |
| Regra de duplicados | Configurações > Perfil da empresa > rolar até o fim, bloco "Preferências de Desduplicação de Contatos", `settings/company` (conferido em 03/11/2026) | artigo "Como ajustar preferências de contatos duplicados" |
| Usuários | Configurações > Usuários, `settings/users` (conferido em 03/11/2026) | artigo "Como gerenciar acessos de usuários" |
| WhatsApp | Configurações > WhatsApp, `settings/whatsapp` (conferido em 03/11/2026) | artigo "Como conectar o WhatsApp" |
| Base de conhecimento | Agentes de AI > Base de Conhecimento, `ai-agents/knowledge-base` (conferido em 03/11/2026) | tela |
| Agendas | Calendários, `calendars/view`; configuração em `settings/calendars` (conferido em 03/11/2026) | tela |
| Redes sociais | Marketing > Planejador Social, `marketing/social-planner` (conferido em 03/11/2026) | tela |
