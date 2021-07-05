#!/usr/bin/ksh
#
## Compilador de estructuras Sybase ASE
## Version 3.0
##
## ORDEN DE COMPILACION 
# UDD D USR R GRP USR
# U V P
# CHECK FOR PARAMETER 1 OR 0 TO COMPILE THIS:
# I KC TR
#
echo " "
echo "        ==========================================================================="
echo "                            Programa Compilador de Estructuras                     "
echo "        ==========================================================================="
# PathDDL (Archivos DDLGEN)
PathDDL=$(pwd)/Scripts/$1
ConfigFile=$(pwd)/DDL.config
# ASE NAME
Servidor=$2
Usuario=$3
Password=$4
echo ${PathDDL}
while read tipo
do
	echo " "
	echo "        ==========================================================================="
	echo "                            Compilando: ${tipo}                                        "
	echo "        ==========================================================================="
	ls -ltr ${PathDDL}/*.${tipo}.out | awk '{print $9}' > ${PathDDL}/Archivos.${tipo}.out
	Archivo_Tipos=${PathDDL}/Archivos.${tipo}.out
	echo $Archivo_Tipos
	while read line
	do
		isql -U${Usuario} -P${Password} -S${Servidor} -i$line -o$line.create.out
		cat $line.create.out >> $PathDDL/${tipo}.create
       		rm $line.create.out
	done < $Archivo_Tipos
done < $ConfigFile
#echo " "
#echo "        ==========================================================================="
#echo "                            User Tables U                                          "
#echo "        ==========================================================================="
#
#ls -ltr ${PathDDL}/*.U.out | grep -vE "master|sybsystemprocs|sybsystemdb|sybsecurity|model" | awk '{print $9}' > ${PathDDL}/Archivos.Tablas.out
#Archivo_Tabla=${PathDDL}/Archivos.Tablas.out
#echo $Archivo_Tabla
#while read line
#do
#	#sed 's/with dml_logging/--with dml_logging/g' $line > $line.2
#	#sed 's/partition by roundrobin/--partition by roundrobin/g' $line.2 >> $line.3
#	#sed 's/with exp_row_size/--with exp_row_size/g' $line.3 >> $line.4
#	#sed 's/with identity_gap/--with identity_gap/g' $line.4 >> $line.5
#	#sed 's/with max_rows_per_page/--with max_rows_per_page/g' $line.5 >> $line.6
#        isql -U${Usuario} -P${Password} -S${Servidor} -i$line -o$line.create.out
#        cat $line.create.out >> $PathDDL/Tablas.create
#        rm $line.create.out
#	#rm $line.2
#	#rm $line.3
#	#rm $line.4
#	#rm $line.5
#	#rm $line.6
#done < $Archivo_Tabla
#echo " "
#echo "        ==========================================================================="
#echo "                            Rules  R                                               "
#echo "        ==========================================================================="
#
#        echo "Create Reglas(si/no): "
#        read Opc
#        if [ ${Opc} = "si" ]
#        then
#
#                ls -ltr ${PathDDL}*.R.out | awk '{print $9}' > $PathDDL/Archivos.Reglas.out
#                Archivo_Reglas="$PathDDL/Archivos.Reglas.out"
#
#                while read line
#                do
#
#                        isql -U${Usuario} -P${Password} -S${Servidor} -i$line -o$line.create.out
#                        cat $line.create.out >> $PathDDL/Reglas.create
#                        rm $line.create.out
#
#                done < $Archivo_Reglas
#
#        fi
#
## IMPACTO VISTAS
#
#        echo "Create Vistas(si/no): "
#        read Opc
#        if [ ${Opc} = "si" ]
#        then
#
#                ls -ltr ${PathDDL}*.V.out | awk '{print $9}' > $PathDDL/Archivos.Vistas.out
#                Archivo_Vistas="$PathDDL/Archivos.Vistas.out"
#
#                while read line
#                do
#
#                        isql -U${Usuario} -P${Password} -S${Servidor} -i$line -o$line.create.out
#                        cat $line.create.out >> $PathDDL/Vistas.create
#                        rm $line.create.out
#
#                done < $Archivo_Vistas
#
#        fi

# IMPACTO SPs
#        echo "Create Procs(si/no): "
#        read Opc
#        if [ ${Opc} = "si" ]
#        then
#
#                ls -ltr ${PathDDL}*.P.out | awk '{print $9}' > $PathDDL/Archivos.Procs.out
#                Archivo_Procs="$PathDDL/Archivos.Procs.out"
#
#                while read line
#                do
##			echo "print 'COMIENZO DE COMPILACION DE TABLAS'" > $line.Ejecuta_SPs.tmp
##                       cat $PathDDL/Temporales_SPs.sql >> $line.Ejecuta_SPs.tmp 
#			echo "print 'COMIENZO DE COMPILACION DE SPS'" >> $line.Ejecuta_SPs.tmp
#			cat $line >> $line.Ejecuta_SPs.tmp
#			isql -U${Usuario} -P${Password} -S${Servidor} -i$line.Ejecuta_SPs.tmp -o$line.create
#
#                done < $Archivo_Procs
#
#        fi
