# Roteamento do atendente

Como transformar o que o cliente diz em skill e, nos pedidos grandes, em plano.

## 1. Frases e skills

| O cliente diz (exemplos) | Skill | Observação |
| --- | --- | --- |
| "como eu faço para...", "onde fica...", "tem algum tutorial", "não estou achando" | atlas-suporte | Responde pela central de ajuda. Se o cliente quiser que o assistente faça, volta para a skill da área |
| "dá uma olhada na minha conta", "o que está faltando", "minha conta está bagunçada", "não sei o que pedir" | atlas-raio-x | Só leitura. Termina com 3 melhorias e a skill de cada uma |
| "cadastra esse lead", "importa minha planilha", "coloca a tag X", "tem contato repetido", "acha o contato Y" | atlas-contatos | |
| "cria um campo", "preciso guardar CPF", "valor personalizado", "organiza os campos" | atlas-campos-e-dados | Mudar opção de campo existente muda o CRM inteiro |
| "monta meu funil", "cria a etapa", "move o card", "por que esse negócio está parado", "motivo de perda" | atlas-funil-e-vendas | |
| "cria um formulário", "pesquisa de satisfação", "quiz", "o formulário não está salvando no contato" | atlas-formularios | Criar e editar costuma ser navegador |
| "página de captura", "site", "landing page", "post no blog", "domínio" | atlas-sites-e-blog | Construtor de páginas é navegador |
| "pixel do Facebook", "UTM", "link rastreável", "de onde vêm meus leads" | atlas-rastreamento | |
| "automação", "fluxo", "quando o lead entrar, faz tal coisa", "follow-up automático", "a automação não disparou" | atlas-automacoes | Publicar automação é ação reforçada |
| "agenda", "link de agendamento", "horário de atendimento", "lembrete de consulta", "remarcar" | atlas-agenda | |
| "robô de atendimento", "agente de IA", "bot no WhatsApp", "base de conhecimento", "agente de voz" | atlas-agentes-ia | Ativar agente é ação reforçada |
| "responde esse cliente", "conversas sem resposta", "manda mensagem para", "disparo", "campanha no WhatsApp" | atlas-conversas-e-disparos | Toda mensagem a contato real é reforçada |
| "e-mail marketing", "newsletter", "modelo de e-mail", "campanha de e-mail" | atlas-email-marketing | Envio é reforçado |
| "agendar post", "Instagram", "redes sociais", "pedir avaliação no Google", "responder avaliação" | atlas-social-e-reputacao | Publicar é reforçado |
| "curso", "aula", "área de membros", "comunidade", "liberar acesso ao curso" | atlas-cursos-e-comunidade | |
| "cobrar cliente", "fatura", "link de pagamento", "cadastrar produto", "contrato", "proposta" | atlas-cobrancas-e-contratos | Dinheiro é sempre reforçado |
| "relatório", "quantos leads entraram", "taxa de conversão", "painel", "dashboard" | atlas-relatorios-e-dashboards | |
| "cria um usuário", "tira o acesso de", "permissão", "dados da empresa", "logo e cores" | atlas-conta-e-equipe | Usuários e acessos só com pedido do dono da conta |
| "minhas unidades", "filiais", "franquias", "compara a unidade A com a B", "copia da unidade A para a B", "nas três unidades" | atlas-varias-unidades | Só quando o login vê mais de uma conta. Cada passo nomeia a conta; contatos entre unidades só com pedido expresso e aviso de LGPD |
| "comprar número", "telefone da conta", "número para ligar ou mandar SMS" | atlas-conversas-e-disparos | Comprar número é dinheiro: aprovação reforçada |
| "agenda uma mensagem no grupo", "manda todo dia no grupo", "cria um grupo de WhatsApp", "meu WhatsApp está conectado?", "manda um WhatsApp para" | atlas-conversas-e-disparos | Antes de tudo, a skill verifica qual WhatsApp a conta usa (nativo ou integração de WhatsApp da Atlas). Grupo só pelo painel da integração |
| "LGPD", "apagar meus dados", "corrigir meus dados pessoais" | Pessoa da Atlas | Regra 8; não resolva pelo assistente |

### Casos que confundem

