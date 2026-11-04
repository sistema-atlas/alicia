# Regras do WhatsApp oficial

Fontes: skill interna da Atlas "Criador de Templates para WhatsApp Oficial" (versão 1.9, outubro de 2026, com as regras e os números publicados pela Meta), Help Center da Atlas ("Limites e boas práticas do WhatsApp", "Como verificar janela de atendimento do WhatsApp em uma automação"). Números de preço e limite mudam: cite sempre a data e peça para conferir na Meta antes de usar em proposta.

## Janela de 24 horas

- Quando o contato manda mensagem, abre uma janela de 24 horas. Dentro dela, a empresa responde com texto livre, áudio, imagem, vídeo, lista ou botões (mensagem de sessão).
- Fora da janela, só **template aprovado pela Meta**.
- Como conferir: em `get-messages`, pegue a última mensagem com `direction: inbound` e compare o `dateAdded` com agora.
- Conversa iniciada por anúncio de clique para WhatsApp abre 72 horas gratuitas para qualquer categoria (fonte: skill interna, contexto de custo).
- Em automação existe a etapa de verificar a janela, com caminho para janela aberta e para janela fechada (Help Center). Montar isso é da skill `atlas-automacoes`.

## Categorias de template

| Categoria | Quando | Observação |
| --- | --- | --- |
| Utilidade | O contato fez algo (agendou, comprou, se inscreveu, pediu contato, tem conta ou pagamento) e a mensagem é só sobre isso, sem oferta | Custa quase 10 vezes menos que marketing |
| Marketing | Qualquer oferta, convite que o contato não pediu, reativação, novidade, data comemorativa, ou mistura de utilidade com promoção | Exige opt-in e opção de saída |
| Autenticação | Código de verificação | Só o modelo pronto da biblioteca da Meta, texto fixo |

- A Meta decide pelo **conteúdo**, não pelo que se marca. Desde abril de 2025 ela muda utilidade para marketing automaticamente.
- Abuso leva a escalada: aviso, limite de volume de utilidade, templates de utilidade virando marketing e bloqueio para criar utilidade de 7 a 30 dias, podendo atingir o portfólio inteiro. Revisão de categoria pode ser pedida em até 60 dias pelo WhatsApp Manager.
- Detalhe da árvore de decisão e palavras que derrubam utilidade: `references/templates-whatsapp.md`.

## Custos (referência de outubro de 2026, confira a tabela atual da Meta)

- Cobrança por mensagem entregue desde 1º de julho de 2025.
- Brasil em reais desde 1º de julho de 2026: marketing cerca de R$ 0,32 por mensagem; utilidade e autenticação cerca de R$ 0,035.
- Anunciado pela Meta para 1º de outubro de 2026: utilidade enviada dentro da janela aberta pelo cliente passa a ser cobrada; respostas de atendimento sem template têm 1.000 grátis por número por mês e depois pagam tarifa de utilidade.

## Opt-in e saída

- Só pode iniciar conversa com quem deu o número e aceitou receber mensagens da empresa pelo WhatsApp.
- Pedido de saída feito por qualquer canal precisa ser respeitado. Registre no contato (tag ou campo, skill `atlas-contatos`) e tire do público.
- Marketing sempre leva saída: botão de opt-out de marketing, resposta rápida "Não quero receber" ou uma frase final convidando a avisar.

## Limites e qualidade

- Limite de envio é por portfólio. Portfólio novo começa com 250 contatos por dia e sobe com o uso.
- A Meta limita quantas mensagens de marketing cada pessoa recebe, conforme o engajamento. Erro 131049 significa limite atingido: espere 24 horas ou mais, nunca reenvie em loop. Números dos EUA (+1) não recebem marketing.
- Qualidade do template: muitas denúncias e bloqueios pausam o template por 3 horas, depois 6 horas; na terceira vez ele é desativado.
- Revisão da Meta leva até 24 horas. Template sem uso por 12 meses é arquivado.
- Qualidade do número depende de volume, respostas, bloqueios e denúncias (Help Center). Sinais de queda: muitas mensagens sem resposta, reclamações, falhas de envio.

## Quando a qualidade cai (Help Center, "Limites e boas práticas do WhatsApp")

1. Reduza o volume na hora. Pause disparos em andamento (automação em rascunho, skill `atlas-automacoes`).
2. Revise a origem dos contatos: quem não pediu para receber sai do público.
3. Melhore a segmentação e a abordagem: mensagem clara, com nome da empresa e motivo do contato.
4. Respeite quem pediu para parar.
5. Se houver bloqueio ou falha de envio, acione o suporte da Atlas (`references/_comum/glossario.md`).

## Boas práticas (Help Center)

- Prefira conversas esperadas pelo contato. Nada de disparo frio.
- Mensagens objetivas, com identificação da empresa e motivo.
- Responda rápido: canal saudável responde dentro do prazo combinado.
- Teste com poucos atendimentos antes de divulgar o canal.
- Use templates e snippets com linguagem humana.
