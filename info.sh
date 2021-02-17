#!/usr/bin/env bash

# Проверка Netfilter
if command -v iptables > /dev/null 2>&1; then
    iptables --version
fi