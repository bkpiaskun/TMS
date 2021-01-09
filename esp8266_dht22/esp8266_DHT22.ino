#include <ESP8266WiFi.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include "EEPROM.h"
#include <Ticker.h>

#include <OneWire.h>
#include <DallasTemperature.h>

#include "dht22_lib.h"


Ticker blinker;

String serverAddress = "http://TMS.Server.org/";
int port = 80;

dht22_lib sensor_array[] = {
  dht22_lib(D1),
  dht22_lib(D2),
  dht22_lib(D3),
  dht22_lib(D6),
  dht22_lib(D5)
};

char str[50], ssid[30], key[30];
int state = 0;
int matches = 0;

bool timeToPublish = false;
ESP8266WiFiMulti WiFiMulti;
int status = WL_IDLE_STATUS;
String response;
int statusCode = 0;

void onTime() {
  timeToPublish = true;
}

void setup()
{
  Serial.begin(74880);
  Serial.println("ESP8266 START");
  blinker.attach(30, onTime);
  for (int i = 0; i < 20; i++)
  {
    ssid[i] = 0;
    key[i] = 0;
  }
  for (int i = 0; i < 50; i++)
  {
    str[i] = 0;
  }
  loadCredentials();
  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP(ssid, key);
}

void loop()
{
  switch (state)
  {
    case 0:
      TemperatureMeasurement();
      break;
    case 1:
      PrepareConfig();
      break;
    case 2:
      WaitForSaveConfirmation();
      break;
  }
  if (Serial.available() && state == 0)
    state = 1;
  delay(1000);
}

void TemperatureMeasurement()
{
  for (int i = 0; i < sizeof(sensor_array) / sizeof(sensor_array[0]); i++)
  {
    sensor_array[i].MeasureTemp();
  }
  if (timeToPublish) {
    timeToPublish = false;
    if ((WiFiMulti.run() == WL_CONNECTED)) {
      for (int i = 0; i < sizeof(sensor_array) / sizeof(sensor_array[0]); i++)
      {
        ReadingDatagram datagram = sensor_array[i].CurrentDatagram();
        PushDataToServer(datagram);
        sensor_array[i].ResetTemperature();
      }
    } else {
      Serial.println("WIFI NOT CONNECTED, REBOOT");
      delay(300);
      ESP.restart();
    }
  }
}

bool PushDataToServer(ReadingDatagram data)
{
  HTTPClient http;
  http.begin(serverAddress); //HTTP
  Serial.println(serverAddress);
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
  int httpCode = http.POST(
                   "AVG_Temperature=" + (String)data.AVG_Temperature + "&" +
                   "Max_Temperature=" + (String)data.Max_Temperature + "&" +
                   "Min_Temperature=" + (String)data.Min_Temperature + "&" +
                   "AVG_Humidity=" + (String)data.AVG_Humidity + "&" +
                   "Max_Humidity=" + (String)data.Max_Humidity + "&" +
                   "Min_Humidity=" + (String)data.Min_Humidity + "&" +
                   "MAC=" + WiFi.macAddress() + "&" +
                   "Password=" + "ESPtrzecie" + "&" +
                   "ApiVersion=" + "1.1" + "&" +
                   "Sensor_PIN=" + (String)data.PIN);
  if (httpCode > 0) {
    Serial.printf("[HTTP] GET... code: %d\n", httpCode);
    if (httpCode == HTTP_CODE_OK) {
      String payload = http.getString();
      Serial.println(payload);
    }
  } else {
    Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
  }
  http.end();
  Serial.print("Status code: ");
  Serial.println(httpCode);
  Serial.print("Response: ");
  Serial.println(response);
}

bool PrepareConfig()
{
  for (byte i = 0; Serial.available(); i++) {
    str[i] = Serial.read();
  }
  matches = sscanf (str, "@WIFI %s %s", &ssid, &key);
  Serial.print("Matched "); Serial.print(matches); Serial.println(" credentials");
  if (matches == 1)
  {
    Serial.print("Wifi SSID is: ");
    Serial.println(ssid);
    state = 2;
    return true;
  }
  if (matches == 2)
  {
    Serial.print("Wifi Key is: ");
    Serial.println(key);
    Serial.print("Wifi SSID is: ");
    Serial.println(ssid);
    state = 2;
    return true;
  }
  state = 0;
  return false;
}

void WaitForSaveConfirmation()
{
  Serial.println("To save changes print @SAVE, to reject print @REJECT");
  if (matches == 1)
  {
    Serial.print("Wifi SSID is: ");
    Serial.println(ssid);
  }
  if (matches == 2)
  {
    Serial.print("Wifi Key is: ");
    Serial.println(key);
    Serial.print("Wifi SSID is: ");
    Serial.println(ssid);
  }
  if (Serial.available())
  {
    String action = Serial.readString();
    Serial.print("Read ");
    Serial.println(action);
    if (action == "@REJECT")
    {
      Serial.println("Reverting Changes");
      for (int i = 0; i < 20; i++)
      {
        ssid[i] = 0;
        key[i] = 0;
      }
      for (int i = 0; i < 50; i++)
      {
        str[i] = 0;
      }
    }
    if (action == "@SAVE")
    {
      Serial.println("Saving Changes");
      CommitChanges();
    }
    state = 0;
  }
  delay(3000);
}

void CommitChanges()
{
  Serial.println("Config will now be saved");
  saveCredentials();
  for (int i = 0; i < 20; i++)
  {
    ssid[i] = 0;
    key[i] = 0;
  }
  for (int i = 0; i < 50; i++)
  {
    str[i] = 0;
  }
  WiFiMulti.addAP(ssid, key);
  Serial.println("Config Saved");
}

void loadCredentials() {
  EEPROM.begin(512);
  EEPROM.get(0, ssid);
  EEPROM.get(0 + sizeof(ssid), key);
  char ok[2 + 1];
  EEPROM.get(0 + sizeof(ssid) + sizeof(key), ok);
  EEPROM.end();
  if (String(ok) != String("OK")) {
    ssid[0] = 0;
    key[0] = 0;
  }
  Serial.println("Recovered credentials:");
  Serial.println(ssid);
  Serial.println(strlen(key) > 0 ? "********" : "<no password>");
}

void saveCredentials() {
  EEPROM.begin(512);
  EEPROM.put(0, ssid);
  EEPROM.put(0 + sizeof(ssid), key);
  char ok[2 + 1] = "OK";
  EEPROM.put(0 + sizeof(ssid) + sizeof(key), ok);
  EEPROM.commit();
  EEPROM.end();
}
