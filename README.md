# Flock Information Centre Mobile App

## An adaptation of the website https://kimhamer.wixsite.com/website


## Deployment of dev Django website
1. Install **docker** and **docker-compose** in your system (docker-compose is often installed when installing docker). 
2. Navigate to data_modifier/ on terminal for docker commands.
3. Create **.env.dev** file. Template: <br>
    DEBUG=1<br>
    SECRET_KEY=57819288r7y319137t7139y74dycgf3trteqyfgryg2yrh8fy47r18uef4828ef8qejf8qe<br>
    DJANGO_ALLOWED_HOSTS=localhost 127.0.0.1 [::1]<br>
    SQL_ENGINE=django.db.backends.postgresql<br>
    SQL_DATABASE=main<br>
    SQL_USER=postgres<br>
    SQL_PASSWORD=postgres<br>
    SQL_HOST=db<br>
    SQL_PORT=5432<br>
    SUPERUSER_EMAIL=test2@test.com<br>
    SUPERUSER_USERNAME=test2<br>
    SUPERUSER_PASSWORD=test2<br>
4. Create **.env.dev.db** file. Template: <br>
    POSTGRES_USER=postgres<br>
    POSTGRES_PASSWORD=postgres<br>
    POSTGRES_DB=main<br>
4. Run `$ docker-compose build`
5. Run `$ docker-compose up` to run the website. Server will be running on terminal. Run `$ docker-compose up -d` to run on daemon instead. Run `$ docker-compose down` to stop the server. 
6. You should be able to access the website by going to `http://localhost:8000`. To log in, use SUPERUSER_USERNAME and SUPERUSER_PASSWORD from your **.env.dev**