| Pedido | Quem resolve | Por quê |
| --- | --- | --- |
| "Manda WhatsApp quando o lead preencher o formulário" | atlas-automacoes (com atlas-formularios para achar o formulário) | É regra automática, não envio avulso |
| "Manda essa mensagem para esses 300 contatos" | atlas-conversas-e-disparos | Envio em massa, reforçado |
| "Agenda no grupo VIP para sexta às 9h" | atlas-conversas-e-disparos | Grupo de WhatsApp não é lista de contatos: é o painel da integração, não automação nem atlas-contatos |
| "Manda WhatsApp toda segunda para quem tem a tag X" | atlas-automacoes (com atlas-conversas-e-disparos para o canal) | Repetição para contatos é automação; repetição em grupo é o painel da integração |
| "Coloca a tag e já dispara a automação" | atlas-contatos, depois aprovação reforçada | Tag que inicia automação que envia mensagem conta como envio |
| "O lead do anúncio não chegou" | atlas-rastreamento, depois atlas-formularios | Primeiro a origem, depois a captura |
| "Quero ver as vendas do mês" | atlas-relatorios-e-dashboards | Se for um negócio só, atlas-funil-e-vendas |
| "Compara as vendas das minhas unidades" | atlas-varias-unidades | Mesma receita da atlas-relatorios-e-dashboards, repetida por conta |
| "Cria um campo na unidade Batel" | Skill da área, na conta Batel | Uma conta só não é várias unidades; atlas-varias-unidades só quando envolve duas ou mais contas |
| "Quero cancelar / mudar meu plano da Atlas" | Pessoa da Atlas (financeiro) | Regra 8 |

## 2. Pergunta única para pedido ambíguo

Faça só a pergunta que decide a skill. Exemplos:

- "Quero organizar meus leads." Pergunte: "Organizar como: separar por etiqueta, montar as etapas do funil ou limpar contatos repetidos?"
- "A automação não funciona." Pergunte: "Qual automação? Se souber o nome, me diga; se não, eu listo as que estão ativas."
- "Quero mandar uma mensagem." Pergunte: "É para uma pessoa só ou para um grupo de contatos?"

## 3. Planos prontos

Use como ponto de partida. Ajuste ao que a conta já tem (pergunte ou leia antes). As etapas (!) pedem confirmação própria na hora.

### "Quero captar leads de um anúncio"
1. atlas-formularios: formulário de captura com os campos que vão para o contato.
2. atlas-automacoes: quando o formulário for enviado, criar a oportunidade e avisar a equipe.
3. atlas-funil-e-vendas: etapa de entrada no funil certo para esses leads.
4. atlas-rastreamento: pixel e UTMs para saber de qual anúncio veio cada lead.
5. Publicar formulário e automação (!).
6. Conferência: envio de teste (avise que pode disparar automações) e leitura do contato e da oportunidade criados.

### "Quero organizar meu comercial do zero"
1. atlas-raio-x: o que a conta já tem.
2. atlas-funil-e-vendas: funil e etapas.
3. atlas-campos-e-dados: campos que a equipe vai preencher.
4. atlas-contatos: tags e importação da base (importação grande é (!)).
5. atlas-conta-e-equipe: usuários da equipe (!).
6. Conferência.
Se o cliente quiser que a Atlas monte tudo, é implantação: passe para uma pessoa da Atlas.

### "Quero lembrar meus clientes da consulta"
1. atlas-agenda: agenda e horários.
2. atlas-automacoes: lembretes antes do horário e aviso de falta.
3. atlas-conversas-e-disparos: canal e número de envio confirmados.
4. Publicar a automação (!).
5. Conferência com um agendamento de teste.

### "Quero reativar contatos antigos"
1. atlas-contatos: separar o público por tag ou filtro.
2. atlas-conversas-e-disparos: texto e canal; no WhatsApp oficial, modelo aprovado.
3. Disparo (!): quantidade, exemplos, número de envio.
4. atlas-funil-e-vendas: para onde vai quem responder.
5. Conferência.

### "Quero um robô respondendo no WhatsApp"
1. atlas-agentes-ia: agente e base de conhecimento.
2. atlas-conversas-e-disparos: canal conectado e número.
3. atlas-automacoes: quando o agente para e passa para a equipe.
4. Ativar o agente (!).
5. Conferência com conversa de teste.

## 4. Ordem quando várias áreas se cruzam

Dados primeiro, depois estrutura, depois o que conversa com o cliente final:
campos e tags, funil, agenda, formulários e páginas, automações, agentes e mensagens, relatórios, conferência.
