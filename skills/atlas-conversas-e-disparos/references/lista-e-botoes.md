# Mensagens com lista e botões

**Só se a conta usar a integração de WhatsApp da Atlas.** Nessas contas, uma mensagem interativa sai quando o texto da mensagem é um **comando** que começa com `#tipo|`. Fonte: skill interna da Atlas "Comandos de lista e botões para WhatsApp".

Como saber se a conta usa: a conversa mostra `messageType: TYPE_CUSTOM_SMS` em `get-messages`, ou o menu lateral tem o botão de WhatsApp da integração (roteiro em `whatsapp-da-atlas.md`, seção 1). Se a conta não usa a integração, diga que este formato não vale e ofereça template com botões (`templates-whatsapp.md`) ou texto simples.

Mensagem interativa é mensagem de sessão: só dentro da janela de 24 horas. E é envio a contato real: `CONFIRMO ENVIO`.

## Regras gerais

- Separador de campos: `|`. Ordem fixa.
- Subcampos de cada opção: `*`. Entre opções: `/`. Entre cards do carrossel: `||`.
- Os caracteres `|`, `*` e `/` não podem aparecer dentro dos textos (não há escape). Troque `/` por "ou", tire `*`, troque `|` por vírgula. Exceção: o `/` entre rodapé e texto do botão da lista.
- Campo vazio continua na posição: `#bt|Título|Descrição||Sim*id_sim`.
- Tudo numa linha só. Só funciona em conversa privada, não em grupo.

## IDs: o que volta para o CRM

Quando a pessoa toca numa opção, o que chega no CRM é o **ID** da opção. Por isso:
- ID único dentro do comando e, de preferência, entre comandos do mesmo fluxo.
- Minúsculas, sem acento, sem espaço, com `_` (ex.: `id_quero_agendar`).
- O ID diz o que a opção significa.

## Tipos

### Lista (`#list`), até 10 itens
```
#list|TÍTULO|DESCRIÇÃO|RODAPÉ/TEXTO DO BOTÃO|TÍTULO DA SEÇÃO|item1/item2/...
```
Cada item: `Texto*Descrição*id`. Sem rodapé, fica `/Ver opções`. Nunca deixe botão e seção vazios: o padrão aparece em inglês.

### Botões de resposta (`#bt`), até 3
```
#bt|TÍTULO|DESCRIÇÃO|RODAPÉ|Texto1*id1/Texto2*id2/Texto3*id3
```
Com imagem (URL pública como 2º campo):
```
#bt|TÍTULO|URL_DA_IMAGEM|DESCRIÇÃO|RODAPÉ|Texto1*id1/Texto2*id2
```

### Botão com link (`#bturl`)
```
#bturl|TÍTULO|DESCRIÇÃO|RODAPÉ|TEXTO DO BOTÃO|URL
```

### Botão de ligação (`#btcall`)
```
#btcall|TÍTULO|DESCRIÇÃO|RODAPÉ|TEXTO DO BOTÃO|TELEFONE
```
Telefone com DDI, só dígitos (ex.: `5541999999999`).

### Botão PIX (`#btpix`)
```
#btpix|NOME DO RECEBEDOR|CHAVE PIX
```
Mexe com dinheiro do cliente: confira nome e chave com ele, palavra por palavra.

### Carrossel (`#carousel`), até 10 cards
```
#carousel|TÍTULO|DESCRIÇÃO|RODAPÉ||card1||card2
```
Cada card: `Nome*URL_da_imagem*Rodapé do card*Texto do botão*id_do_botão`.

## Qual usar

- Até 3 opções curtas: `#bt`.
- 4 a 10 opções, ou opções com descrição: `#list`.
- Levar para uma página: `#bturl`.
- Produtos com foto: `#carousel`.

## Conferir antes de entregar

- Começa com `#tipo|` certo (`#list` em minúsculo).
- Número de campos bate com o formato.
- Nenhum `|`, `*` ou `/` sobrando dentro de texto.
- Limite respeitado (3 botões, 10 itens, 10 cards).
- Nenhum ID repetido. Sem quebra de linha. Sem travessão.

Entregue o comando num bloco de código e, abaixo, a tabela Opção → ID, que é o que a automação recebe para decidir o próximo passo.
