# De onde vêm os leads e as vendas

## O que cada dado diz

| Dado | Onde | O que é | Cuidado |
| --- | --- | --- | --- |
| `source` do contato | `get-contact`, `search-contacts-advanced` | Texto de origem: nome do formulário que criou o contato, valor do campo Origem, ou o que a integração gravou | Contato que entrou por WhatsApp, importação ou integração costuma vir sem `source` |
| `attributionSource` | idem | Primeira sessão: `sessionSource`, `utmSource`, `utmCampaign`, `url`, `referrer`, `gclid` | Vazio quando não houve sessão em página, formulário ou chat |
| `lastAttributionSource` | idem | Última sessão, mesmas chaves | Idem |
| `source` da oportunidade | `search-opportunity` | Origem do negócio (texto) | Pode não ser igual ao do contato |
| `attributions` da oportunidade | `search-opportunity` | Lista com primeira (`isFirst`) e última (`isLast`): `utmSessionSource`, `medium`, `mediumId` | Herdada das sessões do contato |
| `others.eventData` do envio | `get-forms-submissions`, `get-surveys-submissions` | Sessão daquele envio: página, origem, cookies do Meta e do Google | Só para envios |
| Relatório de origem do lead | Tela (painel) | Oportunidades por origem: total, abertas, ganhas, perdidas, valores | Conta oportunidades, não contatos |
| Analytics das páginas | Tela (Sites > Analytics) | Visitas, canal de tráfego, fonte e mídia | Sem operação no MCP |

## Receitas

### Leads do período por origem

Data usada: criação do contato (`dateAdded`). Diga isso no relatório.

1. Total do período: `search-contacts-advanced` com `filters: [{ field: "dateAdded", operator: "range", value: { gte, lte } }]`, `pageLimit: 1`, ler `total`.
2. Testes a excluir, só contando: mesmo filtro de data mais `{ field: "tags", operator: "eq", value: "teste-assistente" }`, e outra contagem com `{ field: "firstNameLowerCase", operator: "eq", value: "teste" }`. Os dois filtros foram aceitos na conta Atlas em 03/11/2026. Para tirar os testes de uma contagem por origem, acrescente `{ field: "tags", operator: "not_contains", value: "teste-assistente" }` (também aceito). Diga quantos excluiu.
3. Por origem, só contando: `{ field: "source", operator: "exists" }` e `{ field: "source", operator: "eq", value: "<origem>" }` com `pageLimit: 1`, lendo `total`. Sem origem = total menos os que têm `source`.
4. Só leia contatos em páginas (`pageLimit` até 100, `searchAfter` devolvido) se precisar agrupar por atribuição (`lastAttributionSource.sessionSource`, `utmSource`, `utmCampaign`), porque a busca não filtra por atribuição. Guarde só os campos de origem, sem nomes. Se o período tiver muitos contatos, diga ao cliente quantas páginas seriam e ofereça o relatório da tela antes de seguir.
5. Nunca escreva nomes, e-mails ou telefones no relatório.

### Vendas por origem

1. `get-pipelines` para saber qual funil é de vendas (e não de suporte, onboarding ou outro uso). Pergunte se houver dúvida.
2. `search-opportunity` com `status: won`, `pipelineId` do funil de vendas, `date` e `endDate` (`mm-dd-yyyy`), `limit` até 100.
3. **Qual data**: o `describe_operation` não diz se `date` e `endDate` filtram pela criação ou pela data em que virou ganha. Para "vendas do mês", confira `lastStatusChangeAt` de cada ganha e conte só as que mudaram para ganha no período. Diga ao cliente: "contei pela data em que o negócio foi marcado como ganho".
4. **Descarte testes**: oportunidade com nome começando em `TESTE`, contato com tag `teste-assistente` (vem em `contact.tags`), e oportunidades de contatos internos da própria conta quando o cliente confirmar quais são. Diga quantas descartou.
5. Conte por `source` e pela atribuição `isFirst` ou `isLast` (pergunte qual o cliente quer; padrão: primeira, que mostra o canal que trouxe). Some `monetaryValue` por origem.
6. A resposta traz dados do contato embutidos: use só contagens e valores.

### Origem de um lead

