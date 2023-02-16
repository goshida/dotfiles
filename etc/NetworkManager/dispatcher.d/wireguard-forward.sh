#!/bin/sh

PUB_IF="PUB_IF_DUMMY"
WG_IF="WG_IF_DUMMY"

interface=$1
status=$2

if [ $interface = $WG_IF ]; then
  case $status in
    up)
      nft add "rule inet filter input iifname $PUB_IF udp dport 51820 accept comment \"for wireguard\""
      nft add "rule inet filter input iifname $WG_IF accept comment \"for wireguard\""
      nft add "rule inet filter forward iifname $WG_IF accept comment \"for wireguard\""
      nft add "rule inet filter forward oifname $WG_IF accept comment \"for wireguard\""
      nft add "chain inet filter postrouting { type nat hook postrouting priority srcnat ; }"
      nft add "rule inet filter postrouting iifname $WG_IF oifname $PUB_IF masquerade comment \"for wireguard\""
      ;;
    down)
      nft --handle list chain inet filter input \
        | grep -e 'for wireguard' \
        | sed 's/.* # handle \(.*\)/\1/' \
        | xargs -I{} nft delete 'rule inet filter input handle {}'
      nft --handle list chain inet filter forward \
        | grep -e 'for wireguard' \
        | sed 's/.* # handle \(.*\)/\1/' \
        | xargs -I{} nft delete 'rule inet filter forward handle {}'
      nft delete "chain inet filter postrouting"
      ;;
  esac
fi
