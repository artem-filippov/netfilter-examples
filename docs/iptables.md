Основные команды

Просмотр правил:
iptables -L -n -v
iptables -L -n -v -line-numbers

Сохранение правил
sudo iptables-save > iptables.backup

Восстановление настроек
sudo iptables-restore < iptables.backup

Сброс правил
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo iptables -X

Создание правил по умолчанию
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD DROP

Примеры создания правил

Разрешение установленных соединений
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

Разрешение соединений по порту (SSH)
sudo iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW --dport 22 -j ACCEPT
