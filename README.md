# Lista de Favoritos

Este projeto envolve um método de aprendizado, consiste no aperfeiçoamento das minhas skills em programação com Ruby e consequentemente o uso do Rails. Meu mentor @OtavioHenrique dedicou de seu tempo e paciência para me instruir ao término desse projeto.

Essa aplicação está disponibilizada no Heroku. Para uso seguir a Documentação abaixo:
> Postman: https://documenter.getpostman.com/view/11287623/Tzef9i2y

___

A API desenvolvida, foi implementada usando framework Ruby on Rails 5.2, todos os recurso foram realizados teste unitário e de integração, com uso do RSpec. A API contem autenticação em seu acesso e controle sobre os dados que são utilizados em alguns recursos. 

### Configurações

Caso deseja baixar o projeto e rodar local a aplicação, seguir o passo-a-passo deixado abaixo:

**Requisitos p/ Uso**
* git
* docker

##### Download 
* Clone o repositorio:
> git clone

##### Subindo a API
* Na raiz `/` do projeto, digite:
> docker-compose up -d

* Para ver os logs:
> docker logs -f favorite_list_api

* Para acessar o Container API:
> docker exec -it favorite_list_api bash

* Para rodar os Teste:
> docker-compose run api bundle exec rspec --order rand 

* Para dar um down na API:
> docker-compose down

### Ambiente

Por padrão a API esta disponibilizada na `PORT=3000`, ou seja:
> baseUrl: http://localhost:3000/
