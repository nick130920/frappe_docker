#!/bin/bash
# Resuelve host:puerto a IPv4 (evita IPv6 roto en red privada Railway).
resolve_host_port() {
  local spec="$1"
  local host="${spec%%:*}"
  local port="${spec##*:}"
  [ "$host" = "$port" ] && port=""

  if [[ "$host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "$spec"
    return 0
  fi

  local ip
  ip="$(getent ahostsv4 "$host" 2>/dev/null | awk '{print $1; exit}')"
  if [ -n "$ip" ]; then
    if [ -n "$port" ]; then
      echo "${ip}:${port}"
    else
      echo "$ip"
    fi
    return 0
  fi

  echo "$spec"
}
