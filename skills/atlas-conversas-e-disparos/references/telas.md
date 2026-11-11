# Telas: conversas e disparos

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Painel logado (conferido em 03/11/2026). Se o cliente acessa por outro domínio, use o que aparece na aba dele. O domínio `links.atlasoficial.com` aparece só nos links públicos (ex.: link de agendamento), não no painel.

Regras do navegador: `references/_comum/navegador.md`. Confirme o nome da conta na tela antes de clicar.

Legenda: **(conferido em 03/11/2026)** quando a tela foi vista no navegador na conta Atlas, somente leitura. **confirmado** quando o caminho veio de fonte (guia da Atlas, Help Center ou link devolvido pelo conector). **(a conferir no navegador)** quando o caminho é o padrão da plataforma, mas ainda não foi visto nesta construção. Ao conferir, atualize esta tabela.

| Tela | Caminho depois do endereço base | Como chegar pelo menu | Situação |
| --- | --- | --- | --- |
| Caixa de conversas | `conversations/conversations` | Menu lateral: Conversas. Abas no topo: "Conversas", "Ações manuais", "Trechos", "Links de acionamento", "Estatísticas", "Configurações" | (conferido em 03/11/2026) |
| Filtros da caixa (canal, status, responsável, não lidas) | dentro da caixa de conversas | Conversas, filtros no topo da lista: "Caixa de entrada da equipe", "Não lidos", "Todos", "Recente", "Marcado como importante" | confirmado no Help Center (artigo "Como filtrar conversas"); rótulos (conferido em 03/11/2026) |
| Marcar como lida | dentro da conversa | Abrir a conversa, ação de marcar como lida | confirmado no Help Center |
| Respostas prontas e modelos de SMS | `conversations/templates` | Conversas > aba "Trechos" (nome na tela das respostas prontas) | (conferido em 03/11/2026) |
| Templates de WhatsApp oficial | `settings/whatsapp` | Configurações > WhatsApp; dentro, Templates > Criar template | caminho (conferido em 03/11/2026); na conta Atlas o WhatsApp nativo não está conectado e a tela mostra só a apresentação, sem abas de templates; abas internas de uma conta conectada (a conferir no navegador; não dá para conferir: o WhatsApp nativo não está conectado nem na conta Atlas nem na Demo, visto em 04/11/2026, e conectar está fora desta conferência) |
| Conectar WhatsApp | `settings/whatsapp` | Configurações > WhatsApp | caminho (conferido em 03/11/2026); passos internos (a conferir no navegador; não dá para conferir sem iniciar a conexão do WhatsApp, que está fora desta conferência) |
| Conectar Facebook e Instagram | `settings/lc-integrations` | Configurações > Integrações (não existe seção "canais de comunicação" no menu de Configurações) | caminho (conferido em 03/11/2026); blocos "Facebook" e "Instagram", cada um com a conta conectada e o botão "Gerenciar" ("Conectar" quando não ligado) (conferido em 04/11/2026); o interior de "Gerenciar" não foi aberto |
| Lista de contatos (ação em massa) | `contacts/smart_list/All`; ações em massa em `contacts/bulk/actions` | Menu lateral: Contatos, marcar a caixa de cada linha; aba "Ações em massa" | (conferido em 03/11/2026); ao marcar linhas, a barra mostra "Exportar", "Acionar automação", "Enviar e-mail", "Adicionar tags", "Excluir" e "Mais"; em "Mais": "Enviar SMS", "Enviar e-mail", "Enviar WhatsApp", "Solicitar avaliações", "Gerenciar empresas", "Gerenciar oportunidades", "Acionar automação", "Adicionar tags", "Remover tags", "Exportar", "Mesclar", "Verificar endereços de e-mail", "Excluir" (conferido em 04/11/2026) |
| Mídia (arquivos para anexar) | `media-storage` | Menu lateral: Mídia Drive | (conferido em 03/11/2026) |
| Links de acionamento | `conversations/trigger-links` | Conversas > Links de acionamento | (conferido em 03/11/2026) |
| Configurações de conversas | `conversations/settings` | Conversas > Configurações | (conferido em 03/11/2026) |
| Mensagens agendadas | dentro da conversa | Abrir a conversa e ver a mensagem agendada no histórico | (a conferir no navegador; não dá para conferir sem agendar uma mensagem, e não havia nenhuma agendada. Visto em 04/11/2026: a caixa de resposta tem o botão "Opções de envio" ao lado de enviar, desativado com a caixa vazia) |
| Integração de WhatsApp da Atlas (só contas que usam) | link de menu personalizado `custom-menu-link/<id>` | Fim do menu lateral, botão de WhatsApp logo acima de Configurações (na conta Atlas, "WhatsApp Atlas"; o nome varia por conta). Abre "Escolha a instância", um card por número; dentro do número, abas "Visão geral", "IA", "Voice", "Grupos", "Disparos", "Configurações" | (conferido em 04/11/2026); detalhe de cada aba em `whatsapp-da-atlas.md`, seção 4 |

## Passo a passo para quem está sem navegador controlado

### Responder pela tela
1. Abra a caixa de conversas.
2. Clique na conversa e leia o histórico antes de responder.
3. Confira o canal e o número no topo da caixa de resposta.
4. Escreva (ou escolha uma resposta pronta, que na tela fica em "Trechos"), revise e envie.
5. Depois: marque como lida, aplique tag ou crie tarefa se tiver próximo passo.

### Enviar template aprovado fora da janela
1. Abra a conversa com o contato.
2. Na caixa de resposta do WhatsApp, escolha a opção de template (a conferir no navegador o nome do botão; não dá para conferir: com o canal "WhatsApp" escolhido na caixa de resposta, a conta Atlas mostra só "Conectar o WhatsApp", porque o WhatsApp nativo não está conectado, visto em 04/11/2026).
3. Escolha o template aprovado, preencha as variáveis e confira a prévia.
4. Só envie depois do `CONFIRMO ENVIO` no chat.

### Cadastrar template de WhatsApp oficial
1. Configurações > WhatsApp (`settings/whatsapp`, conferido em 03/11/2026) > Templates > Criar template (abas internas a conferir no navegador; WhatsApp nativo não conectado nas contas Atlas e Demo, visto em 04/11/2026).
2. Ordem dos campos (skill interna da Atlas): nome, categoria, idioma, cabeçalho, corpo, rodapé, exemplos das variáveis, botões.
3. Cole o texto exatamente como foi aprovado no chat, com as quebras de linha.
4. Preencha cada "Exemplo para {{n}}".
5. Envie para aprovação. Só diga que foi enviado quando a lista mostrar o status em análise ou aprovado.

### Integração de WhatsApp da Atlas (só se a conta usar)
Passos completos em `references/whatsapp-da-atlas.md`. Para o cliente, sempre "integração de WhatsApp da Atlas".

## Links que vão para o cliente
Só no domínio da conta (`crm.atlasoficial.com` ou o que aparece na aba do cliente). Se o conector devolver link com domínio técnico do fornecedor, não mostre: use o caminho desta tabela.

Conferência de telas aplicada em 03/11/2026 (somente leitura, conta Atlas). O que segue marcado (a conferir no navegador) não foi visto nessa rodada.
