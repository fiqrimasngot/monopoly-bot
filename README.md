# Monopoly dice roller 

This bot going to tap dice roller on each VMs

## Overview

- [Introduction](https://github.com/fiqrimasngot/monopoly-bot#-introduction)
- [Repository structure](https://github.com/fiqrimasngot/monopoly-bot#-repository-structure)
- [Post installation](https://github.com/fiqrimasngot/monopoly-bot#-post-installation)

## 👋 Introduction

The following components will be installed in your Windows machine,

- [MEmu](https://www.memuplay.com/download-memu-on-pc.html) - Android emulator

### 📚 Reading material

- [MEmu Commands](https://www.memuplay.com/blog/memucommand-reference-manual.html) - memuc supports to manipulate multiple instances (VMs) such as reboot emulator, check status, install apk, run app and etc. 


### 💻 Systems

- One or more VMs installed with [MEmu Android emulator](https://www.memuplay.com/download-memu-on-pc.html)
  - These VMS should be handles by multicore of CPU

📍 It is recommended to have more VMs to get more result choice.

## 📂 Repository structure

The Git repository contains the following directories under `monopoly-bot`.

```sh
📁 monopoly-bot      
├─📁 bot_diceRoller.ps1     
└─📁 README.md          
```

### 📄 Configuration

📍 The `adb shell getevent -l` commad will showing the coordinates of tap in hex, need to converted it into decimal.

1. Copy the result then converted the hex to decimal and start filling out all the $tapLocation variables.

    **All are required** unless otherwise noted in the comments.

    ```sh
    /dev/input/event1: EV_ABS       ABS_MT_POSITION_X    000001b3
    /dev/input/event1: EV_ABS       ABS_MT_POSITION_Y    00000320
    ```

2. Once that is done, verify the configuration is correct by running:

    ```sh
    getevent -l | awk '{ printf "%s %s %s %d\n", $1, $2, $3, ("0x" $4)+0 }'
     ```

### ⚡ Preparing VMs with MEmu

📍 Will be running as main emulator

📍 After installing the emulator, create new VM's with most recent version

1. Ensure you are able to `adb shell` into your nodes from your workstation 

   [How to configure adb](https://stackoverflow.com/questions/38651871/adb-wifi-often-go-offline-how-to-keep-adb-online)

2. Get list of connected internet

    ```sh
    PS C:\Program Files\Microvirt\MEmu> Get-NetAdapter

    Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed
    ----                      --------------------                    ------- ------       ----------             ---------
    Bluetooth Network Conn... Bluetooth Device (Personal Area Netw...      20 Disconnected F0-57-A6-0F-46-54         3 Mbps
    Ethernet                  Realtek PCIe GbE Family Controller           13 Up           A8-A1-59-E0-9C-EA       100 Mbps
    WiFi                      Intel(R) Dual Band Wireless-AC 3168           9 Disconnected F0-57-A6-0F-46-50          0 bps    
    ```

3. Verify the vms has been started

    ```sh
    cd "C:\Program Files\Microvirt\MEmu"
    memuc.exe listvms
    ```

## 📣 Post installation

### 🪝 How to use

After all has been configured, use the command below;

1. Simply execute the following command in current path, with administrator privilege on terminal by right clicking on it;

    ```sh
    monopoly-bot\bot_diceRoller.ps1
    ```

    So you got the policy error run this beforehand

    ```text
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
    ```
