# Explicar e auditar automações

## Como explicar em português simples

Uma linha por bloco, na ordem em que o contato passa:

```
Automação: <nome> (<Rascunho | Publicada>)
Começa quando: <gatilho em palavras do cliente> <filtros: "só se a tag for X", "só no formulário Y">
Depois:
1. <ação> (ex.: manda WhatsApp "Oi {{contact.first_name}}, recebemos seu pedido")
2. Espera <tempo>
3. Se <condição>: <caminho A>. Se não: <caminho B>
Para quando: <meta, resposta, fim do fluxo, ou "não tem parada">
Envia por: <canal e número, ou "não envia mensagem">
```

Variáveis entre chaves (ex.: `{{contact.first_name}}`) viram palavras: "o primeiro nome do contato".

## Lista de checagem (ordem de gravidade)

| # | Problema | Como achar | Gravidade |
| --- | --- | --- | --- |
| 1 | Publicada sem gatilho, ou gatilho sem filtro que pega todo contato | Definição sem trigger, ou trigger amplo (ex.: contato criado sem filtro) que manda mensagem | Alta |
| 2 | Manda mensagem e não para quando o lead responde, agenda, compra ou é marcado perdido | Sem meta de conclusão, sem condição de saída, sem "parar ao responder" nas configurações | Alta |
| 3 | Laço: a automação põe a tag ou muda o campo que é o próprio gatilho, ou duas automações se chamam | Ação "adicionar tag X" com gatilho "tag X adicionada"; automação A coloca em B e B coloca em A | Alta |
| 4 | Duas automações publicadas no mesmo gatilho e mesmo filtro | Compare gatilhos de todas as publicadas (`get-workflow` + definição de cada uma) | Alta |
| 5 | Mensagem sem janela de horário | Envio sem configuração de horário e sem espera até horário comercial | Média |
| 6 | WhatsApp oficial com texto livre fora da janela de atendimento | Envio de texto sem passo de verificação de janela de atendimento antes | Média |
| 7 | Mensagens seguidas sem espera | Duas ações de envio em sequência sem espera entre elas | Média |
| 8 | Reentrada ligada em follow-up | Contato pode entrar de novo e receber a sequência outra vez (configuração de reentrada) | Média |
| 9 | Rascunho esquecido | Automação em rascunho que o cliente acha que está rodando | Média |
| 10 | Passo apontando para algo que não existe | `warnings` da definição, tag ou calendário apagado, modelo de mensagem removido | Média |
| 11 | Nome que não diz o que faz | "New Workflow : 1785956067865" e parecidos | Baixa |
| 12 | Automação de teste publicada | Nome com TESTE ou "apagar depois" e status publicado | Baixa (Alta se envia mensagem) |

Sem a edição automática liberada, os itens 1 a 10 se leem na tela do construtor (`telas.md`). Os itens 9, 11 e 12 saem só do `get-workflow`.

## Como entregar a auditoria

```
Revisei <n> automações da conta <Nome>.
Mais graves:
1. <nome com link>: <problema>. Sugestão: <correção>.
2. ...
Pode melhorar:
- ...
Quer que eu corrija alguma? Eu deixo em rascunho e você aprova a publicação.
```

Correção de automação publicada segue a regra 2 do SKILL.md: pela API, rascunho, validar e publicar de volta com `CONFIRMO PUBLICAÇÃO`; no navegador, avise que salvar muda ao vivo e prefira duplicar como rascunho e trocar depois. Automação nova nasce em rascunho.
