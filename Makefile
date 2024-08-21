SHELL := /bin/bash
GREEN := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET := $(shell tput -Txterm sgr0)

.PHONY: help

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "${YELLOW}%-16s${GREEN}%s${RESET}\n", $$1, $$2}' $(MAKEFILE_LIST)

save: ## Save changes into repository automatically.
	@git add .
	@git commit -m "Save changes at: $$(date +%s)"
	@git push

server: ## Run file server.
	@python3 -m http.server 8080 -b 0.0.0.0

vm: ## Run virtual machine.
	@qemu-img create -q -f qcow2 al.qcow2 20G
	@qemu-system-x86_64 \
		-enable-kvm \
		-m 4G \
		-smp 2 \
		-hda al.qcow2 \
		-bios /usr/share/ovmf/x64/OVMF_CODE.fd \
		-cdrom /home/nsc/Downloads/archlinux-2024.08.01-x86_64.iso \
		-nic user,hostfwd=tcp::60022-:22,hostfwd=tcp::5900-:5900 \
		-vga qxl
