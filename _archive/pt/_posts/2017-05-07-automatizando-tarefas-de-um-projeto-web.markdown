---
layout: post
title: Automatizando tarefas de um projeto web
date: '2017-05-07 22:00:19'
tags:
- desenvolvimento-web
- gulp
- gulpjs
- how-to
- tutorial
- web
---

Olá!

Garanto que vocês já devem ter pensado em como é chato ter que recompilar o seus projetos após cada alteração. Hoje pretendo ensinar vocês à **ganharem tempo** no desenvolvimento de uma aplicação web!

Vamos começar aprendendo a usar uma das mais conhecidas e melhores ferramentas para automatização de processos em um projeto **JS**, o [Gulp](http://gulpjs.com/).

Para instalar ele é bem fácil, já que ele é um programa entregue pelo [npm](https://www.npmjs.com/). Você só precisará ter o [NodeJS](https://nodejs.org/en/download/) instalado na sua máquina e executar o seguinte comando.

```bash 
# este comando instala as "ferramentas"  
# do gulp para a command line  
# o -g é um modificador global do npm  
npm install gulp-cli -g  
```

Após você ter instalado a *CLI* do [Gulp](http://gulpjs.com/), você precisa adicionar os scripts do gulp ao seu projeto.

*Presumo que você já tenha um projeto Node, porém, caso não tenha, veja [este post](http://johnnyasantos.com/2017/03/27/iniciando-um-projeto-javascript-em-2017)*

Vamos então adicionar o Gulp como dependência no nosso projeto e criar um arquivo chamado `gulpfile.js` na nossa raiz do projeto.

```bash 
npm install gulp -D  
# ou usando o Yarn  
# yarn add gulp -D  
```

O Gulp por si só, não faz nada ficar magicamente automático. Então *você* é o responsável por desenvolver as suas tarefas de automação.

Por exemplo, vamos dizer que eu queira adicionar uma tarefa que inicia um servidor de testes e reinicie ele para cada alteração no meu código, assim não vou precisar ter que fazer isso manualmente.


## Criando uma tarefa no Gulp

Para criarmos um servidor usaremos a *package* (pacote do [npm](https://www.npmjs.com/)) [nodemon](https://www.npmjs.com/package/gulp-nodemon) ela irá fazer tudo o que precisamos, é sempre bom, saber de packages que já façam o trabalho pra você, afinal, *pretendemos ganhar tempo com isso e não perde-lo refazendo a roda*.

```bash
npm install gulp-nodemon -D
# ou usando o Yarn
# yarn add gulp-nodemon -D
```

E então adicionamos o script com nossas tarefas, o famoso `gulpfile.js`.

```js
// Importamos as duas packages que usaremos aqui  
// o gulp e o gulp-nodemon  
const gulp = require("gulp"),  
nodemon = require("gulp-nodemon");

//criamos aqui a tarefa serve  
gulp.task("serve", serve);

//função da tarefa serve  
//que será chamada caso essa tarefa seja disparada  
function serve() {  
    //iniciamos o nodemon passando como parâmetro  
    //um objeto de configurações  
    //na propriedade "script" dizemos qual será  
    //o cript de inicialização do servidor.  
    //A propriedade "ext" diz quais as extensões serão  
    //monitoradas em busca de alterações.  
    //A propriedade "watch" diz quais diretórios serão monitorados  
    nodemon({  
        script: "index.js"  
        , ext: "js html css"  
        , watch: ["./src"]  
    });  
}  
```


## Eeeee *Voilà*

![nodemon](https://johnnyasantoscom.files.wordpress.com/2017/05/nodemon.gif)

Espero que tenham gostado desse pequeno post sobre o Gulp!  
 Você pode fazer MUUITAS coisas com essa ferramenta, basta apenas usar a **criatividade**.

Até a próxima! 😀


