# Security Policy

## Reporting a Vulnerability

If you find a security issue in masterrc, **do not open a public issue.**

Please report it privately via one of these methods:
- **GitHub Private Vulnerability Reporting** - on the [Security Form](https://github.com/Master3307/masterrc/security/advisories/new)
- **Discord** - friend me or message me on the user master3307 on Discord directly if you can.

Include in your report:
- A description of the issue
- Steps to reproduce it
- What system/distro you're on
- Any relevant output or screenshots

## What happens next

I'll review your report and respond as soon as I can. If the issue is valid, I'll work on a fix before any public disclosure.

## Scope

This project is a personal dotfiles/shell config repo. Security concerns mainly relate to:
- The `install.sh` / `uninstall.sh` scripts running with elevated privileges
- Any commands or aliases in `.bash_custom` that could behave dangerously on certain systems
