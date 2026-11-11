# Telas de contatos (plano B no navegador)

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Se o cliente usa outro domínio, use o da aba dele. Confirme o nome da conta na tela antes de clicar.

| Tela | Como chegar | Fonte |
| --- | --- | --- |
| Lista de contatos | Menu lateral > Contatos. Endereço `contacts/smart_list/All` (conferido em 03/11/2026) | Central de ajuda: "Como criar um novo contato" |
| Criar contato | Contatos > botão "Adicionar" (conferido em 03/11/2026) | Central de ajuda: "Como criar um novo contato" |
| Tags em massa | Contatos > filtrar > marcar a caixa de cada linha > ações em massa (`contacts/bulk/actions`, (conferido em 03/11/2026)) > "Adicionar tags" (na barra que aparece ao marcar) ou "Remover tags" (no menu "Mais" da mesma barra) (conferido em 04/11/2026) | Central de ajuda: "Como adicionar tags a vários contatos" e "Como remover tags de vários contatos" |
| Importar planilha | Contatos > Importar > escolher Contatos > enviar CSV > conferir mapeamento > preferências > consentimento > iniciar importação | Central de ajuda: "Como importar contatos para a Atlas" |
| Listas inteligentes | Contatos > Listas inteligentes: abas de listas no topo da lista ("Todos") (conferido em 03/11/2026). Salvar filtro como lista: depois de filtrar, botão "Alterações não salvas" > "Salvar como nova lista inteligente" (ou "Descartar alterações"); aba "+ Adicionar" ao lado de "Todos" (conferido em 04/11/2026) | Central de ajuda: "Como importar contatos" cita listas inteligentes |
| Mesclar duplicados | Endereço `contacts/bulk/duplicates` (conferido em 03/11/2026): só abre por URL ou pela busca global ("duplicates"), sem aba visível em Contatos. Título "Gerenciar registros duplicados"; "Atualizar", "Encontrar por email", "Pesquisar"; lista por e-mail com "N contatos encontrados". Por dentro (conferido em 04/11/2026): ao expandir o grupo aparece a tabela com a coluna "Principal" (o contato que fica), caixas de seleção, "Selecionados (N/N)" e os botões "Rejeitar", "Avaliação" e "Mesclar". Também há "Mesclar" no menu "Mais" das ações em massa da lista | telas-conferidas-2.md |
| Restaurar excluídos | Não disponível nas telas conferidas em 03/11/2026: não há aba nem tela de restaurar excluídos (a busca global por "restore" e "excluídos" não achou nada). Não prometa desfazer. Alternativa: em vez de apagar, marcar com uma tag (ex.: `arquivado`) e tirar de listas e automações; contato já apagado, encaminhe ao suporte da Atlas (`_comum/glossario.md`) | telas-conferidas-2.md |
| Preferência de duplicidade | Configurações > Perfil da empresa > rolar até o fim, bloco "Preferências de Desduplicação de Contatos": chave "Permitir contato duplicado", "Localizar contatos existentes com base em" e "Segunda preferência para pesquisa (opcional)". Endereço `settings/company` (conferido em 03/11/2026) | Central de ajuda: "Como ajustar preferências de contatos duplicados" |
| Vários telefones e e-mails | Abrir contato > campo de telefone ou e-mail > adicionar outro | Central de ajuda: "Como adicionar vários telefones" e "Como gerenciar vários e-mails" |
| Arquivo no contato | Configurações > Campos personalizados > criar campo de arquivo; depois anexar no contato | Central de ajuda: "Como anexar arquivos no perfil do contato" |

Central de ajuda da Atlas: https://help.atlasoficial.com (seção CRM > Suporte).

## Passo a passo para o cliente sem navegador controlado

### Importar planilha

1. Abra a Atlas e clique em **Contatos** no menu lateral.
2. Clique em **Importar** e escolha importar contatos.
3. Envie o arquivo CSV (uma linha por contato). Deixe marcada a opção de criar e atualizar.
4. No mapeamento, confira cada coluna: telefone com telefone, e-mail com e-mail, primeiro nome com primeiro nome. Coluna sem campo: escolha o campo certo ou crie antes um campo personalizado.
5. Na tela final, se quiser, crie uma lista inteligente com os importados e adicione uma tag (ex.: `importacao-2026-11`). Só vincule a uma automação se tiver certeza de que ela não manda mensagem sem querer.
6. Marque o consentimento e inicie a importação.
7. Me avise quando terminar. Eu confiro pela contagem da tag.

### Mesclar dois contatos

Os nomes reais dos botões ainda não foram conferidos. Não entregue passos genéricos ao cliente.
- Com Claude in Chrome: diga "vou abrir a tela com você", abra o contato e faça junto, com aprovação antes de confirmar.
- Sem navegador controlado: peça um print da tela do contato para guiar, ou encaminhe ao suporte da Atlas (`_comum/glossario.md`).
- Depois: confira pelo MCP telefone, e-mail, tags e oportunidades do contato que ficou.
