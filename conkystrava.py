#!/usr/bin/python
from __future__ import division
import requests
from pprint import pprint
import json
import sys,getopt
import time
from calendar import timegm
import os

sentinel_file = "strava_sentinel_file"
strava_api_key = ''
sentinel_valid_time = 3600
page = 1
history = 0
def store_sentinel(s):
  f = open(sentinel_file, "w")
  json.dump(s,f)
  f.close

def get_sentinel():
  f = open(sentinel_file, "r")
  return json.load(f)

def sentinel_exists():
  return os.path.isfile(sentinel_file)

def sentinel_changetime():
  return os.path.getmtime(sentinel_file)

def fetch_strava_from_api():
    url = "https://www.strava.com/api/v3/athlete/activities" 

    headers = {
     'accept': "application/json",
     'authorization': "Bearer " + strava_api_key,
     'cache-control': "no-cache",
    }
    #querystring = {"after":start_epoch_time,"per_page":"100","page":page,"before":end_epoch_time}
    querystring =""
    response = requests.request("GET", url, headers=headers, params=querystring)
    data = json.loads(response.text)
    return data



def main(argv):
  
  if sentinel_exists():
      if time.time() - sentinel_changetime() > sentinel_valid_time:
        data = fetch_strava_from_api()
        store_sentinel(data)
      else:
        data = get_sentinel()
  else:
      data = fetch_strava_from_api()
      store_sentinel(data)
  if "date" in sys.argv:
    print str(data[history]['start_date'])
  if "power" in sys.argv:
     print str(str(data[history]['weighted_average_watts']) + "W")
  if "distance" in sys.argv:
     print str(str(data[history]['distance']/1000) + "km")
  if "elevation" in sys.argv:
     print str(str(data[history]['total_elevation_gain']) + "m")
  if "speed" in sys.argv:
     print str(str('%.2f' %((data[history]['distance']/data[history]['moving_time'])*3.6)) + "km/h")



  exit()
  

if __name__ == "__main__":
   main(sys.argv[1:])

