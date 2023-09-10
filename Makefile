.PHONY: all
all: check-env kind flux

.PHONY: kind
kind:
	kind create cluster --name=Flux-k8s-vault --config=./base/kind/config.yaml

.PHONY: check-env
check-env:
	@test $${GITHUB_TOKEN?Please set environment variable GITHUB_TOKEN}
	@test $${GITHUB_USER?Please set environment variable GITHUB_USER}

.PHONY: flux
flux: check-env
	flux bootstrap github \
		--owner="$(GITHUB_USER)" \
		--repository=Flux-k8s-vault \
		--branch=main \
		--path=./cluster \
		--token-auth \
		--personal

.PHONY: cleanup
cleanup:
	kind delete cluster --name=Flux-k8s-vault