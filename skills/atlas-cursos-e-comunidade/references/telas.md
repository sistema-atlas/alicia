# Telas: cursos, comunidade e portal do cliente

Endereço base: `https://crm.atlasoficial.com/v2/location/<locationId>/`. Se o cliente usa outro domínio, use o que aparece na aba dele. Confirme o nome da conta na tela antes de clicar.

Fonte: mapeamento real da conta Atlas em 05/10/2026 (`docs/navegacao-crm/sites-e-funis.md`) e conferência somente leitura de 03/11/2026 (`fabrica/telas-conferidas.md`), marcada (conferido em 03/11/2026). Onde está `(a conferir no navegador)`, o caminho não foi visto na tela nesta construção.

## Mapa

| Tela | Endereço direto | Cliques a partir do menu |
| --- | --- | --- |
| Portal do cliente, painel | `funnels-websites/client-portal/dashboard` | Sites > Portal do cliente > Painel |
| Portal do cliente, configurações | `funnels-websites/client-portal/settings` | Sites > Portal do cliente > Configurações |
| App com a marca (iOS e Android) | `funnels-websites/client-portal/branded-app` | Sites > Portal do cliente > Branded Mobile App |
| Domínio do portal | `settings/domain` | Engrenagem da área Sites > Domínios |
| Área de membros: cursos, ofertas, acessos, comunidade | `memberships/client-portal/client-portal-ai` | Menu **Assinaturas** (conferido em 03/11/2026); abas "IA do Portal do Cliente", "Portal do cliente", "Cursos", "Comunidades", "Eventos", "Certificado" |
| Cursos (lista, construtor, vídeos) | `memberships/courses/dashboard-v2` (conferido em 03/11/2026) | Assinaturas > Cursos. Por dentro (conferido em 04/11/2026): o menu "Cursos" tem "Painel de controle", "Produtos" (`memberships/courses/products-v2`, com "Criar novo"), "Ofertas", "Estatísticas", "Configurações"; dentro do curso, menu lateral "Esboçar", "Sessões ao vivo", "Configurações", "Personalizar", "Pricing", "Ofertas", "Comentários", "Certificado", "Grupos da comunidade", botões "Adicionar sessão ao vivo" e "+ Adicionar conteúdo", e seletor "Publicado"/"Rascunho" em cada módulo e aula |
| Comunidade (grupos, canais, níveis, membros) | `memberships/communities/community-groups` (conferido em 03/11/2026) | Assinaturas > Comunidades. Lista "Grupos da comunidade" com "Criar Grupo" e filtro "Ativa"; cada cartão mostra membros, proprietário, status e o botão "Login", que abre o grupo no portal, onde ficam canais, níveis e membros (conferido em 04/11/2026); o interior do portal não foi aberto |
| Eventos | `memberships/events` (conferido em 03/11/2026) | Assinaturas > Eventos |
| Certificados | `memberships/certificates/create-certificates` (conferido em 03/11/2026) | Assinaturas > Certificado |
| Conectar canal da comunidade ao planejador | `marketing/social-planner` (conferido em 04/11/2026) | Marketing > Planejador Social > botão "+ Redes sociais" > janela "Conectar redes sociais" > "Adicionar uma comunidade" (conferido em 04/11/2026); a ligação em si não foi feita |

## Portal do cliente, painel

O que tem (visto em 05/10/2026): endereço do portal com botão de copiar, contadores de Convidados e Usuários, e as ações:

- **Gerar link mágico**: link de acesso sem senha para um aluno. Link de acesso é pessoal: entregue só ao cliente, nunca publique.
- **Convidar para o Portal do cliente**.
- **Enviar e-mail de login**: manda e-mail para o aluno. É mensagem a pessoa real: `CONFIRMO ENVIO`.
- **Experimente o novo Portal do cliente**.

Ao abrir, pode aparecer o aviso do novo layout com três botões: **Abrir prévia** (só quem está vendo), **Ative para todos** (troca o portal de todos os alunos: **não clicar**) e **Talvez mais tarde** (fecha sem mudar nada).

## Portal do cliente, configurações

Seis grupos (vistos em 05/10/2026):

| Grupo | O que muda |
| --- | --- |
| Configuração de domínio | Endereço do portal |
| Identidade visual | Cores e logo do portal |
| Permissões do app | Liga e desliga apps dentro do portal |
| Configurações de idioma | Idioma do portal e dos apps |
| Widget de chat | Chat dentro do portal |
| Configurações de e-mail | E-mail de lembrete enviado aos membros |

Trocar domínio mexe em DNS: aprovação reforçada (`CONFIRMO PUBLICAÇÃO`) e aviso de que o link antigo pode parar. Trocar identidade visual: aprovação simples, depois conferir o portal no computador e no celular.

## Cursos na tela (plano B)

Use a tela para o que o MCP não faz: subir o vídeo da aula, anexar arquivo, certificado, publicar ou esconder o curso inteiro, liberar ou tirar acesso dado pela oferta padrão. Entrada: Assinaturas > Cursos (`memberships/courses/dashboard-v2`, (conferido em 03/11/2026)). Passo a passo (dentro do curso, conferido em 04/11/2026): Cursos > Produtos > abrir o curso > "Esboçar" > clicar na aula. A aula tem "Mídia da lição" ("Clique para carregar ou arrastar e soltar"), "Nome da lição", "Descrição da aula", "Miniatura da aula", "Recursos disponíveis para download" e os botões "Cancelar", "Salvar" e "Salvar e publicar"; use "Salvar", e "Salvar e publicar" só com aprovação:

1. Abra o curso pelo nome.
2. Abra o módulo e a aula.
3. Para vídeo: escolha o vídeo da mídia da conta ou suba o arquivo. Salve.
4. Deixe em rascunho até o cliente revisar. Publicar só com `CONFIRMO PUBLICAÇÃO`.
5. Confira pelo MCP com `list-lessons` (`contentId` e `visibility`).

## Comunidade na tela (plano B)

Criar grupo, canal, níveis, eventos e moderar membros é pela tela. Regras:

- Grupo pago ou com cobrança é nível dinheiro: `CONFIRMO COBRANÇA`.
- Banir ou remover membro: `CONFIRMO EXCLUSÃO`, um membro por vez.
- Depois de criar um canal novo, para postar pelo MCP o canal precisa aparecer em `get-account` com `platform: "community"`. Se não aparecer, conecte o canal no planejador social.
