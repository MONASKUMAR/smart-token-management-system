/**
 * Smart Token Management System - Master ESP32 Ticket Dispenser
 * 
 * Hardware Description:
 * - ESP32 Development Board
 * - Walk-in Push-Button connected between GPIO 4 and GND
 * - LED Indicator connected to GPIO 2 (onboard LED)
 */

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// Wi-Fi Credentials
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// Google Apps Script Web App URL (MUST end in /exec)
const char* googleWebAppUrl = "https://script.google.com/macros/s/AKfycbxIDzQF_XxhYujTWFyAy9bJQbgpEllYkcfMBr-B0KDe3Lmn3jKImPMLWIglLBDYr-8/exec";

// Hardware Pins
const int BUTTON_PIN = 4; // Push button pin (active LOW)
const int LED_PIN = 2;    // Status LED pin

// Debounce state
unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 300; 

void setup() {
  Serial.begin(115200);
  
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  // Connect to Wi-Fi
  connectToWiFi();
}

void loop() {
  // Read button state (active LOW due to pullup)
  int buttonState = digitalRead(BUTTON_PIN);

  if (buttonState == LOW) {
    if ((millis() - lastDebounceTime) > debounceDelay) {
      lastDebounceTime = millis();
      Serial.println("\n[Master] Button pressed. Dispatching Manual Ticket generation...");
      
      // Visual feedback of pressing
      digitalWrite(LED_PIN, HIGH);
      
      // Generate Token via HTTP call
      triggerGenerateTokenAPI();
      
      digitalWrite(LED_PIN, LOW);
    }
  }
}

/**
 * Handle Wi-Fi Connection
 */
void connectToWiFi() {
  Serial.print("[WiFi] Connecting to SSID: ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[WiFi] Connected successfully!");
    Serial.print("[WiFi] IP Address: ");
    Serial.println(WiFi.localIP());
    // Blinker indicating connection success
    for (int i = 0; i < 3; i++) {
      digitalWrite(LED_PIN, HIGH);
      delay(150);
      digitalWrite(LED_PIN, LOW);
      delay(150);
    }
  } else {
    Serial.println("\n[WiFi] Connection failed. Check credentials.");
  }
}

/**
 * Perform POST Request to Google Apps Script Web App
 */
void triggerGenerateTokenAPI() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("[Error] WiFi disconnected. Attempting reconnect...");
    connectToWiFi();
    if (WiFi.status() != WL_CONNECTED) return;
  }

  HTTPClient http;
  
  // Set up connection target
  http.begin(googleWebAppUrl);
  
  // CRITICAL: Google Apps Script Web Apps redirect (302 Found) to Google User Content URLs.
  // We must instruct HTTPClient to automatically follow redirects.
  http.setFollowRedirects(HTTPC_FORCE_FOLLOW_REDIRECTS);
  
  // Prepare JSON payload parameters
  StaticJsonDocument<256> doc;
  doc["action"] = "generateToken";
  doc["name"] = "Walk-In Customer";
  doc["phone"] = "-";
  doc["email"] = "-";
  doc["serviceType"] = "General Service";
  doc["source"] = "Manual"; // Indicates hardware/desk dispatcher
  doc["remarks"] = "Generated via Master ESP32 hardware button";
  
  String requestBody;
  serializeJson(doc, requestBody);
  
  Serial.println("[HTTP] Sending POST request...");
  
  // Google Apps Script expects "text/plain" or similar content type to bypass CORS issues, 
  // though from ESP32 standard headers are fine.
  http.addHeader("Content-Type", "application/json");
  
  int httpResponseCode = http.POST(requestBody);
  
  if (httpResponseCode > 0) {
    Serial.print("[HTTP] Response code: ");
    Serial.println(httpResponseCode);
    
    String responseString = http.getString();
    Serial.println("[HTTP] Response JSON:");
    Serial.println(responseString);
    
    // Parse response JSON to fetch generated token number
    StaticJsonDocument<512> responseDoc;
    DeserializationError error = deserializeJson(responseDoc, responseString);
    
    if (!error) {
      bool success = responseDoc["success"];
      if (success) {
        const char* tokenNum = responseDoc["tokenNumber"];
        const char* timeGen = responseDoc["timeGenerated"];
        int waitTime = responseDoc["estimatedWaitingTimeMinutes"];
        
        Serial.println("\n==================================");
        Serial.print("  TICKET DISPENSED SUCCESS\n");
        Serial.print("  Token Number: "); Serial.println(tokenNum);
        Serial.print("  Time: "); Serial.println(timeGen);
        Serial.print("  Est. Wait: "); Serial.print(waitTime); Serial.println(" Mins");
        Serial.println("==================================");
        
        // Double blink success LED indicator
        digitalWrite(LED_PIN, HIGH); delay(200);
        digitalWrite(LED_PIN, LOW); delay(200);
        digitalWrite(LED_PIN, HIGH); delay(200);
        digitalWrite(LED_PIN, LOW);
      } else {
        const char* err = responseDoc["error"];
        Serial.print("[API Error] Failed to generate token: ");
        Serial.println(err);
      }
    } else {
      Serial.print("[JSON Error] Deserialization failed: ");
      Serial.println(error.f_str());
    }
  } else {
    Serial.print("[HTTP Error] POST request failed: ");
    Serial.println(http.errorToString(httpResponseCode).c_str());
  }
  
  // Clean up
  http.end();
}
