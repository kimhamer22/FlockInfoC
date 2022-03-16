from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.urls import reverse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
# from data_modifier.models import *
from data_modifier.custom_sql import *
from data_modifier.section_type import SectionType
from django.http import Http404
import shutil

def index(request):
    return render(request, 'data_modifier/index.html')

def version(request):
    return HttpResponse(get_version())

def user_login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        user = authenticate(username=username, password=password)
        if user:
            if user.is_active:
                login(request, user)
                return redirect(reverse('index'))
            else:
                return HttpResponse("Your account is disabled.")
        else:
            print(f"Invalid login details: {username}, {password}")
            return HttpResponse("Invalid login details supplied.")
    else:
        return render(request, 'data_modifier/login.html')

@login_required
def user_logout(request):
    logout(request)
    return redirect(reverse('index'))

@login_required
def navigation(request, section_id=None):

    # Load species if no id is provided
    if not section_id:
        sections = get_species_sections() + get_main_page_sections()

    # Load children of current section
    else:
        sections = get_child_sections(section_id)


    context_dict = {}
    context_dict['sections'] = sections
    context_dict['parent_id'] = section_id
    return render(request, 'data_modifier/navigation.html', context=context_dict)

@login_required
def section_edit_language(request, parent_id = None, section_id=None):

    method = request.POST.get('_method', '').lower()

    if method == 'delete':
        delete_section(section_id)
        return redirect(reverse('navigation_section', args=(parent_id,)))

    context_dict = {}
    context_dict['section_translations'] = enumerate(get_section_languages(section_id))
    context_dict['section_id'] = section_id

    return render(request, 'data_modifier/section/edit_language.html', context=context_dict)


@login_required
def section_edit(request, section_id, language_id):

    if request.method == 'POST':
        heading = request.POST.get('heading')
        info = request.POST.get('info')
        if heading and info:
            update_section(section_id, language_id, heading, info)
        return redirect(reverse('navigation_species'))

    context_dict = {}
    context_dict['section'] = get_section(section_id)

    return render(request, 'data_modifier/section/edit.html', context=context_dict)


@login_required
def section_create(request, parent_id=None):

    if request.method == 'POST':

        heading = request.POST.get('heading')
        info = request.POST.get('info')


        insert_section(heading, info, parent_id)

        if parent_id is not None:
            return redirect(reverse('navigation_section', args=(parent_id,)))

        return redirect(reverse('navigation_species'))

    context_dict = {}
    if parent_id is not None:
        context_dict['parent_name'] = get_section(parent_id)[2]
    else:
        context_dict['parent_name'] = ""

    return render(request, 'data_modifier/section/create.html', context=context_dict)


@login_required
def language_index(request):

    method = request.POST.get('_method', '').lower()

    if method == 'delete':
        language_id = request.POST.get('language_id')
        if language_id:
            delete_language(language_id)

    elif request.method == 'POST':
        language_name = request.POST.get('language_name')
        if language_name:
            insert_language(language_name)

    context_dict = {}
    context_dict['enumerated_languages'] = enumerate(get_languages())

    return render(request, 'data_modifier/language/index.html', context=context_dict)


@login_required
def release(request):
    shutil.make_archive('static/downloads/' + 'database', 'zip', './', 'flock-control.sqlite')

    increment_version()
    return render(request, 'data_modifier/release.html')
