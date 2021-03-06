from django.db import connections
from data_modifier.section_type import SectionType

def get_child_sections(section_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
				ts.translation as translation_section
			FROM section as s
			JOIN translations_sections as ts ON s.id = ts.section_id
			LEFT JOIN section_parent as sp ON s.id = sp.section_id
			LEFT JOIN translations_sections as pts ON sp.parent_section_id = pts.section_id
			WHERE sp.parent_section_id=%s and ts.language_id=1 and pts.language_id=1
			ORDER BY ts.translation""", [section_id])

		return cursor.fetchall()

def get_species_sections():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
               	ts.translation as translation_section
	        FROM section as s
	        JOIN translations_sections as ts ON s.id = ts.section_id
	        WHERE s.type=%s and ts.language_id=1
	        ORDER BY ts.translation""", [SectionType.speciesCategory.value[0]])
		
		return cursor.fetchall()


def get_main_page_sections():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
               	ts.translation as translation_section
	        FROM section as s
	        JOIN translations_sections as ts ON s.id = ts.section_id
	        WHERE s.type=%s and ts.language_id=1
	        ORDER BY ts.translation""", [SectionType.homePage.value[0]])

		return cursor.fetchall()

def get_hamburger_menu_sections():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
               	ts.translation as translation_section
	        FROM section as s
	        JOIN translations_sections as ts ON s.id = ts.section_id
	        WHERE s.type=%s and ts.language_id=1
	        ORDER BY ts.translation""", [SectionType.hamburgerMenu.value[0]])

		return cursor.fetchall()

def get_section(section_id, language_id=1):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id,
               COALESCE (tran.translation_data, ""), 
               COALESCE (tran.translation_section, ""),
               (SELECT name FROM language where id=%s) as l_name,
               (SELECT translation FROM translations_sections where section_id=%s and language_id=1) as default_title
			FROM section as s
			LEFT JOIN (
				SELECT ts.section_id, td.translation as translation_data, ts.translation as translation_section 
				FROM translations_sections as ts
				LEFT JOIN ( SELECT * FROM translations_data WHERE language_id=%s and section_id=%s) as td
				WHERE ts.language_id=%s and ts.section_id=%s
			) as tran
			WHERE s.id=%s""", [language_id, section_id, language_id, section_id, language_id, section_id, section_id])
		
		return cursor.fetchone()

def get_section_type(section_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.type
			FROM section as s
			WHERE s.id=%s
			LIMIT 1""", [section_id])
		
		return cursor.fetchone()

def get_section_languages(section_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id as id, 
               COALESCE (s.translation_section, "-") as translation_section,
               l.name as language,
               l.id as language_id
			FROM language as l
			LEFT JOIN (
				SELECT ts.section_id as id, ts.translation as translation_section, 
				       ts.language_id as lang
				FROM translations_sections as ts
				WHERE ts.section_id=%s
			) as s ON s.lang=l.id
			
        """, [section_id])
		
		return cursor.fetchall()


# TODO REMOVE HARDCODED TYPE (header)
def insert_section(section_type, translation_section, translation_data, parent_id = None):
	LANGUAGE_ID = 1 # english fixed for all new

	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			INSERT INTO section (type) VALUES(%s)
			""", [section_type])

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

		# delete previous translations and insert new, better than updating in case the translation is missing
		# since update would miss out on translations that were missing before

		# deleting
		cursor.execute("""
			DELETE FROM translations_sections
			WHERE section_id=%s and
				  language_id=%s
			""", [section_id, language_id])

		cursor.execute("""
			DELETE FROM translations_data
			WHERE section_id=%s and
				  language_id=%s
			""", [section_id, language_id])

		# inserting new
		cursor.execute("""
			INSERT INTO translations_sections(language_id, section_id, translation) VALUES(%s, %s, %s)
	        """, [language_id, section_id, translation_section ])

        cursor.execute("""
            INSERT INTO translations_data(language_id, section_id, translation) VALUES(%s, %s, %s)
            """, [language_id, section_id, translation_data])

def update_section_type(section_id, section_type):
	with connections['app-db'].cursor() as cursor:

		# delete previous section and insert new, better than updating in case the translation is missing
		# since update would miss out on translations that were missing before

		# deleting
		cursor.execute("""
			UPDATE section
			SET type=%s
			WHERE id=%s
			""", [section_type, section_id])


def get_relevant_sections(section_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
				SELECT ts.section_id, ts.translation
				FROM relevant_sections as rs
				JOIN translations_sections as ts ON rs.relevant_sections_id=ts.section_id
				WHERE rs.section_id=%s
				ORDER BY ts.translation
	        """, [section_id])

		return cursor.fetchall()


def delete_relevant_sections(section_id, to_delete_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
					DELETE FROM relevant_sections 
					WHERE (section_id=%s and relevant_sections_id=%s) or 
					      (section_id=%s and relevant_sections_id=%s)
					""", [section_id, to_delete_id, to_delete_id, section_id])


def insert_relevant_section(section_id, relevant_section_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
				INSERT INTO relevant_sections
				VALUES (%s, %s), (%s, %s)
	        """, [section_id, relevant_section_id, relevant_section_id, section_id])


def get_all_sections_sorted():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
				SELECT ts.section_id, ts.translation
				FROM translations_sections as ts
				ORDER BY ts.translation
	        """)

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
				DELETE FROM translations_sections
				WHERE language_id=%s
				""", [language_id])

			cursor.execute("""
				DELETE FROM translations_data
				WHERE language_id=%s
				""", [language_id])

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