#include <OneWire.h>
#include <DallasTemperature.h>

#include "SensorLib.h"

class DS18B20_lib : public SensorLib
{
  private:
    int measurementCount, pinDS18B20;
    OneWire oneWire;
    DallasTemperature DS18B20;
    float maxTemp, minTemp, temp_temperature;

  public:
    DS18B20_lib(int pin);
    void MeasureTemp();
    void ResetTemperature();
    ReadingDatagram CurrentDatagram();
};
