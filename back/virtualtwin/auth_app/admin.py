from django.contrib import admin
from .models import TimeRecord

@admin.register(TimeRecord)
class TimeRecordAdmin(admin.ModelAdmin):
    list_display = ('time_in_minutes', 'submission_time')
