# Rag Agent with Ray


# Overview

This repository does the following:

1. Fine tuning an LLM
2. Populate a vector database with and embedding model, so able to query your context similarty in the vector database
3. Fine tune with Ray framework
4. Use CPU and GPU for fine tuning and serving
5. Serve your fine tuned LLM as REST API.


# Configurations
Please set the API keys accordingly save the content below in `llm_agent/.env`.

```bash
OPENAI_API_KEY=
ANYSCALE_API_KEY=
OPENAI_API_BASE="https://api.endpoints.anyscale.com/v1"
ANYSCALE_API_BASE="https://api.endpoints.anyscale.com/v1"
DB_CONNECTION_STRING="postgresql://testUser:testPassword@localhost:15432/testDB"
EMBEDDING_INDEX_DIR=/tmp/embedding_index_sql
VECTOR_TABLE_NAME=document
VECTOR_TABLE_DUMP_OUTPUT_PATH=/tmp/vector.document.dump.sql
RAYDOCS_ROOT=/tmp/raydocs
NUM_CPUS=14
NUM_GPUS=1
NUM_CHUNKS=5
CHUNK_SIZE=500
CHUNK_OVERLAP=50
EMBEDDING_MODEL_NAME="thenlper/gte-base"
LLM_MODEL_NAME=meta-llama/Llama-2-70b-chat-hf

#How much data should be fed for fine tuning
#give a floating number between >0.001 and 1 (1 included, which means use all the data for fine tuning)
USE_THIS_PORTION_OF_DATA=0.05

```


# Makefile Commands for Project Setup

```bash
make scrape # Scrap the web page

make vectordb # Configure Postgres Vector DB

make postgres-client # Install Postgres Client

Then, in a seperate terminal
make port-forward-postgres # Port Forward DB

make vector-support # Enable Vector Support

make vector-table # Create Vector Table

make embedding-table # Get Vector Table

# result:
               List of relations
 Schema |      Name       |   Type   |  Owner
--------+-----------------+----------+----------
 public | document        | table    | testUser
 public | document_id_seq | sequence | testUser
(2 rows)

make pods-preview # Get Pods

make install-pip-deps # Install Pip Dependencies
```


## Finetuning 

Once Setup, the following commands enable finetuning on a ray cluster:

```bash
make ray-cluster # Start Ray Cluster

make profile-ray-cluster # Profile Cluster

make finetune # Finetune LLM
```
At the end you will see something like below:

```bash
The default batch size for map_batches is rollout_fragment_length * num_envs.
```
which indicates that LLM fine tuning is done, vector db is populated, and a query is sent to LLM with the context identified by your vector DB.

**Note:** My machine has 16 CPUs and 1 GPU, so I set up `NUM_CPUS` and `NUM_GPUs` accordingly. These numbers may differ according to your machine. The principle here is that you can not set up a number larger than existing resources (CPU and GPU).

Pleae note that we are using `thenlper/gte-base` as an embedding model, this is a relatively small model, you might like to change it. `LLM_MODEL_NAME` is  to `meta-llama/Llama-2-70b-chat-hf`, which is good for this setup, but again you might like to change it.


#### Serving

```bash
make dev-deploy

make test-query
```
Should yield: 

```bash
b'"{\\"question\\": \\"What is the default batch size for map_batches?\\", \\"sources\\": [\\"https://docs.ray.io/en/master/rllib/rllib-training.html#specifying-rollout-workers\\", \\"https://docs.ray.io/en/master/rllib/rllib-training.html#specifying-rollout-workers\\", \\"https://docs.ray.io/en/master/rllib/package_ref/doc/ray.rllib.policy.policy.Policy.compute_log_likelihoods.html#ray-rllib-policy-policy-policy-compute-log-likelihoods\\", \\"https://docs.ray.io/en/master/rllib/package_ref/doc/ray.rllib.policy.policy.Policy.compute_log_likelihoods.html#ray-rllib-policy-policy-policy-compute-log-likelihoods\\", \\"https://docs.ray.io/en/master/rllib/rllib-algorithms.html#importance-weighted-actor-learner-architecture-impala\\"], \\"answer\\": \\" The default batch size for map_batches is rollout_fragment_length * num_envs.\\", \\"llm\\": \\"meta-llama/Llama-2-70b-chat-hf\\"}"'

```

## TODO
* Spot Instance/Fleet Provisioning for Cost Effective Training
* CUDA devcontainer configurations
* Dockerfiles
* Terraform Configuration for 3-Tier Cloud Deployment
* linting, testing
* Github Push/Pull Actions + CI/CD Building
* Intergrating Other DB Backends
* Quantization


# References
[1](https://www.anyscale.com/blog/a-comprehensive-guide-for-building-rag-based-llm-applications-part-1) A Comprehensive Guide for Building RAG-based LLM Applications (Part 1). Any Scale Blog.
