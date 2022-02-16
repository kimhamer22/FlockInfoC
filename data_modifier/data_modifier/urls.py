"""data_modifier URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from data_modifier import views

urlpatterns = [
    path('', views.index, name='index'),
    path('admin/', admin.site.urls),
    path('login/', views.user_login, name="login"),
    path('logout/', views.user_logout, name='logout'),
    path('navigation/', views.navigation, name='navigation_species'),
    path('navigation/new/', views.section_create, name='section_create_noparent'),
    path('navigation/new/<parent_id>/', views.section_create, name='section_create'),
    path('navigation/<int:section_id>/', views.navigation, name='navigation_section'),
    # path('section/edit/<int:section_id>/', views.section_edit_language, name='section_edit_language'),
    path('section/edit/parent/<int:parent_id>/<int:section_id>/', views.section_edit_language, name='section_edit_language'),
    path('section/edit/<int:section_id>/', views.section_edit_language, name='section_edit_language_noparent'),
    path('section/edit/<int:section_id>/<int:language_id>/', views.section_edit, name='section_edit'),
    path('language/index/', views.language_index, name='language_index'),

]
