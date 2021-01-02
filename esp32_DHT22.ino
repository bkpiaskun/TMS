#include <Arduino.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include <SimpleDHT.h>
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"
#include "EEPROM.h"
#include "dht22_lib.h"

hw_timer_t *timer = NULL;
volatile SemaphoreHandle_t timerSemaphore;
portMUX_TYPE timerMux = portMUX_INITIALIZER_UNLOCKED;
volatile uint32_t isrCounter = 0;
volatile uint32_t lastIsrAt = 0;

String serverAddress = "http://TMS.Server.org/";
int port = 80;

WiFiMulti wifi;
int status = WL_IDLE_STATUS;
String response;
int statusCode = 0;

char str[50], ssid[30], key[30];
int state = 0;
int matches = 0;

dht22_lib sensor_array[] = {
    dht22_lib(5),
    dht22_lib(13),
    dht22_lib(14),
    dht22_lib(15),
    dht22_lib(27)
};

void IRAM_ATTR onTimer()
{
  portENTER_CRITICAL_ISR(&timerMux);
  isrCounter++;
  lastIsrAt = millis();
  portEXIT_CRITICAL_ISR(&timerMux);
  xSemaphoreGiveFromISR(timerSemaphore, NULL);
}

void setup()
{
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0);
  delay(1000);
  Serial.begin(115200);
  if (!EEPROM.begin(64))
  {
    Serial.println("Failed to initialise EEPROM");
    Serial.println("Restarting...");
    delay(1000);
    ESP.restart();
  }
  for (int i = 0; i < 20; i++)
  {
    ssid[i] = 0;
    key[i] = 0;
  }
  for (int i = 0; i < 50; i++)
  {
    str[i] = 0;
  }
  char __ssid[30];
  EEPROM.readString(0).toCharArray(__ssid, sizeof(__ssid));
  char __key[30];
  EEPROM.readString(30).toCharArray(__key, sizeof(__key));
  wifi.addAP(__ssid, __key);
  timerSemaphore = xSemaphoreCreateBinary();
  timer = timerBegin(0, 80, true);
  timerAttachInterrupt(timer, &onTimer, true);
  int timerInSeconds = 30;
  int MiliSeconds = 1000 * timerInSeconds;
  int MicroSeconds = 1000 * MiliSeconds;
  timerAlarmWrite(timer, MicroSeconds, true);
  timerAlarmEnable(timer);
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
  for (int i = 0; i < sizeof(sensor_array)/sizeof(sensor_array[0]); i++)
  {
    sensor_array[i].MeasureTemp();
  }
  if (xSemaphoreTake(timerSemaphore, 0) == pdTRUE)
  {
    uint32_t isrCount = 0, isrTime = 0;
    portENTER_CRITICAL(&timerMux);
    isrCount = isrCounter;
    isrTime = lastIsrAt;
    portEXIT_CRITICAL(&timerMux);
    if ((wifi.run() == WL_CONNECTED))
    {
      for (int i = 0; i < sizeof(sensor_array)/sizeof(sensor_array[0]); i++)
      {
        ReadingDatagram datagram = sensor_array[i].CurrentDatagram();
        PushDataToServer(datagram);
        sensor_array[i].ResetTemperature();
      }
    }
    else
    {
      Serial.println("Wifi not connected, restarting...");
      ESP.restart();
    }
  }
}

bool PrepareConfig()
{
  for (byte i = 0; Serial.available(); i++)
  {
    str[i] = Serial.read();
  }
  matches = sscanf(str, "@WIFI %s %s", &ssid, &key);
  Serial.print("Matched ");
  Serial.print(matches);
  Serial.println(" credentials");
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
  delay(5000);
}

bool PushDataToServer(ReadingDatagram data)
{
  HTTPClient http;
  http.begin(serverAddress); //HTTP
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
  int httpCode = http.POST(
                   "AVG_Humidity=" + (String)data.AVG_Humidity + "&" +
                   "Max_Humidity=" + (String)data.Max_Humidity + "&" +
                   "Min_Humidity=" + (String)data.Min_Humidity + "&" +
                   "AVG_Temperature=" + (String)data.AVG_Temperature + "&" +
                   "Max_Temperature=" + (String)data.Max_Temperature + "&" +
                   "Min_Temperature=" + (String)data.Min_Temperature + "&" +
                   "MAC=" + WiFi.macAddress() + "&" +
                   "Password=" + "ESPtrzecie" + "&" +
                   "API_VER=" + "1.1" + "&" +
                   "Sensor_PIN=" + (String)data.PIN);
  if (httpCode > 0)
  {
    Serial.printf("[HTTP] GET... code: %d\n", httpCode);
    if (httpCode == HTTP_CODE_OK)
    {
      String payload = http.getString();
      Serial.println(payload);
    }
  }
  else
  {
    Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
  }
  http.end();
  Serial.print("Status code: ");
  Serial.println(httpCode);
  Serial.print("Response: ");
  Serial.println(response);

}

void CommitChanges()
{
  EEPROM.writeString(0, ssid);
  yield();
  EEPROM.writeString(sizeof(ssid), key);
  yield();
  EEPROM.commit();
  Serial.println("Config Saved");
}
