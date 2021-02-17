#!/usr/bin/env bash

WORK_FILE="rules"
WORK_DIR="/usr/local/etc/turbo-netfilter-ctl"

# Пример использования
usage()
{
    cat <<EOF
Usage:
    sudo ./turbo-netfilter-ctl.sh [options]

Options:"
    -h, --help                    : Shows this help
    -s, --status                  : Shows status
    -S, --save                    : Save rules to file
    -R, --restore                 : Restore rules from file
    -D, --delete                  : Delete rules 
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

    if ! command -v iptables-save > /dev/null 2>&1; then
        echo -e "ERROR: iptables-save command not found"
        exit 1
    fi

    if ! command -v iptables-restore > /dev/null 2>&1; then
        echo -e "ERROR: iptables-restore command not found"
        exit 1
    fi
}

iptables_status()
{
    iptables_check

    echo -e "INFO: iptables version:"
    iptables --version

    echo -e "INFO: iptables rules:"
    iptables -L -n -v --line-numbers
}

iptables_save()
{
    iptables_check
    
    # Проверяем каталог
    if [ ! -e "$WORK_DIR" ]; then
        mkdir $WORK_DIR
    fi

    echo -n "INFO: Save rules... "
    iptables-save > $WORK_DIR/$WORK_FILE
    echo "done"
}

iptables_restore()
{
    iptables_check
    
    # Проверяем файл с правилами
    if [ ! -e "$WORK_DIR/$WORK_FILE" ]; then
        echo -e "ERROR: File not found"
        exit 1
    fi

    echo -e "INFO: Restore rules... "
    iptables-restore < $WORK_DIR/$WORK_FILE
    echo "done"
}

iptables_delete()
{
    iptables_check

    echo -n "INFO: Delete rules... "
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -F
    iptables -X
    echo "done"
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
fi

if [[ $1 = "-S" || $1 = "--save" ]]; then
    iptables_save
fi

if [[ $1 = "-R" || $1 = "--restore" ]]; then
    iptables_restore
fi

if [[ $1 = "-D" || $1 = "--delete" ]]; then
    iptables_delete
fi
