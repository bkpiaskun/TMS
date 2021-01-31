#include "DS18B20_lib.h"
#include <OneWire.h>
#include <DallasTemperature.h>

DS18B20_lib::DS18B20_lib(int pin)
{
  this->pinDS18B20 = pin;
  this->oneWire = OneWire(pinDS18B20);
  this->DS18B20 = DallasTemperature(&oneWire);
  this->DS18B20.begin();
  this->ResetTemperature();
}

void DS18B20_lib::MeasureTemp()
{
  DS18B20.requestTemperatures();
  int temperature = DS18B20.getTempCByIndex(0);
  if (temperature > -50.0f && temperature < 150.0f)
  {
    if (minTemp > temperature)
    {
      minTemp = temperature;
    }
    if (maxTemp < temperature)
    {
      maxTemp = temperature;
    }
    if (measurementCount == 0)
    {
      temp_temperature = (float)temperature;
    }
    else
    {
      Serial.println("Pin: " + (String)pinDS18B20 + " Temp: " + (String)((float)temp_temperature));
      if (measurementCount > 1)
      {
        temp_temperature = (((float)(measurementCount - 1) * temp_temperature) + (float)temperature) / measurementCount;
      }
      else
      {
        if (measurementCount == 0)
        {
          temp_temperature = (float)temperature;
        }
      }
    }
    measurementCount++;
  }
  else
  {
    Serial.print("Read DS18B20 failed on pin:");
    Serial.println(pinDS18B20);
    Serial.println("TEMP: " + (String)temperature);
  }
}

void DS18B20_lib::ResetTemperature()
{
  measurementCount = 0;
  maxTemp = -50;
  minTemp = 100;
  temp_temperature = minTemp;
}

ReadingDatagram DS18B20_lib::CurrentDatagram()
{
  ReadingDatagram dtm;
  dtm.Max_Temperature = maxTemp;
  dtm.Min_Temperature = minTemp;
  dtm.AVG_Temperature = temp_temperature;
  dtm.PIN = pinDS18B20;
  return dtm;
}
