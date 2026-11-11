# Instalar pixel do Meta e Google Analytics

Fontes: documentação oficial do fornecedor consultada em 03/11/2026 e montagem real na conta Atlas (código do cabeçalho de página, 07/10/2026).

## Antes

1. Qual ferramenta: Meta (Facebook e Instagram), Google Analytics 4, Google Ads, Google Tag Manager, outra.
2. Onde: funil ou site inteiro, ou uma página só.
3. O código vem do cliente:
   - Meta: Gerenciador de Eventos > Conectar fontes de dados > Web > pixel > instalar manualmente > Copiar código. O ID do pixel é o ID do conjunto de dados.
   - Google Analytics 4: Administrador > Criar propriedade > Fluxo de dados > Web (URL do site) > tag gtag.js. Ou o Google Tag Manager, um método só.
4. Nunca invente ID. Nunca peça senha da conta do Meta ou do Google.

## Onde colar

| Escopo | Onde | Campo |
| --- | --- | --- |
| Funil ou site inteiro | Funil ou site > Configurações | Código de rastreamento do cabeçalho (head) ou do corpo (body), conforme a instrução da ferramenta |
| Uma página | Construtor da página > ícone de código | Código do cabeçalho ou código do rodapé (página não tem campo de corpo) |

- Pixel do Meta e tag do Google: cabeçalho.
- **Um nível só.** Código no funil e na página ao mesmo tempo duplica visitas e conversões.
- Clonar página **não copia** o código da página. O código do funil inteiro continua valendo.

## Passos no navegador

1. `getFunnels` com `name` para achar o funil e confirmar com o cliente.
2. Abra o funil ou a página. Leia o código que já existe e mostre ao cliente.
3. Monte o novo conteúdo do campo: o que já existia + o código novo, sem apagar o de outra ferramenta.
4. Aprovação reforçada: `CONFIRMO PUBLICAÇÃO` (vale para página no ar).
5. Cole, **Salvar**, publique se for página.
6. Confira na página publicada. A plataforma pode injetar o script depois de carregar, então ele pode não aparecer em "ver código-fonte". Use:
   - Meta: extensão Meta Pixel Helper ou Testar eventos no Gerenciador de Eventos (o cliente olha).
   - Google: Tempo real ou DebugView no Google Analytics.
   - No navegador: `typeof fbq` ou `typeof gtag` pelo JavaScript da página.
7. Na conta Atlas, o código do cabeçalho de página com script de redirecionamento rodou só 3 a 8 segundos depois da página abrir: o rastreamento carrega depois da página. Normal.

## Conversões

- **Visita de página**: o pixel base já registra.
- **Envio de formulário ou pesquisa**:
  - Pesquisa: Configurações > Pixel do Facebook, com evento na página e no envio (visto na tela).
  - Formulário: editor > aba "Configurações" > "ID do pixel do Facebook" e "Eventos do pixel do Facebook" ("Exibição na página", "No envio do formulário") (conferido em 03/11/2026). Alternativa: evento na página de obrigado (código só nessa página, por exemplo `fbq('track','Lead')`).
  - Pelo servidor (API de Conversões do Meta): automação com gatilho "Formulário enviado", "Pesquisa respondida", "Status do compromisso" ou "Envio do formulário de pedido" (rótulos do construtor, conferidos em 03/11/2026), e a ação de API de Conversões do Meta com evento de funil (o nome da ação pode aparecer em inglês na tela; ao cliente, diga "ação de API de Conversões do Meta"). O token e o ID do pixel são colados pelo cliente na ação. Montar é da skill `atlas-automacoes`.
- **Agendamento**: página de confirmação com evento, ou API de Conversões pela automação.
- Google Ads conversões offline e envio de dados ao Google Analytics por automação: há artigos na central do fornecedor; montar com `atlas-automacoes` `(a conferir no navegador)`.

## Consentimento

Scripts de análise e anúncio podem exigir aviso de cookies (LGPD). A plataforma tem um banner de consentimento de cookies (documentação). Pergunte ao cliente se quer ativar `(a conferir no navegador)`.

## Site fora da Atlas

- Rastreamento externo: script da conta (Configurações > Rastreamento externo) colado antes do `</body>` do site do cliente. Registra visitas e capta envios de formulários HTML do site (WordPress, HTML próprio, construtores sem código), criando ou atualizando contatos.
- Não detecta formulário dentro de iframe nem widget que não expõe os campos. Precisa de campo de e-mail.
- Quem cola no site é o cliente ou quem cuida do site. Entregue o passo a passo.
- Novidade anunciada no LevelUp 2026 (post oficial de 27/10/2026): controle de mapeamento de campos e rastreamento de formulário em iframe no rastreamento externo, sem data clara. Não prometa.
