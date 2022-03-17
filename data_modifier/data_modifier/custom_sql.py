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
               COALESCE (tran.translation_data, ""), 
               COALESCE (tran.translation_section, ""),
               (SELECT name FROM language where id=%s) as l_name,
               (SELECT translation FROM translations_sections where section_id=%s and language_id=1) as default_title
        FROM section as s
        LEFT JOIN (
        	SELECT td.section_id, td.translation as translation_data, ts.translation as translation_section, l2.name as language 
        	FROM language as l2 
			LEFT JOIN translations_sections as ts ON l2.id = ts.language_id
			LEFT JOIN translations_data as td ON l2.id = td.language_id
			WHERE td.section_id=%s and ts.section_id=%s and l2.id=%s
		) as tran ON tran.section_id = s.id""", [language_id, section_id, section_id, section_id, language_id])
		
		return cursor.fetchone()

def get_section_languages(section_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id as id, 
               COALESCE (s.translation_data, "-") as translation_data, 
               COALESCE (s.translation_section, "-") as translation_section,
               l.name as language,
               l.id as language_id
			FROM language as l
			LEFT JOIN (SELECT s2.id, td.translation as translation_data, ts.translation as translation_section, td.language_id as lang
			 FROM section as s2
			 LEFT JOIN translations_sections as ts ON s2.id = ts.section_id
			 LEFT JOIN translations_data as td ON s2.id = td.section_id
			 WHERE td.language_id = ts.language_id and s2.id=%s) as s on l.id=s.lang
        """, [section_id])
		
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