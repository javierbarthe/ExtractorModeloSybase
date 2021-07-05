#!/usr/bin/ksh
#
## Extractor de estructuras servidor ASE
## Version 3.0
##

verificacion_ambiente()
{
	if [[ "${SYBASE}" == "" ]] then
		echo "ERROR: La variable de entorno \$SYBASE no esta definida"
		echo " Verifique la configuracion del Open Client Sybase"
		echo " Ejecutar: '. SYBASE.sh' desde la ruta de instalacion."
		exit -1
	fi
	if [[ ! -f $SYBASE/$SYBASE_ASE/bin/ddlgen ]] then
		echo "ERROR: no se encuentra la utilidad ddlgen en $SYBASE/$SYBASE_ASE/bin/ddlgen"
		exit -1
	fi
	
}

login_info()
{
	date +"%A %D %T  (INICIO PROGRAMA LOGIN)" > ${workDirAux}/extrae.log
	chmod 777 ${workDirAux}/extrae.log
	
	#funcion 1 Definir Usuario Sybase 
	#echo "Ingrese servidor Sybase ($DSQUERY?)" 
	#read servidor?"Servidor: "
	#echo "  " 
	#echo "  " 
	servidor=$1
	usuario=$2
	password=$3
	#funcion 1 Definir Usuario Sybase 
	#echo "Ingrese usuario Sybase (sa?)" 
	#read usuario?"Usuario: "
	#echo "  " 
	
	#echo "Ingrese la password del usuario ${usuario}"
	#stty -echo
	#read password?"Password: "
	#stty echo
	#echo "  " 
	
	date +"%A %D %T  (FIN PROGRAMA LOGIN)" >> ${workDirAux}/extrae.log
	clear 
}

generaListaBases()
{
	isql -U${usuario} -P${password} -S${servidor} -b >${workDirAux}/bases.lst <<SQL
set nocount on
go
select name from master..sysdatabases where dbid = db_id('pubs2')
go
SQL
	echo "Bases a procesar ($(cat ${workDirAux}/bases.lst | wc -l)) : "
	cat ${workDirAux}/bases.lst
	echo " "
}

ddlextract()
{
	salida=${servidor}.${base}.${tipo}     
	if [[ "${tipo}" = "I" ]] then
		argN="-N${base}.%.%.% -F%"
	elif [[ "${tipo}" = "RI" ]] then
		argN="-N%.%.%"
	else
		argN="-N% -F%"
	fi
	
	date +"%D %T Extrayendo ${salida} ..."
	$SYBASE/$SYBASE_ASE/bin/ddlgen -U${usuario} -P${password} -S${servidor} -D${base} -T${tipo} ${argN} -o${workDirData}/${salida}.out -e${workDirData}/${salida}.error  >> ${workDirAux}/extrae.log
	
	date +"%D %T Extracción de ${salida} completa."
	echo " "
}

##Funcion extractor    
extractor()
{
	date +"%A %D %T  (INICIO PROGRAMA extractor)" >> ${workDirAux}/extrae.log
	
	#	Object type 	Description
	#	C 	cache
	#	D 	default
	#	DB 	database
	#	DBD 	database device
	#	DPD 	dump device
	#	EC 	execution class
	#	EG 	engine group
	#	GRP 	group
	#	I 	index
	#	L 	login
	#	P 	stored procedure
	#	R 	rule
	#	RO 	role
	#	RS 	remote server
	#	SGM 	segment
	#	TR 	trigger
	#	U 	table
	#	UDD 	user-defined datatype
	#	USR 	user
	#	V 	view
	#	XP 	extended stored procedure
	
	#base=master
	#tipos="DBD DB DPD EC EG GRP L RO RS"  
	
	#for j in ${tipos}
	#do
	#	tipo=${j}
	#	ddlextract
	#done
	
	# recorro por base 
	for i in $(cat ${workDirAux}/bases.lst)
	do 
		## Extrae Grupos
		
		base=${i}
		tipos="GRP USR UDD R U V P TR I KC RI RO LK D"  
		
		for j in ${tipos}
		do
			tipo=${j}
			ddlextract
		done
							
	done
	date +"%A %D %T  (FIN PROGRAMA extractor)" >> ${workDirAux}/extrae.log
}                                                       

generar_tar()
{
	tar -cvf ${timeStamp}.${servidor}.tar ./${timeStamp}/* >> ${workDirAux}/extrae_tar.log
}

#################  Inicio programa extractor  ###############################

clear
echo " "
echo "        ==========================================================================="
echo "                            Programa extractor de Estructuras                      "
echo "        ==========================================================================="

verificacion_ambiente

timeStamp=$(date +"%y%m%d_%H%M%S")
workDirAux=$(pwd)/Scripts

login_info $1 $2 $3

workDirData=${workDirAux}/${servidor}
if [ -d "$workDirData" ]; then rm -Rf $workDirData; fi
mkdir ${workDirData}

generaListaBases
echo "        ==========================================================================="
echo "                            Login y Genera Lista de Bases                          "
echo "        ==========================================================================="

extractor
echo "        ==========================================================================="
echo "                            Extractor de Estructuras                               "
echo "        ==========================================================================="

#generar_tar
echo "        ==========================================================================="
echo "                        Ejecucion completa                                         "
echo "        ==========================================================================="
echo " "

#egrep "There was an error" ${workDirData}/*.out

#tar -uvf ${timeStamp}.${servidor}.tar ./${timeStamp}/*.log >> ${workDirAux}/extrae_tar.log

#gzip ${timeStamp}.*.tar

#ls -l ${timeStamp}.${servidor}* 
