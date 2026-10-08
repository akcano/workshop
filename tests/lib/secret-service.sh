#!/bin/bash

# Helpers for spread tests that retrieve secrets from a host Secret Service.
# They are not part of utils.sh so that tests opt in explicitly with:
#
#   . "$TESTSLIB"/secret-service.sh
#
# The daemon resolves system secret slots by running workshop-ss-tool as the
# host user, which connects to that user's session bus at
# /run/user/<uid>/bus. These helpers stand up a GNOME keyring on that bus.

# install_secret_service installs the packages required to run a host Secret
# Service on the user's session bus.
function install_secret_service() {
    apt-get install -y --no-install-recommends gnome-keyring libsecret-tools
}

# secret_service_env runs a command as the host user with the session bus
# environment the daemon's secret helper expects.
function secret_service_env() {
    local uid
    uid="$(id -u ubuntu)"
    sudo -u ubuntu -- env \
        HOME=/home/ubuntu \
        XDG_RUNTIME_DIR="/run/user/${uid}" \
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${uid}/bus" \
        "$@"
}

# start_secret_service starts and unlocks a GNOME keyring on the host user's
# session bus. Any previous keyring is discarded so tests start clean.
function start_secret_service() {
    local uid
    uid="$(id -u ubuntu)"

    pkill -u ubuntu gnome-keyring-daemon || true
    rm -rf /home/ubuntu/.local/share/keyrings

    # The session bus is provided by the host user's lingering user manager.
    systemctl start "user@${uid}.service"
    for _ in $(seq 1 30); do
        [ -S "/run/user/${uid}/bus" ] && break
        sleep 1
    done
    if [ ! -S "/run/user/${uid}/bus" ]; then
        echo "session bus for uid ${uid} did not appear" >&2
        return 1
    fi

    # Unlock a fresh login keyring with a known password. The daemon
    # registers as org.freedesktop.secrets on the session bus and persists.
    printf '%s\n' workshop |
        secret_service_env gnome-keyring-daemon --unlock --components=secrets
}

# store_secret stores value in the host user's keyring using the supplied
# secret-tool attribute pairs, for example:
#
#   store_secret value service workshop account demo
function store_secret() {
    local value="$1"
    shift
    printf '%s' "$value" | secret_service_env \
        secret-tool store --label="Workshop secret test" "$@"
}

# stop_secret_service stops the host user's keyring daemon and discards its
# keyring.
function stop_secret_service() {
    pkill -u ubuntu gnome-keyring-daemon || true
    rm -rf /home/ubuntu/.local/share/keyrings
}
