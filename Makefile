base:
	sudo pacman -S \
		vi \
		sudo \
		openssh \
		git \
		neovim \
		screen \
		man-db \
		man-pages

network:
	sudo pacman -S \
		networkmanager \
		network-manager-applet
	sudo systemctl enable NetworkManager.service

japanese:
	sudo pacman -S \
		fcitx \
		fcitx-im \
		fcitx-mozc \
		fcitx-configtool
	sudo pacman -S \
		otf-ipafont \
		noto-fonts \
		noto-fonts-cjk \
		noto-fonts-emoji \
		adobe-source-han-sans-otc-fonts \
		adobe-source-han-serif-otc-fonts
	yay -S \
		ttf-hackgen-nerd

audio:
	sudo pacman -S \
		pulseaudio \
		pavucontrol \
		alsa-utils

bluetooth:
	sudo pacman -S \
		bluez \
		bluez-libs \
		bluez-utils \
		blueman
	yay -S \
		bluez-firmware
	sudo systemctl start bluetooth
	sudo systemctl enable bluetooth

bluetooth-audio:
	sudo pacman -S \
		pulseaudio-alsa \
		pulseaudio-bluetooth

sshd:
	sudo systemctl enable sshd

gui:
	sudo pacman -S \
		xorg-server \
		xorg-apps \
		xorg-xinit \
		xfce4 \
		xfce4-goodies \
		xfce4-notifyd \
		xfce4-clipman-plugin \
		xarchiver \
		lightdm \
		lightdm-gtk-greeter \
		wmctrl
	yay -S \
		gamin \
		libinput-gestures \
		nordic-theme \
		tela-icon-theme
	sudo systemctl enable lightdm.service
	cp /etc/X11/xinit/xinitrc ~/.xinitrc
	libinput-gestures-setup autostart

browser:
	sudo pacman -S \
		firefox
	yay -S \
		google-chrome \
		slack-desktop

rdp:
	sudo pacman -S \
		remmina \
		freerdp

vpn:
	sudo pacman -S networkmanager-openvpn
	sudo pacman -S xl2tpd
	yay -S \
		ike-scan \
		libreswan \
		networkmanager-l2tp \
		networkmanager-libreswan

cli-tools:
	sudo pacman -S \
		pacman-contrib \
		gptfdisk \
		exfat-utils \
		nfs-utils \
		lsof \
		zip \
		unzip \
		p7zip \
		unarchiver \
		tree \
		colordiff \
		dnsutils \
		pwgen \
		iftop \
		nethogs \
		screenfetch
	yay -S \
		downgrade \
		nkf \
		perl-image-exiftool

gui-tools:
	sudo pacman -S \
		plank \
		xdotool \
		peek \
		code \
		galculator \
		vlc
	yay -S \
		xzoom \
		archlinux-artwork

development-tools:
	sudo pacman -S \
		inetutils \
		rsync \
		cronie \
		jq \
		yq \
		whois \
		traceroute \
		gnu-netcat \
		tcpdump \
		wireshark-cli \
		wireshark-qt \
		curl \
		wget \
		starship \
		bash-completion
	sudo pacman -S \
		python \
		python-pip \
		pyenv \
		packer
	yay -S \
		aws-cli-v2-bin \
		aws-sam-cli \
		git-secrets

docker:
	sudo pacman -S \
		docker \
		docker-compose
	sudo usermod -aG docker ${USER}
	sudo systemctl enable docker

asdf:
	yay -S \
		asdf-vm
	source /opt/asdf-vm/asdf.sh
	asdf plugin add kubectl

wps-office:
	yay -S \
		wps-office \
		ttf-wps-fonts

desktop-install: base network japanese audio bluetooth gui rdp vpn cli-tools gui-tools development-tools docker asdf
wsl-install: base cli-tools development-tools docker asdf

dropbox:
	yay -S \
		dropbox \
		thunar-dropbox

delay-install: dropbox

deploy-dotfiles:
	ln --backup=simple -sn `pwd`/home/.bash_profile ~/
	ln --backup=simple -sn `pwd`/home/.bashrc ~/
	ln --backup=simple -sn `pwd`/home/.profile ~/
	ln --backup=simple -sn `pwd`/home/.xprofile ~/
	ln --backup=simple -sn `pwd`/home/.Xmodmap ~/
	mkdir -p ~/.config
	ln --backup=simple -sn `pwd`/home/.config/nvim ~/.config/
	ln --backup=simple -sn `pwd`/home/.config/screen ~/.config/
	ln --backup=simple -sn `pwd`/home/.config/starship ~/.config/
	ln --backup=simple -sn `pwd`/home/.config/xfce4 ~/.config/
	ln --backup=simple -sn `pwd`/home/.config/fcitx ~/.config/
	ln --backup=simple -sn `pwd`/home/.config/plank ~/.config/
	-sudo gpasswd -a ${USER} input
	ln --backup=simple -sn `pwd`/home/.config/libinput-gestures.conf ~/.config/
	mkdir -p ~/.config/autostart
	ln --backup=simple -sn `pwd`/home/.config/autostart/Plank.desktop ~/.config/autostart/
	ln --backup=simple -sn `pwd`/home/.config/autostart/libinput-gestures.desktop ~/.config/autostart/
	mkdir -p ~/.local/share
	ln --backup=simple -sn `pwd`/home/.local/share/themes/ ~/.local/share/
	ln --backup=simple -sn `pwd`/home/.local/share/resources ~/.local/share/

