# Neo4j Graph Database

This upload script has been kindly donated by Scott Campbell and his team from the University of Nebraska Medical Center, Omaha, NE.

**NOTE:** This script is not directly supported by SNOMED International and has not been tested by the SNOMED International team.

Version 1.2, 2018-04-18,
    (a) Support python 3 in addition to python 2.7.  (Tested with python 3.6 and python 2.7).
    (b) Support --neopw <password> in addition to --neopw64 <base64-password> (deprecated, but still supported).
    (c) Bug fix -- bug existed in update processing, related to defining relationship differences determination.
Version 1.1, 2018-04-13, Fix FSN issue in some ObjectConcept nodes -- require that the description have the active='1' attribute value.

## For attribution:

**Pedersen JG, Campbell WS**. Graph database build of SNOMED CT files. University of Nebraska Medical Center, Omaha, NE. 2017

**Full manuscript:** Campbell WS, Pedersen J, McClay JC, Rao P, Bastola D, Campbell JR. [An alternative database approach for management of SNOMED CT and improved patient data queries](https://www.ncbi.nlm.nih.gov/pubmed/26305513). J Biomed Inform. 2015 Oct;57:350-7\. doi: 10.1016/j.jbi.2015.08.016\. Epub 2015 Aug 21\. PubMed PMID: 26305513.

## Create a Neo4j Graph from a FULL RF2

This is a Linux or Windows command-line operation requiring a Python 2.7 or Python 3.5 (or above) interpreter and the SNOMED_G software.

Requirements:

1. Requires python 2.7 or python 3.5 (or above)
    - NOTE: has been tested with python 2.7 and python 3.6
    - Requires the py2neo python library to be installed
2. Requires the directory specified by `--output_dir` parameter to the snomed_g_graphdb_build_tools.py to be an empty directory.
    - Log files and CSV files are created there and we do not want to accidentally remove the files from a previous build.
3. Requires a FULL format RF2 release of SNOMED CT, which includes historical SNOMED CT codes and full change history.
4. Requires Java version 8 or above, as needed by NEO4J version 3 installations
5. Requires NEO4J version 3.2 or above to be installed and running (preferable with an empty NEO4J database)
    - Requires the LOAD CSV command not be limited to the import directory of the NEO4J installation
      - Controlled by the NEO4J configuration option dbms.directories.import=import
        - That option should be commented out, at least for the duration of the database load
        - #dbms.directories.import=import
    - Requires 4GB of Java heap memory be configured in the NEO4J configuration
      - A system with 16GB of memory or above will probably not have to explicitly configure this.
      - See NEO4J operations documentation for configuring memory parameters.
        - Currently exists at: https://neo4j.com/docs/operations-manual/current/performance/memory-configuration/

NOTE: the database load will fail if these requirements are not met.

General syntax:

`python <path-to-snomed_g-bin>/snomed_g_graphdb_build_tools.py db_build --action create --rf2 <rf2-release-directory> --release_type full --neopw <password> --output_dir <output-directory-path>`

Mac syntax for for en-GB

Assuming you download desktop version of neo4j, create a database, then find neo4j.conf for that database by clicking on open folder, then select configuration

Comment out import directory variable

`#dbms.directories.import=import`

Configure it so that it has at least 4g memory

`dbms.memory.heap.max_size=4G`


`cd <path-to-snomed_g-bin>`

`python snomed_g_graphdb_build_tools.py db_build --release_type full  --mode build --action create --rf2 /Users/<user>/Documents/SnomedCT/SnomedCT_UKClinicalRF2_Production_20171001T000001Z/Full/ --release_type full --neopw <password> --language_code 'en-GB'  --output_dir /var/tmp/SnomedCT_UKClinicalRF2_Production_20171001T000001Z `

By default, the language designation is "en" and the language is simply "Language", which is used in the filename of the Description file and the Language files.

If that is not what was used, the following parameters need to be specified (assume "en-us" and "USEnglish" values should be used):

`--language_code 'en-us' --language_name 'USEnglish'`

**NOTE**: the `--output_dir` specifies a directory for creating temporary CSV files for use in database creation, it is not the location of the database itself.

Example: (using the Jan 31, 2015 International Edition, on a windows machine)

`python c:/apps/snomed_g_v1_01/bin/snomed_g_graphdb_build_tools.py db_build --action create --rf2 c:/sno/snomedct/nelex/SnomedCT_RF2Release_INT_20150131/ --release_type full --neopw <password> --output_dir c:/build/20150131 --language_code 'en-us' --language_name 'USEnglish'`

================================================================================================

## Update a Neo4j Graph from a FULL RF2

This is a Linux or Windows command-line operation requiring Python 2.7 and the SNOMED_G software.

Requirements:

1. Requires python 2.7 or python 3.5 (or above)
    - NOTE: has been tested with python 2.7 and python 3.6
    - Requires the py2neo python library to be installed
2. Requires the directory specified by `--output_dir` parameter to the snomed_g_graphdb_build_tools.py to be an empty directory.
    - Log files and CSV files are created there and we do not want to accidentally remove the files from a previous build.
3. Requires a FULL format RF2 release of SNOMED CT, which includes historical SNOMED CT codes and full change history.
4. Requires Java version 8 or above, as needed by NEO4J version 3 installations
5. Requires NEO4J version 3.2 or above to be installed and running (holding the NEO4J database to be updated)
    - Requires the LOAD CSV command not be limited to the import directory of the NEO4J installation
      - Controlled by the NEO4J configuration option dbms.directories.import=import
        - That option should be commented out, at least for the duration of the database load
        - #dbms.directories.import=import
    - Requires 4GB of Java heap memory be configured in the NEO4J configuration
      - A system with 16GB of memory or above will probably not have to explicitly configure this.
      - See NEO4J operations documentation for configuring memory parameters.
        - Currently exists at: https://neo4j.com/docs/operations-manual/current/performance/memory-configuration/

NOTE: the database load will fail if these requirements are not met.

General syntax:

`python <path-to-snomed_g-bin>/snomed_g_graphdb_tools.py db_build --action update --rf2 <path-to-snomedct-release> --release_type full --neopw <password> --output_dir <path-to-output-folder-for-csv-files> --logfile <path-to-filename-to-hold-log-file>`

**NOTE:** the `--output_dir` specifies a directory for creating temporary CSV files for use in database creation, it is not the location of the database itself.

Example: (_UPDATE to US 2016 0301 (from INT 20150131)_)

`python c:/apps/snomed_g_v1_01/bin/snomed_g_graphdb_tools.py db_build --action update --rf2 /sno/snomedct/SnomedCT_RF2Release_US1000124_20160301 --release_type full --neopw <password> --output_dir /sno/build/upd_to_us20160301 --logfile /sno/build/int_20150131/sct_build_20160301.log`

=================================================================================================

## Create Transitive Closure of ISA relationships contained in a SNOMED CT graph stored in Neo4j

Syntax:

`python <path-to-snomed_g-bin>/snomed_g_TC_tools.py TC_from_graph <output-transitive-closure-file> --neopw <password>`

Example: `base64-neo4j-password` must be replaced by the Base64 representation of the Neo4j password):

`python /sno/bin/snomed_g/snomed_g_TC_tools.py TC_from_graph TC_20150131_graph.txt --neopw <password>`

Output example:

```
1 commands succeeded
1\. [u'typeId', u'effectiveTime', u'active', u'moduleId', u'sourceId', u'characteristicTypeId', u'history', u'id', u'relationshipGroup', u'destinationId']
1 commands succeeded
Result class: <type 'dict'>
Returned 897831 objects
NEO4J Graph DB open: 0.0179009
ISA extraction from NEO4J: 307.962
TC computation: 7.12733
Output (csv): 8.38032
Total time: 323.487
```
