#!/bin/bash
set -e;

cd "`dirname "$0"`"
basedir="$(pwd)"
releasePath=$1
dbName=$2
loadType=$3
locale=$4 

if [ -z ${loadType} ] || [ -z ${locale} ]
then
	echo "Usage <release location> <db schema name> <DELTA|SNAP|FULL|ALL> <locale ie US1000124>"
	exit -1
fi

dbUsername=postgres
echo "Enter postgres username [$dbUsername]:"
read newDbUsername
if [ -n "$newDbUsername" ]
then
	dbUsername=$newDbUsername
fi

dbPortNumber=5432
echo "Enter postgres port number [$dbPortNumber|:"
read newDbPortNumber
if [ -n "$newDbPortNumber" ]
then
	dbPortNumber=$newDbPortNumber
fi

#Unzip the files here, junking the structure
localExtract="tmp_extracted"
generatedLoadScript="tmp_loader.sql"
generatedEnvScript="tmp_environment-postgresql.sql"

#What types of files are we loading - delta, snapshot, full or all?
case "${loadType}" in 
	'DELTA') fileTypes=(Delta)
		unzip -j ${releasePath} "*Delta*" -d ${localExtract}
	;;
	'SNAP') fileTypes=(Snapshot)
		unzip -j ${releasePath} "*Snapshot*" -d ${localExtract}
	;;
	'FULL') fileTypes=(Full)
		unzip -j ${releasePath} "*Full*" -d ${localExtract}
	;;
	'ALL') fileTypes=(Delta Snapshot Full)	
		unzip -j ${releasePath} -d ${localExtract}
	;;
	*) echo "File load type ${loadType} not recognised"
	exit -1;
	;;
esac

cp $basedir/../*.tsv ${localExtract}
cp $basedir/../*.txt ${localExtract}

	
#Determine the release date from the filenames
releaseDate=`ls -r -1 ${localExtract}/*.txt | head -1 | egrep -o '[0-9]{8}'`	

#Generate the environemnt script by running through the template as 
#many times as required
#now=`date +"%Y%m%d_%H%M%S"`
#echo -e "\nGenerating Environment script for ${loadType} type(s)"
#echo "/* Script Generated Automatically by load_release.sh ${now} */" > ${generatedEnvScript}
#for fileType in ${fileTypes[@]}; do
#	fileTypeLetter=`echo "${fileType}" | head -c 1 | tr '[:upper:]' '[:lower:]'`
#	tail -n +2 environment-postgresql-mysql.sql | while read thisLine
#	do
#		echo "${thisLine/TYPE/${fileTypeLetter}}" >> ${generatedEnvScript}
#	done
#done

function addLoadScript() {
	for fileType in ${fileTypes[@]}; do
		fileName=${1/TYPE/${fileType}}
		fileName=${fileName/DATE/${releaseDate}}
		fileName=${fileName/INT/${locale}}

		#Check file exists - try beta version if not
		if [ ! -f ${localExtract}/${fileName} ]; then
			origFilename=${fileName}
			fileName="x${fileName}"
			if [ ! -f ${localExtract}/${fileName} ]; then
				echo "Unable to find ${origFilename} or beta version"
				exit -1
			fi
		fi

#		tableName=${2}_`echo $fileType | head -c 1 | tr '[:upper:]' '[:lower:]'`
# we are using as snapshot, even tough we are doing a full release
		tableName=${2}_s

		echo -e "COPY ${tableName}" >> ${generatedLoadScript}
		echo -e "FROM '"${basedir}/${localExtract}/${fileName}"'" >> ${generatedLoadScript}
		echo -e "WITH (FORMAT csv, HEADER true, DELIMITER E'	', QUOTE E'\b');" >> ${generatedLoadScript}
		echo -e ""  >> ${generatedLoadScript}
	done
}

