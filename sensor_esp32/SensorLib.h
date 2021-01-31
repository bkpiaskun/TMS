#ifndef SensorLib_H_
#define SensorLib_H_

struct ReadingDatagram
{
  float AVG_Humidity;
  float Max_Humidity;
  float Min_Humidity;
  float AVG_Temperature;
  float Max_Temperature;
  float Min_Temperature;
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
