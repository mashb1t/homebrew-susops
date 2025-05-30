<p align="center">
    <img src="icon.png" alt="Menu" height="200" />
</p>

# Homebrew SusOps Tap - SSH Utilities & SOCKS5 Operations

This is the Homebrew tap for SusOps, providing an easy way to install the SusOps CLI on macOS:

- **[SusOps CLI](https://github.com/mashb1t/susops-cli)**: Lightweight command-line interface for website proxying and port forwarding.
- **[SusOps Mac](https://github.com/mashb1t/susops-mac)**: Native macOS application for SusOps.


## Installation

1. Tap the repository:

   ```bash
   brew tap mashb1t/susops
   ```

2. Install the `susops` CLI:

   ```bash
   brew install susops
   brew link susops # only if the GUI is already installed
   ```
    or, for the GUI:
    
    ```bash
    brew install --cask susops
    ```

3. (Optional) To upgrade:

   ```bash
   brew upgrade mashb1t/susops
   brew upgrade --cask mashb1t/susops
   ```

> [!NOTE]
> homebrew tries to upgrade the SusOps cask in-place, which may fail sometimes. If you get an error like
> `error: redefinition of module 'SwiftBridging'`, please manually delete the app and install it again with
> `brew install --cask susops`. No data is lost in the process.

## License

MIT © 2025 Manuel Schmid — see [LICENSE](LICENSE).
