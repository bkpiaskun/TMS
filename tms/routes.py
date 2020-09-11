from flask import  request, Response, jsonify
from tms import app,db
from tms.models import User,Sensor,SensorLog,SensorReading

@app.route('/', methods=['POST'])
def getData():
    passwd = request.values.get('Password')
    mac = request.values.get('MAC')
    sensor = db.session.query(Sensor).filter_by(password=passwd,mac_address=mac).first()
    AVG_Humidity = request.values.get('AVG_Humidity')
    Max_Humidity = request.values.get('Max_Humidity')
    Min_Humidity = request.values.get('Min_Humidity')
    AVG_Temperature = request.values.get('AVG_Temperature')
    Max_Temperature = request.values.get('Max_Temperature')
    Min_Temperature = request.values.get('Min_Temperature')

    if sensor is not None:
        read = SensorReading()
        read.sensor_id = sensor.sensor_id
        read.mac_address = mac
        read.password = passwd
        read.avg_humidity = AVG_Humidity
        read.max_humidity = Max_Humidity
        read.min_humidity = Min_Humidity
        read.avg_temperature = AVG_Temperature
        read.max_temperature = Max_Temperature
        read.min_temperature = Min_Temperature
        db.session.add(read)
        db.session.commit()
        response = Response("Record Created")
        response.headers["Access-Control-Allow-Origin"] = "*"
        return response
    else:
        log = SensorLog()
        log.mac_address = mac
        log.password = passwd
        log.avg_humidity = AVG_Humidity
        log.max_humidity = Max_Humidity
        log.min_humidity = Min_Humidity
        log.avg_temperature = AVG_Temperature
        log.max_temperature = Max_Temperature
        log.min_temperature = Min_Temperature
        db.session.add(log)
        db.session.commit()
        response = Response("malfunction reported")
        response.headers["Access-Control-Allow-Origin"] = "*"
        return response

@app.route('/LAST', methods=['GET'])
def last():
    SensorReadings = db.session.execute(""" SELECT temptable1.id,
    temptable1.sensor_name,
    concat(
        CASE
            WHEN date_part('hour'::text, temptable1.difftime) > 0::double precision THEN concat(date_part('hour'::text, temptable1.difftime), ' godzin ')
            ELSE ''::text
        END,
        CASE
            WHEN date_part('minute'::text, temptable1.difftime) > 0::double precision THEN concat(date_part('minute'::text, temptable1.difftime), ' minut ')
            ELSE ''::text
        END, round(date_part('second'::text, temptable1.difftime))::text, ' sekund temu') AS timestamp_of_reading,
    temptable1.avg_humidity,
    temptable1.max_humidity,
    temptable1.min_humidity,
    temptable1.avg_temperature,
    temptable1.max_temperature,
    temptable1.min_temperature
   FROM ( SELECT ttable.id,
            ttable.sensor_name,
            ttable.timestamp_of_reading,
            ttable.avg_humidity,
            ttable.max_humidity,
            ttable.min_humidity,
            ttable.avg_temperature,
            ttable.max_temperature,
            ttable.min_temperature,
            now() - ttable.timestamp_of_reading AS difftime
           FROM "LAST_Measurements" ttable) temptable1
  ORDER BY temptable1.difftime;""")
    readings_dict = []
    for read in SensorReadings:
        temp_dict = dict()
        for item in read.items():
            temp_dict[item[0]] = str(item[1])
        readings_dict.append(temp_dict)
    response = jsonify(readings_dict)

    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