Ache o contato seguindo `references/_comum/achar-contato.md` (e-mail ou telefone primeiro). Não achou: peça o outro dado (telefone ou e-mail) uma vez e confira a grafia com o cliente; por nome, só como a regra comum manda. Achou: `get-contact` e mostre `source`, primeira e última atribuição em linguagem simples ("chegou pelas redes sociais, pela página X, no dia Y"), traduzindo os valores pela tabela abaixo.

### Por campanha de anúncio

Com a conta de anúncios conectada: `fb-get-reporting-list` (`listType: campaigns`) para gasto e resultados, e o CRM (`utmCampaign` da atribuição, ou `fb-get-campaign-reporting` com `leads`) para leads. Mostre os dois com o nome certo: "leads contados pelo Meta" e "contatos atribuídos no CRM". Ver `anuncios.md`.

## Tradução obrigatória para o cliente

Nunca mostre o valor cru da origem da sessão.

| Valor técnico | Diga ao cliente |
| --- | --- |
| `Direct traffic` | acesso direto (digitou o endereço ou abriu um link sem origem) |
| `Referral` | veio de outro site |
| `Social media` | redes sociais |
| `Paid Social` | anúncio em rede social |
| `Paid Search` | anúncio no Google |
| `Organic Search` | busca no Google |
| `CRM UI` | criado na tela do CRM |
| `Third-Party` | integração de outra ferramenta |
| `Others` | outros |
| `form`, `survey` (medium) | formulário, pesquisa |
| `membership` (source) | área de membros |

Valores fora da tabela: descreva em português o que é, sem copiar.

## Modelo de relatório (exemplo real, só contagens)

Montado em 03/11/2026 na conta de teste da Atlas, outubro de 2026, com 3 chamadas (`search-contacts-advanced` com `pageLimit: 1`, a mesma com `pageLimit: 50`, `search-opportunity` com `status: won`).

```
Origem dos leads: outubro de 2026 (conta Atlas)

Contatos novos no mês (data de criação): 35 (1 de teste descartado: 34)

Por origem (campo de origem do contato)
| Origem                         | Leads |
| Sem origem (entraram pelo WhatsApp ou integração) | 30 |
| Pesquisa "Briefing de onboarding" | 3 |
| Outros (teste de e-mail)       | 1 |

Por última atribuição (sessão no site, formulário ou pesquisa)
| Canal          | Leads |
| Veio de outro site (página de links da própria Atlas) | 3 |
| Sem sessão registrada | 31 |
UTM preenchida: 0 contatos.

Vendas ganhas no mês no funil de vendas (data em que viraram ganhas):
1, de teste, descartada. Vendas reais: 0.

O que isso mostra
- Quase 9 em cada 10 leads (30 de 34) entraram sem origem: a conversa começa no
  WhatsApp e nada marca de onde a pessoa veio.
- Nenhum link com UTM em uso.

Próximo passo sugerido
1. Links com UTM para bio, anúncios e campanhas (posso montar).
2. Campo Origem nos formulários.
3. Para WhatsApp: perguntar ou marcar a origem no primeiro contato
   (automação ou etiqueta), com a skill de automações.

Fonte: Atlas pelo conector, em 03/11/2026. Relatório de atribuição
com gráficos: painel do CRM, widget de origem do lead.
```

Notas da montagem (para quem constrói):
- Os 3 contatos da pesquisa tinham `sessionSource: Referral`: 2 com `referrer` na página-ponte de links da própria Atlas e 1 vindo da prévia do construtor (teste interno sem o prefixo TESTE). "Indicação" aqui não é indicação de cliente: explique de onde veio e aponte possíveis testes.
- O `get-contact` de um contato criado pelo formulário trouxe `lastAttributionSource` com `sessionSource: Direct traffic`, `medium: form` e a `url` da página, mas `attributionSource` ausente porque o contato já existia antes, criado por integração.
- As oportunidades ganhas traziam `source: membership` e `attributions` com `Social media / instagram`: a atribuição vem do contato, não do negócio. Por isso, sempre confira o funil antes de chamar de venda.

## Limites para dizer ao cliente

- Busca do MCP não filtra por UTM nem por atribuição. Para recortes grandes por campanha, o relatório da tela é melhor.
- "Leads" do Meta e "leads" do CRM não batem: um conta ações no anúncio, o outro conta contatos atribuídos.
- Contato que chega pelo WhatsApp sem passar por página fica sem atribuição.
- Formulário em iframe de site externo pode perder a UTM.
