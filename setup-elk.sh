#!/bin/bash

echo -e "Installing dependencies...\n\n"

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt-get update

apt install -y apt-transport-https wget default-jre
apt install -y elasticsearch logstash kibana filebeat

systemctl enable elasticsearch logstash kibana filebeat

echo -e "Dependencies installed...\n\n"
echo -e "Configuring ELK...\n\n"

# Create kibana logs directory and set user and group
if [ ! -d "/var/log/kibana" ]; then
    echo -e "Creating directory for Kibana logs\n"
    mkdir /var/log/kibana
    chown kibana:kibana /var/log/kibana
fi

# Create Geoip database directory
echo -e "Creating directory for Geoip database...\n"
mkdir -p /opt/logstash/vendor/geoip/

echo -e "Copying configuration files...\n\n"
declare -A config_files=(
  ["./elk/config/kibana.yml"]="/etc/kibana/kibana.yml"
  ["./elk/config/filebeat-cowrie.conf"]="/etc/filebeat/filebeat.yml"
  ["./elk/config/logstash-cowrie.conf"]="/etc/logstash/conf.d/logstash-cowrie.conf"
)

# Iterate over the files and their destinations
for source in "${!config_files[@]}"; do
  destination="${config_files[$source]}"

  # Check if the source file exists
  if [ ! -f "$source" ]; then
    echo -e "The source file does not exist: $source"
    continue
  fi

  # Copy the file to the destination, overwriting if it exists
  echo -e "Copying $source a $destination\n"
  cp -f "$source" "$destination"


  echo -e "File $source successfully copied to $destination\n\n"
done

echo -e "ELK Configured\n\n"
echo -e "Fixing permissions...\n\n"

chown kibana:kibana /etc/kibana/kibana.yml
chown logstash:logstash /etc/logstash/conf.d/logstash-cowrie.conf

echo -e "Permissions Fixed...\n\n"

echo -e "Restarting services...\n\n"
systemctl restart elasticsearch logstash kibana filebeat

echo "Setup Completed"


