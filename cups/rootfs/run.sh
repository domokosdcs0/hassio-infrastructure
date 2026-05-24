#!/usr/bin/with-contenv bashio

bashio::log.info "Cleaning up old Avahi and CUPS PIDs..."
rm -rf /var/run/avahi-daemon/*
rm -f /var/run/cups/cupsd.pid

if ! pidof avahi-daemon > /dev/null; then
  bashio::log.info "Starting Avahi daemon..."
  avahi-daemon --daemonize --no-chroot
fi

bashio::log.info "Waiting for Avahi socket..."
until [ -e /var/run/avahi-daemon/socket ]; do
  sleep 1s
done

bashio::log.info "Starting CUPS server..."
exec cupsd -f
