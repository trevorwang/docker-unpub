FROM google/dart
WORKDIR /app
RUN pub global activate unpub
ENV PATH="$PATH:/root/.pub-cache/bin"
EXPOSE 4000
ADD entrypoint.sh /app
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.5.1/wait /wait
RUN chmod a+x /wait
CMD /wait && /app/entrypoint.sh