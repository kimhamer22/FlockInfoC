from django.db import connections
from data_modifier.section_type import SectionType

# TODO - add language
def get_child_sections(section_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
				td.translation as translation_data, 
				ts.translation as translation_section
			FROM section as s
			JOIN translations_sections as ts ON s.id = ts.section_id
			LEFT JOIN translations_data as td ON s.id = td.section_id
			LEFT JOIN section_parent as sp ON s.id = sp.section_id
			LEFT JOIN translations_sections as pts ON sp.parent_section_id = pts.section_id
			WHERE sp.parent_section_id=%s""", [section_id])

		return cursor.fetchall()

def get_species_sections():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
				td.translation as translation_data,
               	ts.translation as translation_section
	        FROM section as s
	        JOIN translations_sections as ts ON s.id = ts.section_id
			LEFT JOIN translations_data as td ON s.id = td.section_id

	        WHERE s.type=%s""", [SectionType.speciesCategory.value[0]])
		
		return cursor.fetchall()

def get_section(section_id, language_id=1):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
               td.translation as translation_data, 
               ts.translation as translation_section,
               l.name as language
        FROM section as s
        JOIN translations_sections as ts ON s.id = ts.section_id
        JOIN language as l on ts.language_id=l.id
        LEFT JOIN translations_data as td ON s.id = td.section_id
        WHERE s.id=%s and ts.language_id =%s""", [section_id, language_id])
		
		return cursor.fetchone()

def get_section_languages(section_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
               td.translation as translation_data, 
               ts.translation as translation_section,
               l.name as language,
               l.id as language_id
        FROM section as s
        JOIN translations_sections as ts ON s.id = ts.section_id
        JOIN language as l on ts.language_id=l.id
        LEFT JOIN translations_data as td ON s.id = td.section_id
        WHERE s.id=%s""", [section_id])
		
		return cursor.fetchall()


def get_languages():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT id, name
        	FROM language
        """)
		
		return cursor.fetchall()


def insert_language(language):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			INSERT INTO language('name', icon) VALUES(%s, '')
        """, [language])

def delete_language(language_id):

	# protect english
	if language_id == 1:
		pass

	else:
		with connections['app-db'].cursor() as cursor:
			cursor.execute("""
				DELETE FROM language WHERE id=%s
	        """, [language_id])