{
  "log": {
    "level": "warn",
    "output": "box.log",
    "timestamp": true
  },
  "dns": {
    "servers": [
      {
        "tag": "dns-remote",
        "address": "udp://1.1.1.1",
        "address_resolver": "dns-direct",
        "detour": "select"
      },
      {
        "tag": "dns-direct",
        "address": "1.1.1.1",
        "address_resolver": "dns-local",
        "detour": "direct"
      },
      {
        "tag": "dns-local",
        "address": "local",
        "detour": "direct"
      },
      {
        "tag": "dns-block",
        "address": "rcode://success"
      }
    ],
    "rules": [
      {
        "domain": "cp.cloudflare.com",
        "server": "dns-remote",
        "rewrite_ttl": 3000
      }
    ],
    "final": "dns-remote",
    "independent_cache": true
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "mtu": 9000,
      "inet4_address": "172.19.0.1/28",
      "auto_route": true,
      "strict_route": true,
      "endpoint_independent_nat": true,
      "sniff": true,
      "sniff_override_destination": true
    },
    {
      "type": "mixed",
      "tag": "mixed-in",
      "listen": "127.0.0.1",
      "listen_port": 2334,
      "sniff": true,
      "sniff_override_destination": true
    },
    {
      "type": "direct",
      "tag": "dns-in",
      "listen": "127.0.0.1",
      "listen_port": 6450,
      "override_address": "1.1.1.1",
      "override_port": 53
    }
  ],
  "outbounds": [
    {
      "type": "selector",
      "tag": "select",
      "outbounds": [
        "auto",
        "IP-\u003eIran, Yotube:MisaHiro",
        "IP-\u003eMain, Yotube:MisaHiro"
      ],
      "default": "auto"
    },
    {
      "type": "urltest",
      "tag": "auto",
      "outbounds": [
        "IP-\u003eIran, Yotube:MisaHiro",
        "IP-\u003eMain, Yotube:MisaHiro"
      ],
      "url": "http://cp.cloudflare.com/",
      "interval": "10m0s"
    },
    {
      "type": "wireguard",
      "tag": "IP-\u003eIran, Yotube:MisaHiro",
      "local_address": [
        "172.16.0.2/32",
        "2606:4700:110:8c91:4063:21d0:7dd5:f218/128"
      ],
      "private_key": "CBVIIWvXdLr4PbSrnm11ZJJ300IiPudRD4R62/IxV1g=",
      "server": "185.228.236.161",
      "server_port": 2087,
      "peer_public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
      "reserved": "AAAA",
      "mtu": 1280,
      "fake_packets": "5-10"
    },
    {
      "type": "wireguard",
      "tag": "IP-\u003eMain, Yotube:MisaHiro",
      "detour": "IP-\u003eIran, Yotube:MisaHiro",
      "local_address": [
        "172.16.0.2/32",
        "2606:4700:110:8c15:3f90:ad2d:8810:77f3/128"
      ],
      "private_key": "CCC/TQTc82ub9i8f37Rpix2v425Sv/mxTzvE/iKRMkw=",
      "server": "185.228.236.161",
      "server_port": 2087,
      "peer_public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
      "reserved": "AAAA",
      "mtu": 1280,
      "fake_packets": "5-10"
    },
    {
      "type": "dns",
      "tag": "dns-out"
    },
    {
      "type": "direct",
      "tag": "direct"
    },
    {
      "type": "direct",
      "tag": "bypass"
    },
    {
      "type": "block",
      "tag": "block"
    }
  ],
  "route": {
    "geoip": {
      "path": "geo-assets/sagernet-sing-geoip-geoip.db"
    },
    "geosite": {
      "path": "geo-assets/sagernet-sing-geosite-geosite.db"
    },
    "rules": [
      {
        "inbound": "dns-in",
        "outbound": "dns-out"
      },
      {
        "port": 53,
        "outbound": "dns-out"
      },
      {
        "clash_mode": "Direct",
        "outbound": "direct"
      },
      {
        "clash_mode": "Global",
        "outbound": "select"
      }
    ],
    "auto_detect_interface": true,
    "override_android_vpn": true
  },
  "experimental": {
    "cache_file": {
      "enabled": true,
      "path": "clash.db"
    },
    "clash_api": {
      "external_controller": "127.0.0.1:6756"
    }
  }
}
