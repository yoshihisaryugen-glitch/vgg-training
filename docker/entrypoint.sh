#!/bin/bash
set -euo pipefail

python - <<'PY'
import os
import urllib.request
import zipfile

data_dir = "/workspace/data"
os.makedirs(data_dir, exist_ok=True)

index_path = os.path.join(data_dir, "imagenet_class_index.json")
if not os.path.exists(index_path):
    url = "https://s3.amazonaws.com/deep-learning-models/image-models/imagenet_class_index.json"
    print("Downloading", url)
    urllib.request.urlretrieve(url, index_path)

hymenoptera_dir = os.path.join(data_dir, "hymenoptera_data")
if not os.path.isdir(hymenoptera_dir):
    url = "https://download.pytorch.org/tutorial/hymenoptera_data.zip"
    zip_path = os.path.join(data_dir, "hymenoptera_data.zip")
    print("Downloading", url)
    urllib.request.urlretrieve(url, zip_path)
    with zipfile.ZipFile(zip_path) as archive:
        archive.extractall(data_dir)
    os.remove(zip_path)
PY

if [ "$#" -gt 0 ]; then
  exec "$@"
fi

exec jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root \
  --IdentityProvider.token="" \
  --ServerApp.password="" \
  --ServerApp.allow_origin="*" \
  --ServerApp.root_dir=/workspace \
  --LabApp.extension_manager=readonly
