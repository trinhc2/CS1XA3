# Generated by Django 2.2 on 2019-04-19 22:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('usersystem', '0002_auto_20190419_1834'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userinfo',
            name='info',
            field=models.IntegerField(),
        ),
    ]
