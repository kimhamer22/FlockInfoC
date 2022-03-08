from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
import os

class Command(BaseCommand):

    def handle(self, *args, **options):
        if User.objects.count() == 0:

            username = os.environ.get("SUPERUSER_USERNAME", 'test')
            email = os.environ.get("SUPERUSER_EMAIL", 'test@test.com')
            password = os.environ.get("SUPERUSER_PASSWORD", 'test')

            print(f"------REMOVE FROM PROD------ Creating account: {username}")

            admin = User.objects.create_superuser(email=email, username=username, password=password)
            admin.is_active = True
            admin.is_admin = True
            admin.save()
        else:
            print('------REMOVE FROM PROD------ Account already exists, skipping...')