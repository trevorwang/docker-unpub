FROM dart
WORKDIR /app
RUN dart pub global activate unpub
ENV PATH="$PATH:/root/.pub-cache/bin"
EXPOSE 4000
ADD entrypoint.sh /app
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
CMD /wait && /app/entrypoint.sh