## Lista de Favoritos

Este projeto consiste no aperfeiçoamento de minhas skills em programação com **_Ruby_** e consequentemente o uso do **_Ruby on Rails_**. Meu mentor @OtavioHenrique dedicou de seu tempo e paciência para me instruir nesse projeto.  


Essa aplicação está disponibilizada no Heroku \o/. E para seu uso, basta seguir a Documentação abaixo:
> Postman: https://documenter.getpostman.com/view/11287623/Tzef9i2y  


A **API** desenvolvida, foi implementada usando _framework_ **_Ruby on Rails_** (5.2). Todos os recurso possuem teste unitário e de integração, com uso do RSpec.  

___
### Configurações


Caso deseja baixar o projeto e rodar local a aplicação, seguir o _passo-a-passo_ abaixo:

* **Requisitos p/ Uso**
  * git
  * docker

##### Download 

* Você precisa dar um Clone no projeto:
> git clone https://github.com/CarmichaelLucas/favorite_list.git

##### Build da API
* Na raiz `/` do projeto, digite:
> docker-compose up -d

* Para ver os logs, caso precise:
> docker logs -f favorite_list_api

* Para acessar o container API:
> docker exec -it favorite_list_api bash

* Para rodar os Teste:
> docker-compose run api bundle exec rspec --order rand 

* Para dar um down na API:
> docker-compose down

### Ambiente

Por padrão a API esta disponibilizada na `PORT=3000`, ou seja, quando realizar o _build_ usar:
> baseUrl: http://localhost:3000/