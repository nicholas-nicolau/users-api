# README

## Levantar servidor

```
docker compose up web
```

## Configurar DB

### Com o servidor rodando
```
docker compose exec web sh
rails db:drop db:create db:migrate db:seed
```

### Sem o servidor rodando
```
docker compose run web sh
rails db:drop db:crate db:migrate db:seed
```

