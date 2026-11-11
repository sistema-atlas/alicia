# Domínios, SEO e QR codes

Tudo pelo navegador. Não há operação no MCP para domínio, SEO de página ou QR code.

## Domínios

Tela: engrenagem no fim da barra de Sites > **Domínios** (`settings/domain`).

- **Domínio de marca**: usado nos links de formulário, pesquisa, agenda e telas do CRM. Na conta Atlas: `links.atlasoficial.com`. **Nunca** mova esse domínio para funil ou site.
- **Funil/Site**: subdomínio (ou domínio raiz) conectado a um funil ou site. É o que aparece no endereço das páginas.
- Conectar, trocar ou desconectar domínio de funil ou site muda o endereço público: `CONFIRMO PUBLICAÇÃO`.
- Conectar domínio externo exige mexer no DNS do cliente (registro CNAME ou A). O assistente não acessa o painel do registrador. Entregue o passo a passo com o valor que a tela mostrar e peça para o cliente (ou quem cuida do domínio) fazer.
- Exemplo real da conta Atlas: subdomínio `app` com CNAME para o destino indicado pela tela, conectado a um funil.
- Página padrão e página 404 do domínio: Gerenciar > editar subdomínio.
- Comprar domínio pela plataforma é dinheiro: `CONFIRMO COBRANÇA`, e só com pedido expresso.
- Configurar domínio raiz e subdomínio: há artigo da central do fornecedor sobre isso; os passos exatos mudam com a tela `(a conferir no navegador)`.

## SEO da página

No construtor da etapa, ícone **SEO e otimização** (visto na conta Atlas):
- **Conteúdo**: título e descrição.
- **Imagens**: imagem de prévia (URL da Mídia, 1200x630).
- Palavras-chave, idioma, autor e outros campos podem aparecer `(a conferir no navegador)`.

Mapa do site (XML sitemap): a central do fornecedor tem artigo sobre sitemap de funis e sites `(a conferir no navegador)`.

O módulo **SEO (Beta)** em Sites é um produto pago à parte (SEO pago, com valor mensal). Não contrate; se o cliente pedir expressamente, `CONFIRMO COBRANÇA`.

## QR codes

Tela: Sites > **Códigos QR** (`qr-codes`).

1. **Gerar código QR**, escolher o tipo (site, cartão de visita e outros que a tela oferecer).
2. Destino: de preferência um link rastreável da conta (`create-link` pelo MCP) ou uma página com UTM (`atlas-rastreamento`), para medir quem chegou pelo QR.
3. Nome claro (ex.: `QR cartão de visita`), cores da marca.
4. Salvar com aprovação simples. Baixar a imagem e conferir lendo o QR com a câmera do celular.
5. Analytics de cada QR: botão Analytics na lista.

Mudar o destino de um QR já impresso muda para todo mundo: `CONFIRMO PUBLICAÇÃO`.
