FROM debian:stable-slim
WORKDIR /root
COPY build.sh /root
COPY entrypoint.sh /bin/entrypoint.sh
RUN bash build.sh "linux/amd64"
RUN rm build.sh
ENTRYPOINT ["bash", "/bin/entrypoint.sh"]