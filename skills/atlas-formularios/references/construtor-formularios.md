# Construtor de formulários: campos, estilo, CSS e verificação

Base: a skill interna de formulários da Atlas e o kit de construção entregue a clientes, adaptados para a conta do cliente. Leia inteiro antes de mexer num formulário.

## Marca do cliente antes do CSS

Monte a paleta antes de escrever qualquer CSS. Fontes, nesta ordem:

1. **Marca da conta (cores, fontes e logo)**, pelo MCP, só leitura: `list-design-kits` e `get-design-kit` (kit com `isDefault: true`). Traz cores, fontes e logos.
2. Material que o cliente mandar: manual de marca, site, logo.
3. Se não houver nada, pergunte uma coisa por vez: cor principal, cor de destaque, fonte.

Guarde em variáveis: cor principal, cor escura, fundo da página, fundo do card, cor do texto, cor do rótulo, raio dos cantos e fonte. Confira contraste: texto branco só em fundo escuro.

Para a fonte, prefira uma que exista no seletor de fontes do construtor. `@import` de fonte externa no CSS pode não sobreviver à reformatação do servidor; se usar, confira no link público que carregou.

Logo ou banner: se ainda não estiver na Mídia da conta, suba com `upload-media-content` (aprovação simples) ou peça ao cliente para subir pela tela de Mídia. Use a `url` que volta.


O construtor (builder) fica em Sites > Formulários e abre na rota `form-builder-v2/<formId>` dentro do CRM (conferido em 03/11/2026: Formulários > menu da linha > Editar). Ele roda dentro de um iframe de outra origem, então não dá para inspecionar o DOM do construtor por JavaScript: trabalhe por screenshot e clique. O formulário publicado é medido e conferido no **link público**, onde o CSS personalizado é aplicado.

Ajustes que não precisam de tela: ler formulários e envios pelo MCP (`get-forms`, `get-forms-submissions`).

## Montagem

1. Limpar o formulário base: remover Último nome, Gmail e os consentimentos de SMS se não fizerem parte do pedido. Os consentimentos voltam sozinhos quando existe campo de telefone; remover de novo no fim, se o usuário não quiser.
2. Montar seção por seção: título (elemento Text da Adição rápida, linha 1 em Heading 1, Enter, a linha 2 vira Paragraph sozinha), depois os campos.
3. Configurar cada campo no painel direito: Rótulo, Placeholder, Obrigatório.
4. Nomear o formulário pelo lápis ao lado do título e Salvar.

## Campos

- Arrastar pelo ícone de grip. Clicar no card não adiciona.
- Soltar logo abaixo do botão Enviar insere antes dele.
- Para reordenar no canvas, arrastar o bloco já posicionado. Arrastar pelo rótulo às vezes não engata.
- Campos nativos (First Name, Email, Phone, City, State, Postal Code) aparecem cinza na aba de objeto. Os equivalentes da Adição rápida mapeiam para eles; confirmar pela Chave de consulta (`phone`, `city`, `postal_code`, `full_name`).
- O elemento **Nome Completo** da Adição rápida grava em `full_name`. O elemento **Nome** grava só em `first_name`.
- Em alguns subcampos o checkbox Obrigatório só aparece depois de digitar algo no Rótulo.
- O botão + ao lado do filtro de objeto não cria campo de forma utilizável.

## Bloco de endereço

- Endereço, Cidade, Estado, País e CEP formam **um bloco único** com ordem fixa: Endereço, Cidade, Estado, País, CEP.
- Cada subcampo pode ser ligado, desligado e renomeado. Não pode ser reordenado.
- Um Código postal avulso arrastado para perto do bloco é absorvido para dentro dele.
- "Concluir endereço automaticamente" liga a barra Pesquisar endereço. Deixar "Obrigatório para selecionar o endereço" desligado para não travar quem digita manual.
- Estado é texto livre. Não existe dropdown de UF.
- Para mudar a ordem visual, usar o CSS de grade do bloco de endereço (abaixo).

## Painel Estilos e Opções

Abre pelo ícone no canto superior direito da barra do builder.

- **Estilos > Layout**: Exibir imagem (banner no topo, com upload), Colunas, Estilo de entrada, Largura do formulário, Espaçamento de campo, Largura e alinhamento do rótulo, Margem e preenchimento.
- **Estilos > Cores**: Plano de fundo, Cor principal, Cor do texto, Mapear a cor primária para o botão, fundo e borda dos inputs, Imagem de fundo.
- **Temas**: vários temas prontos. Sobrescrevem cores e brigam com o CSS. Testar só em cópia.
- **Avançado**: Formulário (borda, raio, sombra), Campo de entrada, Rótulo, Rótulo curto, Placeholder, CSS personalizado.
- **Cor principal não aceita hex digitado no campo.** Clicar no quadradinho, "+ Add", digitar o hex, nomear, Save. A cor fica na paleta da conta.

