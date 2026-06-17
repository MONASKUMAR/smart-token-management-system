/**
 * Smart Token Management System - Slave ESP32 Operator Terminal
 * 
 * Hardware Description:
 * - ESP32 Development Board
 * - "Next Token" Button connected between GPIO 4 and GND
 * - DFPlayer Mini (MP3 TF 16P) connected to:
 *     - VCC -> 5V
 *     - GND -> GND
 *     - TX -> GPIO 16 (ESP32 RX2)
 *     - RX -> GPIO 17 (ESP32 TX2) [Use 1K ohm resistor in series between TX2 and RX]
 *     - Busy Pin -> GPIO 5 (with internal pullup)
 * - LED Indicator on GPIO 2
 */

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <HardwareSerial.h>
#include <DFRobotDFPlayerMini.h>

// Wi-Fi Credentials
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// Google Apps Script Web App URL
const char* googleWebAppUrl = "https://script.google.com/macros/s/AKfycbxIDzQF_XxhYujTWFyAy9bJQbgpEllYkcfMBr-B0KDe3Lmn3jKImPMLWIglLBDYr-8/exec";

// Hardware Pin Configuration
const int NEXT_BUTTON_PIN = 4; // Operator Desk Call Button (active LOW)
const int BUSY_PIN = 5;        // DFPlayer Mini BUSY pin (LOW = playing, HIGH = idle)
const int LED_PIN = 2;         // Status indicator LED

// DFPlayer and Serial configurations
HardwareSerial mySoftwareSerial(2); // Use ESP32 HardwareSerial 2
DFRobotDFPlayerMini myDFPlayer;

// Debounce settings
unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 400; 

void setup() {
  Serial.begin(115200);
  
  pinMode(NEXT_BUTTON_PIN, INPUT_PULLUP);
  pinMode(BUSY_PIN, INPUT_PULLUP);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  // Initialize HardwareSerial2 (RX=16, TX=17) for DFPlayer Mini
  mySoftwareSerial.begin(9600, SERIAL_8N1, 16, 17);
  
  Serial.println("[DFPlayer] Connecting to DFPlayer Mini...");
  
  if (!myDFPlayer.begin(mySoftwareSerial)) {
    Serial.println("[Error] DFPlayer Mini not detected. Check RX/TX connections and SD card.");
    // Blink LED to indicate DFPlayer failure
    for (int i = 0; i < 10; i++) {
      digitalWrite(LED_PIN, HIGH); delay(100);
      digitalWrite(LED_PIN, LOW); delay(100);
    }
  } else {
    Serial.println("[DFPlayer] Connected successfully.");
    myDFPlayer.volume(25); // Set speaker volume (0 to 30)
  }

  // Connect Wi-Fi
  connectToWiFi();
}

void loop() {
  // Read Operator "Next" button
  int buttonState = digitalRead(NEXT_BUTTON_PIN);

  if (buttonState == LOW) {
    if ((millis() - lastDebounceTime) > debounceDelay) {
      lastDebounceTime = millis();
      Serial.println("\n[Slave] Calling next customer queue slot...");
      
      digitalWrite(LED_PIN, HIGH);
      
      // Call Next Token from Apps Script
      triggerNextTokenAPI();
      
      digitalWrite(LED_PIN, LOW);
    }
  }
}

/**
 * Handle Wi-Fi connections
 */
void connectToWiFi() {
  Serial.print("[WiFi] Connecting to: ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[WiFi] Connected!");
    Serial.print("[WiFi] IP Address: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("\n[WiFi] Connection failed.");
  }
}

/**
 * Call Next Token API and announce resulting digits
 */
