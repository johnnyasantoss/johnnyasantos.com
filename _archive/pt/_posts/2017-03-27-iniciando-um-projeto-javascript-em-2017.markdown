---
layout: post
title: Iniciando um projeto JavaScript em 2017
date: '2017-03-27 20:00:32'
categories:
- javascript
- webdev
- archive
tags:
- angular-1-x
- css3
- desenvolvimento-web
- express
- how-to
- lista-de-tarefas
- project
- projeto
- todo-list
- tutorial
- web-dev
---


Como sabemos, o cenário atual do JavaScript, está uma **bagunça** daquelas, que só quem fez sabe onde as coisas estão guardadas. Isso, aquela que você faz no seu quarto e ninguém, a não ser você, sabe o local das coisas.

Então, para ajudar vocês a entender essa bagunça, eu vou mostrar algumas coisas que podem ser muito úteis, para quem ainda não está por dentro desse *JS WORLD* (não, não é Jurassic World).


## Pré-Requisitos

- Conhecimento básico de HTML e Javascript
- [Node](https://nodejs.org/en/download/)


## Escolha um bom editor de textos ou IDE

Sempre é bom que você tenha consigo, ferramentas de trabalho que o ajudem a alcançar o seu objetivo. Nesse caso, nosso objetivo é criar um *workspace* para usar JS(es6) + [Angular](https://angularjs.org/).

#### Minha escolha

**[VSCODE](https://code.visualstudio.com/)**: Pra mim, hoje, o editor de textos mais completos, é o Visual Studio Code. É leve, direto, tem ferramentas muito úteis e tem inúmeras extensões que podem me ajudar.


## Comece a gostar da *command line*

A maior parte do setup de um novo projeto, vai acontecer na *command line*(cmd/powershell/bash), então, se você não tem costume de procurar a definição dos comandos usados, é bom começar a desenvolve-lo, pois, essa é uma das formas mais fáceis de entender, o que tal comando irá fazer.

Não confie cegamente nas documentações, até porque, geralmente elas são atualizadas por pessoas, assim como eu e você. E diferente das máquinas, nós, esquecemos de algumas coisas, certo?


## Vamos lá

Pra começar, crie uma pasta. Você decide o nome, eu deixo. Eu vou chamar a minha de `introducao-js`.

```
$ mkdir introducao-js
$ cd introducao-js
```

Inicie um “projeto” do *npm* (node package manager), usando o seguinte comando.

`npm init`

**Dica**: Usem o [Yarn](https://yarnpkg.com/pt-br/docs/install) ao invés do [Npm](https://www.npmjs.com/). Ele é mais rápido e os seus métodos são mais práticos e sucintos.

Preencha as informações requisitadas, e no final desse “quiz” você verá que foi gerado um arquivo `package.json`. Se você não souber o que preencher em alguns campos, simplesmente aperte `enter` e prossiga.

Certo! Agora temos um projeto JS (node).


## Decida qual framework vai usar

Claro, não é obrigatório você usar um framework, mas, a não ser que você goste de sofrer, creio que um framework, que faça o trabalho “sujo” de cuidar da compatibilidade do seu código, cai bem, não?
 Vou estar usando [`Angular 1.x`](https://angularjs.org/) e o servidor [Express](http://expressjs.com/pt-br/) nesse *mini tutorial*. **Nosso objetivo vai ser fazer uma lista de tarefas**.

Vamos criar uma pasta chamada `src` para manter o código da aplicação. Criaremos também, um arquivo, `index.js` para iniciar o nosso servidor, assim, poderemos ver a nossa aplicação.


## Mão na massa

Primeiro, vamos criar todos os arquivos necessários para fazer o nosso aplicativo começar a funcionar. Vamos deixar para escrever o código neles daqui à pouco.

Esta é a estrutura inicial do nosso projeto.

```
 .
 ├── index.js # Inicializador do nosso server
 ├── package.json  # O arquivo criado pelo ‘npm init’
 └── src
    ├── css
    │ └── app.css # folha de estilos do nosso app
    ├── index.html # página inicial
    └── js
      └── app.js # Aqui vai o código da aplicação

3 diretórios, 5 arquivos
```

## Criando o servidor

Vamos usar o [Express](http://expressjs.com/pt-br/) para nos ajudar com essa tarefa.

```js
//importamos o módulo do express
const express = require("express");

function meuAngularApp() {
    // criamos nosso servidor do express
    // qualquer dúvida que você tenha de como usa-lo melhor
    // acesse a referência da API do express
    // http://expressjs.com/pt-br/4x/api.html
    var app = express();

    // a função use() ela serve para permitir que você use
    // um controlador de requisições feitas em seu servidor
    // estaremos usando a função express.static() para gerar
    // um servidor de conteúdo estático na pasta ‘src’
    // para podermos acessar na url ‘/’
    app.use(express.static("./src", {
        extensions: [
            "html",
            "htm",
            "js",
            "css"
        ]
    }));

    // criamos outro controlador para as nossas
    // bibliotecas. Assim não precisamos usar um site externo
    // para carregar nossas bibliotecas
    app.use(express.static("./node_modules", {
        extensions: [
            "js",
            "css"
        ]
    }));

    // a função listen() faz com que o servidor espere
    // por requisições na porta informada
    // nesse caso a porta 9000
    var porta = (process.env.PORT || 9000);
    app.listen(porta, function (erro) {
        // se acontecer algum erro ao ligar
        // o erro vai ser mostrado e a aplicação para
        if (erro)
        throw erro;

        // Exibimos no console que o servidor está ligado
        // e pronto para receber requisições
        console.log("Servidor iniciado em http://127.0.0.1:" + porta);
    });

    return app;
}

// Aqui é exportado o módulo do nosso servidor
// caso você queira saber mais sobre módulos do Node
// procure por "CommonJS Modules"
module.exports = meuAngularApp();
```

Creio que não tem muita complexidade nesse script para gerar o server, até porquê, o [Express](http://expressjs.com/pt-br/) nos permite criar um servidor muito bem estruturado, com poucas linhas de código simples e fácil de entender.


## Pagina do app

Os comentários abaixo explicam de uma forma mais direta o código.

```html
 <!–
 Estamos definindo que o aplicativo do angular à ser usado
 é o ‘listaTarefasApp’ e que iremos usar a diretiva
 ‘ng-strict-di’. Essa diretiva serve para ‘obrigar’
 o desenvolvedor à sempre usar a injeção escrita
 das dependências do controller.
 –>
 <html lang="pt-BR" ng-app="listaTarefasApp" ng-strict-di>


 <meta charset="utf-8">
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
 <meta name="viewport" content="width=device-width, initial-scale=1">

 <title>Johnny A. Santos – Lista de Tarefas</title>
 <!– Fontes para facilitar a leitura –>
 <link href="https://fonts.googleapis.com/css?family=Open+Sans|Ubuntu" rel="stylesheet">

 <!– Estilo –>
 <link href="/css/app.css" rel="stylesheet">


<body ng-controller="listaTarefasController as vm">
 <!– Aqui criamos uma div para conter todos os objetos da nossa lista –>
 <div class="conteiner-lista">
 <h1>Lista de Tarefas</h1>
 <!–
 ng-submit permite que você escreva uma expressão para ser avaliada e executada
 no evento de envio do formulário em que se encontra.
 –>
 <form ng-submit="vm.novaTarefa()" class="nova-tarefa">
 <input placeholder="Criar uma tarefa" class="titulo" required ng-model="vm.tarefaObj.titulo" />
 <button class="botao botao-nova-tarefa" type="submit">Nova tarefa</button>
 </form>
 <!–
 Div que será repetida pela diretiva ng-repeat do Angular
 para cada item no nosso array dentro do controller
 –>
 <div class="objeto-lista" ng-repeat="tarefa in vm.tarefas">
 <!–
 Estou usando o ng-if para "economizar" nos *watchers* do Angular
 ng-class faz a adesão da classe ‘item-finalizado’ quando o meu objeto
 `tarefa` do escopo local tem a propriedade `concluida` como `true`
 o ng-cloak serve para esconder os elementos do html até que o Angular
 tenha carregado por completo
 –>
 <div class="item-lista" ng-if="!tarefa.editando" ng-cloak ng-class="{ ‘item-finalizado’: tarefa.concluida }">
 <!–
 A diretiva ng-bind faz com que o valor dentro do meu `span` seja o da propriedade
 `titulo` dentro do objeto `tarefa`. Os `::` (dois pontos) são para informar que esse
 é um bind único, e que só acontecerá essa "passagem" de valores para o meu span
 só ocorra uma vez.
 Dica: Eu prefiro sempre usar o ng-bind ao \{\{}}, porque ele só é avaliado quando
 o Angular termina de carregar, sem mostrar o código no inicio do app.
 –>
 <span class="titulo-lista" ng-bind="::tarefa.titulo" ng-click="vm.finalizar(tarefa)"></span>
 <div class="botoes-conteiner">
 <!–
 A diretiva ng-click permite que você escreva uma expressão, podendo
 usar as variáveis do escopo local ou global do Angular,
 que será avaliada dentro do evento de clique do botão.
 –>
 <button class="botao botao-edicao" ng-click="vm.editar(tarefa)">Editar</button>
 <button class="botao botao-remocao" ng-click="vm.remover(tarefa)">Remover</button>
 </div>
 </div>

 <form ng-submit="vm.salvar(tarefa)" class="item-lista item-edicao-lista" ng-if="tarefa.editando" ng-cloak>
 <input ng-model="tarefa.titulo" />
 <button type="submit" class="botao botao-salvar">Salvar</button>
 </form>
 </div>
 </div>
 <small class="footer">2017 – <a href="https://johnnyasantos.com" target="_blank">Johnny Anderson dos Santos</a></small>

 <!– Scripts podem ir no final do HTML para ajudar no carregamento –>
 <script src="/angular/angular.js" defer></script>
 <script src="/js/app.js" defer></script>
```


## Finalmente o JavaScript

Novamente, vamos direto ao código. Até por quê, como já dizia [*Linus Torvalds*](https://pt.wikipedia.org/wiki/Linus_Torvalds)

> Talk is cheap, show me the code!


```js
// criamos nosso aplicativo angular
var app = angular.module("listaTarefasApp", []);

// vamos então, definir um controlador (controller)
// para nossa view (a pagina) do nosso aplicativo
app.controller("listaTarefasController", listaTarefasController);

/**
 * Controlador da nossa aplicação
 * @param {Object} $log logger padrão do Angular
 */
 function listaTarefasController(
     $log
 ) {
    //uma referência para ajudar no entendimento
    var vm = this;

    //lista de tarefas
    vm.tarefas = [];

    function inicializarTestes() {
    var hw = criarTarefa();
    hw.editando = true;
    hw.titulo = "Hello world!";

    vm.tarefas.push(hw);

    var om = criarTarefa();
        om.titulo = "Olá Mundo!"
        vm.tarefas.push(om);
    }
    inicializarTestes();

    //objeto para criação de novas tarefas
    vm.tarefaObj = criarTarefa();

    /**
    * Cria um novo objeto de tarefa
    * @returns {Tarefa}
    */
    function criarTarefa() {
        return new Tarefa(vm.tarefas.length);
    }

    /**
    * Adiciona uma nova tarefa a lista
    */
    function novaTarefa() {
        $log.debug("Criando nova tarefa.");

        vm.tarefas.push(vm.tarefaObj);

        vm.tarefaObj = criarTarefa();
    }
    //desta forma, expomos essa função ao objeto gerado pelo nosso controller
    //diferentemente da função criarTarefa que não é exibida publicamente
    vm.novaTarefa = novaTarefa;

    /**
    * Finaliza a edição da tarefa
    * @param {Tarefa} tarefa
    */
    function salvar(tarefa) {
        $log.debug("Salvando item: %s.", tarefa.titulo);
        tarefa.editando = false;
    }
    vm.salvar = salvar;

    /**
    * Finaliza a edição da tarefa
    * @param {Tarefa} tarefa
    */
    function remover(tarefa) {
        $log.debug("Removendo item: %s.", tarefa.titulo);

        vm.tarefas = vm.tarefas.filter(function (t) {
            return t.id !== tarefa.id;
        });
    }
    vm.remover = remover;

    /**
    * Coloca uma tarefa em edição
    * @param {Tarefa} tarefa
    */
    function editar(tarefa) {
        $log.debug("Iniciando edição do item: %s.", tarefa.titulo);
        tarefa.editando = true;
    }
    vm.editar = editar;

    /**
    * Troca o status da tarefa
    * @param {Tarefa} tarefa
    */
    function finalizar(tarefa) {
        $log.debug("Alterando o status do item: %s.", tarefa.titulo);
        tarefa.concluida = !tarefa.concluida;
    }
    vm.finalizar = finalizar;

    //retornamos o nosso objeto do controller
    return vm;
}

listaTarefasController.$inject = [
    "$log"
];

/**
 * Nosso construtor do nosso objeto de tarefa
 * @param {number} id Id da tarefa
 */
function Tarefa(id) {
    this.id = id;
    this.titulo = "";
    this.editando = false;
    this.concluida = false;

    return this;
}
```

#### Acessem o exemplo

O código é aberto, e está no [GitHub](https://github.com/johnnyasantoss/introducao-js), quando vocês verem o código e a estrutura do projeto, irão entender melhor o seu funcionamento.

Fiz também um exemplo “ao vivo” do nosso pequeno projetinho JS.
 Acesse-o aqui [https://introducao-js.herokuapp.com/](https://introducao-js.herokuapp.com/)

Qualquer erro encontrado, sugestão, ou ideia, crie um [*issue*](https://github.com/johnnyasantoss/introducao-js/issues) no [GitHub](https://github.com/johnnyasantoss/introducao-js).

Espero que eu tenha sido claro.

Até a próxima 🙂
