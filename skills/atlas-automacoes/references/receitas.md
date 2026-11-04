# Receitas de automação para pequenas empresas

Cada receita diz: gatilho, filtros, passos, quando para, canal de envio. Use como roteiro no construtor ou como base para a definição pela API nova.

## De onde vêm os nomes

- Gatilhos e ações entre aspas são os rótulos exatos vistos no construtor da conta Atlas (painéis "Adicionar acionador" e "Actions") (conferido em 03/11/2026), em `fabrica/telas-conferidas-2.md`. Parte aparece em inglês mesmo com o painel em português; use como está na tela (ex.: "Add task", "Whatsapp: customer service window check").
- O que vai dentro de cada gatilho e ação (filtros, campos, opção de espera relativa ao agendamento, variáveis de mensagem) não foi aberto nessa conferência e segue `(a conferir no navegador)`.
- **Chave técnica** (o `type` de cada passo na definição): só `get-workflow-step-types` diz qual é nesta conta. Em 03/11/2026 a API nova estava fechada na conta de teste, então nenhuma chave foi confirmada. O describe da operação cita `send_email` e `add_contact_tag` apenas como exemplo de busca. Antes de gravar pela API, rode `get-workflow-step-types` com `types` ou `query` e use o que voltar.
- Item marcado `(a conferir no navegador)` não tem fonte de nome exato.

Regras para todas:
- Nasce em **Rascunho**. Publicar pede `CONFIRMO PUBLICAÇÃO` e, se envia mensagem, teste antes num contato de teste.
- Confirme com o cliente o canal e o número de envio (WhatsApp oficial, não oficial, SMS, e-mail). Antes, descubra qual WhatsApp a conta usa (`atlas-conversas-e-disparos`, seção "Qual WhatsApp esta conta usa?").
- **Conta com a integração de WhatsApp da Atlas:** o passo "WhatsApp" das receitas vira um passo de SMS. Para escolher o número, um passo de SMS só com `#sw|N` (N é a Ref. do número no painel) antes da mensagem. Template oficial: segundo passo de SMS com `#template|nome|PARAM_1`. Botões e listas: comandos de `atlas-conversas-e-disparos/references/lista-e-botoes.md`. Detalhe em `atlas-conversas-e-disparos/references/whatsapp-da-atlas.md`. Para o cliente, sempre "integração de WhatsApp da Atlas".
- Mensagem recorrente para **grupo** de WhatsApp não é automação: é o painel da integração (Grupos > Mensagens programadas), na `atlas-conversas-e-disparos`.
- Mensagens só em horário comercial ("Janela de tempo" nas configurações da automação, ou "Esperar" até o horário).

---

## 1. Lead de formulário entra no funil

- Gatilho: "Formulário enviado", filtro: o formulário de captação.
- Passos:
  1. "Criar/atualizar oportunidade" no funil de vendas, etapa "Novo lead".
  2. "Atribuir ao usuário" (responsável do contato) ou "Add owner to opportunity" (dono da oportunidade), ou deixar a regra de distribuição do funil.
  3. "Enviar notificação interna" ao responsável: "Novo lead: {{contact.name}}".
  4. "WhatsApp" de primeira resposta (texto aprovado pelo cliente).
  5. "Add task" "Ligar para o lead" com prazo de 1 hora (prazo a definir com o cliente).
- Para quando: fim do fluxo.
- Cuidado: se o formulário já cria a oportunidade sozinho, não duplique.

## 2. Lembrete de agendamento

- Gatilho: "Status do compromisso", filtro: status confirmado e o calendário certo. Um gatilho só para marcações feitas pelo próprio cliente não apareceu na lista vista em 03/11/2026 (a conferir no navegador).
- Passos:
  1. "WhatsApp" de confirmação com data e hora do agendamento.
  2. "Esperar" até 1 dia antes do horário do agendamento (opção de espera relativa ao agendamento dentro da ação, a conferir no navegador).
  3. "WhatsApp" de lembrete.
  4. "Esperar" até 2 horas antes.
  5. "WhatsApp" curto: "Te esperamos às {{appointment.start_time}}" (variável a conferir no navegador).
- Para quando: agendamento cancelado ou remarcado (outra automação tira o contato, ou condição antes de cada envio).
- Cuidado: o calendário também tem lembretes próprios (skill `atlas-agenda`). Use um ou outro, nunca os dois.

## 3. Follow-up de orçamento

