from django.shortcuts import render, redirect
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
# from data_modifier.models import *
from data_modifier.custom_sql import *
from data_modifier.section_type import SectionType
from django.http import Http404
from django.db import IntegrityError
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
        sections = get_species_sections() + get_main_page_sections() + get_hamburger_menu_sections()

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
    section_type = request.POST.get('type')

    if method == 'delete':
        delete_section(section_id)
        return redirect(reverse('navigation_section', args=(parent_id,)))
    elif section_type:
        update_section_type(section_id, section_type)

    context_dict = {}

    relevant_sections = get_relevant_sections(section_id)
    translations = get_section_languages(section_id)
    all_sections = get_all_sections_sorted()

    context_dict['section_translations'] = enumerate(translations)
    context_dict['section_id'] = section_id
    context_dict['section_name'] = translations[0][1]
    context_dict['relevant_sections'] = enumerate(relevant_sections)
    context_dict['all_sections'] = enumerate(all_sections)
    context_dict['parent_id'] = parent_id
    context_dict['section_type'] = int(get_section_type(section_id)[0])
    context_dict['types'] = enumerate([s_type for s_type in SectionType])

    return render(request, 'data_modifier/section/edit_language.html', context=context_dict)


@login_required
def section_relevant(request, section_id, parent_id = None):
    method = request.POST.get('_method', '').lower()
    relevant_section_id = request.POST.get('section', '').lower()

    if not method:
        try:
            insert_relevant_section(section_id, relevant_section_id)
        except IntegrityError as e:
            pass #already added anyways, just prevent error

    elif method  == 'delete':
        print("OK")
        delete_relevant_sections(section_id, relevant_section_id)


    return HttpResponseRedirect(request.META.get('HTTP_REFERER', '/'))


@login_required
def section_edit(request, section_id, language_id):

    if request.method == 'POST':
        heading = request.POST.get('heading')
        info = request.POST.get('info')
        if heading:
            update_section(section_id, language_id, heading, info)
        return redirect(reverse('navigation_species'))

    context_dict = {}
    context_dict['section'] = get_section(section_id, language_id)

    return render(request, 'data_modifier/section/edit.html', context=context_dict)


@login_required
def section_create(request, parent_id=None):

    if request.method == 'POST':

        heading = request.POST.get('heading')
        info = request.POST.get('info')
        section_type = request.POST.get('type')

        insert_section(section_type, heading, info, parent_id)

        if parent_id is not None:
            return redirect(reverse('navigation_section', args=(parent_id,)))

        return redirect(reverse('navigation_species'))

    context_dict = {}
    if parent_id is not None:
        context_dict['parent_name'] = get_section(parent_id)[2]
    else:
        context_dict['parent_name'] = ""
    context_dict['types'] = enumerate([s_type for s_type in SectionType])

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
