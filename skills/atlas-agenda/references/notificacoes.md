# Confirmações e lembretes do calendário

O calendário tem avisos próprios, configurados por `create-event-notification` e companhia. Eles saem a cada agendamento, sem automação.

## Tipos (`notificationType`)

| Tipo | Quando sai | Precisa de |
| --- | --- | --- |
| `booked` | Ao marcar | nada |
| `confirmation` | Ao confirmar | nada |
| `cancellation` | Ao cancelar | nada |
| `reschedule` | Ao remarcar | nada |
| `reminder` | Antes do horário | `beforeTime` (ex.: `[{"timeOffset":24,"unit":"hours"}]`) |
| `followup` | Depois do horário | `afterTime` |

Canais (`channel`): `email`, `inApp`, `sms`, `whatsapp`. Para quem (`receiverType`): `contact`, `guest`, `assignedUser`, `emails`, `phoneNumbers`, `business`.

Unidades de `timeOffset`: o describe mostra `hours` no exemplo. Outras unidades (a conferir no navegador).

## Regras

1. Aviso para `contact` ou `guest` é mensagem a contato real em cada agendamento: aprovação reforçada `CONFIRMO ENVIO`, com canal, número de envio e texto.
2. Antes de criar, leia o que existe (`get-event-notification`). Não duplique.
3. Pergunte se já existe automação de lembrete (`atlas-automacoes`, receita 2). Um ou outro.
4. WhatsApp oficial fora da janela de atendimento pede modelo aprovado (artigo da Atlas "Como verificar janela de atendimento do WhatsApp em uma automação"). Se o canal for WhatsApp oficial, confirme com o cliente qual modelo usar (skill `atlas-conversas-e-disparos`).
5. Para desligar, `update-event-notification` com `isActive: false`. Excluir só com pedido.
6. Se a resposta da criação trouxer erro de canal, o canal não está conectado na conta: navegador.
7. **Sempre leia de volta.** Depois de criar, `get-event-notification` e compare canal, tipo, `beforeTime` e texto com o que foi aprovado. No teste v1 o `dryRun` montou o corpo embrulhado (`{"body":[...]}`) em vez da lista; até uma escrita real em calendário de teste confirmar o formato, essa conferência é obrigatória. Se vier diferente: `update-event-notification` com `isActive: false` na hora, aviso ao cliente e plano B no navegador (editor do calendário > Configurações avançadas > Notificações e Políticas).

## Exemplo: lembrete por WhatsApp 1 dia antes

```json
[{"receiverType":"contact","channel":"whatsapp","notificationType":"reminder","isActive":true,
  "body":"Oi {{contact.first_name}}, lembrando do seu horário amanhã.","beforeTime":[{"timeOffset":24,"unit":"hours"}]}]
```

Variáveis de agendamento no texto (nome exato a conferir no navegador).