- Gatilho: "Etapa do funil alterada", filtro: etapa "Orçamento enviado".
- Passos:
  1. "Esperar" 1 dia.
  2. "If/else": se o contato respondeu, sair. Se não: "WhatsApp" "Conseguiu ver o orçamento?".
  3. "Esperar" 2 dias.
  4. Se não respondeu: "WhatsApp" com uma pergunta simples.
  5. "Esperar" 3 dias.
  6. Se não respondeu: "Add task" para o vendedor ligar.
- Para quando: o lead responde (gatilho "Cliente respondeu" em outra automação que tira daqui, ou "Parar ao receber resposta" nas configurações da automação), a oportunidade muda de etapa, é ganha ou perdida. Use "Evento de meta" para a mudança de etapa.
- Cuidado: tempos são sugestão. Pergunte ao cliente.

## 4. Aniversário

- Gatilho: "Lembrete de Aniversário", pela data de nascimento do contato.
- Filtro: só clientes (tag ou tipo de contato).
- Passos:
  1. "Esperar" até 9h do dia.
  2. "WhatsApp" de parabéns (com cupom, se o cliente quiser).
- Para quando: fim do fluxo.
- Cuidado: precisa do campo data de nascimento preenchido.

## 5. Reativação de clientes parados

- Gatilho: "Tag de contato", tag `reativar` adicionada. A tag é posta à mão, por lista inteligente ou pela skill `atlas-contatos` em massa.
- Passos:
  1. "Liberação contínua" (lotes pequenos, intervalo de minutos) para não mandar tudo de uma vez.
  2. "Whatsapp: customer service window check" (janela de atendimento); se fechada, usar modelo aprovado de WhatsApp oficial.
  3. "WhatsApp" de reativação.
  4. "Esperar" 3 dias.
  5. Se não respondeu: "Remova tag de contato" `reativar` e encerrar.
- Para quando: respondeu (sai e cria tarefa para o vendedor), ou fim.
- Cuidado: é envio em massa. Colocar a tag em muitos contatos pede `CONFIRMO MASSA` e `CONFIRMO ENVIO`.

## 6. Não compareceu (no-show)

- Gatilho: "Status do compromisso", filtro: não compareceu.
- Passos:
  1. "Esperar" 30 minutos.
  2. "WhatsApp": "Sentimos sua falta hoje. Quer remarcar?" com o link do calendário.
  3. "Add task" para a recepção ligar no dia seguinte.
  4. "Esperar" 2 dias.
  5. Se não remarcou: segunda mensagem curta.
- Para quando: novo agendamento ("Status do compromisso" com status agendado em outra automação que usa "Remover do fluxo de trabalho", ou "Evento de meta").
- Cuidado: o status "não compareceu" precisa ser marcado pela equipe no agendamento. Sem isso, a automação nunca começa.

## 7. Boas-vindas ao cliente novo

- Gatilho: "Status da oportunidade alterado", filtro: ganha. Ou "Tag de contato" com a tag `cliente`.
- Passos:
  1. "WhatsApp" de boas-vindas.
  2. "Enviar e-mail" com orientações e contatos.
  3. "Add task" para o responsável agendar a primeira conversa.
  4. "Esperar" 7 dias.
  5. "WhatsApp" perguntando como está indo.
- Para quando: fim do fluxo.

## 8. Lead respondeu: avisa o vendedor

- Gatilho: "Cliente respondeu", filtro: canal WhatsApp e contato com oportunidade aberta.
- Passos:
  1. "Enviar notificação interna" ao responsável.
  2. "Remover do fluxo de trabalho": tira o contato das automações de follow-up.
- Para quando: fim do fluxo.
- Cuidado: é a parada das receitas 3 e 5. Sem ela, o lead que respondeu continua recebendo follow-up.

## 9. Lead novo sem resposta em 5 minutos

- Gatilho: "Formulário enviado" ou "Contato criado".
- Passos:
  1. "Esperar" 5 minutos.
  2. "If/else": se ninguém da equipe falou com o lead (a condição exata dentro do If/else, a conferir no navegador), "Enviar notificação interna" ao gestor.
- Para quando: fim do fluxo.

## 10. Pesquisa de satisfação depois do atendimento

- Gatilho: "Status do compromisso", filtro: compareceu.
- Passos:
  1. "Esperar" 2 horas (dentro do horário comercial).
  2. "WhatsApp" com o link da pesquisa (pesquisa criada pela skill `atlas-formularios`).
- Para quando: fim do fluxo.

---

## Como passar a receita ao cliente (texto pronto)

```
Automação: <nome>
Começa quando: <gatilho>
Só para: <filtro>
1. <ação>
2. Espera <tempo>
...
Para quando: <parada>
Envia por: <canal e número>
Fica em rascunho até você aprovar.
```
