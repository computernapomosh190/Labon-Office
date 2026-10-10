# 2026-10-09 15:08:56 by RouterOS 7.21.5
# system id = 1Zfpiru0AUP
#
/interface bridge
add name=bridge-local vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
set [ find default-name=ether9 ] disable-running-check=no
set [ find default-name=ether10 ] disable-running-check=no
set [ find default-name=ether11 ] disable-running-check=no
set [ find default-name=ether12 ] disable-running-check=no
set [ find default-name=ether13 ] disable-running-check=no
set [ find default-name=ether14 ] disable-running-check=no
set [ find default-name=ether15 ] disable-running-check=no
set [ find default-name=ether16 ] disable-running-check=no
set [ find default-name=ether17 ] disable-running-check=no
set [ find default-name=ether18 ] disable-running-check=no
set [ find default-name=ether19 ] disable-running-check=no
set [ find default-name=ether20 ] disable-running-check=no
set [ find default-name=ether21 ] disable-running-check=no
set [ find default-name=ether22 ] disable-running-check=no
set [ find default-name=ether23 ] disable-running-check=no
set [ find default-name=ether24 ] disable-running-check=no
/interface wireguard
add listen-port=59893 mtu=1420 name=wg1
/interface vlan
add interface=bridge-local name=vlan10 vlan-id=10
add interface=bridge-local name=vlan30 vlan-id=30
/ip pool
add name=vlan30 ranges=192.168.30.2-192.168.30.30
/ip dhcp-server
add address-pool=vlan30 interface=vlan30 lease-time=1d name=dhcp-vlan30
/queue simple
add disabled=yes max-limit=10k/10k name="pc1 target" target=192.168.10.2/32
/routing table
add disabled=no fib name=to_vlan10
add disabled=no fib name=to_vlan30
add disabled=no fib name=to_Wi-FI
/interface bridge port
add bridge=bridge-local interface=ether2 pvid=10
add bridge=bridge-local interface=ether3 pvid=10
add bridge=bridge-local interface=ether4 pvid=10
add bridge=bridge-local interface=ether5 pvid=10
add bridge=bridge-local interface=ether6 pvid=10
add bridge=bridge-local interface=ether7 pvid=10
add bridge=bridge-local interface=ether8 pvid=10
add bridge=bridge-local interface=ether9 pvid=30
add bridge=bridge-local interface=ether10 pvid=30
add bridge=bridge-local interface=ether11 pvid=30
add bridge=bridge-local interface=ether12 pvid=30
add bridge=bridge-local interface=ether13 pvid=30
/interface bridge vlan
add bridge=bridge-local untagged=ether3,ether2,ether4,ether5,ether6,ether7,ether8 vlan-ids=10
add bridge=bridge-local untagged=ether9,ether10,ether11,ether12,ether13 vlan-ids=30
/interface wireguard peers
add allowed-address=10.0.20.10/32 client-allowed-address=::/0 interface=wg1 name=peer6 public-key=\
    "tnXO3OVsK+IVcz4pn3lYIotn2+RPhqg9Bl5/FZuIxgA="
/ip address
add address=192.168.10.1 interface=ether1 network=192.168.10.1
add address=192.168.10.1/24 interface=vlan10 network=192.168.10.0
add address=192.168.30.1/24 interface=vlan30 network=192.168.30.0
add address=10.0.20.1/24 interface=wg1 network=10.0.20.0
/ip dhcp-client
add interface=ether1
add interface=vlan30
/ip dhcp-server lease
add address=192.168.30.29 client-id=1:0:50:79:66:68:28 mac-address=00:50:79:66:68:28 server=dhcp-vlan30
/ip dhcp-server network
add address=192.168.30.0/24 dns-server=8.8.8.8 gateway=192.168.30.1 netmask=24
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,1.1.1.1
/ip dns static
add address=192.168.10.3 name=labon.storage type=A
add address=192.168.10.5 name=cctv.storage type=A
/ip firewall address-list
add address=192.168.30.29 comment="PC CTO" list=Allow-Winbox
add address=192.168.10.0/24 list=vlan10
/ip firewall filter
add action=accept chain=forward comment="Allow Printing to second OpenWrt" dst-address=192.168.10.251 \
    dst-port=9100 protocol=tcp
