#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <DHT.h>

// WiFi credentials
const char* ssid     = "BS14-STUDENTS-BYOD";
const char* password = "322984238";

// Pin configuration
const int DHTPin = 2;  // GPIO2
const int redLampPin = 14;  // GPIO14
const int greenLampPin = 12;

bool IsConnectedToWifi;  // GPIO12

// Initialize DHT sensor
#define DHTTYPE DHT11   // DHT 11
DHT dht(DHTPin, DHTTYPE);

void setup() {
  Serial.begin(115200);
  delay(10);
  
  dht.begin();
  pinMode(redLampPin, OUTPUT);
  pinMode(greenLampPin, OUTPUT);

  connectToWiFi();
}

void loop() {
  if(IsConnectedToWifi) readDHTSensorAndSendData();
  delay(2000);
}

void connectToWiFi() {
  Serial.println("Connecting to WiFi...");
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print("Waiting for connection");
  }

  IsConnectedToWifi = true;
  Serial.println("\nConnected to WiFi");
}

void sendRequestToSteam() {
  BearSSL::WiFiClientSecure client;
  client.setInsecure();

  HTTPClient https;
  https.begin(client, "https://super-sopapillas-4b452b.netlify.app/.netlify/functions/api/firebase-status");
  int httpCode = https.GET();
  Serial.print("HTTP Response Code: ");
  Serial.println(httpCode);

  if (httpCode > 0) { //Check the returning code
    String payload = https.getString(); //Get the request response payload
    Serial.println(httpCode); //Print the response payload
  }

  https.end();
}

void readDHTSensorAndSendData() {
  float h = dht.readHumidity();
  float t = dht.readTemperature();

  if (isnan(h) || isnan(t)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }

  Serial.print(F("Humidity: "));
  Serial.print(h);
  Serial.print(F("%  Temperature: "));
  Serial.print(t);
  Serial.println(F("°C "));

  if (WiFi.status() == WL_CONNECTED) {

     BearSSL::WiFiClientSecure client;
    client.setInsecure();

    HTTPClient https;
    https.begin(client, "https://super-sopapillas-4b452b.netlify.app/.netlify/functions/api/temperatures"); //Specify the URL
    https.addHeader("Content-Type", "application/json");

    StaticJsonDocument<200> doc;
    doc["temperature"] = t;
    doc["humidity"] = h;
    String requestBody;
    serializeJson(doc, requestBody);

    int httpCode = https.POST(requestBody); //Send the request
    String payload = https.getString(); //Get the response payload

    if(httpCode > 0) {
        String payload = https.getString(); //Get the response payload
        Serial.print("Response Code: ");
        Serial.println(httpCode);   // Print HTTP return code
        Serial.println(payload);    // Print request response payload
    } else {
        Serial.print("Error on sending POST: ");
        Serial.println(https.errorToString(httpCode));
    }
      // Print request response payload

    https.end();  //Close connection
  } else {
    Serial.println("Not connected to WiFi");
  }

  if (t >= 20) {
    digitalWrite(redLampPin, HIGH);
    digitalWrite(greenLampPin, LOW);
    Serial.println(F("Warning temperature is too high!"));
  } else {
    digitalWrite(redLampPin, LOW);
    digitalWrite(greenLampPin, HIGH);
    Serial.println(F("Temperature is within safe limits."));
  }
}
