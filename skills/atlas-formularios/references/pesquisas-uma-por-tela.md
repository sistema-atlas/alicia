# Pesquisa uma pergunta por tela

Objetivo padrão: pesquisa no estilo Typebot. Uma pergunta por tela, avanço automático nas escolhas, visual da marca, logo no topo e, no fim, redirecionamento (por exemplo para a agenda).

Base: montagem real da pesquisa "Briefing de onboarding" na conta da Atlas em 07/10/2026. Editor: `survey-builder-v2/<surveyId>`. Roda em iframe de outro domínio: sem leitura de DOM, só print e clique. Link público: `https://<domínio de marca da conta>/widget/survey/<surveyId>`.

## Passo a passo

1. Print do estado atual. Confirme com o cliente a lista de perguntas e o campo do contato de cada uma.
2. Sites > Pesquisas > **Criar pesquisa**, em branco. Renomeie pelo lápis e salve.
3. **Estilos > Layout > "Uma pergunta de cada vez"**. Salve. Nunca volte para "Muitos de uma vez".
4. Tela 1: elemento **Texto** (seção Personalizado) com boas-vindas. Título na primeira linha, apoio abaixo.
5. Perguntas: selecione o elemento depois do qual elas entram, abra **Adicionar campos de objeto**, marque os campos, clique em **Adicionar N campos**.
6. Rótulo de cada pergunta: clique no rótulo dentro do slide e digite. Engrenagem do elemento: Rótulo, Placeholder, Obrigatório.
7. Ramificação, se houver (abaixo).
8. **Estilos > Rodapé**: textos dos botões. **Configurações > Ao enviar**: final.
9. CSS (abaixo).
10. Conferência no link público.

## Campos

- Cada campo vira um slide **logo depois do elemento selecionado, na ordem da lista de pastas**, não na ordem em que você marcou. Confira e reordene.
- A aba "Adicionar campos de objeto" só abre com um elemento selecionado no canvas.
- Slide vazio: arraste o campo pelo ícone de grip à direita do nome na lista até "Arraste e solte". Arrastar cards da Adição rápida não funcionou.
- Campo já usado fica cinza: o mesmo campo não entra duas vezes.
- Campo criado durante a sessão só aparece depois de salvar e recarregar o editor.
- **Descrição do campo** aparece acima do rótulo. No upload, o **Rótulo curto** aparece embaixo da caixa: use como texto de ajuda.
- Campos de opção única viram lista suspensa e **avançam sozinhos** ao escolher. Múltipla escolha não avança: a pessoa clica em Próximo.
- Mudar opções no painel Opções muda o campo no CRM inteiro. Só com o cliente sabendo.

## Ramificação por link

Para mandar cada pessoa por um caminho sem perguntar o que você já sabe (ex.: serviço contratado).

1. Campos de **texto** guardam a informação (só campo de texto pode ser oculto). Marque **Oculto**.
2. Ajuste a **Chave de consulta** para um nome sem acento. Ela é o nome do parâmetro: `?contratou_implementacao=Sim&contratou_consultoria=Nao`.
3. **Slide só com campo oculto é pulado** e a regra dele não dispara. Arraste um elemento **Texto** para o mesmo slide, criando uma tela de transição visível que sirva para todos os caminhos.
4. Condição: ícone no topo esquerdo do construtor (ao lado do +), regra **Pular para**. Uma condição por regra. Destino aparece como `Pn - Slide N`. Não existe "ir para o fim".
5. Outras ações da lógica condicional: Redirecionar para URL, Exibir mensagem personalizada, Desqualificar lead, Mostrar ou Ocultar campos. Executam de cima para baixo.
6. Teste cada combinação de parâmetros no link público.

Campos ocultos também servem para guardar UTM vindos do link. Detalhes na skill `atlas-rastreamento`.

## Rodapé, final e configurações

- **Estilos > Rodapé**: Anterior, Próximo, Enviar.
- Em largura de celular o construtor mostra só setas e o botão final como "SUBMIT". Trate no CSS e confira em janela estreita.
- **Configurações > Ao enviar**: Mensagem, Redirecionar para URL ou Confirmação.
- Link da agenda no redirecionamento: `https://<domínio de marca>/widget/bookings/<slug>` (bookings no plural). `/widget/booking/<slug>` dá 404; `/widget/booking/<ID da agenda>` funciona.
- **Salvar progresso** (ligado por padrão): a resposta parcial fica no navegador de quem responde ("Envio em andamento"). O contato só é criado no envio final, salvo com **Criar contato em envio parcial** ligado.
- Outras opções em Configurações: Navegação automática, Rolar até o topo, Gerar documento de envio, Contato importante, Ativar fuso horário, Fonte GDPR, Pixel do Facebook (evento na página e no envio).

## CSS da pesquisa

Fica em **Estilos & Opções > Avançado > CSS personalizado**. A prévia do construtor não mostra o CSS: confira sempre no link público.

