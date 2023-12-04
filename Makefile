postgres:
	docker run --name postgres_new_new -p 5444:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres_new_new createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres_new_new dropdb --username=root --owner=root simple_bank

.PHONY: createdb
