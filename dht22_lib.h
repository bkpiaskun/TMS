#include <SimpleDHT.h>

struct ReadingDatagram {
  float AVG_Humidity;
  float Max_Humidity;
  float Min_Humidity;
  float AVG_Temperature;
  float Max_Temperature;
  float Min_Temperature;
  int PIN;
};

class dht22_lib
{
private:
  int measurementCount, pinDHT22;
  SimpleDHT22 dht22;
  float maxTemp, minTemp, minHum, maxHum, temp_temperature, temp_humidity;

public:
  dht22_lib(int pin);
  void MeasureTemp();
  void ResetTemperature();
  ReadingDatagram CurrentDatagram();
};
