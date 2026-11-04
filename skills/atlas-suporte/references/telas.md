# Telas citadas nos artigos

Caminhos como os artigos da central descrevem (texto de menu). Quando há caminho de endereço confirmado, ele aparece na terceira coluna. Endereço base da conta: `https://<domínio da conta>/v2/location/<locationId>/`.

| Tarefa | Como o artigo descreve | Caminho no endereço |
| --- | --- | --- |
| Criar contato | Menu principal > Contatos > Adicionar contato | `contacts/smart_list/All`, botão "Adicionar" (conferido em 03/11/2026) |
| Importar contatos | Contatos > Importar > escolher contatos > enviar CSV > mapear campos | `contacts/smart_list/All`, botão "Importar" (conferido em 03/11/2026) |
| Tag em vários contatos | Contatos > lista > selecionar > ações em massa > adicionar ou remover tag | `contacts/bulk/actions` (Contatos > Ações em massa) (conferido em 03/11/2026); ao marcar linhas, a barra mostra "Adicionar tags"; "Remover tags" fica no menu "Mais" (conferido em 04/11/2026) |
| Campos personalizados | Configurações > Campos personalizados | `settings/fields` (conferido em 03/11/2026) |
| Contatos duplicados | Configurações > preferências de contatos duplicados | `settings/company`: Configurações > Perfil da empresa > rolar até o fim, bloco "Preferências de Desduplicação de Contatos" (conferido em 03/11/2026) |
| Pipelines | Oportunidades ou configurações de pipeline | `crm-settings` (Configurações > Oportunidades & Pipelines) (conferido em 03/11/2026) |
| Oportunidades (kanban, lista, filtros, busca) | Área de oportunidades | `opportunities/list` (conferido em 03/11/2026) |
| Conversas | Menu principal > Conversas | `conversations/conversations` (conferido em 03/11/2026) |
| Conectar WhatsApp | Configurações > canais de comunicação ou WhatsApp > conectar | `settings/whatsapp` (Configurações > WhatsApp) (conferido em 03/11/2026) |
| Conectar Facebook e Instagram | Configurações > Integrações (não existe seção "canais de comunicação") | `settings/lc-integrations` caminho (conferido em 03/11/2026); blocos "Facebook" e "Instagram" com a conta conectada e "Gerenciar" (conferido em 04/11/2026) |
| Conectar e-mail pessoal | Configurações > Meu perfil > aba "E-mail e conversas" > "E-mail (sincronização bidirecional)" > Gmail ou Outlook > "Conectar" | `settings/users/me` (conferido em 04/11/2026) |
| Snippets e modelos de SMS | Área de templates, snippets ou mensagens salvas | `conversations/templates` (Conversas > Trechos) (conferido em 03/11/2026) |
| Tarefas | Área de tarefas ou atividades | `tasks` (Contatos > Tarefas) (conferido em 03/11/2026) |
| Usuários | Configurações > usuários ou equipe | `settings/users` (Configurações > Usuários) (conferido em 03/11/2026) |
| Automações | Área de automações > abrir ou criar o fluxo | uma automação: `automation/workflow/<id>` (do `uiUrl`) |
| Motivos de perda | (sem artigo) | sem tela própria encontrada na conferência de 03/11/2026; cadastro pelo suporte da Atlas |

Fontes dos caminhos de endereço: `docs/navegacao-crm/` e `uiUrl` devolvido pelo conector.
