# Clean Architecture Sample 

Originally for my interview assessment, but I am making this as my
clean architecture sample example for Flutter.

**Apk is available on root dir [here](app-release.apk)**

### Prerequisites
1. Flutter
2. Android Studio / XCode - For emulator / simulator
3. IDE - Android Studio, IntellliJ IDEA, VSCode.

### Running
1. `flutter run` on terminal or IDE configuration setup.

## Build with
1. Presentation layer.
    1. [Flutter_hooks](https://pub.dev/packages/flutter_hooks) - UI Management
    2. [Flutter_bloc](https://pub.dev/packages/flutter_bloc) - State management
    3. [Intl](https://pub.dev/packages/intl) - Internationalization (supported locale is English and Malay)
    4. [Equatable](https://pub.dev/packages/equatable)
    
    **note**: Internationalization is built with [Flutter_intl_jetbrain](https://plugins.jetbrains.com/plugin/13666-flutter-intl) plugins.
    There's also plugins for [vscode](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl)

2. Data Layer
    1. [Hive](https://pub.dev/packages/hive)
    2. [Hive_flutter](https://pub.dev/packages/hive_flutter)
    
    
3. Pure Dart on Domain Layer
4. [Equatable](https://pub.dev/packages/equatable) for unit tests.

### Architecture
![clean architecture](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)
* Layers separated by Data, Domain, Presentation.
* Presentation layer are mainly in [lib/](lib) directories.
    * Pure UI logic (no business logic)
    * Only using logic from our domain / presentation.
    * Consist of:
        1. Widgets
        2. Blocs (refer flutter_bloc)
        3. Device (here is mainly for geo fencing)

* Domain layer [domain/](domain)
    * Pure dart (no Flutter sdk)
    * Only using logic within our domain.
    * Consists of:
        1. Entities (Models)
        2. Repositories (Interfaces)
        3. Use cases (or you can also call it User Stories)

* Data layer [data](data)
    * Might contains Platform code (In this case Database)
    * Only using logic within our domain / data
    * Consists of:
        1. Data sources (local / remote but in this example only local)
        2. Models (Data source model response object / database object)
        3. Repositories Implementations (Implemented from Domain)

* Rules:
    1. UI must not know about where the data is from.
    2. From the image above, the inner layer *MUST NOT* know the outer layer.
    3. Bloc should be state management, not handle logic.
    4. Bloc should handle state based on user stories (use cases).

### Running
1. `flutter run` on terminal or IDE configuration setup.

## Formatter
1. Run `dartfmt -w lib/ test/`

## Features
1. Home Page.
* Feature to add / save which point & Wi-Fi 
* Update status by location tracking.
* Update status by changing on selected items.

![First Screen](screenshot/home_one.png)
![Second screen](screenshot/home_with_list.png)
![Third screen](screenshot/home_update_status_location.png)

2. Edit / Add screen
* Add Wi-Fi name
* Point on the map where to set geofence
* Resize geofence area
* Display current status on editing.

![First add screen](screenshot/add_empty.png)
![Second add screen](screenshot/edit_wifi.png)
![Third add screen](screenshot/edit_wifi_2.png)
![Fourth add screen](screenshot/resize_fencing.png)

<details>
    <summary>flutter doctor -v</summary>
    
    ```
    [✓] Flutter (Channel stable, v1.17.2, on Linux, locale en_US.UTF-8)
        • Flutter version 1.17.2 at /home/yuzuriha/devenv/flutter
        • Framework revision 5f21edf8b6 (5 days ago), 2020-05-28 12:44:12 -0700
        • Engine revision b851c71829
        • Dart version 2.8.3
    
     
    [✓] Android toolchain - develop for Android devices (Android SDK version 29.0.3)
        • Android SDK at /home/yuzuriha/Android/Sdk
        • Platform android-29, build-tools 29.0.3
        • Java binary at: /home/yuzuriha/.local/share/JetBrains/Toolbox/apps/AndroidStudio/ch-0/193.6514223/jre/bin/java
        • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)
        • All Android licenses accepted.
    
    [!] Android Studio (version 3.6)
        • Android Studio at /home/yuzuriha/.local/share/JetBrains/Toolbox/apps/AndroidStudio/ch-0/192.6392135
        ✗ Flutter plugin not installed; this adds Flutter specific functionality.
        ✗ Dart plugin not installed; this adds Dart specific functionality.
        • Java version OpenJDK Runtime Environment (build 1.8.0_212-release-1586-b4-5784211)
    
    [!] Android Studio (version 4.0)
        • Android Studio at /home/yuzuriha/.local/share/JetBrains/Toolbox/apps/AndroidStudio/ch-0/193.6514223
        ✗ Flutter plugin not installed; this adds Flutter specific functionality.
        ✗ Dart plugin not installed; this adds Dart specific functionality.
        • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)
    
    [✓] Connected device (1 available)
        • sdk gphone x86 • emulator-5554 • android-x86 • Android 10 (API 29) (emulator)
    ```
</details>

## Authors

* [**Yusuf Rosman**](https://github.com/zaralockheart)
