# homebrew-bench

The [Homebrew](https://brew.sh) tap for the repair bench tools: install them on a Mac, and update them with `brew upgrade`, the way the [apt repo](https://github.com/IamMrCupp/bench-suite#install) does it on Ubuntu.

```sh
brew tap iammrcupp/bench
brew install bench-setup
```

## What's here

| Name | Kind | What it is |
|---|---|---|
| `bench-setup` | formula | The setup command from [bench-suite](https://github.com/IamMrCupp/bench-suite). On a Mac it sets a password and token on the benchhud-intake and bench-parts menu-bar apps, wires them into benchhud, and checks that macOS has OBS's camera extension turned on. |

The apps themselves aren't here yet. A cask can only install an app that's signed with a Developer ID and notarized — anything else, Gatekeeper blocks on first launch. They arrive as each app's releases carry a notarized build:

| App | Status |
|---|---|
| [benchhud](https://github.com/IamMrCupp/benchhud) | Signing is in CI; the cask lands with the first release that carries the `.dmg` ([benchhud#394](https://github.com/IamMrCupp/benchhud/issues/394)) |
| [benchhud-intake](https://github.com/IamMrCupp/benchhud-intake) | Waiting on a notarized build ([benchhud-intake#121](https://github.com/IamMrCupp/benchhud-intake/issues/121)) |
| [bench-parts](https://github.com/IamMrCupp/bench-parts) | Waiting on a notarized build ([bench-parts#129](https://github.com/IamMrCupp/bench-parts/issues/129)) |

Until then, get the apps from each repo's releases and run `bench-setup` once they're in Applications.

Apple silicon only. bench-recon has no Mac app; it runs in a container, and `bench-setup services --compose --recon` turns it on.

The whole plan is tracked in [bench-suite#14](https://github.com/IamMrCupp/bench-suite/issues/14).

## How it's checked

CI installs everything in the tap on a clean `macos` runner: the formula's own test, and for each cask, that the installed app passes Gatekeeper as a notarized Developer ID app. It also runs once a day, so a release that breaks a download shows up here.

## License

[PolyForm Small Business 1.0.0](LICENSE), like the tools it installs.
