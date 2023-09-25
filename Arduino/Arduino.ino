#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <BearSSLHelpers.h>

// Replace with your network credentials
const char* ssid     = "BS14-STUDENTS-BYOD";
const char* password = "322984238";

void setup() {
  Serial.begin(115200);
  delay(1000);  // Add a delay to ensure Serial is initialized
  
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
  }
  Serial.println("Connected to WiFi");
  delay(1000);

  BearSSL::WiFiClientSecure client;
  client.setInsecure();

  HTTPClient https;
  https.begin(client, "https://steamcommunity.com/market/itemordershistogram?country=DE&language=english&currency=23&item_nameid=176042546&two_factor=0");
  int httpCode = http.GET();
  Serial.print("HTTP Response Code: ");
  Serial.println(httpCode);

  if (httpCode > 0) { //Check the returning code
    String payload = http.getString(); //Get the request response payload
    Serial.println(payload); //Print the response payload
  }

  http.end();

}

void loop() {
  if (WiFi.status() == WL_CONNECTED) { //Check WiFi connection status
    WiFiClient client;
    HTTPClient http;

    http.begin(client, "https://steamcommunity.com/market/itemordershistogram?country=DE&language=english&currency=23&item_nameid=176042546&two_factor=0"); //Specify the URL
    int httpCode = http.GET(); //Send the request

    if (httpCode > 0) { //Check the returning code
      String payload = http.getString(); //Get the request response payload
      Serial.println(payload); //Print the response payload
    }

    http.end(); //Close connection
  }

  delay(10000); //Send a request every 10 seconds
}
