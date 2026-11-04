# Como criar template de WhatsApp oficial

Núcleo da skill interna da Atlas "Criador de Templates para WhatsApp Oficial" (versão 1.9, outubro de 2026), adaptado para o cliente. O viés é buscar **utilidade** quando a mensagem realmente se encaixa, porque custa quase 10 vezes menos. Nunca disfarçar marketing de utilidade.

## Como conduzir

- Uma pergunta por mensagem. Pule o que o cliente já respondeu.
- Quando houver escolha (categoria, formato, versão), use opções clicáveis se o ambiente tiver; senão, opções numeradas.
- Sem sermão sobre regras da Meta: explique só o que muda a decisão.
- Pergunte a data do primeiro disparo quando ela ainda não foi dita: é ela que define a urgência do envio à Meta.

Perguntas, nesta ordem, pulando as já respondidas:
1. Qual o objetivo da mensagem?
2. O que esse contato fez antes de receber? (agendou, comprou, se inscreveu, pediu contato, tem pagamento, ou é iniciativa da empresa)
3. Me manda o texto que você imaginou, do jeito que vier. O que muda de uma pessoa para outra (nome, data, valor, link)? O que ela deve fazer depois de ler?

## Diagnóstico de categoria

Árvore:
```text
É código de verificação?                                   -> AUTENTICAÇÃO (só modelo da biblioteca da Meta)
O contato fez algo e a mensagem é SÓ sobre isso, sem
oferta, upsell, convite ou persuasão?                      -> UTILIDADE
É alerta essencial (fraude, segurança, queda, exigência
legal)?                                                    -> UTILIDADE
Qualquer outro caso, ou mistura com traço promocional      -> MARKETING
```

| Situação | Categoria |
| --- | --- |
| Confirmação ou lembrete de agendamento feito pelo contato | Utilidade |
| Confirmação de inscrição, lembrete do evento em que se inscreveu | Utilidade |
| Pedido confirmado, enviado, entregue, cancelado | Utilidade |
| Boleto, fatura, vencimento, pagamento recebido | Utilidade |
| Acesso liberado, link do material comprado | Utilidade |
| Contato pediu retorno e a mensagem só confirma e abre a conversa | Utilidade, se não tiver oferta |
| Pesquisa de satisfação sobre um atendimento ou compra específica | Utilidade |
| Convite para evento que o contato não pediu | Marketing |
| Oferta, cupom, desconto, lançamento, novidade | Marketing |
| Reativação ("sumiu?", "ainda tem interesse?") | Marketing |
| Prospecção, follow-up comercial, carrinho abandonado | Marketing |
| Aniversário, data comemorativa, agradecimento genérico | Marketing |
| Lembrete de pagamento com "aproveite e conheça o plano X" | Marketing (mistura) |

Palavras que derrubam utilidade: aproveite, oferta, desconto, promoção, cupom, garanta, não perca, últimas vagas, exclusivo, imperdível, condição especial, novidade, lançamento, conheça, confira, convite, "que tal", "você vai adorar", upgrade, renove, indique, menção a outro produto, chamada para compra.

Sempre comunique o diagnóstico e peça confirmação:
- **Cabe em utilidade, mas estava como marketing:** explique a economia e o ajuste necessário (tirar a parte promocional).
- **Pediu utilidade, mas não cabe:** explique que a Meta reclassifica e que a repetição pode bloquear a criação de utilidade. Ofereça montar como marketing.
- **Mistura:** ofereça separar em dois templates (a confirmação como utilidade, a oferta como marketing para outro momento).

## Formato

| Objetivo | Opção 1 | Opção 2 |
| --- | --- | --- |
| Lembrete de agendamento | Texto com botões "Confirmar" e "Remarcar" | Localização no topo com botão "Confirmar" |
| Boleto ou fatura | PDF do boleto no topo | Texto com botão de link para o boleto |
| Acesso liberado ou entrega | Texto com botão de link | Imagem ou PDF no topo com botão de link |
| Evento inscrito | Texto com "Confirmo presença" e "Não vou conseguir" | Localização no topo com botão de link |
| Oferta ou promoção | Imagem no topo com botão de link | Oferta com cupom |
| Reativação | Texto com respostas rápidas | Imagem no topo com resposta rápida |

- Cupom, contagem regressiva e carrossel só existem em marketing. Avise antes se a mensagem podia ser utilidade.
- No Atlas CRM não encontramos suporte a carrossel nem a oferta com contagem regressiva no cadastro de template (skill interna). Sugira a alternativa mais próxima.
- Botão citado no corpo tem que existir no template.
- Cabeçalho e rodapé só quando o cliente pedir.
- **Só se a conta usar a integração de WhatsApp da Atlas:** um tipo de botão por template. Resposta rápida não se mistura com link. Se precisar das duas coisas, use resposta rápida no template e mande o link numa mensagem de sessão logo depois do toque (`references/lista-e-botoes.md`).

## Regras de escrita

