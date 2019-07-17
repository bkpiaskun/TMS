#include <Arduino.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"
#include <OneWire.h>
#include <DallasTemperature.h>
#include "EEPROM.h"

hw_timer_t * timer = NULL;
volatile SemaphoreHandle_t timerSemaphore;
portMUX_TYPE timerMux = portMUX_INITIALIZER_UNLOCKED;
volatile uint32_t isrCounter = 0;
volatile uint32_t lastIsrAt = 0;

float maxTemp = -50;
float minTemp = 100;



String serverAddress = "https://intern.kluchens.eu/";
int port = 80;

WiFiMulti wifi;
int status = WL_IDLE_STATUS;
String response;
int statusCode = 0;

int pin = 5;               // pin 5
OneWire  oneWire(pin);
DallasTemperature sensors(&oneWire);

uint8_t measurementCount = 0;
float temp_temperature = 0;





char str[50],ssid[30],key[30];
int state = 0;
int matches = 0;


void IRAM_ATTR onTimer(){
  portENTER_CRITICAL_ISR(&timerMux);
  isrCounter++;
  lastIsrAt = millis();
  portEXIT_CRITICAL_ISR(&timerMux);
  xSemaphoreGiveFromISR(timerSemaphore, NULL);
}

void setup() {
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0);
  delay(1000);
 Serial.begin(115200);
  if (!EEPROM.begin(64)) {
    Serial.println("Failed to initialise EEPROM");
    Serial.println("Restarting...");
    delay(1000);
    ESP.restart();
  }
  for(int i = 0;i<20;i++)
  {
    ssid[i] = 0;
    key[i] = 0;
  }
  for(int i = 0;i<50;i++)
  {
    str[i] = 0;
  }
  char __ssid[30];
  EEPROM.readString(0).toCharArray(__ssid, sizeof(__ssid));
  char __key[30];
  EEPROM.readString(30).toCharArray(__key, sizeof(__key));
  wifi.addAP(__ssid,__key);
  timerSemaphore = xSemaphoreCreateBinary();
  timer = timerBegin(0, 80, true);
  timerAttachInterrupt(timer, &onTimer, true);
  int timerInSeconds = 30;
  int MiliSeconds = 1000* timerInSeconds;
  int MicroSeconds = 1000* MiliSeconds;
  timerAlarmWrite(timer, MicroSeconds, true);
  timerAlarmEnable(timer);
  sensors.begin();
}

void loop() {
  switch( state )
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
  if(Serial.available() && state == 0)
  state = 1;
    
    delay(1000);
    //################## CALCS
 
}

void TemperatureMeasurement()
{
   float temperature = readTemp();
  if (temperature > -50.0f && temperature < 150.0f) {
           if(minTemp > temperature) {minTemp = temperature;}
        if(maxTemp < temperature) {maxTemp = temperature;}
       if(measurementCount == 0)
       {
          temp_temperature = (float)temperature;
       } else {
        Serial.println("Temperature read success: "+(String)((float)temp_temperature)); 
          if(measurementCount > 1) {
            temp_temperature = (((float)(measurementCount-1)*temp_temperature) + (float)temperature) / measurementCount;
          } else {
            if(measurementCount == 0)
            {
              temp_temperature = (float)temperature;
            }
          }
      }
    measurementCount++;  
    } else {
    Serial.print("Reading temperature failed"); 
  }
  if (xSemaphoreTake(timerSemaphore, 0) == pdTRUE){
    uint32_t isrCount = 0, isrTime = 0;
    portENTER_CRITICAL(&timerMux);
    isrCount = isrCounter;
    isrTime = lastIsrAt;
    portEXIT_CRITICAL(&timerMux);
    if((wifi.run() == WL_CONNECTED)) {
      HTTPClient http;
      http.begin(serverAddress); //HTTP
      http.addHeader("Content-Type","application/x-www-form-urlencoded");
      int httpCode = http.POST(
        "AVG_Temperature="+(String)temp_temperature+"&"+
        "Max_Temperature="+(String)maxTemp+"&"+
        "Min_Temperature="+(String)minTemp+"&"+
        "MAC="+WiFi.macAddress()+"&"+
        "Password="+"ESPtrzecie"
        );
      if(httpCode > 0) {
              Serial.printf("[HTTP] GET... code: %d\n", httpCode);
              if(httpCode == HTTP_CODE_OK) {
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
        temp_temperature = 0;
        measurementCount = 0;

        maxTemp = -50;
        minTemp = 100;
    } else {
    Serial.println("WIFI NOT CONNECTED, REBOOT");
    delay(300);
    ESP.restart();
  }
  }
}
float readTemp()
{
  sensors.requestTemperatures(); 
  return sensors.getTempCByIndex(0);
}

bool PrepareConfig()
{
  for (byte i=0; Serial.available(); i++){
     str[i] = Serial.read();
  }     
  matches = sscanf (str,"@WIFI %s %s", &ssid,&key);
  Serial.print("Matched ");Serial.print(matches);Serial.println(" credentials");
  if(matches == 1)
  {
    Serial.print("Wifi SSID is: ");
    Serial.println(ssid);
    state = 2;
    return true;
  }  
  if(matches == 2)
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
  if(matches == 1)
  {
    Serial.print("Wifi SSID is: ");
    Serial.println(ssid);
  }  
  if(matches == 2)
  {
    Serial.print("Wifi Key is: ");
    Serial.println(key);
    Serial.print("Wifi SSID is: ");
    Serial.println(ssid);
  }
  if(Serial.available())
  {
    String action = Serial.readString();
    if(action == "@REJECT")
    {
      Serial.println("Reverting Changes");
      for(int i = 0;i<20;i++)
      {
        ssid[i] = 0;
        key[i] = 0;
      }
      for(int i = 0;i<50;i++)
      {
        str[i] = 0;
      }
    }
    if(action == "@SAVE")
    {
      Serial.println("Saving Changes");      
      CommitChanges();
    }
    state = 0;
  }
  delay(5000);
}

void CommitChanges()
{
  for(int x = 0;x<64;x++)
  {EEPROM.write(x,0);}
  EEPROM.writeString(0,ssid);
  yield();
  EEPROM.writeString(sizeof(ssid),key);
  yield();
  EEPROM.commit();
  for(int i = 0;i<20;i++)
  {
    ssid[i] = 0;
    key[i] = 0;
  }
  for(int i = 0;i<50;i++)
  {
    str[i] = 0;
  }
  Serial.println("Config Saved");
}
