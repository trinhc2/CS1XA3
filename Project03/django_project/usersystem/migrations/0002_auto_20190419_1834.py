# Generated by Django 2.2 on 2019-04-19 22:34

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('usersystem', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userinfo',
            name='info',
            field=models.IntegerField(max_length=30),
        ),
    ]
