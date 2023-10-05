#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <DHT.h>

// WiFi credentials
const char* ssid     = "Your-SSID";
const char* password = "Your-Password";

// Pin configuration
const int DHTPin = 2;  // GPIO2
const int redLampPin = 14;  // GPIO14
const int greenLampPin = 12;  // GPIO12

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
  readDHTSensorAndSendData();
  delay(2000); // Send data every 2 seconds
}

void connectToWiFi() {
  Serial.println("Connecting to WiFi...");
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }

  Serial.println("\nConnected to WiFi");
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
    HTTPClient http;
    http.begin("http://localhost/temperature"); //Specify the URL
    http.addHeader("Content-Type", "application/json");

    StaticJsonDocument<200> doc;
    doc["temperature"] = t;
    doc["humidity"] = h;
    String requestBody;
    serializeJson(doc, requestBody);

    int httpCode = http.POST(requestBody); //Send the request
    String payload = http.getString(); //Get the response payload

    Serial.print("HTTP Response Code: ");
    Serial.println(httpCode);   // Print HTTP return code
    Serial.println(payload);    // Print request response payload

    http.end();  //Close connection
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
