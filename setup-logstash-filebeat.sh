#!/bin/bash

echo -e "Installing dependencies...\n\n"

apt-get update
apt install -y apt-transport-https wget default-jre
apt install -y  logstash filebeat

systemctl enable logstash filebeat

echo -e "Dependencies installed...\n\n"
echo -e "Configuring ELK...\n\n"


# Create Geoip database directory
echo -e "Creating directory for Geoip database...\n"
mkdir -p /opt/logstash/vendor/geoip/

echo -e "Copying configuration files...\n\n"
declare -A config_files=(
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

chown logstash:logstash /etc/logstash/conf.d/logstash-cowrie.conf

echo -e "Permissions Fixed...\n\n"

echo -e "Restarting services...\n\n"
systemctl restart logstash filebeat

echo "Setup Completed"


