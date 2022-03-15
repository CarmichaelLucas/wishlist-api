# API WishList

Este projeto consiste em uma API, onde seu proprosito está em organizar uma lista de produtos favoritos de um determinado cliente. Quando desenvolvido este projeto que está em constante evolução foi para o aperfeiçoamento de minhas skills em programação com **_Ruby_** e consequentemente o uso do **_Ruby on Rails_**. Este projeto segue os exercicios propostos pelo meu mentor @OtavioHenrique.  

Essa aplicação está disponibilizada no Heroku, porém não está a versão mais atual do projeto. Para seu uso, basta seguir a documentação abaixo que disponibilizei pela ferramente do Postman :point_down:
> Postman: https://documenter.getpostman.com/view/11287623/Tzef9i2y  

A **API** desenvolvida, foi implementada usando _framework_ **_Ruby on Rails_** (5.2). Todos os recurso possuem testes unitários e testes de integração, com uso do RSpec e alguns facilitadores

## Ferramentas necessarias

* Git
* Docker
* AWS SQS

# Configuração inicial para uso

## Build com Make (caso use S.O Linux)

Na raiz `/` do projeto, digite:
> make build

Para ver os logs, caso precise:
> make logs

Para rodar os Teste:
> make test

Para dar um down na API:
> make remove

## Ambiente

Por padrão a API esta disposta na porta `3000`, ou seja, quando realizar o _build_ acesse em seu navegador ou use os recursos pela seguinte `baseUrl` :point_down:
> baseUrl: http://localhost:3000/