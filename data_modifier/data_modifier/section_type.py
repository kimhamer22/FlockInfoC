from enum import Enum

class SectionType(Enum):
	speciesCategory = 0, # will appear on species page
	homePage = 1, # will appear on home page
	button = 2, # intermediate button (e.g. nutrition)
	tab = 3, # tab (e.g. causes and control)
	expandable = 4, # expandable heading
	hamburgerMenu = 5,  # appears on the Hamburger Menu
