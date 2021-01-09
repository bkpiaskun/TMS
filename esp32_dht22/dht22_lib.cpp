#include "dht22_lib.h"
#include "SimpleDHT.h"

dht22_lib::dht22_lib(int pin)
{
  this->pinDHT22 = pin;
  this->dht22 = SimpleDHT22(pin);
}

void dht22_lib::MeasureTemp()
{
  float temperature = 0;
  float humidity = 0;
  int err = SimpleDHTErrSuccess;
  if ((err = dht22.read2(&temperature, &humidity, NULL)) != SimpleDHTErrSuccess)
  {
    Serial.print("Read DHT22 failed on pin:");
    Serial.print(pinDHT22);
    Serial.print(", err=");
    Serial.println(err);
  }
  else
  {
    if (minTemp > temperature)
    {
      minTemp = temperature;
    }
    if (minHum > humidity)
    {
      minHum = humidity;
    }
    if (maxTemp < temperature)
    {
      maxTemp = temperature;
    }
    if (maxHum < humidity)
    {
      maxHum = humidity;
    }
    if (measurementCount == 0)
    {
      temp_temperature = (float)temperature;
      temp_humidity = (float)humidity;
    }
    else
    {
      Serial.println("Pin: " + (String)pinDHT22 + " Temp: " + (String)((float)temp_temperature) + " Humid " + (String)((float)temp_humidity));

      if (measurementCount > 1)
      {
        temp_temperature = (((float)(measurementCount - 1) * temp_temperature) + (float)temperature) / measurementCount;
        temp_humidity = (((float)(measurementCount - 1) * temp_humidity) + (float)humidity) / measurementCount;
      }
      else
      {
        if (measurementCount == 0)
        {
          temp_temperature = (float)temperature;
          temp_temperature = (float)humidity;
        }
      }
    }
    measurementCount++;
  }
}

void dht22_lib::ResetTemperature()
{
  measurementCount = 0;
  maxTemp = -50;
  minTemp = 100;
  minHum = 100;
  maxHum = -1;
  temp_temperature = minTemp;
  temp_humidity = minHum;
}

ReadingDatagram dht22_lib::CurrentDatagram()
{
  ReadingDatagram dtm;
  dtm.Max_Temperature = maxTemp;
  dtm.Min_Temperature = minTemp;
  dtm.Min_Humidity = minHum;
  dtm.Max_Humidity = maxHum;
  dtm.AVG_Temperature = temp_temperature;
  dtm.AVG_Humidity = temp_humidity;
  dtm.PIN = pinDHT22;
  return dtm;
}
