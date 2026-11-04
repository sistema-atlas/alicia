# Formato de aprovação

Funciona no Claude e no Codex. No Claude, se houver ferramenta de perguntas com opções, use as mesmas opções como botões. No Codex e em qualquer cliente sem botões, use texto puro.

## Aprovação simples

```
Vou fazer isto na conta <Nome da conta>:
- <ação em palavras do cliente>
- <onde: contato, funil, campo>
Pré-visualização conferida, nada foi alterado ainda.

Responda SIM para eu fazer, ou diga o que mudar.
```

## Aprovação reforçada

```
ATENÇÃO: esta ação <envia mensagem | apaga | movimenta dinheiro | altera muitos registros | publica | muda acessos>.
Conta: <Nome da conta>
O que: <ação>
Quantidade: <n registros>   Exemplos: <3 exemplos sem dados sensíveis>
<Canal e número de envio | Valor e destinatário | Link que vai ao ar>
Dá para desfazer: <sim | em parte | não>

Para confirmar, responda exatamente: CONFIRMO <palavra-chave da ação>
```

Palavras-chave: `CONFIRMO ENVIO`, `CONFIRMO EXCLUSÃO`, `CONFIRMO COBRANÇA`, `CONFIRMO MASSA`, `CONFIRMO PUBLICAÇÃO`, `CONFIRMO ACESSO`. Aceite a palavra com ou sem acento.

Qualquer outra resposta (ok, pode, vai, beleza) não vale para aprovação reforçada: repita o pedido de confirmação uma vez, curto.

## Plano de várias etapas

```
Plano para "<pedido>":
1. <etapa>
2. <etapa>
3. <etapa> (!)
As etapas marcadas com (!) vão pedir confirmação própria na hora.

Responda SIM para começar.
```
