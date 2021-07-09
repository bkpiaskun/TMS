#ifndef SensorLib_H_
#define SensorLib_H_

struct ReadingDatagram
{
  float AVG_Humidity = 0;
  float Max_Humidity = 0;
  float Min_Humidity = 0;
  float AVG_Temperature = 0;
  float Max_Temperature = 0;
  float Min_Temperature = 0;
  int PIN;
};

class SensorLib
{
  public:
    virtual void MeasureTemp();
    virtual void ResetTemperature();
    virtual ReadingDatagram CurrentDatagram();
};


#endif
