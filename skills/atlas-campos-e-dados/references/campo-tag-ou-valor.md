# Campo, tag ou valor personalizado: qual usar

## Em uma frase

| Use | Quando | Exemplo |
| --- | --- | --- |
| **Campo personalizado** | Uma informação que muda de pessoa para pessoa (ou de negociação para negociação) e que você quer ver, filtrar ou usar em mensagem | CPF, data de nascimento do pet, valor do orçamento, tipo de serviço |
| **Tag** | Uma marca de sim ou não que agrupa pessoas e costuma ligar automação | `cliente`, `evento-junho`, `orcamento-enviado` |
| **Valor personalizado** | Um texto fixo da empresa, igual para todo mundo, que aparece em várias mensagens ou páginas | link da agenda, endereço da clínica, nome do responsável, horário de atendimento |

## Perguntas para decidir

1. Muda de um contato para outro? Sim: campo ou tag. Não, é igual para todos: valor personalizado.
2. A informação tem um valor (texto, número, data, opção)? Sim: campo. É só "tem ou não tem": tag.
3. Vai disparar ou parar automação? Tag é o gatilho mais simples. Campo também pode ser gatilho ("campo alterado"), mas exige mais cuidado.
4. Vai aparecer em relatório ou filtro por faixa (valor maior que, data entre)? Campo.
5. Pode ter mais de uma ao mesmo tempo? Tags podem. Campo de opção única não; use campo de várias opções.

Se o cliente não souber responder, faça só a pergunta 1. Ela resolve a maioria dos casos.

## Tipos de campo em palavras simples

| O cliente quer | Tipo | Observação |
| --- | --- | --- |
| Texto curto (nome do pet, cidade) | `TEXT` | |
| Texto longo (observação, resumo) | `LARGE_TEXT` | |
| Número inteiro (quantidade) | `NUMERICAL` | |
| Número com casas decimais | `FLOAT` | |
| Dinheiro | `MONETORY` | |
| Telefone extra | `PHONE` | Telefone principal já existe no contato |
| Data | `DATE` | |
| Uma opção de uma lista (origem, prioridade) | `SINGLE_OPTIONS` | Padroniza o dado, bom para filtro |
| Várias opções de uma lista (produtos de interesse) | `MULTIPLE_OPTIONS` ou `CHECKBOX` | |
| Escolha visível em botões redondos | `RADIO` | |
| Anexar documento | `FILE_UPLOAD` | Central de ajuda "Como anexar arquivos no perfil do contato" |
| Assinatura | `SIGNATURE` | |
| Várias caixas de texto com rótulo | `TEXTBOX_LIST` | Exige `textBoxListOptions` |

Tipos `URL`, `USER`, `TIME`, `DATE_TIME` e `RICH_TEXT` estão marcados como experimentais no describe. Não use sem pedido do cliente.

## Onde o campo mora

| Informação de | Objeto |
| --- | --- |
| A pessoa | Contato (`model: contact`) |
| A negociação (valor, produto, motivo) | Oportunidade (`model: opportunity`) |
| A empresa cliente | Empresa (`objectKey: business`, domínio custom-fields) |
| Algo que se repete várias vezes por pessoa (pets, imóveis, veículos) | Objeto personalizado (ver `objetos-e-ligacoes.md`) |

Central de ajuda "Como criar campos personalizados em oportunidades": se o objeto errado for escolhido, o campo aparece em contatos ou empresas e não dentro das oportunidades.

## Como usar em mensagem

- Campo de contato: `{{contact.<chave>}}`. A chave vem em `fieldKey` (ex.: `contact.cpf`), leia com `get-custom-fields`.
- Campo de oportunidade: a chave vem como `opportunity.<chave>` (ex.: `opportunity.prioridade`). Confirme na tela de mensagem qual variável aparece (a conferir no navegador).
- Valor personalizado: `{{custom_values.<chave>}}`. O `fieldKey` de `get-custom-values` já vem pronto, ex.: `{{ custom_values.link_agenda }}`.
- Sempre copie a chave da resposta do MCP. A chave perde acento: "Endereço" pode virar `endereo`.

## Boas práticas de nome

- Campo: nome curto e claro, com acento normal ("Origem do lead"). A chave será gerada sem acento.
- Tag: minúsculas, hífen no lugar de espaço, sem acento, com contexto: `origem-instagram`, `evento-2026-06`. Evite duas tags que diferem só por acento ou espaço (ex.: "disparo reativacao" e "disparo reativação").
- Valor personalizado: nome que diga onde é usado: "Link da agenda de avaliação".
