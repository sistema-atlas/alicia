# Telas: automações (plano B no navegador)

Endereço base do painel: `https://crm.atlasoficial.com/v2/location/<locationId>/` (conferido em 03/11/2026, fabrica/telas-conferidas.md). Se o cliente usa outro domínio, use o da aba dele.

O `uiUrl` que `get-workflow` devolve veio com o domínio `links.atlasoficial.com`, que é o domínio dos links públicos, não o do painel logado. Se o `uiUrl` não abrir logado, troque só o domínio pelo do painel e mantenha o resto do caminho. Ao cliente, entregue o `uiUrl` como veio.

| Tela | Endereço | Cliques | Fonte |
| --- | --- | --- | --- |
| Lista de automações | `<base>automation/workflows` | Menu lateral > Automações > Fluxos de trabalho (botões "Criar fluxo de trabalho", "Construa usando IA", "Criar pasta"; listas "Todos os fluxos", "Precisa de avaliação", "Apagado(a)") | telas-conferidas.md (conferido em 03/11/2026) |
| Construtor de uma automação | `<base>automation/workflow/<workflowId>` (caminho do `uiUrl`) | Lista > nome da automação. Topo: "Lista de fluxos de trabalho", nome com lápis, "Salvo(a)"; abas "Construtor", "Configurações", "Histórico de inscrições", "Registros de execução"; botão "Testar fluxo de trabalho"; chave "Rascunho / Publicar"; no canvas, "Adicionar novo acionador", "+" entre etapas | telas-conferidas-2.md (conferido em 03/11/2026) |
| Histórico de inscrições e registros de execução | Abas "Histórico de inscrições" e "Registros de execução" no topo do construtor | Construtor > aba | telas-conferidas-2.md (conferido em 03/11/2026) (conteúdo das abas não aberto) |
| Configurações da automação | `<base>automation/workflow/<workflowId>/settings` | Construtor > aba "Configurações" (título "Configurações de fluxo de trabalho"): "Habilitar reentrada", "Permitir múltiplas oportunidades", "Parar ao receber resposta", "Fuso horário", "Janela de tempo", "Detalhes do remetente" ("Do nome", "Do e-mail", "Número de origem"), "Marcar como lido(a)" | telas-conferidas-2.md (conferido em 03/11/2026) |
| Estatísticas da automação | Link "Estatísticas" no cartão do gatilho, no construtor | Construtor > cartão do gatilho > "Estatísticas" | telas-conferidas-2.md (conferido em 03/11/2026); por dentro, o link abre "Disparar inscrições" com "Attempted", "Matched", "Unmatched" e o link "Visualizar estatísticas detalhadas"; a barra lateral do construtor tem o ícone "Tela de estatísticas" (conferido em 04/11/2026 na conta Demo) |
| Escolher gatilho | Painel "Adicionar acionador" (busca "Pesquisar acionadores", abas "Gatilhos" e "Apps") | Construtor > "Adicionar novo acionador" | telas-conferidas-2.md (conferido em 03/11/2026); nomes em receitas.md |
| Escolher ação | Painel "Actions" (busca "Pesquisar ações", abas "Ações" e "Apps") | Construtor > "+" no fluxo | telas-conferidas-2.md (conferido em 03/11/2026); nomes em receitas.md |

## Como ler uma automação na tela

1. Abra o construtor. Confirme o nome da conta no canto da tela.
2. Leia o texto da página (não print). O gatilho é o primeiro bloco; cada ação vem abaixo, na ordem.
3. Clique no gatilho para ver os filtros. Clique em cada espera para ver o tempo. Feche sem salvar.
4. Veja o status na chave "Rascunho / Publicar" do topo (conferido em 03/11/2026). Não clique nela.

## Como montar a partir de uma receita

1. Lista de automações > "Criar fluxo de trabalho" (conferido em 03/11/2026) > "Começar do zero": é opção do menu do próprio botão "Criar fluxo de trabalho" na lista (ao lado de "Selecione a partir de um modelo" e "Fluxo de trabalho baseado em Company"), não do construtor (conferido em 04/11/2026 na conta Demo). Ao abrir, o construtor pode perguntar sobre salvamento automático ("Continuar com o salvamento manual" ou "Ativar salvamento automático agora").
2. Dê o nome com o padrão da conta (ex.: "Follow-up de orçamento").
3. "Adicionar novo acionador" > escolha o gatilho da receita pelo nome exato e aplique os filtros. Salve o gatilho.
4. Clique no "+" e adicione cada ação na ordem, com os textos exatos da receita, e salve cada ação no botão "Salvar ação" do rodapé da ação (ao lado de "Cancelar"; no gatilho o botão é "Salvar acionador") (conferido em 04/11/2026 na conta Demo). No salvamento manual, o topo do construtor mostra "Salvar" com alteração pendente e "Salvo(a)" depois de salvo.
5. Aba "Configurações" (conferido em 03/11/2026): aplique "Habilitar reentrada", "Janela de tempo" e "Parar ao receber resposta", conforme a receita.
6. Deixe a chave em **Rascunho**.
7. Mostre ao cliente o resumo e peça `CONFIRMO PUBLICAÇÃO` antes de mudar para publicado.

## Editar automação publicada (regra 2 do SKILL.md)

1. Avise: "Salvar aqui muda a automação na hora, para quem já está nela e para quem entrar."
2. Caminho preferido: duplicar a automação (lista > menu de três pontos da linha > "Duplicar fluxo de trabalho" (conferido em 04/11/2026 na conta Demo)), ajustar a cópia em rascunho, testar, e depois publicar a cópia e pausar a original, com `CONFIRMO PUBLICAÇÃO`.
3. Se o cliente quiser editar a original: mostre antes e depois; aprovação simples, ou `CONFIRMO PUBLICAÇÃO` se a mudança mexe em mensagem, público ou espera de envio.

## Cuidados no construtor

- Uma ação por vez. O construtor trava com muitos cliques seguidos (relato no doc interno da Atlas 08-plano-de-execucao-flow-builder.md). Depois de cada clique importante, leia a página de novo para conferir.
- Se a tela parar de responder, recarregue e confira se nada ficou pela metade (ação sem tipo escolhido solta no fluxo).
- Nunca inscreva contatos em massa numa automação sem `CONFIRMO MASSA` e `CONFIRMO ENVIO`. O construtor não tem botão de inscrição em massa (conferido em 04/11/2026 na conta Demo); ela fica em Contatos > marcar as linhas > "Acionar automação" (conferido em 04/11/2026).