Ajustes padrão para formulário em cards: a largura padrão do modelo (ajuste à página onde o formulário vai), cor principal da marca, mapear primária para o botão ligado.

## CSS personalizado: o ritual para não perder alteração

O editor descarta mudanças em silêncio se o ritual não for seguido. Fazer sempre nesta ordem:

1. Abrir Estilos e Opções. Conferir por screenshot que o painel mostra Estilos, Temas, Avançado. **Depois de cada Salvar o painel volta para o elemento selecionado**; se digitar sem reabrir, o texto vai parar nos campos do elemento.
2. Avançado, expandir CSS personalizado.
3. Clicar dentro do editor, `ctrl+End`, digitar.
4. **Clicar fora do editor, numa área vazia do próprio painel direito.** Sem esse clique o conteúdo não é gravado.
5. Esperar 2 segundos, tirar screenshot para localizar o botão Salvar (a largura da janela muda entre chamadas e as coordenadas mudam junto), clicar em Salvar.
6. Abrir o link público e conferir que a regra nova está no `<style>`.

Outras regras do editor:

- O CSS é **escopado com `#_builder-form`**. Seletores de ancestrais (`html`, `body` ou contêineres de fora do formulário) nunca funcionam.
- O servidor reformata ao salvar. A numeração de linhas do editor não bate com o CSS final.
- **Chave desbalanceada quebra em silêncio**: a primeira regra depois do erro some. Conferir o balanço depois de cada save com o script de verificação.
- Textos longos digitados de uma vez podem estourar o tempo da ferramenta; dividir em blocos de 6 a 10 linhas.
- Variáveis CSS funcionam, inclusive `content: var(--texto)`. `:has()` funciona. `mask-image` sem prefixo funciona.

## Estrutura do DOM publicado

```
#_builder-form
  .fields-container                         contêiner com os campos (existe um segundo vazio)
    .form-field-wrapper#el_<formId>_<campo>_<n>
      .form-field-container
        .form-builder--item
          label.label-alignment.field-label   rótulo (e-mail usa só label-alignment)
          .heading-element > .text-element    títulos de seção (h1 + p)
          .address-wrapper                    bloco de endereço
            > div.col-12 (1)                  barra de pesquisa
            > div.col-12 (2)                  endereço completo
            > .non-address-elements           cidade (1), estado (2), CEP (3)
          [id$="-bubble-option-container"]    grupo de rádios
          .form-builder--btn-submit button.button-element
```

## CSS base do template

Trocar a identidade visual só no primeiro bloco. O resto é estrutural.

