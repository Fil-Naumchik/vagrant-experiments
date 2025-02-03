#!/bin/bash
#
sudo apt-get -y update

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y postgresql

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

PG_HBA_CONF=$(find /etc/postgresql -name "pg_hba.conf" | head -n 1)

# Проверяем, найден ли файл
if [[ -z "$PG_HBA_CONF" ]]; then
  echo "Файл pg_hba.conf не найден."
  exit 1
fi

echo "Найден файл pg_hba.conf: $PG_HBA_CONF"

sed -i 's/local\s*all\s*postgres\s*peer/local all postgres md5/g' "$PG_HBA_CONF"

echo "Файл $PG_HBA_CONF успешно изменен."

sudo systemctl restart postgresql

sudo apt-get install -y make

npm install -g npm@11.1.0

cd /vagrant/js-fastify-blog

make install

make dev

make build

make start &
