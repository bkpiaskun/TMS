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


String serverAddress = "http://192.168.0.58/?urlParameter=asd";  // server address
//"http://example.com/index.html"
int port = 80;

 
WiFiMulti wifi;
int status = WL_IDLE_STATUS;
String response;
int statusCode = 0;




// for DHT22, 
//      VCC: 5V or 3V
//      GND: GND
//      DATA: 2
int pinDHT22 = 5;
SimpleDHT22 dht22(pinDHT22);


  uint8_t measurementCount = 0;
  float temp_temperature = 0;
  float temp_humidity = 0;


void IRAM_ATTR onTimer(){
  // Increment the counter and set the time of ISR
  portENTER_CRITICAL_ISR(&timerMux);
  isrCounter++;
  lastIsrAt = millis();
  portEXIT_CRITICAL_ISR(&timerMux);
  // Give a semaphore that we can check in the loop
  xSemaphoreGiveFromISR(timerSemaphore, NULL);
  // It is safe to use digitalRead/Write here if you want to toggle an output
}

void setup() {
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0);
  delay(1000);
  Serial.begin(115200);
  wifi.addAP("SushiSashimi", "StrzelajDoPolaka");
  timerSemaphore = xSemaphoreCreateBinary();
  timer = timerBegin(0, 80, true);
  timerAttachInterrupt(timer, &onTimer, true);
  timerAlarmWrite(timer, 300000000, true);
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
            } else {
              //temp_temperature = (temp_temperature + temperature) / 2;
              //temp_temperature = (temp_temperature + humidity) / 2;
            }
          }
      }
    measurementCount++;  
  }



  
  // If Timer has fired
  if((wifi.run() == WL_CONNECTED)) {
    if (xSemaphoreTake(timerSemaphore, 0) == pdTRUE){
      uint32_t isrCount = 0, isrTime = 0;
      // Read the interrupt count and time
      portENTER_CRITICAL(&timerMux);
      isrCount = isrCounter;
      isrTime = lastIsrAt;
      portEXIT_CRITICAL(&timerMux);
      //  NOW I NEED TO CALCULATE SOME BITCH ASS STATS

    HTTPClient http;
    http.begin(serverAddress); //HTTP
    http.addHeader("Content-Type","application/x-www-form-urlencoded");

    int httpCode = http.POST(
      "AVG_Humidity="+(String)temp_humidity+"&"+
      "Max_Humidity="+(String)temp_humidity+"&"+
      "Min_Humidity="+(String)temp_humidity+"&"+
      "AVG_Temperature="+(String)temp_temperature+"&"+
      "Max_Temperature="+(String)temp_temperature+"&"+
      "Min_Temperature="+(String)temp_temperature+"&"+
      "MAC="+WiFi.macAddress()+"&"+
      "Password="+"ESPtrzecie"
      );
    //int httpCode = http.GET();
    \
    
    

//    Post.addHeader("operator", "text/plain");  
//    Post.POST("Key=hi&val=jagrut1");
    if(httpCode > 0) {
            // HTTP header has been send and Server response header has been handled
            Serial.printf("[HTTP] GET... code: %d\n", httpCode);

            // file found at server
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
    Serial.println("Wait five seconds");
    Serial.println(temp_humidity);
    Serial.println(temp_temperature);
    Serial.println(measurementCount);
    temp_humidity = 0;
    temp_temperature = 0;
    measurementCount = 0;
    }
  }
}
