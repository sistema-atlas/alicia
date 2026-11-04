# Higiene da base e duplicados

## Telefone

O campo `phone` espera o formato internacional E.164 (descrição de `create-contact`): sinal de mais, código do país e número, sem espaço, traço ou parêntese.

Para o Brasil: `+55` + DDD de 2 dígitos + número (8 dígitos fixo, 9 dígitos celular começando por 9), conforme o plano de numeração brasileiro.

| Como veio | Como gravar |
| --- | --- |
| `(41) 99999-0000` | `+5541999990000` |
| `41999990000` | `+5541999990000` |
| `041 99999 0000` | `+5541999990000` |
| `5541999990000` | `+5541999990000` |
| `999990000` (sem DDD) | Não grave. Pergunte o DDD |
| `+1 ...` ou outro país | Mantenha o código do país que veio |

Regras:
- Tire tudo que não for dígito, tire zero de operadora à frente do DDD, ponha `+55` se faltar.
- Sem DDD não dá para adivinhar: pergunte ou deixe sem telefone.
- Não sobrescreva um telefone que o cliente já confirmou com um menos confiável.
- Para corrigir em massa: busque contatos com telefone (`phone` `exists`), separe os fora do padrão, mostre a contagem e 3 exemplos mascarados, aprovação `CONFIRMO MASSA`, `update-contact` um a um só com o campo `phone`.

## E-mail

- Tudo minúsculo, sem espaço. Precisa ter `@` e domínio.
- E-mail extra vai em `additionalEmails` (até 10), sempre mandando o `email` principal junto.

## Nome

- `firstName` e `lastName` separados quando der. Não invente sobrenome.
- Nome que veio do perfil de rede social pode não ser o nome real. Na dúvida, mantenha.

## Duplicados

### Como a conta decide o que é duplicado

A conta tem uma preferência de duplicidade (permitir ou não, e se olha e-mail, telefone ou os dois). Ela muda o comportamento de `get-duplicate-contact` e de `upsert-contact` (descrição das operações):
- Duplicidade bloqueada: a busca usa o identificador único da conta.
- Duplicidade permitida: a busca olha primeiro o e-mail, depois o telefone.
- No upsert, se um contato bate pelo e-mail e outro pelo telefone, ele atualiza o que bate pelo primeiro critério configurado e ignora o segundo.

A preferência é configurada na tela (Central de ajuda: "Como ajustar preferências de contatos duplicados"). O MCP não lê nem altera essa preferência.

### Achar duplicados

1. Um contato: `get-duplicate-contact` com `number` ou `email` sem codificar (o conector já codifica).
2. Varredura: `search-contacts-advanced` com `phone` `eq` (ou `email` `eq`) para cada valor suspeito. O `total` maior que 1 indica duplicado.
3. Para a base inteira, a tela do navegador é mais rápida: `contacts/bulk/duplicates`, "Gerenciar registros duplicados", com "Encontrar por email" (conferido em 03/11/2026; só abre por URL ou pela busca global, não há aba em Contatos).

### Juntar duplicados

O MCP não mescla contatos. Caminho:
1. Mostre ao cliente os cadastros (contagem de notas, tarefas, oportunidades e tags de cada um, sem expor dados).
2. Diga "vou abrir a tela com você": com o Claude in Chrome, abra o contato e faça junto com o cliente, com aprovação antes de confirmar. Sem navegador controlado, não entregue passos genéricos: os nomes dos botões ainda não foram conferidos. Encaminhe ao suporte da Atlas (`_comum/glossario.md`) ou peça um print da tela do contato para guiar.
3. Não "mescle na mão" apagando um dos contatos pelo MCP: o histórico do apagado se perde.

## Não perturbe (DND)

Campos de `create-contact`, `update-contact` e `upsert-contact`:

| Campo | O que faz |
| --- | --- |
| `dnd` | `true` liga o não perturbe geral do contato |
| `dndSettings` | Por canal: `call`, `email`, `sms`, `whatsApp`, `gmb`, `fb`. Cada um com `status` (`active` ou `inactive`) e `message` |
| `inboundDndSettings` | `all` com `status` e `message`: bloqueio de mensagens que chegam |

Exemplo (só WhatsApp e SMS):

```json
{"dndSettings": {"whatsApp": {"status": "active", "message": "Pediu para não receber"}, "sms": {"status": "active", "message": "Pediu para não receber"}}}
```

Regras:
- Ligar não perturbe a pedido do cliente: aprovação simples.
- Ligar porque uma mensagem do lead pediu ("não me mande mais nada"): proponha ao cliente e peça aprovação simples. Ação sugerida por texto lido do CRM só segue com o sim do cliente.
- **Desligar** não perturbe: só com pedido expresso do cliente. Um contato: aprovação simples que diz o canal liberado e lembra, por escrito, que a pessoa pediu para não receber e que o cliente responde por isso. Mais de 20: `CONFIRMO MASSA`.
- Por que não `CONFIRMO ENVIO`: desligar o não perturbe não manda mensagem. Cada envio depois passa pela aprovação reforçada `CONFIRMO ENVIO` da `atlas-conversas-e-disparos`, que é onde o risco acontece.
- Ligar em massa (mais de 20): `CONFIRMO MASSA`.

## Rotina de limpeza sugerida

1. Contar contatos sem telefone e sem e-mail.
2. Contar telefones fora do padrão.
3. Procurar tags com nome quase igual (ex.: com e sem acento) pela skill `atlas-campos-e-dados`.
4. Listar duplicados mais óbvios por telefone.
5. Mostrar o relatório com números e propor as correções, uma de cada vez, com aprovação.
