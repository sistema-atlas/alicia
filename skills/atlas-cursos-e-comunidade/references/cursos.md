# Como os cursos funcionam na Atlas

Fonte: respostas reais da conta de teste da Atlas (03/11/2026) e descrições das operações do conector.

## Estrutura

```
Curso (product)
  Módulo (category)            sequenceNo, visibility, gotejamento ou trava
    Submódulo (category com parentCategory)   só um nível
      Aula (lesson)            contentType: video, audio, assignment, quiz, funnel
        Quiz da aula           nota mínima, mensagem de aprovado e reprovado
          Perguntas            single ou multiple, opções com isCorrect
Oferta (offer)                 pacote de um ou mais cursos; grátis, avulsa ou assinatura
Matrícula (enrollment)         contato + oferta
```

## Estados de visibilidade

| Item | Valores | Para o cliente |
| --- | --- | --- |
| Módulo | `draft`, `published`, `locked`, `drip` | rascunho, publicado, travado até concluir algo, liberado com o tempo |
| Aula | `draft`, `published`, `locked` | rascunho, publicado, travado |
| Oferta | `draft`, `published` | rascunho, publicada |

Gotejamento: `visibility: drip` com `dripDays` e `metadata.dripUnit` (`days` ou `hours`) ou `metadata.dripDate`. Trava: `visibility: locked` com `lockedBy` (aula publicada) ou `lockedByCategory` (módulo publicado).

## Receita: curso novo com módulos e aulas

1. `create-course` com `title`, `description` e dados do instrutor em `customizations`. O curso não tem rascunho pelo conector; o conteúdo é que fica em rascunho.
2. Para cada módulo, `create-category` com `title`, `sequenceNo` e `visibility: draft`.
3. Para cada aula, `create-lesson` com `title`, `categoryId`, `description` (HTML simples: `<p>`, `<ol>`, `<strong>`), `visibility: draft`, `sequenceNo`.
4. Se a ordem saiu errada, `sequence-lessons` com todos os `ids` do módulo na ordem certa.
5. Quiz: `create-lesson-quiz` na aula, depois `upsert-quiz-questions` com todas as perguntas.
6. Vídeo de cada aula: tela.
7. Publicar: `update-category` e `update-lesson` com `visibility: published`, só com `CONFIRMO PUBLICAÇÃO`. Mostrar ou esconder o curso inteiro na biblioteca: tela.

Cada passo é uma escrita: dryRun, resumo, sim. Para um curso inteiro, peça um sim para o plano e um `CONFIRMO PUBLICAÇÃO` só no fim.

## Receita: liberar acesso

1. Ache o contato (skill `atlas-contatos`) e guarde o `contactId`.
2. `list-offers` com `search` pelo nome. Se houver oferta com o curso, use o `offerId`.
3. Sem oferta própria (o curso foi liberado pela tela, oferta padrão; `create-enrollment` daria 404): duas saídas, pergunte qual o cliente prefere:
   - criar uma oferta grátis com o curso (`create-offer` com `type: free`, `productIds`), que fica reaproveitável;
   - liberar pela tela do curso.
4. `create-enrollment` com `contactId` e `offerId`. Resposta `alreadyEnrolled: true` quer dizer que já tinha acesso.
5. Liberar não manda e-mail de acesso pelo conector. Para o aluno entrar, use o convite ou o e-mail de login do portal (tela), com `CONFIRMO ENVIO`.

## Receita: tirar acesso

1. Ache o contato (`references/_comum/achar-contato.md`).
2. `list-offers`: há oferta própria com o curso? Diga quais cursos estão nessa oferta (todos saem juntos).
3. Com oferta própria: dryRun de `delete-enrollment` e `CONFIRMO EXCLUSÃO`.
4. Sem oferta própria (acesso pela oferta padrão): pelo conector não dá (404). Passo a passo na tela Assinaturas, o cliente remove o acesso. Para todos os alunos de uma vez, além disso, `CONFIRMO MASSA`.

## Receita: "o aluno terminou?"

- `list-bulk-progress` com `contactId` e o `productId`: devolve `progress`, `completedLessons`, `totalLessons` (só aulas publicadas).
- Detalhe por aula: `list-completions` com `contactId`.
- Notas de quiz: `list-assessments` com `status`.

## Valores e moeda

`amount` das ofertas é o valor cheio na moeda (`currency`), por exemplo `297` com `BRL` é R$ 297,00. Mostre sempre no formato brasileiro: R$ 297,00.
