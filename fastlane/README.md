fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios unitTest

```sh
[bundle exec] fastlane ios unitTest
```

The unitTest lane runs all unit tests and generates a code coverage report.

### ios getLatestBuildNumber

```sh
[bundle exec] fastlane ios getLatestBuildNumber
```

The getLatesetBuildNumber lane retrieves the latest build number for the current version in ITC for the passed in options[:bundleId]

### ios buildReleaseCore

```sh
[bundle exec] fastlane ios buildReleaseCore
```

The buildReleaseCore lane builds the project archive in the enterprise configuration

### ios uploadToTestflight

```sh
[bundle exec] fastlane ios uploadToTestflight
```

The uploadToTestflight lane builds the project archive in the Release configuration and submits to Testflight

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
