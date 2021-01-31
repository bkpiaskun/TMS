#include "SimpleDHT.h"

#include "SensorLib.h"


class DHT22_lib : public SensorLib
{
  private:
    int measurementCount, pinDHT22;
    SimpleDHT22 dht22;
    float maxTemp, minTemp, minHum, maxHum, temp_temperature, temp_humidity;

  public:
    DHT22_lib(int pin);
    void MeasureTemp();
    void ResetTemperature();
    ReadingDatagram CurrentDatagram();
};