```css
/* ===== IDENTIDADE: trocar so aqui ===== */
.fields-container{--brand:#1544A8;--brand-dark:#0B2A6B;--bg-page:#EEF1F6;--card:#FFFFFF;--radius:14px;--titulo-cor:#0B2A6B;--titulo-tamanho:21px;--subtitulo-cor:#6B7280;--rotulo-cor:#1F2937;--input-bg:#F7F8FA;--input-borda:#E3E6EC;--banner-texto:"CADASTRO DE LEAD";}

/* ===== cards ===== */
.fields-container{background:var(--bg-page);padding:14px !important;display:grid !important;grid-template-columns:repeat(12,1fr);}
.fields-container:empty{display:none !important;padding:0 !important}
.form-field-wrapper,.form-field-container{height:auto !important;}
.form-field-wrapper{background:var(--card);padding-left:22px !important;padding-right:22px !important;margin-bottom:0 !important;grid-column:1/13;}
.form-field-wrapper[id*="_header_"]{margin-top:16px !important;padding-top:18px !important;border-radius:var(--radius) var(--radius) 0 0;}
.form-field-wrapper[id$="_header_0"]{margin-top:0 !important;}
.form-field-wrapper:has(+ .form-field-wrapper[id*="_header_"]),.form-field-wrapper:has(+ .form-field-wrapper[id*="_button_"]){border-radius:0 0 var(--radius) var(--radius);padding-bottom:20px !important;}
.form-field-wrapper[id*="_button_"]{background:transparent;padding:0 !important;margin-top:20px !important;}

/* ===== faixa de titulo ===== */
.form-field-wrapper[id$="_header_0"]::before{content:var(--banner-texto);display:block;background:linear-gradient(90deg,var(--brand-dark) 0%,var(--brand) 100%);color:#fff;font-weight:800;font-size:20px;letter-spacing:.06em;padding:16px 22px;margin:-18px -22px 20px -22px;border-radius:var(--radius) var(--radius) 0 0;}

/* ===== tipografia ===== */
.heading-element{display:flex;align-items:center;gap:12px}
.heading-element h1{color:var(--titulo-cor);font-weight:800;font-size:var(--titulo-tamanho);text-transform:uppercase;margin:0 0 2px 0;line-height:1.2;}
.heading-element p{color:var(--subtitulo-cor);font-size:13px;margin:0;}
label.label-alignment{color:var(--rotulo-cor);font-weight:600;font-size:13px}

/* ===== campos ===== */
input.form-control{background:var(--input-bg) !important;border:1px solid var(--input-borda) !important;border-radius:10px !important;height:46px;}
input.form-control:focus{border-color:var(--brand) !important;background:#fff !important;}
[id$="-bubble-option-container"]{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:6px 18px;}
.form-builder--btn-submit button.button-element{border-radius:999px !important;letter-spacing:.06em;box-shadow:0 10px 24px rgba(21,68,168,.30);}

/* ===== endereco: busca / CEP + endereco / cidade + estado ===== */
.address-wrapper{display:grid !important;grid-template-columns:repeat(12,1fr);column-gap:14px;}
.address-wrapper>.non-address-elements{display:contents;}
.address-wrapper>div,.non-address-elements>div{padding-left:0 !important;padding-right:0 !important;box-sizing:border-box;}
.address-wrapper>div.col-12:nth-child(1){order:1;grid-column:1/13;}
.non-address-elements>div:nth-child(3){order:2;grid-column:1/4;}
.address-wrapper>div.col-12:nth-child(2){order:3;grid-column:4/13;}
.non-address-elements>div:nth-child(1){order:4;grid-column:1/8;}
.non-address-elements>div:nth-child(2){order:5;grid-column:8/13;}

/* ===== icones (base) ===== */
.heading-element::before{content:"";flex:0 0 28px;height:28px;background:var(--brand);mask-repeat:no-repeat;mask-position:center;mask-size:contain}

/* ===== MAPA DE POSICOES: regerar a cada formulario ===== */
/* (ver secao abaixo) */

/* ===== mobile: sempre por ultimo ===== */
@media (max-width:640px){.fields-container>.form-field-wrapper{grid-column:1/13 !important;grid-row:auto !important;padding-left:22px !important;padding-right:22px !important;border-radius:0 !important;}.address-wrapper>div,.non-address-elements>div{grid-column:1/13 !important;}[id$="-bubble-option-container"]{grid-template-columns:1fr;}}
```

## Mapa de posições

As regras de colunas e de ícones dependem da **posição** de cada wrapper dentro de `.fields-container`. Adicionar, remover ou reordenar qualquer campo desloca tudo. Sempre regerar o mapa depois de mudar campos.

1. No link público, listar as posições com o script de verificação (abaixo).
2. Para cada título de seção, uma regra de ícone na posição dele.
3. Para campos lado a lado: coluna da esquerda com `padding-right:8px` e `padding-left:22px`; coluna da direita com `padding-left:8px` e `padding-right:22px`. Trocar esses paddings é o erro mais comum e desloca o input 14px.
4. Se uma linha tem duas células, arredondar só o canto de baixo de cada lado na última linha da seção (`0 0 0 var(--radius)` à esquerda, `0 0 var(--radius) 0` à direita), senão aparece degrau no card.
5. Para uma grade 2x2 em ordem diferente da ordem dos campos, usar `grid-row` explícito.

Exemplo de um formulário de 5 seções (1 título, 2 Nome, 3 WhatsApp, 4 CPF, 5 E-mail, 6 título, 7 endereço, 8 título, 9 Área de atuação, 10 Registro profissional, 11 título, 12 Experiência, 13 título, 14 Faixa de orçamento, 15 botão), com Nome e CPF em cima e WhatsApp e E-mail embaixo:

```css
.fields-container>.form-field-wrapper:nth-child(1){grid-row:1}
.fields-container>.form-field-wrapper:nth-child(2){grid-row:2;grid-column:1/7;padding-left:22px !important;padding-right:8px !important}
.fields-container>.form-field-wrapper:nth-child(3){grid-row:3;grid-column:1/7;padding-left:22px !important;padding-right:8px !important;border-radius:0 0 0 var(--radius);padding-bottom:20px !important}
.fields-container>.form-field-wrapper:nth-child(4){grid-row:2;grid-column:7/13;padding-left:8px !important;padding-right:22px !important}
.fields-container>.form-field-wrapper:nth-child(5){grid-row:3;grid-column:7/13;padding-left:8px !important;padding-right:22px !important;border-radius:0 0 var(--radius) 0;padding-bottom:20px !important}
.fields-container>.form-field-wrapper:nth-child(9){grid-column:1/7;padding-left:22px !important;padding-right:8px !important;border-radius:0 0 0 var(--radius);padding-bottom:20px !important}
.fields-container>.form-field-wrapper:nth-child(10){grid-column:7/13;padding-left:8px !important;padding-right:22px !important;border-radius:0 0 var(--radius) 0;padding-bottom:20px !important}
```

