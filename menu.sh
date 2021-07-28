#!/bin/bash

# パラメータ設定
PRJ_HOME=/var/code
AUTHOR="Early Brain Co., Ltd."
ACCOUNT_NAME="earlybrain"
CONTAINER_NAME="git-webui"
TAG_NAME="v1.5.0-1.0.0"
COMMIT_MESSAGE="alberthier/git-webui v1.5.0 image"

# メニューの表示
print_menu () {
  echo -e "\e[33m"
  cat <<-'EOS'


			■■■■■　Docker Image 開発ツールメニュー　■■■■■

	EOS
  echo -e "\e[32m"
  cat <<-'EOS'
			 0) bashの実行
			 1) Dockerイメージの作成
			 2) Dockerコンテナの起動
			 3) Dockerイメージのコミット
			 4) Dockerイメージのアップロード
			 5) Dockerイメージの削除
			 6) Dockerイメージの作成 ～ アップロード
			 7) 開発環境SSL証明書再発行
			 q) 開発メニューの終了
	EOS
  echo -e "\e[m"
}

# Dockerイメージの作成
build() {
  echo "Dockerイメージを作成します..."
  docker build -t ${ACCOUNT_NAME}/${CONTAINER_NAME}:latest .
}

# Dockerコンテナの起動
run() {
  echo "Dockerコンテナを起動します..."
  docker run -p 9000:9000 -v ${PRJ_HOME}:/workspace --name "${CONTAINER_NAME}" -d --rm ${ACCOUNT_NAME}/${CONTAINER_NAME}:latest
  echo ""
  echo ""
  echo -e "\e[36m"
  echo "以下のURLをブラウザで参照してください."
  echo "  http://localhost:9000/"
  echo -e "\e[m"
  echo ""
  echo ""
  read -p "[Enter] キーを押すと停止します."
  docker commit -a "${AUTHOR}" -m "${COMMIT_MESSAGE}" `docker ps -a | grep "${ACCOUNT_NAME}/${CONTAINER_NAME}:latest" | awk '{print $1}'` ${ACCOUNT_NAME}/${CONTAINER_NAME}:latest
  docker stop ${CONTAINER_NAME}
}

# Dockerイメージのコミット
commit() {
  echo "Dockerイメージをコミットします..."
  docker run -p 9000:9000 -v ${PRJ_HOME}:/workspace --name "${CONTAINER_NAME}" -d --rm ${ACCOUNT_NAME}/${CONTAINER_NAME}:latest
  docker commit -a "${AUTHOR}" -m "${COMMIT_MESSAGE}" `docker ps -a | grep "${ACCOUNT_NAME}/${CONTAINER_NAME}:latest" | awk '{print $1}'` ${ACCOUNT_NAME}/${CONTAINER_NAME}:latest
  docker stop ${CONTAINER_NAME}
}

# Dockerイメージのアップロード
push() {
  echo "Dockerイメージをアップロードします..."
  docker tag ${ACCOUNT_NAME}/${CONTAINER_NAME}:latest ${ACCOUNT_NAME}/${CONTAINER_NAME}:${TAG_NAME}
  echo -e "\e[32m"
  sudo docker login -u ${ACCOUNT_NAME}
  echo -e "\e[m"
  sudo docker push ${ACCOUNT_NAME}/${CONTAINER_NAME}:${TAG_NAME}
  sudo docker push ${ACCOUNT_NAME}/${CONTAINER_NAME}:latest
  sudo docker pushrm ${ACCOUNT_NAME}/${CONTAINER_NAME}
}

# Dockerイメージの削除
rm() {
  echo "Dockerイメージを削除します..."
  docker rmi -f `docker images | grep "${ACCOUNT_NAME}/${CONTAINER_NAME}" | grep "latest" | awk '{print $3}'`
}

# 開発環境SSL証明書再発行
update_cert() {
  echo "開発環境SSL証明書を再発行します..."
  pushd etc/nginx/ssl
  export CAROOT=/var/code/etc/nginx/ssl
  ./mkcert -install
  ./mkcert -key-file /var/code/etc/nginx/ssl/server.key -cert-file /var/code/etc/nginx/ssl/server.crt localhost 127.0.0.1
  sudo cp -p /var/code/etc/nginx/ssl/server.key /etc/nginx/ssl/server.key
  sudo cp -p /var/code/etc/nginx/ssl/server.crt /etc/nginx/ssl/server.crt
  sudo /usr/local/bin/docker-compose restart nginx
  popd
}

# メイン
function main () {
  while :
  do
    cd $PRJ_HOME
    print_menu
    read -p "実行するメニュー番号を入力してください: " key
    echo ""
    echo ""
    case "$key" in
      0) # bashの実行
        bash
        ;;
      1) # Dockerイメージの作成
        build
        ;;
      2) # Dockerコンテナの起動
        run
        ;;
      3) # Dockerイメージのコミット
        commit
        ;;
      4) # Dockerイメージのアップロード
        push
        ;;
      5) # Dockerイメージの削除
        rm
        ;;
      6) # Dockerイメージの作成 ～ アップロード
        build
        commit
        push
        ;;
      7) # 開発環境SSL証明書再発行
        update_cert
        ;;
      [qQ]) # 開発メニューの終了
        echo ""
        echo "開発メニューを終了します。"
        echo ""
        break ;;
    esac
  done
}

main
exit 0
