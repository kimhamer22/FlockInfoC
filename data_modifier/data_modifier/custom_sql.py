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


def get_main_page_sections():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
				td.translation as translation_data,
               	ts.translation as translation_section
	        FROM section as s
	        JOIN translations_sections as ts ON s.id = ts.section_id
			LEFT JOIN translations_data as td ON s.id = td.section_id

	        WHERE s.type=%s""", [SectionType.homePage.value[0]])

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


# TODO REMOVE HARDCODED TYPE (header)
def insert_section(translation_section, translation_data, parent_id = None):
	LANGUAGE_ID = 1 # english fixed for all new

	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			INSERT INTO section (type) VALUES(4)
			""")

		new_section_id = cursor.lastrowid

		cursor.execute("""
			INSERT INTO translations_sections (language_id, section_id, translation) VALUES(%s, %s, %s)
			""", [LANGUAGE_ID, new_section_id, translation_section])

		cursor.execute("""
			INSERT INTO translations_data (language_id, section_id, translation)  VALUES(%s, %s, %s)
			""", [LANGUAGE_ID, new_section_id, translation_data])

		if parent_id is not None:
			cursor.execute("""
				INSERT INTO section_parent VALUES(%s, %s)
				""", [new_section_id, parent_id])


def delete_section(section_id):

	with connections['app-db'].cursor() as cursor:

		cursor.execute("""
			DELETE FROM translations_sections WHERE section_id=%s
			""", [section_id])

		cursor.execute("""
			DELETE FROM translations_data WHERE section_id=%s
			""", [section_id])

		cursor.execute("""
			DELETE FROM section_parent WHERE parent_section_id=%s or section_id=%s
			""", [section_id,section_id])

		cursor.execute("""
			DELETE FROM relevant_sections WHERE section_id=%s or relevant_sections_id=%s
			""", [section_id, section_id])

		cursor.execute("""
			DELETE FROM section WHERE id=%s
			""", [section_id])

def update_section(section_id, language_id, translation_section, translation_data):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			UPDATE translations_sections
			SET translation=%s
			WHERE section_id=%s and
			      language_id=%s
	        """, [translation_section, section_id, language_id])

		# TODO implement this:
		# if info exists but is not passed: set existing to empty
		# if info exists and is passed: set existing to passed value
		# if info does not exist, create it anyways

		# FOR NOW JUST UPDATE EXISTING, TO NOT BREAK ANYTHING ON THE APP

		cursor.execute("""
			UPDATE translations_data
			SET translation=%s
			WHERE section_id=%s and
			      language_id=%s
	        """, [translation_data, section_id, language_id])

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


def get_version():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT version_number
        	FROM version
        	LIMIT 1
        """)

		return cursor.fetchone()[0]

def increment_version():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
	        	UPDATE version
	        	SET version_number=version_number+1
	        """)