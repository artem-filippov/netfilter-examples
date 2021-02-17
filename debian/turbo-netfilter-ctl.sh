#!/usr/bin/env bash

# Пример использования
usage()
{
    cat <<EOF
Usage:
    sudo ./turbo-netfilter-ctl.sh [options]

Options:"
    -h, --help                    : Shows this help
    -s, --status                  : Shows status
EOF
}

# Проверяем на sudo
if [ $USER != "root" ]; then
    echo -e "ERROR: Superuser privileges are required to run this script\n"
    usage
    exit 1
fi

# Основные функции

iptables_check()
{
    if ! command -v iptables > /dev/null 2>&1; then
        echo -e "ERROR: iptables command not found"
        exit 1
    fi
}

iptables_status()
{
    iptables_check
    iptables -L -n -v
}

# Проверки параметров командной строки

if [ $# -lt 1 ]; then
    echo -e "INFO: Need to set options\n"
    usage
    exit 1
fi

if [[ $1 = "-h" || $1 = "--help" ]]; then
    usage
    exit 1
fi

if [[ $1 = "-s" || $1 = "--status" ]]; then
    iptables_status
    exit 0
fi
