# 8zar Makefile
# Useful tooling for complex commands
# Specs: http://www.gnu.org/software/make/manual/make.html
# import .env environment variables
include .env
export

ifneq ($(wildcard .env.secret),)
include .env.secret
export
LOCAL_DEV = 1
else
LOCAL_DEV = 0
endif

# Override if env if not set
export ENV := $(shell terraform workspace show)
export PATH := .scripts:$(PATH)
export PROJECT_WORKDIR := terraform/providers/$(PROVIDER)/$(REGION)

## Set env var is empty
ifeq ($(GOOGLE_APPLICATION_CREDENTIALS),)
export GOOGLE_APPLICATION_CREDENTIALS := ${HOME}/gcloud-service-key.json
endif

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

VERSION_FILE=VERSION
VERSION=`cat $(VERSION_FILE)`

TARGET_MAX_CHAR_NUM=25

## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)



## Scripts
## -----------------------------------------
## -----------------------------------------
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
8ZAR_ROOT := $(dir $(realpath $(dir $$PWD)))
SERVICE_NAME:= "infra"
#include $(8ZAR_ROOT)/.scripts/_rc.mk
#include $(8ZAR_ROOT)/.scripts/_.mk
#include $(8ZAR_ROOT)/.scripts/_cd.mk
#include $(8ZAR_ROOT)/.scripts/_ci.mk
#include $(8ZAR_ROOT)/.scripts/_dev.mk
#include $(8ZAR_ROOT)/.scripts/_svc.mk
#include $(8ZAR_ROOT)/.scripts/_py.mk
#include $(8ZAR_ROOT)/.scripts/_tf.mk
#include $(8ZAR_ROOT)/.scripts/_wh.mk

## Deploy


default:
	@echo $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
	@echo MAKEFILE_LIST: ${MAKEFILE_LIST}
	@env_info.sh

init:
	@echo Init
	@terraform init -var-file terrform.tfvars

plan:
	@echo Plan
	@terraform plan -out out.tfplan -var-file terraform.tfvars

apply:
	@echo Apply
	@terraform apply out.tfplan


kubeproxy:
	@echo Kubernetes Proxy
	@kubectl proxy

kubeproxy_token:
	@echo Kubernetes Proxy Token
	@#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')


kubedescribe:
	@APISERVER=$(kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " ")
	@SECRET_NAME=$(kubectl get secrets | grep ^default | cut -f1 -d ' ')
	@TOKEN=$(kubectl describe secret $SECRET_NAME | grep -E '^token' | cut -f2 -d':' | tr -d " ")
	@curl $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure

kubedescribe_json:
	@APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
	@SECRET_NAME=$(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}')
	@TOKEN=$(kubectl get secret $SECRET_NAME -o jsonpath='{.data.token}' | base64 --decode)
	@curl $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure