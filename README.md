# Database Lab

## Como usar este repositório?

1. Realize a instalação do [Docker](https://docs.docker.com/engine/install/)
2. Clone o repositório:
```bash
git clone https://github.com/rbsilmann/database_lab.git
```
3. Acesse o repositório e suba o arquivo declarativo:
```bash
cd database_lab && docker compose up -d
```

## Como utilizar o ambiente?
Este ambiente irá subir uma <i>stack<i> simples composta do PostgreSQL 15 (versão alpine) e a ferramenta pgAdmin web.
O pgAdmin ficará disponível na porta local [8500](http://localhost:8500/).