# 🖱️ LogiOps Config — Logitech MX Master 3

Personal configuration for [LogiOps](https://github.com/PixlOne/logiops) (Linux driver for Logitech mice), tailored for **MX Master 3** on Fedora GNOME.  
This config unlocks advanced features like gestures, SmartShift, DPI tuning, and thumb wheel remapping.

---

## ✨ Features

- **SmartShift**
  - Enabled with threshold `15` (auto free-spin when scrolling fast)
  - Can be toggled on/off with the top button

- **High-Resolution Scroll**
  - High-resolution scrolling enabled
  - Normal (non-inverted) direction

- **Pointer Speed**
  - DPI set to `1500` (MX Master 3 supports up to `4000`)
  - Top button supports **on-the-fly DPI change** (+/- 1000 per gesture)

- **Thumb Wheel**
  - Diverted to LogiOps for custom actions
  - Maps to **Ctrl+PageUp/PageDown** → switch tabs in browsers/apps

- **Buttons**
  - **Forward button (0x56)**:
    - None → Browser Forward
    - Up → Play/Pause
    - Down → GNOME Activities (Meta)
    - Right/Left → Next/Previous song
  - **Back button (0x53)**:
    - None → Browser Back
  - **Gesture button (0xc3, thumb rest)**:
    - None → Activities (Meta)
    - Left/Right → Switch workspace
    - Up → Maximize
    - Down → Minimize
  - **Top button (0xc4)**:
    - None → Toggle SmartShift (ratchet/free)
    - Up/Down → Change DPI (+/- 1000)

---

## 📂 File Structure

```bash
logiops
├── logid.cfg
└── README.md
```

---
## 🚀 Installation

1. Install LogiOps on Fedora (or other distros):
   ```bash
   sudo dnf copr enable zeno/logiops
   sudo dnf install logiops
   ```

   On Ubuntu/Debian:
   ```bash
   sudo apt install cmake libevdev-dev libudev-dev libconfig++-dev
   git clone https://github.com/PixlOne/logiops.git
   cd logiops && mkdir build && cd build
   cmake ..
   make
   sudo make install
   ```
2. Copy config file:
   ```bash
   sudo cp logid.cfg /etc/logid.cfg
   ```
3. Enable and start the service:
   ```bash
   sudo systemctl enable logid
   sudo systemctl start logid
   ```
---

## 🎛️ Debugging

To find your device name and test gestures:
```bash
logid --debug
```
---

## 🔗 References
- [LogiOps](https://github.com/PixlOne/logiops.git)

---

## 🧑 Author

WhoAmI (Paweł Owczarczyk)

Linux & DevOps Enthusiast — dotfiles and homelab configs

---