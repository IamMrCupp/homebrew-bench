# homebrew-bench

The [Homebrew](https://brew.sh) tap for the repair bench tools: install them on a Mac, and update them with `brew upgrade`, the way the [apt repo](https://github.com/IamMrCupp/bench-suite#install) does it on Ubuntu.

```sh
brew tap iammrcupp/bench
brew trust --tap iammrcupp/bench
brew install --cask bench-suite
bench-setup
```

That's everything: the three apps and `bench-setup`, which then wires them to each other. Each piece also installs on its own.

`brew trust` is Homebrew asking you to say this tap is one you mean to use: without it, it won't load the apps `bench-suite` depends on. Installing a single cask or the formula by name doesn't need it.

## What's here

| Name | Kind | What it is |
|---|---|---|
| `benchhud` | cask | The [benchhud](https://github.com/IamMrCupp/benchhud) app: signed with a Developer ID and notarized, so it opens with no Gatekeeper warning. |
| `benchhud-intake` | cask | The [benchhud-intake](https://github.com/IamMrCupp/benchhud-intake) menu-bar app: repair intake. |
| `bench-parts` | cask | The [bench-parts](https://github.com/IamMrCupp/bench-parts) menu-bar app: parts inventory. |
| `bench-suite` | cask | Nothing of its own: it installs the three apps and `bench-setup`. |
| `bench-setup` | formula | The setup command from [bench-suite](https://github.com/IamMrCupp/bench-suite). On a Mac it sets a password and token on the benchhud-intake and bench-parts menu-bar apps, wires them into benchhud, and checks that macOS has OBS's camera extension turned on. |

Every app is signed with a Developer ID and notarized. Apple silicon only. bench-recon has no Mac app; it runs in a container, and `bench-setup services --compose --recon` turns it on.

The whole plan is tracked in [bench-suite#14](https://github.com/IamMrCupp/bench-suite/issues/14).

## How it's checked

CI installs everything in the tap on a clean `macos` runner: the formula's own test, and for each cask, that the installed app passes Gatekeeper as a notarized Developer ID app. It also runs once a day, so a release that breaks a download shows up here.

## How it stays current

A `bump` workflow runs once a day. When a project has a newer release it points the formula or cask at it on a branch, installs that branch on a clean Mac with the same checks, and merges it only if they pass. A cask only moves to a release that carries its `.dmg`.

## License

[PolyForm Small Business 1.0.0](LICENSE), like the tools it installs.