- Dentro do formulário, todo seletor começa com **`#app #_builder-form`** (dois IDs) para vencer os `!important`. Fora do formulário (rodapé, moldura), `#app` + classe.
- Classes úteis: `.ghl-form-wrap`, `.ghl-footer`, `.ghl-footer-buttons`, `.ghl-footer-back`, `.ghl-footer-next`, `.ghl-submit-btn`, `.multiselect`, `.multiselect__tags`, `.multiselect__option`, `.file-upload`, `.custom-file-upload`, `.short-label`, `.text-element`, `.field-label`, `.slide-no-N`, `.ghl-page-current`.
- O editor reformata ao colar. Cole o bloco inteiro de uma vez: clique no editor, `ctrl+End`, `ctrl+V`, salve. Para pôr texto na área de transferência pelo Chrome, um botão temporário na página do CRM que faz `execCommand('copy')` no clique, clicado de verdade.
- Depois de colar, o iframe pode rolar e esconder a barra de cima. Fechar o painel da direita no X faz o Salvar aparecer.

Trechos que sempre entram (troque as cores e a logo pelas da marca do cliente):

```css
/* Botão "Começar" só na primeira tela */
#app .ghl-form-wrap:has(.slide-no-1.ghl-page-current) .ghl-footer-next span { font-size: 0 !important; }
#app .ghl-form-wrap:has(.slide-no-1.ghl-page-current) .ghl-footer-next span::after { content: 'Começar'; font-size: 16px; }

/* Logo no topo (imagem na Mídia da conta) */
#app .ghl-form-wrap::before {
  content: ''; display: block; width: 140px; height: 52px;
  background: url('URL_DA_LOGO') left center / contain no-repeat;
  margin: 0 0 48px;
}

/* Sem cartão branco */
#app .ghl-form-wrap { max-width: 640px !important; box-shadow: none !important; background: transparent !important; }
#app #_builder-form { background: transparent !important; border: 0 !important; padding: 0 !important; }

/* Pergunta grande */
#app #_builder-form label, #app #_builder-form .field-label { font-size: 26px !important; font-weight: 700 !important; }

/* Próximo e Enviar em pílula */
#app .ghl-footer-next, #app .ghl-submit-btn { border-radius: 999px !important; height: 50px !important; padding: 0 28px !important; }

/* Celular: o layout é escolhido ao carregar, não pela largura */
#app .ghl-footer-next:not(:has(span)) svg { display: none !important; }
#app .ghl-footer-next:not(:has(span))::after { content: 'Próximo'; color: #fff; font-size: 16px; font-weight: 600; }
#app .ghl-form-wrap:has(.slide-no-1.ghl-page-current) .ghl-footer-next:not(:has(span))::after { content: 'Começar'; }
#app .ghl-footer-back:not(:has(span))::after { content: 'Voltar'; margin-left: 4px; }
#app .ghl-submit-btn[aria-label="SUBMIT"] { font-size: 0 !important; }
#app .ghl-submit-btn[aria-label="SUBMIT"]::after { content: 'Enviar'; font-size: 16px; font-weight: 600; }
#app #_builder-form .multiselect__placeholder:empty::before { content: 'Selecione'; }
#app #_builder-form .custom-file-upload .upload-copy .file-placeholder:empty::after { content: 'Clique ou arraste o arquivo aqui'; display: block; }
#app .survey-progress-bar-mobile { background: rgba(255,255,255,.2) !important; border-radius: 999px !important; margin: 0 0 36px !important; }
```

- O campo de e-mail traz `padding-left: 36px !important` inline (por causa do ícone). CSS não vence inline: puxe o input com `margin-left: -34px` e `overflow: hidden` no `.email-input`.
- Fundo da página: `html, body, #app, .hl-app, .ghl-body` com a cor da marca.
- Upload depois de anexar mostra "Add more files" e "1 file selected" em inglês e um cartão branco: trate com `.upload-add-more`, `.upload-count`, `.upload-card`, `.file-title`, `.file-subtitle`, `.progress-fill`.

## Link curto com prévia no WhatsApp

Redirecionamento comum (301) não mostra prévia no WhatsApp. A solução é uma página de funil com SEO e um script de redirecionamento. É trabalho da skill `atlas-sites-e-blog` (ver lá `paginas-e-construtor.md`). Nunca use o domínio de marca dos links de pesquisa, formulário e agenda para funil: quebra todos eles.

## Conferência

- Link público com cada combinação de parâmetros, respondendo até o fim.
- Telas na ordem, transições visíveis, avanço automático nas escolhas, "Começar" só na tela 1, logo no topo, final sem 404.
- Repita em largura de celular (setas e "SUBMIT").
- Com aprovação, envio de teste (nome `TESTE ...`). Confira por `get-surveys-submissions` e `get-contact` que as respostas caíram nos campos certos, inclusive ocultos e arquivo.
- O envio pode disparar automações (tags, mensagens). Na conta Atlas, o teste recebeu uma tag de automação sem ninguém esperar. Avise o cliente antes.

## Armadilhas

- Voltar para "Muitos de uma vez": todos os slides viram um. Recarregue sem salvar.
- Slide só com campo oculto: pulado, regra não dispara.
- Lote de campos fora de ordem: segue a ordem das pastas.
- CSS sem `#app #_builder-form`: perde sem aviso.
- Link de agenda com `/widget/booking/<slug>`: 404.
- Painel "Pergunte à IA" abre sozinho em alguns editores: feche no X. É cobrado da conta.