void triggerNextTokenAPI() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("[WiFi Error] Disconnected. Reconnecting...");
    connectToWiFi();
    if (WiFi.status() != WL_CONNECTED) return;
  }

  HTTPClient http;
  http.begin(googleWebAppUrl);
  http.setFollowRedirects(HTTPC_FORCE_FOLLOW_REDIRECTS);
  
  // JSON payload structure
  StaticJsonDocument<128> doc;
  doc["action"] = "nextToken";
  
  String requestBody;
  serializeJson(doc, requestBody);
  
  http.addHeader("Content-Type", "application/json");
  int httpResponseCode = http.POST(requestBody);
  
  if (httpResponseCode > 0) {
    String responseString = http.getString();
    Serial.println("[HTTP] NextToken Response:");
    Serial.println(responseString);
    
    StaticJsonDocument<512> responseDoc;
    DeserializationError error = deserializeJson(responseDoc, responseString);
    
    if (!error) {
      bool success = responseDoc["success"];
      if (success) {
        // If there's an active token details returned in serving payload
        if (responseDoc.containsKey("serving") && !responseDoc["serving"].isNull()) {
          const char* tokenNum = responseDoc["serving"]["tokenNumber"];
          const char* name = responseDoc["serving"]["customerName"];
          
          Serial.println("\n==================================");
          Serial.print("  CALLING NOW: "); Serial.println(tokenNum);
          Serial.print("  Customer: "); Serial.println(name);
          Serial.println("==================================");
          
          // Vocal Speech Announcement sequence
          announceToken(tokenNum);
        } else {
          Serial.println("[Lobby Info] Queue is currently empty. No waiting customers.");
          // Play buzzer chime only indicating empty queue
          playBuzzerChime();
        }
      } else {
        const char* err = responseDoc["error"];
        Serial.print("[API Error] "); Serial.println(err);
      }
    } else {
      Serial.print("[JSON Error] Deserialization failed: ");
      Serial.println(error.f_str());
    }
  } else {
    Serial.print("[HTTP Error] POST request failed: ");
    Serial.println(http.errorToString(httpResponseCode).c_str());
  }
  
  http.end();
}

/**
 * Speak the token number digit-by-digit
 * 
 * Audio track mapping layout:
 * - 0001.mp3: "Token"
 * - 0002.mp3: "Number"
 * - 0003.mp3: "Zero"
 * - 0004.mp3: "One"
 * - 0005.mp3: "Two"
 * - 0006.mp3: "Three"
 * - 0007.mp3: "Four"
 * - 0008.mp3: "Five"
 * - 0009.mp3: "Six"
 * - 0010.mp3: "Seven"
 * - 0011.mp3: "Eight"
 * - 0012.mp3: "Nine"
 * - 0013.mp3: "Please proceed to counter one"
 */
void announceToken(const String& tokenStr) {
  Serial.println("[DFPlayer] Commencing Voice Announcement...");
  
  // 1. Play track 1 ("Token")
  myDFPlayer.play(1);
  waitPlayComplete();
  
  // 2. Play track 2 ("Number")
  myDFPlayer.play(2);
  waitPlayComplete();
  
  // 3. Process digits sequence
  for (int i = 0; i < tokenStr.length(); i++) {
    char ch = tokenStr.charAt(i);
    int trackNum = -1;
    
    // Convert ASCII digit characters to respective track numbers
    if (ch >= '0' && ch <= '9') {
      trackNum = (ch - '0') + 3; // '0' is track 3, '1' is track 4, etc.
    }
    
    if (trackNum != -1) {
      Serial.print("[DFPlayer] Playing digit: "); Serial.println(ch);
      myDFPlayer.play(trackNum);
      waitPlayComplete();
    }
  }
  
  // 4. Play track 13 ("Please proceed to counter one")
  myDFPlayer.play(13);
  waitPlayComplete();
  
  Serial.println("[DFPlayer] Vocal announcement sequence completed.");
}

/**
 * Blocking wait until DFPlayer Mini finishes playing active track.
 * Reads high/low state of GPIO Pin connected to DFPlayer Busy pin.
 */
void waitPlayComplete() {
  delay(100); // Give DFPlayer 100ms to pull the BUSY pin low
  
  // While BUSY pin is LOW (0), track is playing. Wait.
  while (digitalRead(BUSY_PIN) == LOW) {
    delay(10);
  }
}

/**
 * Play a simple single chime track for announcements
 */
void playBuzzerChime() {
  // Let's assume Track 14 is a buzzer chime sound
  Serial.println("[DFPlayer] Playing empty queue chime...");
  myDFPlayer.play(14);
  waitPlayComplete();
}
