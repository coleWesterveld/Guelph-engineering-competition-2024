import csv 
import re

days = [["Monday",0],["Tuesday",24],["Wednesday",48],["Thursday",72],["Friday",96],["Saterday",120],["Sunday",144]]

def oCSV() :
    with open("Guelph-engineering-competition-2024/classdates.csv","r") as csvfile:
        courseList = list(csv.reader(csvfile))
        courseList.pop(0)
        courseList.pop(0)

    return courseList

def converTo24Hour(curDay,timeSTR) :

    hour, minute = timeSTR.split(":")

    period = minute[-2:]
    minute = minute[:2]
    hour = int(hour)
    minute = int(minute)

    if period.lower() == 'am':
        if hour == 12:
            hour = 0
    else:  # PM case
        if hour != 12:
            hour += 12
    
    for day in days:
        
        if str(curDay).strip() == str(day[0]):
            hour += day[1]

    return f'{hour:02}:{minute:02}'

def converCSV(courseList) :
    hour24List = []
    for item1 in courseList:
        temp_list = []
        temp_list.append(item1[0])
        for entry in item1:
            if '|' in entry: 
                day, times = entry.split("|")
                startTime,endTime = times.split("-")

                temp_list.append(converTo24Hour(day,startTime))
                temp_list.append(converTo24Hour(day,endTime))
        hour24List.append(temp_list)

    return hour24List

def main() :
    courseList = oCSV()

    hour24List = converCSV(courseList)

    print(hour24List)

main()