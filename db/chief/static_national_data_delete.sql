delete from regulation_groups_oplog where national = 1;
delete from regulation_group_descriptions_oplog where national = 1;
delete from regulation_role_types_oplog where national = 1;
delete from regulation_role_type_descriptions_oplog where national = 1;
delete from base_regulations_oplog where national = 1;
delete from measure_types_oplog where national = 1;
delete from measure_type_descriptions_oplog where national = 1;
delete from additional_code_types_oplog where national = 1;
delete from additional_code_type_descriptions_oplog where national = 1;
delete from additional_code_type_measure_types_oplog where national = 1;
delete from additional_codes_oplog where additional_code_sid <= -1 and additional_code_sid >= -9999 and national = 1;
/* TODO: is it additional_code_sid or additional_code_description_sid */
delete from additional_code_descriptions_oplog where additional_code_sid <= -1 and additional_code_sid >= -9999 and national = 1;
delete from footnote_types_oplog where national = 1;
delete from footnote_type_descriptions_oplog where national = 1;
delete from footnotes_oplog where national = 1;
delete from footnote_description_periods_oplog where footnote_description_period_sid <= -1 and footnote_description_period_sid >= -9999 and national = 1;
delete from footnote_descriptions_oplog where footnote_description_period_sid <= -1 and footnote_description_period_sid >= -9999 and national = 1;
delete from certificates_oplog where national = 1;
delete from certificate_description_periods_oplog where national = 1;
delete from certificate_descriptions_oplog where national = 1;
delete from certificate_types_oplog where national = 1;
delete from certificate_type_descriptions_oplog where national = 1;
delete from geographical_area_memberships_oplog where national=1;
delete from geographical_area_descriptions_oplog where national=1;
delete from geographical_area_description_periods_oplog where national=1;
delete from geographical_areas_oplog where national=1;
delete from footnote_association_goods_nomenclatures_oplog where national=1;
delete from footnote_association_measures_oplog where national=1;
