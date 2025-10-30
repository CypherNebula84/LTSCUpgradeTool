# LTSC Upgrade Tool

**Version:** 1.0  
**Author:** [CN84]  
**Date:** 2025-10-30  

---

## Overview

`LTSCUpgradeTool.bat` is a Windows batch script designed to **modify registry keys** so that your current Windows installation appears as a chosen **LTSC edition**. This allows for an **in-place upgrade** using the LTSC ISO without needing a full reinstall.  

> **Important:** This script does **not activate LTSC**. You still need a "Totally" legally obtained and valid LTSC license key.
And I Do Not Plan on Updating this.

---

## Supported Editions

- **Enterprise LTSC** – Standard enterprise desktop, stable, fewer feature updates, long-term support.  
- **IoT Enterprise LTSC** – For embedded or IoT devices, minimal feature changes, long-term stability.  


---

## Features

- **Registry backup:** Automatically backs up your current registry to your Desktop.  
- **Before/After logs:** Displays the current value of registry keys and the new LTSC values before applying changes.  

---

## How to Use

1. **Download this script.  
2. **Run as Administrator** by right-clicking the batch file and selecting “Run as Administrator.”  
3. Follow the prompts:  
   - Choose the LTSC edition (1 = Enterprise, 2 = IoT Enterprise).  
4. The script will:  
   - Display the registry values it is about to change.  
   - Backup your current registry to your Desktop.  
   - Apply the changes.  
5. Follow the **NEXT STEPS** after the script completes:  
   - Reboot your PC.  
   - Mount the LTSC ISO for the edition you selected.  
   - Open it in Explorer.  
   - Run `setup.exe` in Windows and choose “Keep files and apps.”  
   - Activate with your valid LTSC license key.  
6. If the installer fails, restore the registry backup using:  
   ```bat
   reg import "C:\Users\<YourUsername>\Desktop\LTSC_upgrade_tool_registry_backup_<date>\CurrentVersionBackup.reg"
