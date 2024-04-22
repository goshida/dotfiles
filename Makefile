date := $(shell date '+%Y%m%d-%H%M%S%z')

setup-desktop:
	./scripts/install-yay.sh | tee -a ./log/$(date).install-yay.sh.log
	./scripts/install-packages.sh desktop | tee -a ./log/$(date).install-packages.sh.log
	./scripts/setup-desktop.sh | tee -a ./log/$(date).setup-desktop.sh.log

setup-server:
	./scripts/install-packages.sh server | tee -a ./log/$(date).install-packages.sh.log
	./scripts/setup-server.sh | tee -a ./log/$(date).setup-server.sh.log

deploy-dotfiles:
	./scripts/deploy-dotfiles.sh | tee -a ./log/$(date).deploy-dotfiles.sh.log

archive-secrets:
	./scripts/archive-secrets.sh | tee -a ./log/$(date).archive-secrets.sh.log