add action=accept chain=forward dst-address=192.168.10.250
add action=accept chain=forward out-interface=ether1 src-address=192.148.40.0/22
add action=fasttrack-connection chain=forward
add action=drop chain=input comment="Drop Invalid packets" connection-state=invalid
add action=accept chain=input comment="Allow ICMP with limit" limit=5,5:packet protocol=icmp \
    src-address-list=!Allow-Winbox
add action=reject chain=input comment="Allow WinBox ONLY for CTO" connection-state=new dst-address-list=\
    !Allow-Winbox dst-port=8291 protocol=tcp reject-with=tcp-reset
add action=accept chain=forward comment="Accept established, related" connection-state=established,related
add action=drop chain=forward comment="Block VLAN 10 -> VLAN 30" in-interface=vlan10 out-interface=vlan30 \
    out-interface-list=all
add action=drop chain=forward comment="Block VLAN 30 -> VLAN 10" in-interface=vlan30 out-interface=vlan10
add action=accept chain=forward comment="Allow Outgoing traffic to WAN" out-interface=ether1
add action=drop chain=forward comment="DROP EVERYTHING ELSE FORWARD" disabled=yes
add action=accept chain=forward comment="Allow CCTV Web and Stream Access" dst-address=192.168.10.5 \
    dst-port=8080,8081 protocol=tcp
add action=accept chain=forward dst-address=192.168.10.7
add action=accept chain=forward comment="Allow SIP to MikoPBX" dst-address=192.168.10.7 dst-port=5060 \
    protocol=udp
add action=accept chain=forward comment="Allow RTP Voice to MikoPBX" dst-address=192.168.10.7 dst-port=\
    10000-20000 protocol=udp
add action=accept chain=forward comment="Forward SNMP" port=161 protocol=udp src-address-list=observed
add action=accept chain=forward comment="allow related connections" connection-state=related
add action=accept chain=forward comment="allow already established connections" connection-state=\
    established
/ip firewall nat
add action=masquerade chain=srcnat comment=Internet out-interface=ether1
add action=masquerade chain=srcnat disabled=yes out-interface=!bridge-local
add action=dst-nat chain=dstnat comment="CCTV Server" dst-address=192.168.152.129 dst-port=8441 protocol=\
    tcp to-addresses=192.168.10.5 to-ports=8200
add action=dst-nat chain=dstnat comment="Login to interface IP Telephonia" dst-address=192.168.152.129 \
    dst-port=8443 protocol=tcp to-addresses=192.168.10.7 to-ports=443
add action=dst-nat chain=dstnat comment="Login to interface OpenWrt" dst-address=192.168.152.129 dst-port=\
    8442 protocol=tcp to-addresses=192.168.10.250 to-ports=443
add action=dst-nat chain=dstnat comment="  EspoCRM" dst-address=192.168.152.129 dst-port=8444 protocol=tcp \
    to-addresses=192.168.10.2 to-ports=8081
add action=dst-nat chain=dstnat comment=WordPress dst-address=192.168.152.129 dst-port=8447 protocol=tcp \
    to-addresses=192.168.10.2 to-ports=8082
add action=accept chain=input comment=WireGuard dst-port=59853 in-interface=ether1 protocol=udp
/ip firewall raw
add action=drop chain=prerouting dst-address-list="" dst-port=53 protocol=tcp src-address=!192.168.10.0/24
add action=drop chain=prerouting dst-address-list="" dst-port=53 protocol=udp src-address=!192.168.10.0/24
/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=192.168.10.250 routing-table=to_Wi-FI scope=30 \
    target-scope=10
add disabled=no dst-address=192.168.40.0/22 gateway=192.168.10.250 routing-table=main
/radius
add address=192.168.10.4 service=ppp
/system clock
set time-zone-name=Europe/Kyiv
/user aaa
set use-radius=yes
