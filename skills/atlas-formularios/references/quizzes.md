# Quizzes (Sites > Testes)

Quiz é uma pesquisa com pontos por resposta e telas de resultado. Use para diagnóstico ("qual o nível do seu comercial?"), qualificação por pontuação ou teste de perfil.

Fontes: tela de apresentação do construtor vista na conta Atlas em 05/10/2026 (Sites > Testes, sem quiz criado) e o guia do construtor de quiz da documentação do fornecedor, consultado em 03/11/2026. Na conferência de 03/11/2026 a lista foi vista (`quiz-builder/main`, título "Questionários", abas "Todos os questionários", "Envios", "Configurações", botão "Create quiz"); o editor não foi aberto porque a conta não tem quiz e criar um estava fora da conferência. Os nomes do construtor abaixo vêm da documentação e estão marcados `(a conferir no navegador)` quando é caminho de clique.

## O que a tela mostrou (05/10/2026)

- **Criar questionário** e **Tente a pré-visualização do questionário** (em 03/11/2026 o botão da lista aparecia como "Create quiz").
- Pontos por resposta, agrupados em categorias.
- Níveis de pontuação com padrão Baixa 0 a 39, Média 40 a 70, Alta 71 a 100.
- Página de resultado para cada nível, com chamada para ação (ex.: agendar).
- Tipos de pergunta: escolha única, múltipla escolha, lista suspensa, classificação, envio de arquivo.
- Dispara automações pela pontuação e pela categoria.
- Modelos prontos.

## Tipos de quiz (documentação)

- **Pontuado**: cada opção tem pontos; o total vira a nota.
- **Por categoria**: cada resposta pertence a uma categoria (grupo de resultado).
- **Perfil**: o resultado é a categoria com mais (ou menos) pontos.

## Faixas e resultados

- Configurações > Editar página de resultados > Configurar faixas `(a conferir no navegador)`.
- Faixas são em porcentagem da nota máxima.
- Antes de configurar, combine por escrito com o cliente os pontos de cada resposta e as faixas. Confira que as faixas não se sobrepõem nem deixam buraco (ex.: 0 a 39, 40 a 70, 71 a 100).

## Gravar o resultado no contato

- O construtor pode gravar nota, faixa, nota por categoria e maior ou menor categoria em campos personalizados do contato (documentação: "mapear resultados do quiz para campos do CRM").
- Os campos precisam existir. Se não existem, pergunte e passe para `atlas-campos-e-dados`. Não crie por conta própria.
- Perguntas que gravam no contato (nome, e-mail, telefone) vêm dos campos de objeto, com as mesmas regras do formulário.

## Automação

- Gatilho de automação **"Quiz submitted"** (assim, em inglês, no painel "Adicionar acionador", conferido em 03/11/2026). Montar a automação é da skill `atlas-automacoes`.

## Publicar

- Botão **Integrar** no canto superior direito: iframe ou link direto `(a conferir no navegador)`.
- Quiz usado como prova dentro de um curso é outra coisa: fica no curso (skill `atlas-cursos-e-comunidade`).

## Estilo

1. Opções nativas: cor principal, botão, fonte, fundo, largura, barra de progresso. As cores da marca da conta aparecem no seletor de cores dos construtores de formulário, pesquisa e quiz.
2. CSS personalizado, se o construtor oferecer o campo (procure em Estilos, Avançado ou Configurações). Mesmo ritual de salvamento dos formulários.
3. Como o construtor do quiz não foi mapeado, **descubra a estrutura antes de escrever CSS**, no link público:

```js
const c={};document.querySelectorAll('body *').forEach(e=>{(e.getAttribute('class')||'').split(/\s+/).filter(Boolean).forEach(k=>c[k]=(c[k]||0)+1)});
JSON.stringify(Object.entries(c).sort((a,b)=>b[1]-a[1]).slice(0,60)).replace(/=/g,'~')
```

Caminho de um elemento até o topo (troque o texto pelo de uma pergunta visível):

```js
const alvo=[...document.querySelectorAll('body *')].find(e=>e.children.length===0&&e.textContent.trim().startsWith('TEXTO DA PERGUNTA'));
const cam=[];let e=alvo;while(e&&e!==document.body){cam.push(e.tagName.toLowerCase()+(e.id?'#'+e.id:'')+(e.getAttribute('class')?'.'+e.getAttribute('class').trim().split(/\s+/).join('.'):''));e=e.parentElement}
JSON.stringify(cam).replace(/=/g,'~')
```

Prefira seletores por classe estável a seletores por posição.

## Conferência

- Percorrer todas as perguntas no link público, desktop e celular.
- Simular ao menos uma combinação de respostas para cada faixa e conferir que cai no resultado certo, só navegando, sem enviar.
- Envio de teste só com sim do cliente. Depois, conferir o contato (`get-contact`) e os campos de resultado. Se `get-surveys-submissions` não trouxer o quiz, conferir pela aba Envios do construtor.
