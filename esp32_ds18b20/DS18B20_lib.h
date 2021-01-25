#include <OneWire.h>
#include <DallasTemperature.h>

struct ReadingDatagram
{
  float AVG_Temperature;
  float Max_Temperature;
  float Min_Temperature;
  int PIN;
};

class DS18B20_lib
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
