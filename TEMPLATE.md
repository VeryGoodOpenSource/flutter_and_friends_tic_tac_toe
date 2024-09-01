---
name: Tic Tac Toe with Flutter and Dart Frog
description: Building a Flutter Tic Tac Toe Game with a Dart Frog Backend
tags: ["dart-frog", "games", "flutter", "dart"]
username: VeryGoodOpenSource
---

# Tic Tac Toe with Flutter and Dart Frog Workshop

## Overview

Create a Tic Tac Toe game with Flutter and Dart Frog.

### Getting Started

#### Install Globe

Install Globe, Melos and Dart Frog CLIs using the command below

```shell
dart pub global activate globe_cli melos dart_frog_cli
```

#### Bootstrap

Initialize your project in a new directory using the command below

```shell
mkdir flutter_sudoku
cd flutter_sudoku
globe create -t flutter_ttt
```

#### Start Dart Server

```shell
melos backend
# or `dart_frog dev ..` in the backend directory
```

#### Start Flutter Project

```shell
melos frontend
# or `flutter run ..` in the frontend directory
```

### Deployment

TODO: Deploy backend first, then deploy frontend, frontend will need to be able to connect to backend by reading a flutter build arg.