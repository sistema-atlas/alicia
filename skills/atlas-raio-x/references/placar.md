# Placar do raio-x

Os cortes abaixo são critérios do raio-x da Atlas, escolhidos para orientar a conversa. Não são regras da plataforma. Se o cliente discordar de um corte (por exemplo, o prazo de oportunidade parada), use o dele e diga que mudou.

Cor "não verificado": a leitura falhou ou o conector não alcança. Nunca conte como verde.
"Sem cor": a área não se aplica ao negócio do cliente. Não entra nas melhorias.

## Critérios por área

| Área | Verde | Amarelo | Vermelho |
| --- | --- | --- | --- |
| Funis e etapas | Pelo menos 1 funil de vendas; nenhuma etapa chamada Perdido ou Perdida; existe funil de reciclagem | Falta funil de reciclagem, ou funil com 1 etapa só | Nenhum funil, ou etapa Perdido usada como etapa |
| Motivos de perda | 3 ou mais | 1 ou 2 | Nenhum |
| Campos de oportunidade | Há campos que a equipe preenche (origem, produto, valor, datas) | Nenhum campo de oportunidade | (não se aplica) |
| Campos de contato | Campos do negócio existem (ex.: empresa, cargo, cidade) | Só os campos padrão | (não se aplica) |
| Tags | Sem nomes repetidos com grafia parecida; tags de teste identificadas | Tags quase iguais (só muda acento, maiúscula, hífen ou espaço) ou muitas tags de teste | (não se aplica) |
| Formulários e pesquisas | Há pelo menos 1 formulário. O conector só traz o nome: não diga se é de captura sem perguntar ao cliente | Nenhum formulário | (não se aplica) |
| Automações | Há automações publicadas | Rascunhos sem nome ("New Workflow"), de teste ("TESTE"), rascunho parado junto com uma versão publicada parecida, ou automação **publicada** com "TESTE" ou "apagar depois" no nome (fica ligada na conta) | Nenhuma automação publicada |
| Agendas | Agenda ativa, se o negócio agenda reunião ou atendimento | Agenda ativa sem membro da equipe | Negócio agenda e não há agenda |
| Equipe | Mais de 1 usuário e só quem precisa como administrador | Todos são administradores | (não se aplica) |
| Conversas sem resposta | 0 | 1 a 10 | Mais de 10 |
| Oportunidades paradas (abertas sem mudar de etapa há mais de 30 dias, fora da espera planejada) | Menos de 10% das abertas | De 10% a 30% | Mais de 30% |
| Qualidade dos contatos | Menos de 5% sem telefone e sem e-mail | De 5% a 20% | Mais de 20% |
| Contatos duplicados | `allowDuplicateContact` desligado | Ligado (permite duplicados) | (não se aplica) |
| Kit da marca (logo, cores e fontes) | Existe um kit padrão | Nenhum kit | (não se aplica) |
| Base de conhecimento | Existe, se a conta usa agente de IA | Agente de IA sem base | (não se aplica) |
| Widget de chat | Existe, se a empresa tem site | Sem widget e com site | (não se aplica) |
| Telefonia | Há número ativo, se a empresa liga ou manda SMS pelo CRM | Nenhum número e a empresa diz que liga pelo CRM | Sem cor: a empresa não usa ligação pelo CRM (pergunte se não souber) |
| Redes sociais | Contas conectadas, nenhuma vencida nem vencendo | Alguma vence nos próximos 7 dias, ou tem data de `expire` já passada com `isExpired: false` (conferir na tela) | Alguma com `isExpired: true` |
| WhatsApp | Há conversas por WhatsApp oficial ou por integração (`TYPE_WHATSAPP` ou `TYPE_CUSTOM_SMS`) | Nenhuma nas duas consultas | (nunca) |

Regras de leitura:
- Etapa Perdido: compare o nome da etapa sem acento e em minúsculas com "perdido", "perdida", "perdidos", "perda". Nomes como "Venda perdida" contam.
- Funil de reciclagem: nome do funil com "reciclagem", "reativação" ou "incubação". Na dúvida, pergunte ao cliente.
- Tags quase iguais: compare sem acento, em minúsculas e trocando hífen, sublinhado e espaço por nada. Ex.: "disparo reativacao" e "disparo reativação".
- Oportunidade parada: `lastStageChangeAt` mais antigo que 30 dias antes de hoje. Se houver mais de 500 abertas, conte as 500 primeiras e diga que foi amostra.
- **Espera planejada não é parada.** Não conte como parada a oportunidade que está em funil de reciclagem ou em etapa de espera planejada (nome com incubação, nutrição, aguardando, reciclagem; compare sem acento e em minúsculas). Mostre essas à parte: "<n> oportunidades em espera planejada". Separe a contagem por funil.
- WhatsApp: nunca afirme desconectado. Sem conversas nas duas consultas, diga: "Não encontrei conversas pelo WhatsApp; vale conferir a conexão na tela."

## Prioridade (para escolher as 3 melhorias)

Ordem de impacto na venda. Pegue as 3 primeiras que não estão verdes (ignore "sem cor" e "não verificado").

| Ordem | Situação | Melhoria em palavras do cliente | Skill |
| --- | --- | --- | --- |
| 1 | Conversas sem resposta | "Responder quem está esperando e criar um aviso para a equipe não deixar conversa parada" | atlas-conversas-e-disparos, depois atlas-automacoes |
| 2 | Oportunidades paradas (fora da espera planejada) | "Revisar os negócios parados e criar follow-up automático por etapa" | atlas-funil-e-vendas, depois atlas-automacoes |
| 3 | Funil sem reciclagem ou com etapa Perdido | "Tirar a etapa Perdido e criar o funil de reciclagem para o lead perdido voltar a ser trabalhado" | atlas-funil-e-vendas |
| 4 | Nenhuma automação publicada | "Ligar o básico: resposta ao lead novo, follow-up e lembrete" | atlas-automacoes |
| 5a | WhatsApp sem conversas nas duas consultas | "Conferir se o WhatsApp está conectado" | atlas-conversas-e-disparos |
| 5b | Rede social vencida ou vencendo em 7 dias | "Renovar a conexão da rede social antes que as postagens parem" | atlas-social-e-reputacao |
| 6 | Contatos sem telefone e sem e-mail | "Completar ou limpar os contatos sem forma de contato" | atlas-contatos |
| 7 | Poucos ou nenhum motivo de perda | "Cadastrar os motivos de perda para saber por que se perde venda" | atlas-funil-e-vendas |
| 8 | Nenhum formulário | "Criar o formulário que leva o lead direto para o CRM" | atlas-formularios |
| 9 | Duplicados permitidos | "Ajustar a regra de contatos duplicados" | atlas-contatos |
| 10 | Automação de teste publicada | "Desligar as automações de teste que ficaram ligadas" | atlas-automacoes |
| 11 | Tags quase iguais ou de teste | "Juntar as tags repetidas e apagar as de teste" | atlas-contatos |
| 12 | Rascunhos de automação sem uso | "Arquivar ou apagar rascunhos que não servem mais" | atlas-automacoes |
| 13 | Equipe toda administradora | "Dar a cada pessoa só o acesso que ela usa" | atlas-conta-e-equipe |
| 14 | Sem kit da marca | "Cadastrar logo, cores e fontes da marca" | atlas-conta-e-equipe |
| 15 | Sem agenda (negócio que agenda) | "Criar a agenda e o link de agendamento" | atlas-agenda |
| 16 | Telefonia amarela | "Ativar um número para ligar pelo CRM" | atlas-conversas-e-disparos |
