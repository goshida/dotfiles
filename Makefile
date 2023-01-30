
setup-desktop:
	./scripts/install-yay.sh | tee -a ./log/$( date '+%Y%m%dT%H%M%S%z' )_install-yay.sh
	./scripts/install-packages.sh desktop | tee -a ./log/$( date '+%Y%m%dT%H%M%S%z' )_install-packages.sh
	./scripts/setup-desktop.sh | tee -a ./log/$( date '+%Y%m%dT%H%M%S%z' )_setup-desktop.sh

setup-server:
	./scripts/install-packages.sh server | tee -a ./log/$( date '+%Y%m%dT%H%M%S%z' )_install-packages.sh
	./scripts/setup-server.sh | tee -a ./log/$( date '+%Y%m%dT%H%M%S%z' )_setup-server.sh

deploy-dotfiles:
	./scripts/deploy-dotfiles.sh | tee -a ./log/$( date '+%Y%m%dT%H%M%S%z' )_deploy-dotfiles.sh

