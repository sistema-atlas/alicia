# Trava de disparo

Vale para qualquer envio a mais de um contato: disparo por automação, ação em massa na lista de contatos, campanha de SMS ou WhatsApp, contatos colocados numa automação que manda mensagem. Fonte: skill interna da Atlas "Trava de disparo", criada depois de um disparo real que saiu para centenas de pessoas com botões apontando para páginas fora do ar. Um envio de teste teria pegado o erro.

Nenhum contato real recebe nada antes dos 5 passos. Nem com pressa, nem se o cliente pedir para "já deixar publicado".

## Passo 1. Inventário

Mostre ao cliente, em lista:
- **Canal e número de envio** (ou número da integração, na integração de WhatsApp da Atlas).
- **Público**: de onde vem (tag, lista, filtro), quantos contatos, 3 exemplos com primeiro nome e telefone mascarado. Contagem pela skill `atlas-contatos`.
- **Quem fica fora**: quem pediu para sair, quem não deu opt-in, números que não recebem marketing (EUA, +1).
- **Texto final** de cada mensagem, com as variáveis e o valor de exemplo de cada uma.
- **Template** (nome e status na Meta) se for fora da janela de 24 horas. Status tem que ser aprovado.
- **Cada botão e cada link**: tipo e destino final. O destino vem do cadastro do template, não da memória.
- **Saída (opt-out)**: como a pessoa para de receber. Marketing sem saída não sai.
- **Data e hora** de cada envio e o que acontece se a data já passou.

## Passo 2. Links no ar

Para cada link e botão:
- Abra o endereço de verdade (navegador ou leitura da página), seguindo redirecionamentos. Tem que terminar na página certa, carregando.
- Confira que formulário, botão de grupo ou agenda abrem o destino certo.
Qualquer link com erro trava tudo. Avise o cliente na hora e não siga.

## Passo 3. Envio de teste real

- Para o **número ou e-mail do próprio cliente** (ou de alguém da equipe que ele indicar). Nunca para lead.
- Exatamente a mesma mensagem que a base vai receber: mesmo template, mesmas variáveis, mesmo número de envio.
- Um teste por template diferente e por variação de variável que muda o sentido.
- O teste é envio real: `CONFIRMO ENVIO` para ele também.
- Avise que o contato de teste pode disparar automações da conta (`regras-de-seguranca.md`, seção 6).

## Passo 4. Confirmação do cliente

Pergunte e espere resposta:
- A mensagem chegou e o texto está certo?
- Tocou em cada botão e abriu a página certa no celular?
Só conta como aprovado quando ele responder que sim. Silêncio não é aprovação.

## Passo 5. Liberar o disparo

Aprovação reforçada com as duas palavras, nesta ordem, cada uma numa resposta:
1. `CONFIRMO MASSA` (quantidade de contatos e 3 exemplos).
2. `CONFIRMO ENVIO` (canal, número, texto final, data e hora).

Depois:
- Libere em lotes e acompanhe as respostas antes do próximo lote. Prática interna da Atlas: lotes de 100 por hora na automação. Na integração de WhatsApp da Atlas, o disparo oficial sai em torno de 80 contatos por minuto (skill interna de templates).
- Confira a contagem de inscritos ou enviados.
- Se a automação foi publicada com antecedência, repita o passo 2 no dia do primeiro envio, antes do horário.

## Quando algo der errado depois de liberado

1. Pause na hora tudo que envia (automação em rascunho, skill `atlas-automacoes`). Pausar é proteção: faça e avise.
2. Levante quantas pessoas receberam e o que tinha nos botões.
3. Conte ao cliente o que aconteceu, sem suavizar.
4. Se a qualidade do número caiu, siga `whatsapp-oficial.md`, seção "Quando a qualidade cai".

## Pedido de "manda para todo mundo"

- Não existe disparo para "todo mundo" sem filtro. Pergunte o público em uma pergunta só ("Para quem exatamente: todos os contatos, ou uma tag ou lista?").
- Base inteira sem opt-in claro: recuse o disparo de marketing e explique o risco de bloqueio do número. Ofereça segmentar quem pediu para receber.
