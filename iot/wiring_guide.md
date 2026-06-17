# IoT Hardware Wiring & DFPlayer Configuration Guide

This guide describes how to wire the ESP32 microcontrollers and set up the DFPlayer Mini (MP3 TF 16P) sound player with speaker outputs.

---

## 1. Bill of Materials (BOM)

To build both Master and Slave devices, you will need:

| Qty | Component Name | Purpose |
| :---: | :--- | :--- |
| **2** | ESP32 Development Board (e.g. NodeMCU-32S, ESP32-WROOM-3D) | Main Wi-Fi enabled microcontrollers |
| **1** | DFPlayer Mini Module (MP3 TF 16P) | Sound player decoder chip |
| **1** | MicroSD Card (Capacity <= 32GB) | Storage for voice audio files (Formatted FAT16/FAT32) |
| **1** | 8 Ohm, 3W Mini Speaker | Output sound player speaker |
| **1** | 1K Ohm Resistor | Noise cancellation resistor for serial connection |
| **2** | Momentary Push Buttons | Triggers token generation (Master) and next-calling (Slave) |
| **-** | Breadboards & Jumper wires | Electrical connections |

---

## 2. Wiring Connections

Both ESP32 chips use standard internal pullup resistors, meaning buttons are wired directly from the GPIO pin to Ground (no external pullup resistors needed).

### Master ESP32: Walk-In Dispenser
- **Push Button**: Connected between **GPIO 4** and **GND**.
- **Indicator LED**: Onboard LED uses **GPIO 2** (integrated).

### Slave ESP32: Operator Terminal with Speaker calling
- **Call Button**: Connected between **GPIO 4** and **GND**.
- **Blink LED**: Onboard LED uses **GPIO 2** (integrated).

#### DFPlayer Mini Wiring Map (Slave ESP32 to DFPlayer)

Connect the DFPlayer Mini pins to the Slave ESP32 development board according to this diagram:

```
          DFPlayer Mini Pinout
           +----+---U---+----+
    VCC    | 1  |       | 16 |   BUSY Pin (Connects to ESP32 GPIO 5)
    RX Pin | 2  |       | 15 |   GND
    TX Pin | 3  |       | 14 |   DAC_R
    DAC_L  | 4  |       | 13 |   DAC_L
    SPK1   | 5  |       | 12 |   ADKEY2
    GND    | 6  |       | 11 |   ADKEY1
    SPK2   | 7  |       | 10 |   IO2
    GND    | 8  |       | 9  |   IO1
           +----+-------+----+
```

| DFPlayer Pin | Label | Connection Target (ESP32 / Speaker) | Rationale |
| :---: | :--- | :--- | :--- |
| **Pin 1** | **VCC** | **ESP32 5V Pin** (or VIN) | Requires 5V for high speaker volume. |
| **Pin 2** | **RX** | **1K Resistor** $\rightarrow$ **ESP32 GPIO 17 (TX2)** | 1K resistor prevents serial communication noise. |
| **Pin 3** | **TX** | **ESP32 GPIO 16 (RX2)** | TX lines transmit serial packets. |
| **Pin 5** | **SPK1** | **Speaker positive terminal** | Audio out driver. |
| **Pin 6** | **GND** | **ESP32 GND Pin** | Ground reference. |
| **Pin 7** | **SPK2** | **Speaker negative terminal** | Audio out driver. |
| **Pin 16** | **BUSY** | **ESP32 GPIO 5** | Indicates track state (LOW = playing, HIGH = done). |

> [!CAUTION]
> Always insert a **1K Ohm resistor** in series between ESP32 TX2 (GPIO 17) and DFPlayer RX (Pin 2). Failing to do so causes severe crackling noise in the speaker and can damage the RX line of the DFPlayer module due to 3.3V vs 5V voltage mismatch.

---

## 3. MicroSD Card Folder & Audio Track Setup

The MicroSD card must be formatted with **FAT16** or **FAT32** file systems.
For the `DFRobotDFPlayerMini` library to locate files correctly, create a folder named `mp3` at the root of the SD card, and rename your audio files to match the four-digit prefixes listed below:

```
SD Card Root (D:)
 └── mp3/
      ├── 0001.mp3   <-- Speaks "Token"
      ├── 0002.mp3   <-- Speaks "Number"
      ├── 0003.mp3   <-- Speaks "Zero"
      ├── 0004.mp3   <-- Speaks "One"
      ├── 0005.mp3   <-- Speaks "Two"
      ├── 0006.mp3   <-- Speaks "Three"
      ├── 0007.mp3   <-- Speaks "Four"
      ├── 0008.mp3   <-- Speaks "Five"
      ├── 0009.mp3   <-- Speaks "Six"
      ├── 0010.mp3   <-- Speaks "Seven"
      ├── 0011.mp3   <-- Speaks "Eight"
      ├── 0012.mp3   <-- Speaks "Nine"
      ├── 0013.mp3   <-- Speaks "Please proceed to counter one"
      └── 0014.mp3   <-- Speaks "Buzzer Chime sound"
```

### Tips for creating voice files:
- You can use online text-to-speech converters to generate clear, studio-grade voices.
- Save files in `.mp3` format with **128kbps** bit rate and **44100Hz** sample rate.
- If you change the counter number (e.g. "proceed to Counter 2"), record a new phrase for file `0013.mp3`.
