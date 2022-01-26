import csv
import sqlite3
import sys



# globals

file_rows = []


# constants

ENGLISH_LANGUAGE_ID = 1


# functions

def chk_conn(conn):
     try:
        conn.cursor()
        return True
     except Exception as ex:
        return False


def flush_table(name):
	con.execute("DELETE FROM " + name)
	con.execute("DELETE FROM sqlite_sequence WHERE name='"+ name +"'")
	con.commit()
	print(f"Flushed and reset Auto Increment for {name}\n")


def enum_reverse(s):
	dic = {"species" : 0, "home" : 1, "button" : 2, "tab" : 3, "expandable" : 4}
	s = s.lower().strip()

	if s not in dic:
		raise Exception(f"\"{s}\" NOT FOUND in the section type enum.")

	return dic[s]


def insert_section(row):

	print("Inserting section \"" + row[1] + "\": ")

	con.execute("INSERT INTO `section` VALUES(?,?)", (int(row[0]), enum_reverse(row[3])))
	con.execute("INSERT INTO `translations_sections` VALUES(?,?,?,?)", (int(row[0]), ENGLISH_LANGUAGE_ID, int(row[0]), row[1]))
	if row[3]:
		con.execute("INSERT INTO `translations_data` VALUES(?,?,?,?)", (int(row[0]), ENGLISH_LANGUAGE_ID, int(row[0]), row[2]))
	con.commit()

	print("Done.\n")


def add_parent_relationship(child_id, parent_id):
	print("Parent: \"" + file_rows[int(parent_id) - 1][1] + "\"; child: \"" + file_rows[int(child_id) - 1][1] +"\"")

	con.execute("INSERT INTO `section_parent` VALUES(?,?)", (child_id, parent_id))
	con.commit()

	print("Done.\n")


def add_related_sections(s1, s2):
	print("Adding relationship between \"" + file_rows[int(s1) - 1][1] + "\" and \"" + file_rows[int(s2) - 1][1] +"\"")

	con.execute("INSERT INTO `relevant_sections` VALUES(?,?)", (s1, s2))
	con.execute("INSERT INTO `relevant_sections` VALUES(?,?)", (s2, s1)) # let's add inverted relationship as well
	con.commit()

	print("Done.\n")


def flush_database():
	
	flush_table("associated_image")
	flush_table("translations_data")
	flush_table("translations_sections")
	flush_table("section_parent")
	flush_table("relevant_sections")
	flush_table("section")


def divider():
	print("\n------------------------------------\n")





# script

if __name__ == "__main__":
	if len(sys.argv) < 2:
		raise Exception("No sql file name provided!")


	con = sqlite3.connect(sys.argv[1])
	print("\n\nDatabase connection established: " + str(chk_conn(con)))



	
	divider()

	print("Truncating database: \n")
	flush_database()

	divider()

	print("Writing sections: \n")

	if len(sys.argv) < 3:
		raise Exception("No csv file name provided!")

	with open(sys.argv[2]) as csvfile:
		f = csv.reader(csvfile, delimiter=',', quotechar='"')
		next(f)
		for row in f:
			insert_section(row)
			file_rows.append(row)


	divider()

	print("Adding parent-child relationships: \n")

	for row in file_rows:
		if row[4]:
			spl = row[4].strip().split(",")

			for parent in spl:
				add_parent_relationship(row[0], parent.strip())

	divider()

	print("Adding related sections: \n")

	for row in file_rows:
		if row[5]:
			spl = row[5].strip().split(",")

			for related_section in spl:
				add_related_sections(row[0], related_section.strip())

	divider()

	print("Script terminated successfully!")