@app.route('/MyLasts', methods=['GET'])
def MyLasts():
    username = request.args.get('UserName')
    apikey = request.args.get('ApiKey')
    API_Version = request.args.get('ApiVersion')
    sql = """SELECT *
    FROM (
    SELECT temptable1.ID AS ID,
    temptable1.Sensor_Name AS Sensor_Name, 
	CONCAT( case when date_part('hour'::text, temptable1.diffTime) > 0 then CONCAT(date_part('hour'::text, temptable1.diffTime),' godzin ') else  ''  end, case when date_part('MINUTE'::text, temptable1.diffTime) > 0 then CONCAT(	date_part('MINUTE'::text, temptable1.diffTime),' minut ', round(date_part('SECOND'::text,temptable1.diffTime)),' sekund temu') end ) AS Timestamp_Of_Reading,
    temptable1.AVG_Humidity AS AVG_Humidity,
    temptable1.Max_Humidity AS Max_Humidity,
    temptable1.Min_Humidity AS Min_Humidity,
    temptable1.AVG_Temperature AS AVG_Temperature,
    temptable1.Max_Temperature AS Max_Temperature,
    temptable1.Min_Temperature AS Min_Temperature
    FROM (
    SELECT ttable.ID AS ID,
    ttable.Sensor_Name AS Sensor_Name,
    ttable.Timestamp_Of_Reading AS Timestamp_Of_Reading,
    ttable.AVG_Humidity AS AVG_Humidity,
    ttable.Max_Humidity AS Max_Humidity,
    ttable.Min_Humidity AS Min_Humidity,
    ttable.AVG_Temperature AS AVG_Temperature,
    ttable.Max_Temperature AS Max_Temperature,
    ttable.Min_Temperature AS Min_Temperature, 
    NOW() - ttable.Timestamp_Of_Reading AS diffTime
    FROM (
    SELECT *
    FROM "RAW_Last_Measurements" rlm
    JOIN Users us ON rlm.Sensor_Owner = us.User_ID
    WHERE us.UserName = :usr AND us.API_KEY = :api) ttable
    ) temptable1
    ORDER BY temptable1.diffTime) ttj;"""
    if API_Version == "1.1":
        sql = """SELECT 
                ttable.ID AS ID,
                ttable.Sensor_Name AS Sensor_Name,
                ttable.Timestamp_Of_Reading AS Timestamp_Of_Reading,
                ttable.AVG_Humidity AS AVG_Humidity,
                ttable.Max_Humidity AS Max_Humidity,
                ttable.Min_Humidity AS Min_Humidity,
                ttable.AVG_Temperature AS AVG_Temperature,
                ttable.Max_Temperature AS Max_Temperature,
                ttable.Min_Temperature AS Min_Temperature
                FROM (
                    SELECT *
                    FROM "RAW_Last_Measurements" rlm
                    JOIN Users us ON rlm.Sensor_Owner = us.User_ID
                    WHERE us.UserName = :usr AND us.API_KEY = :api
                ) ttable
                ORDER BY ttable.Timestamp_Of_Reading;"""

    SensorReadings = db.session.execute(sql,{"usr": username,"api": apikey})

    readings_dict = []
    for read in SensorReadings:
        temp_dict = dict()
        for item in read.items():
            temp_dict[item[0]] = str(item[1])
        readings_dict.append(temp_dict)
    response = jsonify(readings_dict)

    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

@app.route('/Validate', methods=['GET'])
def Validate():
    username = request.args.get('UserName')
    apikey = request.args.get('ApiKey')
    UserValidation = "Failure"

    checked_user = db.session.query(User).filter_by(username=username,api_key=apikey).first()
    if checked_user is not None:
        UserValidation = "Success"

    response = jsonify(UserValidation)
    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

@app.route('/showSensors', methods=['GET'])
def showSensors():
    username = request.args.get('UserName')
    apikey = request.args.get('ApiKey')
    sensors = db.session.query(Sensor).select_from(Sensor).join(User,User.user_id == Sensor.user_id).filter(User.username==username,User.api_key==apikey).all()
    
    sensor_dict = []
    for sens in sensors:
        temp_dict = {}
        temp_dict["Sensor_Id"] = str(sens.sensor_id)
        temp_dict["Sensor_Name"] = str(sens.sensor_name)
        sensor_dict.append(temp_dict)
    response = jsonify(sensor_dict)
    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

