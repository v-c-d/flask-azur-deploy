#!/usr/bin/env bash

# packages needed to install and compile uwsgi
sudo apt-get update
sudo apt-get install -y python3-venv
sudo apt-get install -y gcc build-essential python3-dev libpcre3 libpcre3-dev

# python env working directory
sudo -i -u eltov bash << EOF
rm -rf ~/StatsApp
mkdir -p ~/StatsApp
cd ~/StatsApp
python3 -m venv env
source env/bin/activate
pip install wheel
pip install uwsgi flask
deactivate
cd
EOF

# activate uwsgi service
sudo tee -a /etc/systemd/system/statsapp.service > /dev/null << EOF
[Unit]
Description=uWSGI instance to serve StatsApp
After=network.target

[Service]
User=eltov
Group=www-data
WorkingDirectory=/home/eltov/StatsApp
Environment="PATH=/home/eltov/StatsApp/env/bin"
ExecStart=/home/eltov/StatsApp/env/bin/uwsgi --ini uwsgi.ini

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start statsapp
sudo systemctl enable statsapp
