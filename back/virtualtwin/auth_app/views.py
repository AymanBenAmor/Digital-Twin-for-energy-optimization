import math
import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
import requests

# Constants for the weather API
from .models import TimeRecord

API_KEY_TEMP = "d0ff7195961030c16384ba1faab66519"
CITY = "Sfax"
BASE_URL_TEMP = f"http://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY_TEMP}&units=metric"



# Utility function to fetch weather data
def fetch_weather_data():
    response = requests.get(BASE_URL_TEMP)
    if response.status_code == 200:
        data = response.json()
        return data
    else:
        print("Error fetching data from OpenWeatherMap API")
        return None

# Utility function to get the temperature
def get_temperature():
    data = fetch_weather_data()
    if data:
        print(f"Temperature outside: {data['main']['temp']}°C")
        return data['main']['temp']
    return None

def get_humidity():
    data = fetch_weather_data()
    if data:
        print(f"humidity : {data['main']['humidity'] }%")
        return data['main']['humidity']
    return None


#Constants for solar radiation
api_key_solar_rad = "60f0450b275045648ee6690aef9d1b2c"
base_url_solar_rad = f"https://api.weatherbit.io/v2.0/current?city={CITY}&key={api_key_solar_rad}"

def fetch_solarRad_data():
    response = requests.get(base_url_solar_rad)
    if response.status_code == 200:
        data = response.json()
        return data
    else:
        print("Erreur en récupérant les données de l'API Weatherbit")

def get_solar_radiation():
    data = fetch_solarRad_data()
    if data:
        print(f"the solar radiation in sfax is : {data['data'][0]['solar_rad']}")
        return data['data'][0]['solar_rad']
    else :
        return 0
    return None

outside_temp = get_temperature()
outside_solar_rad = get_solar_radiation()
outside_humidity = get_humidity()

@csrf_exempt
def login(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            password = data.get('password')

            print(f"Received username: {username}, password: {password}")
            user = authenticate(request, username=username, password=password)

            if user is not None:
                return JsonResponse({'status': 'success', 'is_staff': user.is_staff})
            else:
                print("Authentication failed: Invalid credentials")
                return JsonResponse({'status': 'fail'})
        except Exception as e:
            print(f"Exception: {e}")
            return JsonResponse({'status': 'error', 'message': str(e)})
    return JsonResponse({'status': 'error'})

@csrf_exempt
def add_user(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            email = data.get('email')
            password = data.get('password')
            role = data.get('role')

            if not username or not email or not password or not role:
                return JsonResponse({'status': 'fail', 'message': 'Missing required fields'})

            if User.objects.filter(username=username).exists():
                return JsonResponse({'status': 'fail', 'message': 'Username already exists'})

            user = User.objects.create_user(username=username, email=email, password=password)

            if role == 'Admin':
                user.is_staff = True
                user.is_superuser = True
            else:
                user.is_staff = False
                user.is_superuser = False

            user.save()

            return JsonResponse({'status': 'success'})
        except Exception as e:
            print(f"Exception: {e}")
            return JsonResponse({'status': 'error', 'message': str(e)})
    return JsonResponse({'status': 'error'})

@csrf_exempt
def calculate_time(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            min_temp = data.get('min_temp')
            max_temp = data.get('max_temp')

            if min_temp is None or max_temp is None:
                return JsonResponse({'error': 'Min temp and Max temp are required'}, status=400)

            print(f"Received min_temp: {min_temp} and max_temp: {max_temp}")

            T0 = min_temp + 273.15
            T_target = max_temp + 273.15
            T_ext = outside_temp + 273.15  # Fetch temperature from the weather API

            rho = 1.225
            cp = 1005
            h_int = 10
            h_ext = 15
            A_int = 160
            A_ext = 160
            A_verre = 4
            V = 800

            alpha = 0.7
            Is = outside_solar_rad  # Example solar radiation value

            Q_conv_int = h_int * A_int * (T0 - T_ext)
            Q_conv_ext = h_ext * A_ext * (T_ext - T0)
            Q_sol = alpha * Is * A_verre

            Q_total_ext = Q_conv_ext + Q_sol
            Q_total = Q_conv_int + Q_total_ext

            h_total = h_int * A_int + h_ext * A_ext

            numerator = (T_target - T_ext + Q_total / h_total)
            denominator = (T0 - T_ext + Q_total / h_total)
            if((numerator / denominator) < 0) :
                time_in_minutes = 99.99
            else :
                ln_term = math.log(numerator / denominator)
                t = - (rho * cp * V / h_total) * ln_term

                time_in_minutes = round((t / 60),2)
                TimeRecord.objects.create(time_in_minutes=time_in_minutes)
                print(f"Calculated time: {time_in_minutes} minutes")



            if time_in_minutes:
                return JsonResponse({'time': time_in_minutes})


        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=400)


@csrf_exempt
def fetch_weather(request):
    if request.method == 'POST':

        try:

            return JsonResponse({'temp': outside_temp , 'hum': outside_humidity , 'solar_rad' : outside_solar_rad})
        except Exception as e:
            print(f"Exception: {e}")
            return JsonResponse({'status': 'error', 'message': str(e)})
    return JsonResponse({'status': 'error'})


@csrf_exempt
def get_times_with_submission_time(request):
    if request.method == 'POST':  # You can also use POST if needed
        try:

            # Query all TimeRecord entries and extract both time_in_minutes and created_at
            records = TimeRecord.objects.all().values('time_in_minutes', 'submission_time')
            print("fetch_weather")
            # Convert the records to a list of dictionaries for JSON serialization
            records_list = [
                (
                    record['time_in_minutes'],
                    record['submission_time'].strftime('%Y-%m-%d %H:%M:%S')  # Format the timestamp
                )
                for record in records
            ]

            print(records_list)

            # Return the list of records as a JSON response
            return JsonResponse({'records': records_list})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=400)