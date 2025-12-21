# Change: Improve Multi-OS Support in Setup Script

## Why
The current `setup.sh` only supports macOS and Ubuntu Linux, limiting its usefulness in containerized environments (Alpine) and other Debian-based distributions. As development environments increasingly use Docker containers and cloud instances with minimal base images, the setup script needs broader OS compatibility to maintain its "zero fuss" goal across all deployment targets.

## What Changes
- **Prioritize Homebrew everywhere**: Use Homebrew as primary package manager on all supported platforms (macOS, Linux/Debian, Linux/Ubuntu, Linux/Alpine)
- Install Homebrew/Linuxbrew if not present on Linux systems
- Add autodetection for Alpine Linux (commonly used in Docker containers)
- Add explicit Debian support (currently assumes Ubuntu)
- Improve OS detection logic to handle more distributions reliably
- Fall back to native package managers (apk, apt) only for system-level dependencies where Homebrew isn't suitable
- Ensure all dependencies are installed correctly regardless of OS
- Maintain backward compatibility with existing macOS and Ubuntu installations

## Impact
- **Affected specs**: `setup-automation` (new spec being created)
- **Affected code**: `setup.sh:1-96`
- **Benefits**:
  - Consistent package management experience across all platforms using Homebrew
  - Works in Alpine-based Docker containers (official Node, Python images)
  - Explicit Debian support improves reliability
  - More portable across cloud providers and CI environments
  - Better developer experience when switching between environments
  - Access to latest versions of tools through Homebrew on Linux
- **Risks**: 
  - Homebrew installation adds initial setup time on Linux systems
  - Some minimal Alpine containers may need additional setup for Homebrew dependencies
