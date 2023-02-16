run:
	docker run --publish 8080:8080 day-log-api

ptest-local: 
	ab -n 1000 -c 100 -p json/login.json http://127.0.0.1:8081/api/v1/auth/login

ptest-docker: 
	ab -n 1000 -c 100 -p json/login.json http://127.0.0.1:8080/api/v1/auth/login

ptest-heroku: 
	ab -n 1000 -c 100 -p json/login.json https://daylog-app.herokuapp.com/api/v1/auth/login

deploy-cloud-run:
	sh ./scripts/deploy-cloud-run.sh

compose: 
	docker compose up



