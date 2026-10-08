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
    apt-get install -y --no-install-recommends \
        gnome-keyring libsecret-tools python3-secretstorage
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

# select_default_collection relabels the Secret Service default collection to
# name. The collection remains the default, so it is found through the
# "default" alias, but it no longer shares the provider's fallback name. This
# lets tests prove that a slot which omits its collection resolves through the
# alias rather than by a label lookup.
function select_default_collection() {
    local name="$1"
    secret_service_env python3 -c '
import secretstorage
import sys

connection = secretstorage.dbus_init()
collection = secretstorage.get_default_collection(connection)
collection.set_label(sys.argv[1])
' "$name"
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

# store_secret_in_collection stores value in a non-default collection labelled
# name, so that a slot must select it by name rather than through the "default"
# alias. It relabels the keyring's session collection, which is not the default
# collection, and creates the secret there. Attributes are supplied as
# secret-tool style pairs, for example:
#
#   store_secret_in_collection workshop-named value service workshop account demo
function store_secret_in_collection() {
    local name="$1"
    local value="$2"
    shift 2
    secret_service_env python3 -c '
import secretstorage
import sys

name = sys.argv[1]
value = sys.argv[2].encode()
args = sys.argv[3:]
attributes = dict(zip(args[::2], args[1::2]))

connection = secretstorage.dbus_init()
collections = list(secretstorage.get_all_collections(connection))
target = [c for c in collections if c.collection_path.endswith("/session")][0]
target.set_label(name)
target.create_item("Workshop secret test", attributes, value)
' "$name" "$value" "$@"
}

# stop_secret_service stops the host user's keyring daemon and discards its
# keyring.
function stop_secret_service() {
    pkill -u ubuntu gnome-keyring-daemon || true
    rm -rf /home/ubuntu/.local/share/keyrings
}
