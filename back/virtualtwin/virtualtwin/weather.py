import requests

# Remplacez par votre propre clé API
api_key = "d0ff7195961030c16384ba1faab66519"
city = "Sfax"
base_url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"


def fetch_weather_data():
    response = requests.get(base_url)
    if response.status_code == 200:
        data = response.json()
        return data
    else:
        print("Erreur en récupérant les données de l'API OpenWeatherMap")

def get_temperature():
    data = fetch_weather_data()
    if data:
        return data['main']['temp']
    return None

def get_wind_speed():
    data = fetch_weather_data()
    if data:
        return data['wind']['speed'] * 3600 / 1000  # (km/h)
    return None

def get_humidity():
    data = fetch_weather_data()
    if data:
        return data['main']['humidity']
    return None

def display_hum():
    hum = get_humidity()
    print(f"humidity : {hum}%")

def display_weather():
    temperature = get_temperature()
    wind_speed = get_wind_speed()
    if temperature is not None and wind_speed is not None:
        print(f"La température actuelle à ({city}) est de {temperature}°C")
        print(f"La vitesse du vent actuelle à ({city}) est de {wind_speed} Km/h")
    else:
        print("Les données météo ne sont pas disponibles")
