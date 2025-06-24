FROM debian:stable-slim
ARG TARGETPLATFORM
WORKDIR /root
COPY build.sh /root
COPY entrypoint.sh /bin/entrypoint.sh
RUN bash build.sh $TARGETPLATFORM
RUN rm build.sh
ENTRYPOINT ["bash", "/bin/entrypoint.sh"]