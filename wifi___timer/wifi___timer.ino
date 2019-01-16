#include <Arduino.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include "SimpleDHT.h"
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"

hw_timer_t * timer = NULL;
volatile SemaphoreHandle_t timerSemaphore;
portMUX_TYPE timerMux = portMUX_INITIALIZER_UNLOCKED;
volatile uint32_t isrCounter = 0;
volatile uint32_t lastIsrAt = 0;

float maxTemp = -50;
float minTemp = 100;
float minHum = 100;
float maxHum = 0;


String serverAddress = "https://intern.kluchens.eu/";
int port = 80;

WiFiMulti wifi;
int status = WL_IDLE_STATUS;
String response;
int statusCode = 0;

int pinDHT22 = 5;               // pin 5
SimpleDHT22 dht22(pinDHT22);

uint8_t measurementCount = 0;
float temp_temperature = 0;
float temp_humidity = 0;

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
  wifi.addAP("SushiSashimi", "StrzelajDoPolaka");
  timerSemaphore = xSemaphoreCreateBinary();
  timer = timerBegin(0, 80, true);
  timerAttachInterrupt(timer, &onTimer, true);
  int timerInSeconds = 30;
  int MiliSeconds = 1000* timerInSeconds;
  int MicroSeconds = 1000* MiliSeconds;
  timerAlarmWrite(timer, MicroSeconds, true);
  timerAlarmEnable(timer);
}

void loop() {
    delay(1000);
    //################## CALCS
  float temperature = 0;
  float humidity = 0;
  int err = SimpleDHTErrSuccess;
  if ((err = dht22.read2(&temperature, &humidity, NULL)) != SimpleDHTErrSuccess) {
    Serial.print("Read DHT22 failed, err="); 
    Serial.println(err);
    } else {
        if(minTemp > temperature) {minTemp = temperature;}
        if(minHum > humidity) {minHum = humidity;}
        if(maxTemp < temperature) {maxTemp = temperature;}
        if(maxHum < humidity) {maxHum = humidity;}
       if(measurementCount == 0)
       {
          temp_temperature = (float)temperature;
          temp_humidity = (float)humidity;
       } else {
        Serial.print("temp: "+(String)((float)temp_temperature)); 
        Serial.println("humid "+(String)((float)temp_humidity)); 
          if(measurementCount > 1) {
            temp_temperature = (((float)(measurementCount-1)*temp_temperature) + (float)temperature) / measurementCount;
            temp_humidity = (((float)(measurementCount-1)*temp_humidity) + (float)humidity) / measurementCount;
          } else {
            if(measurementCount == 0)
            {
              temp_temperature = (float)temperature;
              temp_temperature = (float)humidity;
            }
          }
      }
    measurementCount++;  
  }
  if((wifi.run() == WL_CONNECTED)) {
    if (xSemaphoreTake(timerSemaphore, 0) == pdTRUE){
      uint32_t isrCount = 0, isrTime = 0;
      portENTER_CRITICAL(&timerMux);
      isrCount = isrCounter;
      isrTime = lastIsrAt;
      portEXIT_CRITICAL(&timerMux);
      HTTPClient http;
      http.begin(serverAddress); //HTTP
      http.addHeader("Content-Type","application/x-www-form-urlencoded");
      int httpCode = http.POST(
        "AVG_Humidity="+(String)temp_humidity+"&"+
        "Max_Humidity="+(String)maxHum+"&"+
        "Min_Humidity="+(String)minHum+"&"+
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
        temp_humidity = 0;
        temp_temperature = 0;
        measurementCount = 0;
    }
  }
}
