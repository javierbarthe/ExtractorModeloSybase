# ExtractorModeloSybase
Extract DDL from Database and Compile in another

Create a Folder on the same folder where you place the scripts called "Scripts"

Example call for DDL Extract: ksh GeneraModelo.sh [ASENAME] [USER] [PASS]
ksh GeneraModelo.sh DB1 sa passw0rd
This will generate under Scripts folder another folder called DB1.
To modify the database list, check inside there is a query to sysdatabases.

Example call for DDL Compile: ksh CompilaModelo.sh [FROM ASENAME] [TO ASENAME] [USER] [PASS]
ksh CompilaModelo.sh DB1 SRV16 sa passw0rd
This Scripts will put the outputs on the same folder called DB1.
This script will compile all the objects for all the databases finded inside the folder.
