from django.urls import path

from .views import login

from .views import add_user
from .views import calculate_time

from .views import fetch_weather
from .views import get_times_with_submission_time

urlpatterns = [
    path('login/', login, name='login'),
path('add_user/', add_user, name='add_user'),
path('calculate_time/', calculate_time, name='calculate_time'),
path('fetch_weather/', fetch_weather, name='fetch_weather'),
path('get_times_with_submission_time/', get_times_with_submission_time, name='get_times_with_submission_time'),
]
