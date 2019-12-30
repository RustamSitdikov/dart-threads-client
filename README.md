# dart-threads-client

[![Made by Textile](https://img.shields.io/badge/made%20by-Textile-informational.svg?style=popout-square)](https://textile.io)
[![Chat on Slack](https://img.shields.io/badge/slack-slack.textile.io-informational.svg?style=popout-square)](https://slack.textile.io)
[![GitHub license](https://img.shields.io/github/license/textileio/dart-threads-client.svg?style=popout-square)](./LICENSE)
[![Dart CI](https://github.com/textileio/dart-threads-client/workflows/Dart%20CI/badge.svg?branch=master)](https://github.com/textileio/dart-threads-client/actions?query=workflow%3A%22Dart+CI%22)
[![Pub](https://img.shields.io/pub/v/threads_client.svg)](https://pub.dartlang.org/packages/threads_client)

> Textile's Dart client for interacting with remote Threads

Join us on our [public Slack channel](https://slack.textile.io/) for news, discussions, and status updates. [Check out our blog](https://medium.com/textileio) for the latest posts and announcements.

## Table of Contents

-   [Getting Started](#getting_started)
-   [Development](#development)
-   [Contributing](#contributing)
-   [Changelog](#changelog)
-   [License](#license)

## Getting Started

In the `pubspec.yaml` of your project, add the following dependency:

_See latest version in badge at top of README._

```
dependencies:
  ...
  threads_client: "^0.x.x"
```

### Run Threads Daemon

You need to run a threads daemon available to the client.

```sh
git clone git@github.com:textileio/go-threads.git
cd go-threads
go run threadsd/main.go -debug
```

### Usage

You can see complete usage examples in the provided test suite:

[https://github.com/textileio/dart-threads-client/blob/master/test/threads_client.dart#L41](https://github.com/textileio/dart-threads-client/blob/master/test/threads_client.dart)

## Development

### Install

Run the daemon, as above. Next, install and run the Dart `threads_client`:

```sh
git clone git@github.com:textileio/dart-threads-client.git
cd dart-threads-client
pub get
```

### Run tests

```sh
dart test/threads_client_test.dart
```

### Run example

```sh
dart examples/helloworld.dart
```

### Organization

**`examples/helloworld.dart`**

This shows a simple use of the dart client.

**`lib/src/generated/`**

Contains all the protobufs generated by `protoc`. See updating instructions below.

**`lib/src/client.dart`**

This contains the client which wraps the gRPC API. Here, dart-native helper APIs could wrap each client endpoint to give the app a nice way to use the typed requests and responses. 

### Update protobufs

`dart-threads` depends on protobufs built in [go-threads](https://github.com/textileio/go-threads). Until CI is setup, you can manually generate and update the protobufs in this project.

```sh
git clone git@github.com:textileio/go-threads.git
cd api/pb
make clean
make all
ls
```

The result should include,

```sh
api.pb.dart
api.pbenum.dart
api.pbgrpc.dart
api.pbjson.dart
```

Copy those files into, `dart-threads-client/lib/src/generated/`.

## Contributing

This project is a work in progress. As such, there's a few things you can do right now to help out:

-   **Ask questions**! We'll try to help. Be sure to drop a note (on the above issue) if there is anything you'd like to work on and we'll update the issue to let others know. Also [get in touch](https://slack.textile.io) on Slack.
-   **Open issues**, [file issues](https://github.com/textileio/dart-threads-client/issues), submit pull requests!
-   **Perform code reviews**. More eyes will help a) speed the project along b) ensure quality and c) reduce possible future bugs.
-   **Take a look at the code**. Contributions here that would be most helpful are **top-level comments** about how it should look based on your understanding. Again, the more eyes the better.
-   **Add tests**. There can never be enough tests.

Before you get started, be sure to read our [contributors guide](./CONTRIBUTING.md) and our [contributor covenant code of conduct](./CODE_OF_CONDUCT.md).

## Changelog

[Changelog is published to Releases.](https://github.com/textileio/js-threads-client/releases)

## License

[MIT](LICENSE)
