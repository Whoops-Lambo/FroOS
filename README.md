# FroOS Preview 0.4 — VirtualBox Edition

This package contains the FroOS browser-desktop prototype, a GitHub Actions workflow that builds a bootable live ISO, and a Windows PowerShell helper that creates a VirtualBox VM automatically.

**Honest status:** this is still a Linux live environment that auto-launches the FroOS desktop prototype. It is not a standalone kernel or a fully native OS. The ISO must be built by the workflow; no precompiled ISO is included.

## Easiest setup from Windows

### A. Build the ISO
1. Create a repository at https://github.com/new.
2. Upload all files from this folder. Make sure `.github/workflows/build-iso.yml` is included. If the website hides `.github`, use GitHub Desktop or upload with Git.
3. In the repository, select **Actions** → **Build FroOS VirtualBox ISO** → **Run workflow**.
4. Wait for the green checkmark. Open that run and download the **FroOS-VirtualBox-ISO** artifact.
5. Extract the downloaded artifact ZIP. It contains `FroOS-Preview-0.4.iso` and a checksum file.

### B. Create the VM with one PowerShell command
1. Install Oracle VirtualBox from https://www.virtualbox.org/wiki/Downloads.
2. Extract the artifact ISO somewhere convenient, e.g. `C:\Users\you\Downloads\FroOS-Preview-0.4.iso`.
3. In the project folder, right-click Start and open **Terminal (PowerShell)**, then run:
   ```powershell
   Set-ExecutionPolicy -Scope Process Bypass
   .\Create-FroOS-VM.ps1 -IsoPath "$HOME\Downloads\FroOS-Preview-0.4.iso"
   ```
   Change the path if your ISO is elsewhere. This creates a VM named FroOS with 4 GB RAM, 2 CPU cores and a 24 GB virtual disk.
4. Open VirtualBox and start **FroOS**. If it doesn't boot automatically, confirm the ISO is attached under Settings → Storage and Optical is first in the boot order.

You can also create the VM manually: Linux / Debian (64-bit), 4 GB RAM, 2 CPUs, attach the ISO under Settings → Storage, then Start.

## Notes
- Build logs are available in GitHub Actions if a build step fails.
- This is a live ISO: data may not persist after shutdown, and some prototype apps simulate operating-system behavior.
- First build requires internet and may take several minutes.
- VirtualBox Host key (usually Right Ctrl) releases mouse/keyboard capture.

## Fix in 0.4.1
The build logs showed the obsolete Debian security URL `security.debian.org bookworm/updates` returning HTTP 404. This revision disables live-build's outdated default security source and adds the current Bookworm security suite `bookworm-security`. Replace the old workflow with this revision, then rerun Actions.