@app.route('/showSensorAveraged', methods=['GET'])
def showSensorAveraged():

    startDate= request.args.get('StartDate')
    enddate= request.args.get('EndDate')
    sensor_id= request.args.get('Sensor_ID')

    from sqlalchemy.sql import text
    sql = """SELECT 
	  ttj.dateDay,
	  ttj.dateHour,
	  ttj.AVG_Temperature,
	  ttj.AVG_Humidity
from (
select
	date(Timestamp_Of_Reading) dateDay,
 	(extract( hour from Timestamp_Of_Reading)) dateHour,
   avg(AVG_Temperature) AVG_Temperature,
	avg(AVG_Humidity) AVG_Humidity
FROM (
	SELECT Timestamp_Of_Reading,AVG_Temperature,AVG_Humidity
	FROM Sensor_Readings sr
	WHERE 
		sr.Timestamp_Of_Reading >= :sdate AND
		sr.Timestamp_Of_Reading <= :edate and
		sr.Sensor_ID = :s_ID
	) xd
group by date(Timestamp_Of_Reading),(extract(hour from Timestamp_Of_Reading))
ORDER BY dateDay ASC,dateHour ASC
) ttj"""
    params = {"sdate": startDate,"edate": enddate,"s_ID": sensor_id}
    data_fetched = db.session.execute(sql,params)
    
    data_dict = []
    for read in data_fetched:
        temp_dict = dict()
        for item in read.items():
            temp_dict[item[0]] = str(item[1])
        data_dict.append(temp_dict)
    response = jsonify(data_dict)

    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

@app.route('/showAveragedData', methods=['GET'])
def showAveragedData():

    startDate= request.args.get('StartDate')
    enddate= request.args.get('EndDate')
    username= request.args.get('UserName')
    api_key= request.args.get('ApiKey')

    from sqlalchemy.sql import text
    sql = """SELECT 
	  ttj.dateDay,
	  ttj.dateHour,
	  ttj.AVG_Temperature,
	  ttj.AVG_Humidity,
      ttj.Sensor_Name
from (
select
	date(Timestamp_Of_Reading) dateDay,
 	(extract( hour from Timestamp_Of_Reading)) dateHour,
   avg(AVG_Temperature) AVG_Temperature,
	avg(AVG_Humidity) AVG_Humidity,
    Sensor_Name
FROM (
	SELECT Timestamp_Of_Reading,AVG_Temperature,AVG_Humidity,Sensor_Name
	FROM Sensor_Readings sr
    JOIN Sensors snrs
    ON sr.Sensor_ID = snrs.Sensor_ID
    JOIN Users usr
    ON usr.User_ID = snrs.User_ID
	WHERE 
		sr.Timestamp_Of_Reading >= :sdate AND
		sr.Timestamp_Of_Reading <= :edate and
        usr.UserName like :username AND
        usr.API_KEY like :apikey
	) xd
group by Sensor_Name,date(Timestamp_Of_Reading),(extract(hour from Timestamp_Of_Reading))
ORDER BY Sensor_Name,dateDay ASC,dateHour ASC
) ttj"""
    params = {"sdate": startDate, "edate": enddate, "username": username, "apikey": api_key}
    data_fetched = db.session.execute(sql,params)
    
    data_dict = []
    for read in data_fetched:
        temp_dict = dict()
        for item in read.items():
            temp_dict[item[0]] = str(item[1])
        data_dict.append(temp_dict)
    response = jsonify(data_dict)

    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

@app.route('/status', methods=['GET'])
def status():
    try:
        from sqlalchemy.sql import text
        sql = """select 'Working' as status"""
        data_fetched = db.session.execute(sql)
        
        data_dict = []
        for read in data_fetched:
            temp_dict = dict()
            for item in read.items():
                temp_dict[item[0]] = str(item[1])
            data_dict.append(temp_dict)
    except:
        data_dict = [{status: 'Failure'}]
    response = jsonify(data_dict)

    response.headers["Access-Control-Allow-Origin"] = "*"
    return response
