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

## Custom Dart server

If `/app/main.dart` exists, the container will run it instead of the default
`unpub -d $DB_URL` command. Because custom Dart code needs its own
dependencies, mount both `main.dart` and `pubspec.yaml` into `/app`.

Example `pubspec.yaml`:

```yaml
name: custom_unpub
environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  mongo_dart: any
  unpub: any
```

Example `main.dart`:

```dart
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:unpub/unpub.dart' as unpub;

Future<void> main(List<String> args) async {
  final db = Db(Platform.environment['DB_URL']!);
  await db.open();

  final app = unpub.App(
    metaStore: unpub.MongoStore(db),
    overrideUploaderEmail: 'custom@mail.com',
    packageStore: unpub.FileStore('./unpub-packages'),
  );

  final server = await app.serve('0.0.0.0', 4000);
  print('Serving at http://${server.address.host}:${server.port}');
}
```

Compose example:

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
      - ./custom-server:/app
    ports:
      - 4000:4000
    links:
      - mongodb
    depends_on:
      - mongodb
    environment:
      DB_URL: mongodb://mongodb:27017/dart_pub
      WAIT_HOSTS: mongodb:27017
```