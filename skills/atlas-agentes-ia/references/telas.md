# Telas: agentes de IA (plano B no navegador)

Endereço base do painel: `https://crm.atlasoficial.com/v2/location/<locationId>/` (conferido em 03/11/2026, fabrica/telas-conferidas.md). Se o cliente usa outro domínio, use o da aba dele.

| Tela | Endereço | Cliques | Rótulos vistos | Status |
| --- | --- | --- | --- | --- |
| Menu Agentes de AI | `<base>ai-agents/getting-started` | Menu lateral > Agentes de AI | abas "Começando", "Agent Studio", "AIde voz", "Conversation AI", "Base de Conhecimento", "Modelos de agente", "Content AI", "Agent Logs", "Agent Health" | (conferido em 03/11/2026) |
| Lista de agentes de conversa | `<base>ai-agents/conversation-ai` | Agentes de AI > Conversation AI > Lista de agentes | "Agentes de Conversation AI"; abas "Painel", "Lista de agentes"; "Gerenciar base de conhecimento", "Criar agente" | (conferido em 03/11/2026) |
| Um agente de conversa | `<base>ai-agents/conversation-ai/agent/<agentId>` | lista > nome do agente | | doc interno da Atlas 08-plano-de-execucao-flow-builder.md |
| Painel de teste do agente | dentro da tela do agente | tela do agente > botão "Testar agente" (canto superior direito, ao lado de "Salvar") | painel "Teste seu agente": "Visualizar como" (ex.: "Chat ao vivo"), "Experimente seu agente", exemplos prontos, caixa "Enviar uma mensagem", aviso "As mensagens de teste nunca são enviadas aos seus contatos" | (conferido em 04/11/2026); docs/guia-criar-agente-ia-conversacional-atlas-crm.md, passo 18 |
| Base de conhecimento (inclui subir arquivo) | `<base>ai-agents/knowledge-base` | Agentes de AI > Base de Conhecimento | não aberto | caminho (conferido em 03/11/2026) |
| Agente de voz | `<base>ai-agents/voice-ai` | Agentes de AI > aba "AIde voz" (assim aparece na tela) | não aberto | caminho (conferido em 03/11/2026) |
| Widget de chat | `<base>funnels-websites/chat-widget`; configuração em `<base>funnels-websites/chat-widget/builder/<widgetId>` | Sites > Widget de chat > menu da linha > Editar | lista "Widgets de chat" ("Biblioteca", "Insights", "+ Novo"); configuração com abas "Estilo", "Janela de chat", "Mensagens", "Agente" ("Conversation AI", "Agentes conectados"); "Salvar" | (conferido em 03/11/2026) |

## Montar agente de conversa no navegador

1. Abra `<base>ai-agents/conversation-ai`, aba "Lista de agentes". Confirme o nome da conta.
2. "Criar agente". Escolha baseado em prompt. Nome que diga a função (ex.: "WhatsApp - Recepção").
3. Mantenha **desativado**.
4. Cole personalidade, objetivo e regras (texto de `agente-de-conversa.md`, já aprovado pelo cliente).
5. Ligue as bases escolhidas e escreva quando usar cada uma.
6. Ligue só as ações necessárias.
7. Configure canal e comportamento (espera, limite de mensagens, pausa com atendente).
8. Salve. Rode os testes no painel de teste.
9. Só ligue com `CONFIRMO PUBLICAÇÃO`.

## Subir arquivo na base

1. Abra `<base>ai-agents/knowledge-base`. Escolha a base pelo nome.
2. Na base aberta, use o cartão "Upload de arquivo" (botão "+"); as abas da base são "Todos", "Rastreador da web", "Perguntas Frequentes", "Tabelas", "Texto rico", "Arquivos" (conferido em 04/11/2026). Envie o arquivo aprovado pelo cliente.
3. Confira pelo MCP com `getFilesByKnowledgeBasePublic`.

## Widget de chat de tipo não aceito pela API

Se o widget for `allInOneChat` (ou outro tipo fora de `liveChat`/`emailChat`), a escrita pelo conector pode dar 422. Faça a mudança na tela do widget no navegador (Sites > Widget de chat > menu da linha > Editar, (conferido em 03/11/2026); ligar o agente na aba "Agente") e confira depois com `getChatWidget`.

## Cuidados

- Não mude o modo do agente (Desativado para Piloto automático) sem a confirmação.
- Abrir um agente só para leitura pode mostrar o tipo diferente do esperado (houve um caso de "baseado em prompt" aparecer como "baseado em fluxo" depois de aberto, em 2026-10). Se notar mudança, avise o cliente e não salve.
