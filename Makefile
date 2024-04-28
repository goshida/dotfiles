date := $(shell date '+%Y%m%d-%H%M%S%z')

setup-desktop:
	./scripts/install-yay.sh 2>&1 | tee -a ./log/install-yay.sh.$(date).log
	./scripts/install-packages.sh desktop 2>&1 | tee -a ./log/install-packages.sh.$(date).log
	./scripts/setup-desktop.sh 2>&1 | tee -a ./log/setup-desktop.sh.$(date).log

setup-server:
	./scripts/install-packages.sh server 2>&1 | tee -a ./log/install-packages.sh.$(date).log
	./scripts/setup-server.sh 2>&1 | tee -a ./log/setup-server.sh.$(date).log

deploy-dotfiles:
	./scripts/deploy-dotfiles.sh 2>&1 | tee -a ./log/deploy-dotfiles.sh.$(date).log

archive-secrets:
	./scripts/archive-secrets.sh 2>&1 | tee -a ./log/archive-secrets.sh.$(date).log

