# Generated by Django 5.1 on 2024-08-20 13:35

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('auth_app', '0002_timedata_time_recorded'),
    ]

    operations = [
        migrations.DeleteModel(
            name='TimeData',
        ),
    ]
