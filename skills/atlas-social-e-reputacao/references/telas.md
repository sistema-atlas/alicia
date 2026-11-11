# Telas: redes sociais e reputação

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Se o cliente usa outro domínio, use o da aba dele.

Regras do navegador: `references/_comum/navegador.md`.

Legenda: **(conferido em 03/11/2026)** quando a tela foi vista no navegador na conta Atlas, somente leitura. **confirmado** quando o caminho veio de fonte. **(a conferir no navegador)** quando é o padrão da plataforma, ainda não visto nesta construção.

| Tela | Caminho depois do endereço base | Menu | Situação |
| --- | --- | --- | --- |
| Planejador social | `marketing/social-planner` (abre em `marketing/social-planner/planner`) | Marketing > Planejador Social (subabas "Planejador", "Conteúdo", "Configurações"; botão "Nova publicação") | (conferido em 03/11/2026) |
| Conectar redes | dentro do planejador | Marketing > Planejador Social > botão "Conectar redes sociais" ou "Configurações do Social Planner" | botão (conferido em 03/11/2026); hoje o botão se chama "+ Redes sociais" e abre a janela "Conectar redes sociais": "Conectar Facebook", "Conectar Instagram", "Conectar GBP", "Conectar LinkedIn", "Conectar TikTok", "Conectar YouTube", "Conectar Pinterest", "Conectar Threads", "Conectar Bluesky", "Adicionar uma comunidade" e "Enviar convite de conexão social" (conferido em 04/11/2026); a janela de login de cada rede não foi aberta |
| Reputação, visão geral | `reputation/overview` | Menu lateral: Reputação (abas "Visão geral", "Solicitações", "Avaliações", "Depoimentos em vídeo", "Widgets", "Listagens", "Otimização de GBP", "Configurações") | (conferido em 03/11/2026) |
| Avaliações recebidas | `reputation/reviews` | Reputação > Avaliações | (conferido em 03/11/2026) |
| Pedidos de avaliação | `reputation/requests` | Reputação > Solicitações ("Configurar Link de Avaliação", "Enviar solicitação de avaliação", busca por nome, e-mail ou telefone, filtros "Status" e "Enviado via") | (conferido em 03/11/2026) |
| Configurar mensagens de pedido de avaliação | `reputation/settings` (abre em `?tab=reviewsAI`) | Reputação > Configurações; menu "IA de avaliações", "Link para avaliação", "Solicitações de SMS", "Solicitações de e-mail", "Solicitações de WhatsApp", "Avaliações QR", "Avaliações de spam", "Integrações" | menu (conferido em 03/11/2026); por dentro (conferido em 04/11/2026): "Solicitações de SMS" e "Solicitações de e-mail" têm quando enviar após o check-in ("Imediatamente"), "Até ser clicado, repetir isso a cada" ("Não repetir"), "Máximo de novas tentativas", remetente padrão e modelos ("Definir modelos de SMS" ou "Definir modelos de e-mail", "Criar novo"); "Solicitações de WhatsApp" pede "Conectar o WhatsApp"; "Link para avaliação" tem "Equilíbrio de avaliação" ("Configurar equilíbrio"), links do Google, do Facebook e "Link personalizado", "Selecionar página", "Cancelar" e "Salvar"; "Integrações" lista as plataformas com "Conectar conta" |
| Integrar perfil do Google | `settings/lc-integrations` | Configurações > Integrações, bloco do Google | caminho (conferido em 03/11/2026); blocos "Google" (Drive, Planilhas, Gmail, Analytics e AdWords) e "Perfil do Google Business Profile" (avaliações e rastreamento de chamadas), cada um com a conta conectada e "Gerenciar" (conferido em 04/11/2026); interior não aberto |
| Mídia | `media-storage` | Menu lateral: Mídia Drive | (conferido em 03/11/2026) |
| Produtos da loja (avaliações) | `payments/products/reviews` | Pagamentos > Produtos > Reviews | (conferido em 03/11/2026) |

## Passo a passo

### Responder avaliação do Google
1. Reputação > Avaliações (`reputation/reviews`).
2. Ache a avaliação (filtre por nota ou data se houver).
3. Leia a avaliação inteira. Escreva a resposta no chat com o cliente.
4. Mostre a resposta e peça `CONFIRMO PUBLICAÇÃO`.
5. Cole na caixa de resposta e publique. Uma avaliação por vez.
6. Recarregue e confira que a resposta aparece.

### Enviar pedido de avaliação
1. Reputação > Solicitações (`reputation/requests`), ou a ação de enviar pedido.
2. Escolha o contato e o canal (SMS, WhatsApp ou e-mail, conforme a tela).
3. Mostre ao cliente canal, contato e texto do pedido. Peça `CONFIRMO ENVIO`.
4. Envie. Para vários contatos, use automação com a trava (`atlas-automacoes` e `atlas-conversas-e-disparos`).

### Contestar avaliação no Google
Tema confirmado na base de artigos ("contestar uma avaliação do Google e acompanhar o status"). Passos de tela: (a conferir no navegador; não dá para conferir: em 04/11/2026 a conta Atlas não tinha nenhuma avaliação em Reputação > Avaliações, então não há avaliação para ver a opção de contestar). Explique ao cliente que quem decide é o Google e que só vale para avaliação que viola as regras (spam, ofensa, conflito de interesse).

### Reconectar uma rede
1. Marketing > Planejador Social > "Configurações do Social Planner" (ou o botão "Conectar redes sociais").
2. Clique em reconectar na conta vencida.
3. O login na rede é do cliente: ele digita a senha, nunca o assistente.
4. Confira com `get-account` (`isExpired: false`).

## Links que vão para o cliente
Só o caminho da tela no domínio da conta, ou o `previewLink` público do post na rede. Nunca `uiUrl`, avatar ou URL de mídia com domínio técnico do fornecedor.

Conferência de telas aplicada em 03/11/2026 (somente leitura, conta Atlas). O que segue marcado (a conferir no navegador) não foi visto nessa rodada.
