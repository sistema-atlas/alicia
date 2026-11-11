# Links rastreáveis e redirecionamentos

São coisas diferentes:

| | Link rastreável | Redirecionamento de domínio |
| --- | --- | --- |
| O que é | Link curto da conta que leva a uma URL e registra o clique no contato | Regra no seu domínio: quem abre `seudominio.com/caminho` vai para outro endereço |
| Bom para | Mensagens, e-mails, bio, campanhas; disparar automação no clique | Endereço antigo que mudou, atalho fácil de falar (`/whatsapp`, `/promo`) |
| MCP | `get-links`, `search-trigger-links`, `get-link-by-id`, `create-link`, `update-link`, `delete-link` | `fetch-redirects-list`, `create-redirect`, `update-redirect-by-id`, `delete-redirect-by-id` |
| Prévia no WhatsApp | Não (redireciona) | Não (301). Para prévia: página-ponte, ver `paginas-e-construtor.md` |

## Criar link rastreável

1. `search-trigger-links` com o nome para não duplicar.
2. Monte o destino. Com UTM, use a skill `atlas-rastreamento` para padronizar `utm_source`, `utm_medium`, `utm_campaign`.
3. `create-link` com `dryRun: true`: `name` (ex.: `Instagram bio`), `redirectTo`.
4. Aprovação simples. Execute com `idempotencyKey`.
5. Entregue o link e o `fieldKey` (para colar em mensagens e automações).

## Criar redirecionamento

1. `fetch-redirects-list` com `search` para ver se o caminho já existe.
2. Confirme com o cliente: domínio (só o host, sem `https://` e sem barra, ex.: `meusite.com.br`; o cliente informa, porque `getFunnels` só traz o ID do domínio), caminho, destino e tipo (`url` para endereço externo; `funnel` ou `website` para página da conta; `all` para o domínio inteiro).
3. `create-redirect` com `dryRun: true`. Se o caminho já recebe visitas ou já tem página, aprovação reforçada (`CONFIRMO PUBLICAÇÃO`); se é caminho novo, aprovação simples.
4. Execute e abra o endereço para conferir o destino.

Exemplos na conta Atlas (03/11/2026): `www` do domínio redireciona tudo para o domínio sem `www` (`action: all`, `path: *`); `/whatsapp` leva para um link de WhatsApp (`action: url`).

## Mudar ou apagar

- `update-link` exige `name` e `redirectTo` juntos. `update-redirect-by-id` exige `target` e `action`.
- Link já usado em anúncio ou mensagem enviada: mudar o destino muda para todo mundo. `CONFIRMO PUBLICAÇÃO`.
- Apagar: item por item, `CONFIRMO EXCLUSÃO`. Links já enviados param de funcionar.

## Anúncios do Google

Redirecionamento ou caminho extra no endereço da página pode causar reprovação de anúncio no Google (artigo da central do fornecedor sobre reprovação por redirecionamento de funil). Para anúncio, use o endereço final da página.
