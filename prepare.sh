set -eu

cd /home/ubuntu

curl -Lo replay.zip "$REPLAY" &
DOWNLOAD_PID=$!

sleep 5

yad --info --text="Replay download in progress.." --no-buttons --undecorated &
POPUP_PID=$!

wait "$DOWNLOAD_PID"

kill "$POPUP_PID"

starlight-launcher
kill 1
