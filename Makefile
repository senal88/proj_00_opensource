SHELL := /bin/bash
ROOT := $(shell pwd)

.PHONY: help validate sync sync-dry-run channels intake-done

help:
	@echo "validate      - valida estrutura, taxonomia, INDEX, fila, segredos e intake"
	@echo "sync-dry-run  - simula dev -> Google Drive"
	@echo "sync          - espelha dev -> Google Drive (nunca apaga no destino)"
	@echo "channels      - busca novos videos dos canais e adiciona em urls.txt"
	@echo "intake-done   - marca arquivo do _intake como triado (FILE=<nome>)"

validate:
	@python3 "$(ROOT)/scripts/validate_repo.py"

sync-dry-run:
	@"$(ROOT)/scripts/sync_gdrive.sh" --dry-run

sync:
	@"$(ROOT)/scripts/sync_gdrive.sh"

channels:
	@"$(ROOT)/scripts/check_channels.sh"

intake-done:
	@test -n "$(FILE)" || { echo "uso: make intake-done FILE=<caminho relativo no Drive>" >&2; exit 64; }
	@mkdir -p "$$HOME/Projects/opensource/proj_00_opensource__local/_intake"
	@printf '%s\n' "$(FILE)" >> "$$HOME/Projects/opensource/proj_00_opensource__local/_intake/.triaged"
	@sort -u "$$HOME/Projects/opensource/proj_00_opensource__local/_intake/.triaged" -o "$$HOME/Projects/opensource/proj_00_opensource__local/_intake/.triaged"
	@echo "triado: $(FILE)"
