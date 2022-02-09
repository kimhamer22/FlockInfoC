# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Section(models.Model):
    type = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'section'

class AssociatedImage(models.Model):
    section_id = models.ForeignKey(Section, on_delete=models.CASCADE)
    image = models.BinaryField()

    class Meta:
        managed = False
        db_table = 'associated_image'


class Language(models.Model):
    name = models.TextField(unique=True)
    icon = models.BinaryField()

    class Meta:
        managed = False
        db_table = 'language'


class MainPage(models.Model):
    title = models.TextField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    language = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'main_page'


class RelevantSections(models.Model):
    section_id = models.ForeignKey(Section, on_delete=models.CASCADE, related_name="related_from")
    relevant_sections_id = models.ForeignKey(Section, on_delete=models.CASCADE, related_name="related_to")

    class Meta:
        managed = False
        db_table = 'relevant_sections'



class SectionParent(models.Model):
    section_id = models.ForeignKey(Section, on_delete=models.CASCADE, related_name="child")
    parent_section_id = models.ForeignKey(Section, on_delete=models.CASCADE, related_name="parent")

    class Meta:
        managed = False
        db_table = 'section_parent'


class TranslationsData(models.Model):
    language_id = models.ForeignKey(Language, on_delete=models.CASCADE)
    section_id = models.ForeignKey(Section, on_delete=models.CASCADE)
    translation = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'translations_data'


class TranslationsSections(models.Model):
    language_id = models.ForeignKey(Language, on_delete=models.CASCADE)
    section_id = models.ForeignKey(Section, on_delete=models.CASCADE)
    translation = models.TextField()

    class Meta:
        managed = False
        db_table = 'translations_sections'
