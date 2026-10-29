# Random User App

Portfolio project by [Lorhany Moraes](https://github.com/lorhanymoraes), a mid-level Flutter developer.

Random User App loads one profile at a time from the [Random User API](https://randomuser.me/api/), shows the person's photo, name, and email, and opens a details screen with the rest of the profile. Profiles can be kept on the device with `shared_preferences`. The home screen asks for a new person every 5 seconds. On-screen copy is in Portuguese. The Material title is **Random Users** (`random_user_app`, version `1.0.0+1`). The iOS display name is **Random User App**.

## Features

- **Splash.** `SplashPage` plays `assets/animations/loading_card.json` with Lottie, shows a linear progress indicator, waits 4 seconds, then navigates to `/home`.
- **Rotating profile.** `HomeBloc` starts a `Timer.periodic` of 5 seconds when the bloc is created (`StartTicker`). Each tick runs `FetchUser`. The home screen shows the loaded user's large photo, full name, and email. Tapping the profile opens details with that `User` as the route argument.
- **Profile details.** `DetailsPage` renders `User.groupedDetails()` in expansion cards: basic information (open by default), ID, dates, location, and nationality. Dates are formatted with `intl` as `dd/MM/yyyy HH:mm`. Empty, null, or the string `null` is shown as `S/N`.
- **Save and remove.** The details screen checks local storage (match on email) and offers **Salvar nos persistidos** or **Remover dos persistidos**. Success and failure messages use a `SnackBar`.
- **Persisted list.** The home app bar opens `/persisted`. The list shows photo, name, and email. Deleting asks for confirmation, shows a progress indicator for 2 seconds, then removes the user. An empty list shows `Nenhum usuário persistido.` Opening a row pushes `/details` and reloads the list on return.
- **Automatic local save.** After a successful parse, the repository calls `saveUser`. A user whose `idValue` is already stored is left as-is.
- **Accessible labels.** `Semantics` labels cover the home avatar, the details avatar, the back button, the persisted-users button, and each persisted row.

## Tech stack

Packages declared in `pubspec.yaml`:

| Package | Constraint | Role in this project |
| --- | --- | --- |
| Flutter / Dart | Dart SDK `^3.8.1` | UI, `MaterialApp.router`. `.metadata` tracks the stable channel. |
| `flutter_bloc` | `^9.1.1` | `HomeBloc`, `DetailsBloc`, `PersistedBloc` |
| `flutter_modular` | `^6.4.1` | `AppModule` bindings and routes |
| `http` | `^1.5.0` | `GET https://randomuser.me/api/` |
| `dartz` | `^0.10.1` | `Either<UserErrors, User>` and `Either<UserErrors, Unit>` |
| `shared_preferences` | `^2.5.3` | JSON string list of saved users |
| `flutter_dotenv` | `^6.0.0` | Storage-key config from env files |
| `cached_network_image` | `^3.4.1` | `UserAvatar`, with a person icon if the image fails |
| `lottie` | `^3.3.1` | Splash animation |
| `intl` | `^0.20.2` | `formatIsoDateTime` |
| `mocktail` | `^1.0.4` | Repository unit tests |
| `flutter_test` | SDK | Unit tests |
| `flutter_lints` | `^5.0.0` | `analysis_options.yaml` |

Checked-in runners are `android/` (label `random_user_app`) and `ios/`. `.metadata` also records linux, macos, web, and windows as Flutter project platforms; those directories are not in the tree.

## Architecture

The code is split into view, view model (BLoC), domain, and a SharedPreferences service. One `AppModule` wires them together. `GetRandomUserUsecase` returns `Either<UserErrors, User>`. `saveUser` and `removeUser` return `Either<UserErrors, Unit>`. Error types live in `lib/domain/errors/`.

```text
View  →  Bloc  →  GetRandomUserUsecase  →  GetRandomUserRepository
                                              ├─ GetRandomUserDatasource  →  randomuser.me
                                              └─ SharedPreferencesService
```

**View** (`lib/view`). `SplashPage`, `HomePage`, `DetailsPage`, and `PersistedPage`, plus `app_bar.dart` and `user_avatar.dart`. Pages send bloc events and render bloc states. Navigation goes through `Modular.to`.

**View models** (`lib/view_model`).

- `HomeBloc` states: `UserInitial`, `UserLoaded`, `UserError`. Events: `FetchUser`, `StartTicker`, `StopTicker`. `FetchUser` calls `Modular.get<GetRandomUserUsecase>()`.
- `DetailsBloc` states: `DetailsInitial`, `DetailsLoading`, `DetailsLoaded`, `DetailsSuccess`, `DetailsError`. Events: `CheckPersistedStatus`, `TogglePersistedUser`. The page constructs this bloc with the `SharedPreferencesService` from Modular.
- `PersistedBloc` states: `PersistedInitial`, `PersistedLoading`, `PersistedLoaded` (users, optional user being deleted, optional action message), `PersistedError`. Events: `LoadPersistedUsers`, `RemovePersistedUser`. The page constructs this bloc the same way.

`AppModule` also registers all three blocs as lazy singletons. `HomeBloc` is the one the home page resolves from Modular, and its registration dispatches `StartTicker` on creation. The timer is cancelled in `close` and when `StopTicker` runs.

**Domain.**

- `User` (`lib/domain/models/user_model.dart`) maps a Random User `results` object: name, gender, email, phone, cell, large picture, id, date of birth, registration, street, city, state, country, postcode, coordinates, timezone, and nationality. `groupedDetails()` is the map the details screen renders.
- `GetRandomUserUsecase` delegates to `GetRandomUserRepository.fetchRandomUser`.
- `GetRandomUserDatasourceImpl` performs the HTTP GET. It catches `SocketException` and throws `UserErrorApiConnection`. Any other thrown error becomes `UserErrorGeneric`.
- `GetRandomUserRepositoryImpl` requires HTTP 200, a non-empty body, and a non-empty `results` list, then builds `User` from the first item. Other outcomes are `UserErrorInvalidResponse`, `UserErrorEmptyResponse`, or `UserErrorParseJson` (also used for `FormatException`). `UserErrorGeneric` is returned as-is. After a successful parse it calls `saveUser`. If the data source throws `SocketException`, the repository returns the last persisted user, `UserErrorCacheEmpty` when that list is empty, or `UserErrorCacheFailure` when the read throws. `GetRandomUserDatasourceImpl` does not throw `SocketException` (it maps that case to `UserErrorApiConnection`). The repository unit tests cover the `SocketException` branch by throwing it from a mock data source.

**Composition.** `main.dart` calls `WidgetsFlutterBinding.ensureInitialized`, loads dotenv, then `runApp(ModularApp(module: AppModule(), child: AppWidget()))`. `AppWidget` is a `MaterialApp.router` with `ThemeData(primarySwatch: Colors.blue)` and Modular's route information parser and router delegate.

Routes registered in `AppModule`:

| Path | Page |
| --- | --- |
| `/` | `SplashPage` |
| `/home` | `HomePage` |
| `/details` | `DetailsPage` |
| `/persisted` | `PersistedPage` |

The home app bar (`#6930c3`, 100px tall, 20px bottom radius) shows the persisted-users action. Other screens show a back button that calls `Modular.to.pop()`.

## Project structure

```text
lib/
  main.dart                 # dotenv load, ModularApp
  app_module.dart           # lazy singletons and routes
  app_widget.dart           # MaterialApp.router
  domain/
    errors/                 # UserErrors
    models/user_model.dart
    usecases/get_random_user_usecase.dart
    utils/utils.dart        # ISO date formatting
    external/datasources/   # Random User HTTP client
    infra/repositories/     # fetch, validate, save, cache branch
  services/shared_preferences/
  view/
    components/             # app bar, avatar
    splash/ home/ details/ persisted/
  view_model/
    home_bloc/ details_bloc/ persisted_bloc/
assets/
  .env.development
  .env.production
  animations/loading_card.json
test/
  domain/external/datasources/get_random_user_datasource_impl_test.dart
  domain/infra/repositories/get_random_user_repository_impl_test.dart
android/                    # Android runner
ios/                        # iOS runner
```

## Getting started

### Prerequisites

- Flutter on the stable channel, with a Dart SDK that satisfies `^3.8.1` (`pubspec.yaml`)
- A target device or emulator for the Android or iOS runner in this repo

### Environment files (`flutter_dotenv`)

`lib/main.dart` loads one asset before `runApp`:

| Build | File |
| --- | --- |
| `kReleaseMode` is false (debug and profile) | `assets/.env.development` |
| `kReleaseMode` is true | `assets/.env.production` |

Both paths are listed under `flutter: assets:` in `pubspec.yaml`, so they are bundled with the app.

`SharedPreferencesServiceImpl` reads a single key, `PERSISTED_ACCOUNTS_KEY`. That value is the SharedPreferences name for the saved-user list. If the variable is missing, the service uses `persisted_users`.

The repo already includes both env files with `PERSISTED_ACCOUNTS_KEY` set. To point an environment at your own key, edit the matching file. Use a plain storage name. These files are app assets, so do not put API tokens, passwords, or other secrets in them.

```dotenv
PERSISTED_ACCOUNTS_KEY=your_storage_key_here
```

`flutter_dotenv` reads `KEY=value` lines. No quotes are required for a single token. After changing an env file, restart the app so `dotenv.load` runs again.

### Run

```bash
flutter pub get
flutter run
```

Release mode loads `assets/.env.production`:

```bash
flutter run --release
```

### Tests and analysis

```bash
flutter test
flutter analyze
```

`get_random_user_repository_impl_test.dart` uses `mocktail` for a successful payload, a non-200 status, an empty body, an empty `results` list, a `SocketException` that returns the last cached user, and a `SocketException` with an empty cache.

`get_random_user_datasource_impl_test.dart` calls `https://randomuser.me/api/` and expects status 200, so that test needs a network connection.

## Screenshots

Screenshot files are not in the repository yet. Add captures of the running app here:

| Splash | Home | Details | Persisted users |
| --- | --- | --- | --- |
| _Add screenshot_ | _Add screenshot_ | _Add screenshot_ | _Add screenshot_ |

<!--
Replace the placeholders above with images, for example:

![Splash](docs/screenshots/splash.png)
![Home](docs/screenshots/home.png)
![Details](docs/screenshots/details.png)
![Persisted users](docs/screenshots/persisted.png)
-->
