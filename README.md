# dotfiles

## Fresh machine setup

### 1. Install Xcode Command Line Tools

```sh
xcode-select --install
```

### 2. Clone this repo

```sh
git clone git@github.com:CaseyMichael/dotfiles.git ~/Developer/dotfiles
```

### 3. Run the install script

Installs Homebrew (if needed), creates symlinks, and installs all packages.

```sh
~/Developer/dotfiles/install.sh
```

### 4. Restart your shell

```sh
exec zsh
```
