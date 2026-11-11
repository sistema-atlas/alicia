# Funil modelo Atlas

Como a Atlas organiza funis nas implantações. Fontes: método de implantação da Atlas (skill interna de implementação) e os funis da própria conta da Atlas, lidos com `get-pipelines` em 03/11/2026. Use como sugestão para o cliente. A conta dele pode ser diferente; a decisão é dele.

## Princípios

1. **Funil mostra negociação, não contato.** Só vira oportunidade quando há intenção comercial real (Central de ajuda "Como funcionam as oportunidades").
2. **Cada etapa é um avanço real** com regra de entrada e de saída combinada com a equipe.
3. **Comece simples.** Poucas etapas, revisar depois das primeiras semanas (Central de ajuda "Como criar um pipeline").
4. **Nenhum funil tem etapa Perdido.** Uma etapa de perdido esconde a métrica real do funil. Perdido é status, sempre com motivo, e o lead perdido vai para um funil de **Reciclagem**.
5. **Toda oportunidade tem valor, responsável e próximo passo** (tarefa com data).

## Os funis do modelo

### 1. Aquisição (pré-vendas e vendas juntos)

Do lead novo até a venda, para empresas que vendem com reunião ou atendimento agendado. Etapas usadas na conta da Atlas:

1. Entrada
2. Follow-up 1 (frio)
3. Follow-up 2 (morno)
4. Follow-up 3 (quente)
5. Follow-up 4 (reagendar)
6. Agendados
7. Não compareceu
8. Follow-up 5 (proposta na mesa)
9. Venda com sinal
10. Venda realizada

Adaptar: quem vende direto no WhatsApp pode tirar Agendados e Não compareceu; quem faz prospecção ativa pode trocar os follow-ups pela cadência de abordagem.

### 2. Recuperação de orçamento

Para quem recebeu proposta ou orçamento e não fechou.

1. Incubação (48 horas)
2. Follow-up 1 (frio)
3. Em conversa
4. Venda recuperada

### 3. Reciclagem de leads

Para onde vai todo lead marcado como perdido, com o motivo. Depois de um tempo de descanso, volta a ser abordado.

1. Incubação (na Atlas, 2 meses; ajuste ao ciclo do cliente)
2. A fazer
3. Disparo cadência 1 a 5 (uma etapa por toque)
4. Em conversa
5. Voltar para incubação

Recomendação: lead perdido por bloqueio (Blacklist ou LGPD) não recebe cadência de reciclagem. Confirme com o cliente.

### 4. Entrega (pós-venda)

Do cliente novo até a entrega concluída.

1. Novo cliente
2. Primeiro contato
3. Agendar onboarding (ou início do serviço)
4. Reunião de onboarding agendada
5. Não compareceu
6. Entrega em andamento
7. Entrega finalizada

### 5. Suporte (opcional)

A Atlas usa um funil de tickets (Novo, Em triagem, Em atendimento, Aguardando cliente, Escalado, Resolvido, Encerrado), fora dos gráficos de venda. Só sugira se o cliente atende chamados.

## Motivos de perda

A conta da Atlas tem 28 motivos (`get-lost-reason`, 03/11/2026). Agrupados para sugerir ao cliente:

| Grupo | Exemplos de motivo |
| --- | --- |
| Contato | Respondeu e depois sumiu; Tentativas de contato esgotadas; No-show recorrente; Dados incorretos; Engano |
| Perfil | Sem perfil para ser cliente; Falha na qualificação; Nossa solução não atende; Distância / Geográfico |
| Decisão | Não é quem decide; Sem interesse/não quis conversar; Não tem urgência; Está em viagem / férias |
| Dinheiro | Achou "caro"; Sem orçamento no momento; Não tem condições financeiras; Condições de pagamento não correspondidas; Perda para concorrência |
| Prazo e contrato | Tempo de implantação fora do esperado; Datas de agenda incompatíveis; Restrição jurídica ou contratual |
| Não é lead | Já é cliente; É da nossa equipe; É fornecedor da nossa empresa; Está ofertando serviços/produtos para nós; Sendo trabalhado por outro vendedor |
| Bloqueio | Não queremos contato (Blacklist); Não abordar novamente (LGPD) |

Sugira ao cliente os que fazem sentido no negócio dele e acrescente os do segmento. O cadastro é pelo navegador (`telas.md`).

## Como usar este modelo com o cliente

1. Leia os funis atuais (`get-pipelines`) antes de sugerir qualquer coisa.
2. Compare com o modelo e diga, em poucas linhas, o que falta e o que sobra.
3. Se o cliente tem etapa Perdido, explique o motivo do modelo e proponha a troca. Não mude sem aprovação.
4. Montagem completa de funis para uma empresa nova é implantação: ofereça o time da Atlas (`_comum/glossario.md`).
