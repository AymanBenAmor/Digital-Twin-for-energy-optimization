import requests

api_key = "60f0450b275045648ee6690aef9d1b2c"
city = "Sfax"
base_url = f"https://api.weatherbit.io/v2.0/current?city={city}&key={api_key}"



def fetch_solarRad_data():
    response = requests.get(base_url)
    if response.status_code == 200:
        data = response.json()
        return data
    else:
        print("Erreur en récupérant les données de l'API Weatherbit")

def get_solar_radiation():
    data = fetch_solarRad_data()
    if data:
        return data['data'][0]['solar_rad']
    else :
        return 0
    return None

def display_solar_radiation():
    solar_radiation = get_solar_radiation()
    if solar_radiation is not None:
        print(f"L'intensité solaire actuelle à {city} est de {solar_radiation} W/m²")
    else:
        print("Les données d'intensité solaire ne sont pas disponibles")


display_solar_radiation()


