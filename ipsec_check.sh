## Checks the status of HYPERMAQ and HYPERMAQ-Mail VPN connections
## sets up connections that are down
## IPSec start is set to add and DPD is set to clear
## it seems like auto and reset are not reliable
##
## needs to be ran using sudo/root
## QV 2020-06-16
## QV 2021-09-30 added new tunnel names
## QV 2022-07-18 removed iplog section

STATUS=`ipsec status`

tunnels=( IKEv1 MAIL )

## Test HYPERMAQ tunnels
for tun in ${tunnels[@]}; do
 test=`echo $STATUS | grep -e "$tun{[0-9]*}:" | grep -e "INSTALLED, TUNNEL"`
 if [ ! -z "$test" ];
 then
  echo "IPSEC $tun running"
 else
  echo "IPSEC $tun not running"
  echo $STATUS
  ipsec up $tun
  ipsec status
 fi

done
