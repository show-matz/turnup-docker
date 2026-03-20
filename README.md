# はじめに

　これは、turnup をセットアップした docker イメージを作成するための 
Dockerfile です。以下の外部フィルタをまとめて使えるようにしてあります。

* gnuplot
* highlight
* PlantUML
* kaavio
* Mermaid (full 版のみ）

　Mermaid を使えるようにするだけで docker image が 1GB 増えるため、
Mermaid を含まないビルドも用意しています。それ以外は同じ設定なので、
お好きな方をお使いください。

* Dockerfile.full
* Dockerfile.no-mermaid


# セットアップ
## Docker のインストール（もしまだなら）

　以下を実行して docker をインストールしてください。ここでは turnup の 
docker image を使用することだけを想定しているので、docker.io を選択して
います。

```sh
sudo apt update
sudo apt install docker.io
sudo systemctl enable --now docker
```

（お好みであれば docker-ce を選択しても良いですが、その場合は必要に応じて
自分で調べてください。）

　インストールが完了したらまずは以下を実行して docker が動作することを確認
してください。

```sh
sudo docker run hello-world
```

　続いて以下を実行し、 `sudo` 無しで `docker` コマンドを使えるようにします。

```sh
sudo usermod -aG docker $USER
```

## docker イメージのビルド

　docker build します。Mermaid が不要なら `Dockerfile.full` の代わりに 
`Dockerfile.no-mermaid` を使用した方がサイズが小さいです。

```sh
docker build -q -f Dockerfile.full -t turnup .
```

## ショートカットスクリプトの作成

　docker コマンドで実行するのは面倒なので、 `/usr/local/bin` 配下に
スクリプトを作成してショートカットしましょう。以下を実行してください。

```sh
printf \
  '#!/bin/sh\ndocker run --rm --user "$(id -u):$(id -g)" -v "$(pwd)":/work -w /work turnup "$@"\n' \
     | sudo tee /usr/local/bin/turnup \
    && sudo chmod +x /usr/local/bin/turnup
```

# ためしに使ってみる

　このディレクトリにある `test.md` を HTML 文書に変換してみましょう。
以下の要領で実行してください。

```sh
turnup ./test.md  > ./test.htm
```

