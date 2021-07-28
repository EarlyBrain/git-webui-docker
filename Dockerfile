FROM python:3.9.6-alpine3.14

MAINTAINER Early Brain co., Ltd.

RUN apk add git
RUN git clone https://github.com/alberthier/git-webui.git -b v1.5.0
RUN git config --global alias.webui \!$PWD/git-webui/release/libexec/git-core/git-webui

VOLUME ["/workspace"]

WORKDIR /workspace

EXPOSE 9000

CMD ["git", "webui", "--port", "9000"]
