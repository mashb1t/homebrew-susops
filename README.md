# Homebrew SusOps Tap

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

## License

MIT © 2025 Manuel Schmid — see [LICENSE](LICENSE).