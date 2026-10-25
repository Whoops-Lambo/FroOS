# FroOS Preview 0.4.2 — ISO build fix

This revision addresses the new GitHub Actions logs:
- The Debian security repository failed TLS verification because the build chroot had no CA bundle yet.
- The build then failed while retrieving Debian `Contents-amd64.gz`.

Changes in this workflow:
- Uses Debian's signed `bookworm-security` repository over HTTP for the bootstrap chroot (APT still verifies signed repository metadata).
- Adds `ca-certificates` and `xinit` to the live image packages.
- Sets `--apt-indices false` to avoid the failing Contents index retrieval path.
- Checks for the generated ISO and uploads it as `FroOS-VirtualBox-ISO`.

## Build from Windows
1. Replace `index.html`, `README.md`, and `.github/workflows/build-iso.yml` in your existing GitHub repository with these files.
2. Commit the changes.
3. Open **Actions → Build FroOS VirtualBox ISO → Run workflow**.
4. If it succeeds, download the `FroOS-VirtualBox-ISO` artifact and extract `FroOS-Preview-0.4.2.iso`.

## VirtualBox
Create a VM named FroOS (Debian 64-bit), assign 4 GB RAM and 2 CPU cores, attach the ISO in **Settings → Storage**, then start it.

This is an experimental Linux live ISO that launches the FroOS web desktop prototype. The ISO has not been built or boot-tested in this environment. If the next build fails, download the new logs.
