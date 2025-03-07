# 🚀 Solid Queue Lab

Este é um projeto Ruby on Rails. Siga as instruções abaixo para configurar e executar o ambiente local.

## 📦 Instalação

Antes de começar, certifique-se de ter o **Ruby** e o **Bundler** instalados.

1. Instale as dependências:
   ```sh
   bundle install
   ```

2. Configure o banco de dados:
   ```sh
   rails db:create db:migrate db:seed
   ```

## ▶️ Executando o projeto

Para iniciar o servidor local, execute:

```sh
rails server
rails solid_queue:start
```

O projeto estará disponível Swagger: **http://localhost:3000/docs**
