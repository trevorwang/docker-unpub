# unpub docker image

* A mongodb connection must to be provided
* `/app` is the work directory

## Sample
Here's an example for your reference to config unpub
```yaml
services:
  mongodb:
    image: mongo
    ports:
      - "27017:27017"
    restart: always
  unpub:
    container_name: unpub
    image: trevorwang/unpub 
    restart: always
    volumes:
      - .:/app
    ports:
      - 4000:4000
    links:
        - mongodb
    depends_on:
        - mongodb
    environment:
      DB_URL: mongodb://mongodb:27017/pub
      WAIT_HOSTS: mongodb:27017

```