function addSubsetScript() {
	for fileType in ${fileTypes[@]}; do
		fileName=${1/TYPE/${fileType}}
		fileName=${fileName/DATE/${releaseDate}}
		fileName=${fileName/INT/${locale}}
    echo $fileName
		#Check file exists - try beta version if not
		if [ ! -f ${localExtract}/${fileName} ]; then
			origFilename=${fileName}
			fileName="x${fileName}"
			if [ ! -f ${localExtract}/${fileName} ]; then
				echo "Unable to find ${origFilename} or beta version"
				exit -1
			fi
		fi

# 		tableName=${2}_`echo $fileType | head -c 1 | tr '[:upper:]' '[:lower:]'`
# we are using as snapshot, even tough we are doing a full release
		tableName=${2}_s

		echo -e "COPY ${tableName}" >> ${generatedLoadScript}
		echo -e "FROM '"${basedir}/${localExtract}/${fileName}"'" >> ${generatedLoadScript}
		echo -e "WITH (FORMAT csv, HEADER true);" >> ${generatedLoadScript}
		echo -e ""  >> ${generatedLoadScript}
	done
}
function addMapScript() {
	for fileType in ${fileTypes[@]}; do
		fileName=${1/TYPE/${fileType}}
		fileName=${fileName/DATE/${releaseDate}}
		fileName=${fileName/INT/${locale}}
		#Check file exists - try beta version if not
		if [ ! -f ${localExtract}/${fileName} ]; then
			origFilename=${fileName}
			fileName="x${fileName}"
			if [ ! -f ${localExtract}/${fileName} ]; then
				echo "Unable to find ${origFilename} or beta version"
				exit -1
			fi
		fi

# 		tableName=${2}_`echo $fileType | head -c 1 | tr '[:upper:]' '[:lower:]'`
# we are using as snapshot, even tough we are doing a full release
		tableName=${2}_s

		echo -e "COPY ${tableName}" >> ${generatedLoadScript}
		echo -e "FROM '"${basedir}/${localExtract}/${fileName}"'" >> ${generatedLoadScript}
		echo -e "WITH (FORMAT csv, HEADER true, DELIMITER E'\t');" >> ${generatedLoadScript}
		echo -e ""  >> ${generatedLoadScript}
	done
}
echo -e "\nGenerating loading script for $releaseDate"
echo "/* Generated Loader Script */" >  ${generatedLoadScript}
echo "" >> ${generatedLoadScript}
echo "set schema 'snomedct';" >> ${generatedLoadScript}
echo "" >> ${generatedLoadScript}
addLoadScript sct2_Concept_TYPE_INT_DATE.txt concept
addLoadScript sct2_Description_TYPE-en_INT_DATE.txt description
addLoadScript sct2_StatedRelationship_TYPE_INT_DATE.txt stated_relationship
addLoadScript sct2_Relationship_TYPE_INT_DATE.txt relationship
addLoadScript sct2_TextDefinition_TYPE-en_INT_DATE.txt textdefinition
addLoadScript der2_cRefset_AttributeValueTYPE_INT_DATE.txt attributevaluerefset
addLoadScript der2_cRefset_LanguageTYPE-en_INT_DATE.txt langrefset
addLoadScript der2_cRefset_AssociationTYPE_INT_DATE.txt associationrefset
addMapScript tls_Icd10cmHumanReadableMap_INT_DATE.tsv icd10cm_human_readable_map
addLoadScript der2_iisssccRefset_ExtendedMapTYPE_INT_DATE.txt icd10_extendedmapactivesnapshot_map

# Load additional mental health subset
addSubsetScript der1_SubsetMembersTable_1000119_20160226.txt mental_health_subset_with_icd10_map

#psql_camp -U ${dbUsername} -p ${dbPortNumber} -d ${dbName} << EOF
psql -U ${dbUsername} -p ${dbPortNumber} -d ${dbName} << EOF
	\ir create-database-postgres.sql;
	\ir environment-postgresql.sql;
	\ir ${generatedLoadScript};
EOF

rm -rf $localExtract


