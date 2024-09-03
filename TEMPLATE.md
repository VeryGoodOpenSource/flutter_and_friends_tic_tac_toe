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
dart pub global activate globe_cli
dart pub global activate melos 
dart pub global activate dart_frog_cli
```

#### Bootstrap

Initialize your project in a new directory using the command below

```shell
mkdir tic_tac_toe
cd tic_tac_toe
globe create -t tic_tac_toe
```

```shell
cd tic_tac_toe
melos bootstrap
```

Now open the project in your favorite IDE.

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

#### Deploy Backend

```shell
cd backend
globe deploy
```

#### Deploy Frontend

> Note: The frontend needs to be able to connect to the backend.
> The easiest way to do this is to deploy the backend first, and then
> deploy the frontend with the backend used URL in your Flutter code
> instead of using `localhost:8080`.

```shell
cd frontend
globe deploy
```
