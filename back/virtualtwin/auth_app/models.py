from django.db import models

class TimeRecord(models.Model):
    time_in_minutes = models.FloatField()
    submission_time = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.time_in_minutes} minutes recorded on {self.submission_time}'
