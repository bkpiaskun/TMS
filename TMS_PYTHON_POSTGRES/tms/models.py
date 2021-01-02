# coding: utf-8
from sqlalchemy import BigInteger, Column, Date, DateTime, Float, ForeignKey, String, Table, Text, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from json import JSONEncoder
import datetime

Base = declarative_base()
metadata = Base.metadata

t_LAST_Measurements = Table(
    'LAST_Measurements', metadata,
    Column('id', BigInteger),
    Column('sensor_name', String(30)),
    Column('timestamp_of_reading', DateTime(True)),
    Column('avg_humidity', Float(53)),
    Column('max_humidity', Float(53)),
    Column('min_humidity', Float(53)),
    Column('avg_temperature', Float(53)),
    Column('max_temperature', Float(53)),
    Column('min_temperature', Float(53)),
    schema='temperaturemeasuresite'
)

t_Measurements_With_Differences = Table(
    'Measurements_With_Differences', metadata,
    Column('id', BigInteger),
    Column('sensor_name', String(30)),
    Column('timestamp_of_reading', Text),
    Column('avg_humidity', Float(53)),
    Column('max_humidity', Float(53)),
    Column('min_humidity', Float(53)),
    Column('avg_temperature', Float(53)),
    Column('max_temperature', Float(53)),
    Column('min_temperature', Float(53)),
    schema='temperaturemeasuresite'
)

t_RAW_Last_Measurements = Table(
    'RAW_Last_Measurements', metadata,
    Column('id', BigInteger),
    Column('sensor_id', BigInteger),
    Column('sensor_owner', BigInteger),
    Column('sensor_name', String(30)),
    Column('timestamp_of_reading', DateTime(True)),
    Column('avg_humidity', Float(53)),
    Column('max_humidity', Float(53)),
    Column('min_humidity', Float(53)),
    Column('avg_temperature', Float(53)),
    Column('max_temperature', Float(53)),
    Column('min_temperature', Float(53)),
    schema='temperaturemeasuresite'
)

class SensorLog(Base):
    __tablename__ = 'sensor_log'
    __table_args__ = {'schema': 'temperaturemeasuresite'}

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('\"temperaturemeasuresite\".sensor_log_id_seq'::regclass)"))
    sensor_id = Column(BigInteger, index=True)
    timestamp_of_reading = Column(DateTime(True))
    avg_humidity = Column(Float(53))
    max_humidity = Column(Float(53))
    min_humidity = Column(Float(53))
    avg_temperature = Column(Float(53))
    max_temperature = Column(Float(53))
    min_temperature = Column(Float(53))
    mac_address = Column(String(30), nullable=False)
    password = Column(String(30), nullable=False)

class SensorReading(Base):
    __tablename__ = 'sensor_readings'
    __table_args__ = {'schema': 'temperaturemeasuresite'}

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('\"temperaturemeasuresite\".sensor_readings_id_seq'::regclass)"))
    sensor_id = Column(BigInteger, nullable=False, index=True)
    timestamp_of_reading = Column(DateTime(True), index=True, default=datetime.datetime.utcnow)
    avg_humidity = Column(Float(53))
    max_humidity = Column(Float(53))
    min_humidity = Column(Float(53))
    avg_temperature = Column(Float(53))
    max_temperature = Column(Float(53))
    min_temperature = Column(Float(53))
        
class Sensor(Base):
    __tablename__ = 'sensors'
    __table_args__ = {'schema': 'temperaturemeasuresite'}

    sensor_id = Column(BigInteger, primary_key=True, server_default=text("nextval('\"temperaturemeasuresite\".sensors_sensor_id_seq'::regclass)"))
    user_id = Column(BigInteger, nullable=False, index=True, server_default=text("'0'::bigint"))
    sensor_name = Column(String(30), nullable=False)
    mac_address = Column(String(30), nullable=False, unique=True)
    password = Column(String(30), nullable=False)

class User(Base):
    __tablename__ = 'users'
    __table_args__ = {'schema': 'temperaturemeasuresite'}

    user_id = Column(BigInteger, primary_key=True, server_default=text("nextval('\"temperaturemeasuresite\".users_user_id_seq'::regclass)"))
    username = Column(String(50), nullable=False, unique=True, server_default=text("'0'::character varying"))
    name = Column(String(50), nullable=False, server_default=text("'0'::character varying"))
    surname = Column(String(50), nullable=False, server_default=text("'0'::character varying"))
    api_key = Column(String(50), nullable=False, unique=True, server_default=text("'0'::character varying"))

class SensorParam(Base):
    __tablename__ = 'Sensor_Param'
    __table_args__ = {'schema': 'temperaturemeasuresite'}

    ID = Column(BigInteger, primary_key=True)
    Sensor_ID = Column(ForeignKey('temperaturemeasuresite.sensors.sensor_id'), nullable=False)
    Param_Name = Column(String, nullable=False)
    Param_Value = Column(String, nullable=False)
    Updated_Date = Column(Date)

    sensor = relationship('Sensor')
