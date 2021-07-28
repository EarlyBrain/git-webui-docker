# Git WebUI for Docker

このリポジトリは[Docker](https://www.docker.com/)上で「[Git WebUI](https://github.com/alberthier/git-webui)」を動かすためのDockerイメージを作成します。  
「[Git WebUI](https://github.com/alberthier/git-webui)」は、ローカルのGitリポジトリをWebブラウザで使用できるGitクライアントです。  

- Git WebUI リポジトリ  
[https://github.com/alberthier/git-webui](https://github.com/alberthier/git-webui)

- Git WebUI 紹介サイト  
[https://www.moongift.jp/2018/04/git-webui-ローカルのgitリポジトリ用ブラウザ/](https://www.moongift.jp/2018/04/git-webui-%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E3%81%AEgit%E3%83%AA%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA%E7%94%A8%E3%83%96%E3%83%A9%E3%82%A6%E3%82%B6/)


## リポジトリ

- GitHub リポジトリ  
  - [https://github.com/EarlyBrain/git-webui-docker](https://github.com/EarlyBrain/git-webui-docker)


- Docker Hubリポジトリ  
  - [https://hub.docker.com/repository/docker/earlybrain/git-webui](https://hub.docker.com/repository/docker/earlybrain/git-webui)


## Dockerイメージの使い方


### Dockerコンテナの起動
次のコマンドを実行してください。  
なお、コンテナ起動前に、マウントするボリュームに、Gitサーバからローカルコンピューターにリポジトリのクローンしておく必要があります。

```
docker run --rm \
  -p 9000:9000 \
  -v /workspace:/workspace \
  earlybrain/git-webui:latest
```

### docker-composeのサービスとして起動
`docker-compose.yml` に以下の記述を追加し、docker-composeを起動してください。  
なお、docker-compose起動前に、マウントするボリュームに、Gitサーバからローカルコンピューターにリポジトリのクローンしておく必要があります。

```
  git-webui:
    image: earlybrain/git-webui:latest
    container_name: git-webui
    volumes:
      - /workspace:/workspace
    ports:
      - 9000:9000
    restart: always
```


## 開発環境事前準備

Git WebUI for Docker 開発用の Vagrant Box を使用するには、次のいずれかの環境が必要です。
- Intel系 CPU 64ビット Windows
- Intel系 CPU 64ビット Mac
- Intel系 CPU 64ビット Ubuntu / RedHat / CentOS / 他 Linux 全般

事前に VirtualBox と Vagrant をインストールしてください。

- [VirtualBox](https://www.virtualbox.org/):
  - [ダウンロード](https://www.virtualbox.org/wiki/Downloads) から各環境に応じたインストーラーをダウンロードし、インストーラーを実行してください。
  - インストーラー実行後は、インストーラーの指示にしたがってインストールを完了させてください。

- [Vagrant](https://www.vagrantup.com/):
  - ダウンロード から各環境に応じたインストーラーをダウンロードし、インストーラーを実行してください。
  - インストーラー実行後は、インストーラーの指示にしたがってインストールを完了させてください。


### 動作確認のとれた vagrant バージョン  
以下のバージョンの vagrant の動作確認が取れています。

| OS・バージョン  | vagrant バージョン  | Virtual Box バージョン |
|-----------------|---------------------|------------------------|
| Windows 10 21H1 | 2.2.14 [ダウンロード](https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.msi) | 6.1.18 [ダウンロード](https://download.virtualbox.org/virtualbox/6.1.18/VirtualBox-6.1.18-142142-Win.exe)    |


## 開発環境の使い方


### 開発環境の起動

次のコマンドを実行してください。開発環境が起動します。
```
vagrant up
```


### 開発ツールメニューの起動

次のコマンドを実行してください。開発を支援する「開発ツールメニュー」が起動します。
```
vagrant ssh -c "./menu.sh"
```


### 統合開発環境(Cloud9 IDE)の起動

Cloud9 IDE には [https://localhost:8000/](https://localhost:8000/) からアクセスできます。


### Gitクライアント(Git WebUI)の起動

Git WebUI には [https://localhost:8008/](https://localhost:8008/) からアクセスできます。  
※開発中の動作確認を目的としたものではなく、通常の開発に使用します。


## Dockerイメージの作成

開発を支援する「開発ツールメニュー」から開発に必要なコマンドを実行することができます。


### Dockerイメージ動作確認

Dockerコンテナを起動後、[http://localhost:9000/](http://localhost:9000/) からアクセスできます。


### Dockerイメージのタグ名ルール

Dockerイメージのタグ名は、 ```v{Git WebUIのバージョン}-{Git WebUI for Dockerのバージョン}``` とします。

たとえば、Git WebUIのバージョンが `1.5.0` かつ Git WebUI for Dockerのバージョンが `1.0.0` の場合には、 `v1.5.0-1.0.0` となります。  
最新イメージのタグ名は、 `latest` となります。


## 作成者

[株式会社アーリーブレーン](https://www.earlybrain.co.jp/)


## ライセンス

このソフトウェアは [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html) ライセンスの下で公開されています。
