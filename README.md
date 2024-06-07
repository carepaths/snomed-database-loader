# SNOMED CT Database Scripts

The scripts in this repository can be used to create and populate a MYSQL, PostgreSQL of NEO4J database with a SNOMED CT terminology release distributed in the **RF2 distribution format**.

Please see the relevant sub-directories for each of the different database load scripts:

- [PostgreSQL](PostgreSQL/)



## CAREPATHS NOTES:

* We are loading a icd10 map table and the mental health subsets with the whole dataset.

* Internal DB and code is referencing SNAPSHOTS, while the data is really a FULL data.

Example on how to run:
``./load_release-postgresql.sh ~/snomed.zip DB_NAME FULL US1000124`

* A new INT locale parameter has been added to the CLI script 

### SNOMED CT to ICD-10-CM map

Current version of SNOMED CT to ICD-10-CM map can be found in the US Edition of SNOMED CT.

* Go to: https://www.nlm.nih.gov/healthit/snomedct/us_edition.html > Download SNOMED CT to ICD-10-CM Mapping Resources

* Current file: SNOMED_CT_to_ICD-10-CM_Resources_20240301.zip. Extract the *.tsv file and save it in the root of this repo.

### Mental Health Subset

* Mental Health Subset can be found at: https://www.nlm.nih.gov/healthit/snomedct/archive.html > Convergent Medical Terminology (CMT) Release Files > 2016 Subsets Release Files > Mental Health Subset Update

* * The file in there is a XLS. Download the file and save it as a CSV, comma-separated and with a string delimiter. The csv filename is 'der1_SubsetMembersTable_1000119_20160226.txt'. *Save this file in the root of this repo.*



