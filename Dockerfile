FROM ubuntu:latest
LABEL authors="zhangchang"

ENTRYPOINT ["top", "-b"]