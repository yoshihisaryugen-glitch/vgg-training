# vgg_training

学習済みの VGG-16 で画像を分類し、アリとハチの画像へ転移学習とファインチューニングをします。

## 前提

- Docker Desktop が起動していること

コンテナ内は CPU 版 PyTorch です。Mac 上の Docker からは GPU を使いません。

## 起動

```bash
docker compose up -d --build
```

起動後、ブラウザで次を開きます。トークンは不要です。

http://127.0.0.1:8888/lab

初回起動時に、次のファイルを `data/` へダウンロードします。すでに存在する場合はスキップします。

- `data/imagenet_class_index.json`
- `data/hymenoptera_data/`（アリとハチの画像）

VGG の学習済み重みは、ノートブックで学習済み VGG-16 を読み込んだときに取得されます。取得した重みは Docker ボリューム `torch-cache` に残り、コンテナを作り直しても再ダウンロードしません。

## 止める

```bash
docker compose down
```

`docker compose down` ではノートブックと `data/`、学習済み重みは消えません。イメージも残ります。

## ノートブック

JupyterLab で、このディレクトリにある次のファイルを開きます。

| ノートブック | 内容 |
| --- | --- |
| `1-1_load_vgg.ipynb` | 学習済み VGG-16 で画像を分類する |
| `1-3_transfer_learning.ipynb` | アリとハチの画像へ転移学習する |


`make_folders_and_data_downloads.ipynb` のダウンロード処理は、コンテナ起動時に済ませています。

## パッケージ

`1-1_load_vgg.ipynb` は `models.vgg16(pretrained=True)` のままです。`1-3_transfer_learning.ipynb` は `weights=VGG16_Weights.IMAGENET1K_V1` で読みます。`pretrained=True` は torchvision 0.13 以降で非推奨の警告が出て、0.17 で削除されたため、この環境は次のバージョンに固定しています。

- Python 3.10
- torch 2.1.2
- torchvision 0.16.2

一覧は `requirements.txt` です。

Docker を使わず手元で動かす場合は、CPU 版の PyTorch を次のように入れます。

```bash
pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cpu
jupyter lab
```

## 構成

```text
1-1_load_vgg.ipynb          学習済み VGG-16 による分類
1-3_transfer_learning.ipynb アリとハチへの転移学習
utils/                      画像分類用のデータローダー
Dockerfile                  Python 3.10 と依存パッケージ
docker-compose.yml          JupyterLab を 8888 番で公開する
docker/entrypoint.sh        データ取得のあと JupyterLab を起動する
requirements.txt            固定したパッケージ
data/                       起動時に取得する画像とクラス索引
```

カレントディレクトリはコンテナの `/workspace` にマウントされます。ノートブックの保存や `data/` への追記は、ホスト側のこのディレクトリに残ります。
