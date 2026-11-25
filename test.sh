#!/usr/bin/env bash
set -euo pipefail

IMAGE="deltav-selkies"

docker build -t "$IMAGE" .

exec docker run --rm --init -it \
  --name "$IMAGE" \
  --runtime=nvidia \
  --gpus 1 \
  --shm-size="1G" \
  -p 8080:8080 \
  -e PASSWD=changeme \
  -e REPLAY=https://deltav.gay/replays/periapsis/periapsis-2026_11_20-21_42-round_30662.zip \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  "$IMAGE"