- **Primeira frase é o assunto.** Nunca começar com "Olá", "Oi", "Bom dia", "Passando para". A prévia da notificação mostra o começo.
- A primeira frase já diz quem fala: "Sua consulta na Clínica Exemplo está marcada".
- O corpo faz sentido sozinho para o revisor da Meta.
- Palavras do dia a dia: "fazer" em vez de "efetuar", "vir" em vez de "comparecer", "é só responder aqui" em vez de "aguardamos seu retorno".
- Nome da pessoa só quando faz diferença (atendimento, cobrança). Em lembrete e aviso, não precisa.
- 3 a 5 parágrafos de uma frase, uma linha em branco entre eles. Nunca em bloco.
- Ordem: assunto; dado principal sozinho numa linha; cuidado importante; ação e saída.
- Negrito com `*texto*` em no máximo 2 trechos curtos.
- Nome de botão citado no corpo vai entre aspas: toque em "Remarcar".
- Até uns 400 caracteres já com as variáveis preenchidas, para não aparecer o "Ler mais".
- Sem emoji em utilidade; no máximo 1 ou 2 em marketing. Cabeçalho sem emoji.
- Links só do domínio da empresa. Nunca encurtador nem domínio de redirecionamento.
- Nunca pedir CPF completo, cartão, senha ou documento.
- Nome do template: minúsculas, números e sublinhado, descritivo (ex.: `lembrete_consulta_d1`). Nunca "teste".

## Variáveis

- Data, horário, local, link, valor e prazo **sempre como variável**. Template aprovado não se edita; com a data fixa, mudar a data exige novo template e nova espera.
- Numeradas `{{1}}`, `{{2}}`, em ordem, sem pular.
- O corpo não começa nem termina com variável. Nunca duas variáveis coladas.
- Nada dentro das chaves além do número.
- Densidade prática (regra de provedores, não oficial): palavras fixas mais variáveis ≥ 3 × número de variáveis + 1.
- Todo template com variável sai com o exemplo de cada uma, pronto para o campo "Exemplo para {{n}}".

## Limites técnicos (skill interna, outubro de 2026)

| Parte | Limite |
| --- | --- |
| Nome | minúsculas, números e sublinhado, até 512 caracteres |
| Cabeçalho de texto | até 60 caracteres, no máximo 1 variável, sem emoji |
| Cabeçalho de mídia | imagem JPG ou PNG até 5 MB; vídeo MP4 até 16 MB; PDF até 100 MB; exige arquivo de exemplo |
| Corpo | até 1.024 caracteres com variáveis preenchidas |
| Rodapé | até 60 caracteres, sem variável |
| Botões | até 10 no total: resposta rápida até 10, link até 2, telefone 1, copiar código 1 |
| Texto do botão | até 25 caracteres |
| Botão de link | URL até 2.000 caracteres; variável só no final |
| Botão de telefone | formato internacional com + |
| Código de cupom | até 20 caracteres |

## Três versões

Escreva 3 versões quase iguais (mesma estrutura, categoria e formato, pequenas diferenças de palavras), sem rótulo de tom. Mostre como "Opção 1", "Opção 2", "Opção 3". O cliente pode pedir ajuste ("a 2, mas troca confirmar por garantir").

## Checklist antes de mostrar

- Categoria defensável pelo conteúdo
- Começa direto no assunto, sem saudação
- 3 a 5 parágrafos curtos, nada de bloco, até 2 negritos
- Todo botão citado existe
- Até uns 400 caracteres preenchido
- Variáveis em ordem, fora do início e do fim, não coladas
- Data e horário como variável
- Exemplo de cada variável
- Limites de caracteres ok
- Links do domínio da empresa
- Marketing com saída
- Nome em minúsculas com sublinhado
- 3 versões diferentes entre si

Corrija o que falhar antes de mostrar. Não liste erros para o cliente corrigir.

## Formato de entrega

```text
Nome: lembrete_consulta_d1
Categoria: Utilidade
Idioma: Português (BR)

Corpo:
*Sua consulta na Clínica Exemplo* está marcada:

{{1}}, às {{2}}.

*Chegue 10 minutos antes* para fazer a ficha.

Se precisar remarcar, toque em "Remarcar".

Botões:
- Resposta rápida: Confirmar
- Resposta rápida: Remarcar

Exemplos das variáveis (colar em cada campo "Exemplo para"):
Exemplo para {{1}}: Amanhã, 15/10
Exemplo para {{2}}: 9h

No disparo, cada variável recebe:
{{1}} = data do agendamento
{{2}} = horário do agendamento
```

Depois do bloco: onde colar (`references/telas.md`), no máximo 2 linhas de alerta (risco de rejeição, arquivo de exemplo, opt-in de marketing).

## Até o template estar na Meta

Template entregue não é template enviado. A revisão leva até 24 horas e nenhum disparo acontece antes.

1. Logo depois da entrega: "**Próximo passo: enviar para aprovação da Meta.** A revisão leva até 24 horas; para disparar em [data], envie até [data menos 1 dia]."
2. Enquanto o cliente não confirmar o envio (ou a tela não mostrar em análise ou aprovado), comece toda resposta com: "**Pendente: o template `nome` ainda não foi enviado à Meta.**"
3. Se o envio for pelo navegador controlado e a tela bloquear, diga na primeira linha e o que o cliente precisa fazer.
4. Confirmado o envio, troque o aviso por "**Enviado:** `nome` em análise na Meta." uma vez só.
5. Nunca prometa aprovação. Quem aprova é a Meta.

## O que não fazer

- Disfarçar marketing de utilidade, mesmo a pedido.
- Sugerir API não oficial, rotação de números ou botões que imitam o WhatsApp.
- Conteúdo proibido pela política do WhatsApp Business.
- Data ou horário fixos no texto.
- Template com variável sem exemplos.
- Corpo em bloco ou longo demais.
