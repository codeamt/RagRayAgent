scrape: 
bash download-ray-docs.sh

vectordb: 
microk8s.kubectl create -f yamls

postgres-client: 
bash install-libpq-dev.sh


port-forward-postgres: 
bash postgres-port-forward.sh

vector-support: 
bash setup-pgvector.sh

vector-table: 
bash create-embedding-vector-table.sh

embedding-table: 
bash psql_cmd.sh '\d'

pods-preview: 
get pods -A

svc-preview:
get svc

install-pip-deps: 
pipenv install && pipenv shell

ray-cluster: 
bash start-ray-cluster.sh

profile-ray-cluster: 
ray status

finetune: 
python main.py

dev-deploy:
bash start-ray-serve.sh

test-query:
python test-query-llm.py
