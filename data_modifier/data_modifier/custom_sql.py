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


def get_section(section_id):
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT s.id, 
               td.translation as translation_data, 
               ts.translation as translation_section
        FROM section as s
        JOIN translations_sections as ts ON s.id = ts.section_id
        LEFT JOIN translations_data as td ON s.id = td.section_id
        WHERE s.id=%s""", [section_id])
		
		return cursor.fetchone()


def get_languages():
	with connections['app-db'].cursor() as cursor:
		cursor.execute("""
			SELECT id, name
        	FROM language
        """)
		
		return cursor.fetchall()