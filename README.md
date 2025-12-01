<p align="center">
  <img src="https://it2grow.nl/wp-content/uploads/2025/10/It2grow-x-Safehouse-logo-1000x144-1.png" alt="it2grow by Safehouse logo" width="400">
</p>

<h1 align="center">Intune Configs</h1>

<p align="center">
  Centralized configuration files and remediation scripts for Microsoft Intune deployments.<br>
  Maintained by <a href="https://it2grow.nl">it2grow</a>, a <strong>Safehouse Cybersecurity</strong> company.
</p>

---

## 📄 Overview

This repository contains configuration files and PowerShell remediation scripts deployed via Microsoft Intune. Configurations are hosted here to enable centralized updates without redeploying Intune policies.

---

## 🧩 Repository Structure

```
intune-configs/
├── sophos/                          # Sophos Connect VPN configurations
│   └── ra-vpn.pro                   # VPN provisioning file
└── remediations/                    # Intune remediation scripts
    └── sophos/
        ├── Detect-SophosVPNConfig.ps1
        └── Remediate-SophosVPNConfig.ps1
```

---

## 🔐 Sophos Connect VPN Provisioning

Automatically deploys and updates Sophos Connect VPN configurations to endpoints via Intune remediations.

### How It Works

1. **Detection script** – Checks if the local config matches the version in this repo
2. **Remediation script** – Downloads the latest `.pro` file and imports it into Sophos Connect
3. **Auto-import** – Sophos Connect automatically imports the configuration and pulls VPN settings from the portal

### Updating the VPN Configuration

1. Edit `sophos/ra-vpn.pro` in this repo
2. Commit the changes
3. Endpoints pick up the new config on their next remediation run

---

## 🚀 Intune Deployment

### Create Remediation Script Package

1. Go to **Devices → Scripts and remediations → Remediations**
2. Click **Create script package**
3. Configure:

| Setting | Value |
|---------|-------|
| Name | `Sophos VPN Config` |
| Detection script | `remediations/sophos/Detect-SophosVPNConfig.ps1` |
| Remediation script | `remediations/sophos/Remediate-SophosVPNConfig.ps1` |
| Run as logged-on user | No |
| Enforce signature check | No |
| Run in 64-bit PowerShell | Yes |

4. Assign to a device group
5. Set schedule: **Daily** (recommended)

---

## 📋 Prerequisites

- ✅ Sophos Connect client installed on endpoints
- ✅ Endpoints have internet access to `raw.githubusercontent.com`
- ✅ VPN portal accessible from WAN (Sophos Firewall: Administration → Device access)

---

## 📁 Local File Paths

| File | Path |
|------|------|
| Cached config | `C:\ProgramData\it2grow\sophos\ra-vpn.pro` |
| Sophos import folder | `C:\Program Files (x86)\Sophos\Connect\import\` |

---

## 🧱 Adding New Configurations

When adding new remediation scripts:

1. Create a folder under `remediations/` for the product/feature
2. Add `Detect-*.ps1` and `Remediate-*.ps1` scripts
3. Host any config files in a dedicated folder (e.g., `productname/`)
4. Update this README with deployment instructions

---

## 🧰 Tools

Recommended tools for editing and testing:

| Tool | Purpose |
|------|---------|
| Visual Studio Code | Script editing |
| PowerShell ISE | Local testing |
| Windows Sandbox | Safe remediation testing |

---

## 👥 Maintainers

| Name | Role | Organization |
|------|------|--------------|
| it2grow | Development & Deployment | [it2grow.nl](https://it2grow.nl) |
| Safehouse Cybersecurity | Parent Organization | |

---

## 🗂 Version History

| Version | Date | Description | Author |
|---------|------|-------------|--------|
| 1.0.0 | 2025-06-03 | Initial release – Sophos VPN provisioning | it2grow |

---

## 🔒 Internal Use Only

This repository is for internal Safehouse Cybersecurity / it2grow use. Do not distribute or publish externally without authorization.