## Ícones de seção

SVG em data URI, aplicado como máscara. A cor vem de `--brand`, então troca junto com a marca. Usar aspas simples dentro do SVG e duplas na `url("...")`.

```css
/* pessoa */  .fields-container>.form-field-wrapper:nth-child(N) .heading-element::before{mask-image:url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><circle cx='12' cy='8' r='4'/><path d='M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8z'/></svg>")}
/* pin */     ...{mask-image:url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='M12 2C8.1 2 5 5.1 5 9c0 5.2 7 13 7 13s7-7.8 7-13c0-3.9-3.1-7-7-7zm0 9.5A2.5 2.5 0 1 1 12 6.5a2.5 2.5 0 0 1 0 5z'/></svg>")}
/* maleta */  ...{mask-image:url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='M9 4h6a2 2 0 0 1 2 2v1h3a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h3V6a2 2 0 0 1 2-2zm0 3h6V6H9z'/></svg>")}
/* capacete */...{mask-image:url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='M12 3a9 9 0 0 0-9 9v2h8a5 5 0 0 0 5-5h4a9 9 0 0 0-8-6zm-9 13h18v2a3 3 0 0 1-3 3H6a3 3 0 0 1-3-3z'/></svg>")}
/* barras */  ...{mask-image:url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><rect x='3' y='13' width='4' height='8' rx='1'/><rect x='10' y='8' width='4' height='13' rx='1'/><rect x='17' y='3' width='4' height='18' rx='1'/></svg>")}
```

Se um ícone aparecer como quadrado sólido, a regra de máscara está apontando para a posição errada.

## Verificação no link público

Abrir o link público do formulário (no construtor, botão de integrar ou compartilhar, opção de link) numa aba própria e rodar estes scripts com a ferramenta de JavaScript. A extensão bloqueia respostas que contêm o caractere de igual, então sempre terminar com `.replace(/=/g,'~')`.

CSS salvo e balanço de chaves:

```js
const st=[...document.querySelectorAll('style')].find(x=>x.textContent.indexOf('fields-container')>-1);
const t=st.textContent;let d=0,bad=[];
t.split('\n').forEach((l,i)=>{for(const c of l){if(c==='{')d++;else if(c==='}'){d--;if(d<0){bad.push(i+1);d=0}}}});
JSON.stringify({len:t.length,regras:st.sheet.cssRules.length,sobrando:bad,abertas:d}).replace(/=/g,'~')
```

Posição de cada wrapper:

```js
JSON.stringify([...document.querySelectorAll('.fields-container>.form-field-wrapper')].map((e,i)=>{const r=e.getBoundingClientRect();const l=e.querySelector('label,h1');return [i+1,(l?l.textContent.trim().slice(0,16):'?'),Math.round(r.left),Math.round(r.right),Math.round(r.top),Math.round(r.bottom)]})).replace(/=/g,'~')
```

Alinhamento dos inputs:

```js
JSON.stringify([...document.querySelectorAll('input.form-control')].map(i=>{const r=i.getBoundingClientRect();return [(i.placeholder||'').slice(0,14),Math.round(r.left),Math.round(r.right),Math.round(r.top)]})).replace(/=/g,'~')
```

Critérios de aprovação:

- `sobrando` vazio e `abertas` igual a zero.
- Cards com a mesma borda esquerda e direita em todas as seções.
- Inputs da mesma coluna com a mesma borda esquerda e direita.
- Inputs da mesma linha com diferença de topo de no máximo 1px.
- Células lado a lado da mesma linha com o mesmo topo e o mesmo fundo.
- Nenhum elemento com borda direita além do card.
- Screenshot do topo e do fim do formulário para conferência visual antes de entregar.

## Armadilhas já encontradas

- Salvar com o cursor dentro do editor de CSS: alteração perdida sem aviso.
- Digitar sem reabrir o painel de CSS depois de salvar: o texto cai no Placeholder ou no Rótulo do campo selecionado. Conferir os campos do elemento se isso acontecer.
- Chave `}` sobrando: a regra seguinte some. Apagar a sobra, não contornar duplicando regras.
- Segundo `.fields-container` vazio vira quadrado solto na borda se não tiver a regra `:empty` com `!important`.
- Rótulo do e-mail usa só `label-alignment`. Estilizar só `.field-label` desalinha a coluna em 6px.
- Paddings de coluna trocados depois de reorganizar a grade: input desloca 14px.
- Card com duas células e cantos arredondados só de um lado: degrau visível.
- Clique em área vazia do canvas às vezes derruba o builder. Se a tela ficar em branco, recarregar a página do construtor e esperar alguns segundos até o construtor aparecer.

