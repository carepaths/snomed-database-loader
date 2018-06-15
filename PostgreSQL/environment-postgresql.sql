/* create the Full S-CT data tables */
/* Change the table suffix for different release type. _f stands for full, _d stands for delta, _s stands for snapshot */
set schema 'snomedct';

drop table if exists concept_s cascade;
create table concept_s(
  id varchar(18) not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  definitionstatusid varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists description_s cascade;
create table description_s(
  id varchar(18) not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  conceptid varchar(18) not null,
  languagecode varchar(2) not null,
  typeid varchar(18) not null,
  term text not null,
  casesignificanceid varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists textdefinition_s cascade;
create table textdefinition_s(
  id varchar(18) not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  conceptid varchar(18) not null,
  languagecode varchar(2) not null,
  typeid varchar(18) not null,
  term text not null,
  casesignificanceid varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists relationship_s cascade;
create table relationship_s(
  id varchar(18) not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  sourceid varchar(18) not null,
  destinationid varchar(18) not null,
  relationshipgroup varchar(18) not null,
  typeid varchar(18) not null,
  characteristictypeid varchar(18) not null,
  modifierid varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists stated_relationship_s cascade;
create table stated_relationship_s(
  id varchar(18) not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  sourceid varchar(18) not null,
  destinationid varchar(18) not null,
  relationshipgroup varchar(18) not null,
  typeid varchar(18) not null,
  characteristictypeid varchar(18) not null,
  modifierid varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists langrefset_s cascade;
create table langrefset_s(
  id uuid not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  refsetid varchar(18) not null,
  referencedcomponentid varchar(18) not null,
  acceptabilityid varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists associationrefset_s cascade;
create table associationrefset_s(
  id uuid not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  refsetid varchar(18) not null,
  referencedcomponentid varchar(18) not null,
  targetcomponentid varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists attributevaluerefset_s cascade;
create table attributevaluerefset_s(
  id uuid not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  refsetid varchar(18) not null,
  referencedcomponentid varchar(18) not null,
  valueid varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists simplerefset_s cascade;
create table simplerefset_s(
  id uuid not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  refsetid varchar(18) not null,
  referencedcomponentid varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists simplemaprefset_s cascade;
create table simplemaprefset_s(
  id uuid not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  refsetid varchar(18) not null,
  referencedcomponentid varchar(18) not null,
  maptarget text not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists complexmaprefset_s cascade;
create table complexmaprefset_s(
  id uuid not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  refsetid varchar(18) not null,
  referencedcomponentid varchar(18) not null,
  mapGroup smallint not null,
  mapPriority smallint not null,
  mapRule text,
  mapAdvice text,
  mapTarget text,
  correlationId varchar(18) not null,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists extendedmaprefset_s cascade;
create table extendedmaprefset_s(
  id uuid not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  refsetid varchar(18) not null,
  referencedcomponentid varchar(18) not null,
  mapGroup smallint not null,
  mapPriority smallint not null,
  mapRule text,
  mapAdvice text,
  mapTarget text,
  correlationId varchar(18),
  mapCategoryId varchar(18),
  PRIMARY KEY(id, effectivetime)
);

drop table if exists icd10cm_human_readable_map_s cascade;
create table icd10cm_human_readable_map_s(
  id uuid not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  refsetid varchar(18) not null,
  referencedcomponentid varchar(18) not null,
  referencedcomponentname text,
  mapGroup smallint not null,
  mapPriority smallint not null,
  mapRule text,
  mapAdvice text,
  mapTarget text,
  mapTargetName text,
  correlationId varchar(18),
  mapCategoryId varchar(18),
  mapCategoryName text,
  PRIMARY KEY(id, effectivetime)
);

drop table if exists icd10_extendedmapactivesnapshot_map_s cascade;
create table icd10_extendedmapactivesnapshot_map_s(
  id uuid not null,
  effectivetime char(8) not null,
  active char(1) not null,
  moduleid varchar(18) not null,
  refsetid varchar(18) not null,
  referencedcomponentid varchar(18) not null,
  mapGroup smallint not null,
  mapPriority smallint not null,
  mapRule text,
  mapAdvice text,
  mapTarget text,
  correlationId varchar(18),
  mapCategoryId varchar(18),
  PRIMARY KEY(id, effectivetime)
);
