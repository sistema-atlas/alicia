# Links com UTM e captura no contato

## Como a plataforma registra a origem

Fonte: artigo oficial do fornecedor sobre origem da atribuição, consultado em 03/11/2026, e respostas reais do MCP na conta Atlas.

- **Primeira atribuição**: a primeira sessão em que o contato interagiu. Não muda depois.
- **Última atribuição**: a interação mais recente registrada. Atualiza a cada nova.
- Registra quando o contato faz uma ação na mesma sessão: envio de formulário ou pesquisa, agendamento, chat do site depois de deixar contato, formulário de pedido.
- Parâmetros lidos: `utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, `utm_term`, `utm_matchtype`, `campaign_id`, `ad_group_id`, `ad_id`, além de `gclid`, `wbraid`, `gbraid`, `msclkid`, `ctwa_clid`.
- Categorias de origem da sessão: tráfego pago de busca, social pago, tráfego direto, busca orgânica, redes sociais, indicação, outros, tela do CRM e terceiros.
- **A UTM só é gravada se a pessoa enviar na mesma página em que chegou.** Se ela navega para outra página antes de enviar, a UTM pode se perder. Formulário na própria página de entrada (ou pop-up) resolve.
- Parâmetros personalizados nas plataformas de anúncio podem atrapalhar a leitura.

## Padrão de UTM da Atlas

Minúsculas, sem acento, palavras separadas por hífen. Combine o padrão com o cliente uma vez e repita em todos os links.

| Parâmetro | Para quê | Exemplos |
| --- | --- | --- |
| `utm_source` | De onde vem | `instagram`, `facebook`, `google`, `whatsapp`, `email`, `youtube` |
| `utm_medium` | Tipo de tráfego | `cpc` (pago), `bio`, `stories`, `post`, `organico`, `lista` |
| `utm_campaign` | Campanha | `black-friday-2026`, `lancamento-curso` |
| `utm_content` | Peça ou variação | `video-depoimento`, `carrossel-1` |
| `utm_term` | Palavra-chave (busca paga) | `crm-para-clinica` |

Montagem: `https://pagina.com/caminho?utm_source=instagram&utm_medium=bio&utm_campaign=perfil`. Se a URL já tem `?`, junte com `&`.

Anúncios: os parâmetros de URL são preenchidos pelo cliente no gerenciador de anúncios do Meta ou do Google. Entregue o texto pronto para colar.

## Link curto

1. Monte a URL com UTM e mostre ao cliente.
2. `search-trigger-links` para não duplicar.
3. `create-link` (`name`, `redirectTo`) com `dryRun: true`, aprovação simples, execução com `idempotencyKey`.
4. Entregue o link curto. Abra o link e confira que a página final mantém os parâmetros na barra de endereço.

Link curto com prévia no WhatsApp: página-ponte (skill `atlas-sites-e-blog`).

## Guardar a UTM em campo do contato

A atribuição já guarda UTM em `attributionSource` e `lastAttributionSource`. Campo próprio só vale a pena quando o cliente quer **filtrar lista, usar em automação ou ver na ficha** sem abrir a atribuição (o filtro por atribuição não funciona na busca do MCP).

1. `get-custom-fields` (`model: contact`): já existem campos como `utm_source`, `utm_campaign`? Se não, pergunte. Criar campo é `atlas-campos-e-dados`.
2. No formulário ou pesquisa (navegador), adicione o campo pela aba **Adicionar campos de objeto**.
3. Marque **Oculto** e ajuste a **Chave de consulta** para o nome do parâmetro (ex.: `utm_source`). O valor vem da URL. Só campo de texto pode ser oculto (visto no construtor de pesquisa).
4. Em pesquisa uma por tela, slide só com campo oculto é pulado: deixe o campo oculto no mesmo slide de uma pergunta visível.
5. Teste com a URL com UTM, com sim do cliente (cria contato), e confira no contato.
6. Formulário dentro de iframe em site externo: a URL que o formulário enxerga é a dele, não a do site. Os parâmetros do site não chegam sozinhos. Use o rastreamento externo (`instalar-pixel-e-tags.md`) ou peça para quem cuida do site repassar os parâmetros para o endereço do formulário `(a conferir no navegador)`.

## Campo Origem

O elemento **Origem** do formulário e da pesquisa grava um valor fixo no `source` do contato, e `?source=valor` na URL substitui esse valor no envio (documentação do fornecedor). Útil para separar campanhas quando a UTM não chega. Detalhes em `atlas-formularios`.
