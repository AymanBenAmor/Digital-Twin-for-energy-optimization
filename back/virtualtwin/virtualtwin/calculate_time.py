from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import math
from virtualtwin.virtualtwin import weather, solar_rad



def calculate_time():
    try:
        T0 = 18 + 273.15
        T_target = 29 + 273.15
        T_ext = weather.get_temperature() + 273.15

        rho = 1.225
        cp = 1005
        h_int = 10
        h_ext = 15
        A_int = 160
        A_ext = 160
        A_verre = 4
        V = 800
        alpha = 0.7
        Is = solar_rad.get_solar_radiation()

        Q_conv_int = h_int * A_int * (T0 - T_ext)
        Q_conv_ext = h_ext * A_ext * (T_ext - T0)
        Q_sol = alpha * Is * A_verre
        Q_total_ext = Q_conv_ext + Q_sol
        Q_total = Q_conv_int + Q_total_ext
        h_total = h_int * A_int + h_ext * A_ext

        numerator = (T_target - T_ext + Q_total / h_total)
        denominator = (T0 - T_ext + Q_total / h_total)
        ln_term = math.log(numerator / denominator)
        t = - (rho * cp * V / h_total) * ln_term
        time_in_minutes = t / 60
        return time_in_minutes

    except Exception as e:
        return JsonResponse({'error': str(e)})


