# Plano B: navegador do cliente

Use quando o MCP não tem operação para a tarefa, ou quando a conexão não tem permissão para ela.

## No Claude (Claude in Chrome)

1. Veja se as ferramentas do Claude in Chrome estão disponíveis. Se não estiverem, peça ao cliente para instalar a extensão Claude in Chrome e entrar na Atlas no Chrome. Enquanto isso, ofereça o passo a passo manual (abaixo).
2. Abra uma aba nova no endereço direto da tela. Ordem de preferência: (a) o `uiUrl` que a operação do conector devolveu, quando houver; (b) o caminho de `references/telas.md` da skill, sobre o domínio que aparece na aba do cliente já logado; (c) o endereço base padrão `https://crm.atlasoficial.com/v2/location/<locationId>/`.
3. **Se a tela não carregar pelo endereço direto** (fica só girando ou em branco por mais de uns 20 segundos), não insista no mesmo link nem abra outra aba no mesmo endereço. Entre pela conta e vá clicando até a tela: abra o início da conta (`https://crm.atlasoficial.com/v2/location/<locationId>/dashboard`), espere o menu lateral aparecer, clique no item do menu (por exemplo Automações), use a busca ou as pastas da lista e clique no item. Visto na conta Atlas em 11/11/2026: o construtor de automações travava pelo link direto e abria normal pelo menu. Se nem assim carregar, pare e avise o cliente.
4. Confirme na tela o nome da conta antes de clicar em qualquer coisa.
5. Prefira ler o texto da página a tirar print. Print só quando precisa ver o layout.
6. Uma tela por vez. Lotes longos travam o navegador.
7. Antes de salvar, publicar ou ativar: aprovação no formato de `aprovacao.md`.
8. Não clique em botões que abrem alerta do navegador. Se aparecer um, avise o cliente.
9. Depois de salvar, confira pelo MCP (quando houver leitura) ou recarregando a tela.

## No Codex ou sem ferramenta de navegador

O Codex não controla o Chrome do cliente por padrão. Se houver um servidor MCP de navegador configurado (por exemplo Playwright ou Chrome DevTools), use-o com as mesmas regras. Se não houver:

1. Entregue o passo a passo numerado: link direto da tela, onde clicar, o que preencher, com os textos exatos.
2. Peça para o cliente avisar quando terminar.
3. Confira pelo MCP o que der para conferir.

## Nunca no navegador

- Mudar senha, dados de cobrança, usuários ou integrações sem pedido expresso.
- Clicar em "Ativar todos", "Desativar tudo" ou ações em massa da tela sem aprovação reforçada.
- Digitar senha do cliente. Se pedir login, o cliente faz.
