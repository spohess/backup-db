#!/bin/bash
#
# Script apara fazer DUMP de produção
# v1.0

SCRIPT=$(readlink -f "$0")
SCRIPT_HOME=$(dirname "$SCRIPT")

cd ${SCRIPT_HOME} || exit

. $SCRIPT_HOME/variaveis

# Criando diretorio de log
if [ ! -d "$DIR_LOG" ]
then
    mkdir -p ${DIR_LOG}
fi

# Criando diretorio de DUMP diario
if [ ! -d "$DIR_DUMP" ]
then
    mkdir -p ${DIR_DUMP}
fi

function geralog()
{
    echo '['`date '+%Y-%m-%d %H:%M:%S'`'] # ' $1 >> ${ARQ_LOG}
}

geralog '################### Script iniciado ###################'

geralog '##### Iniciando DUMP completo de bancos'
while read BANCO
do 

geralog '   Iniciando DUMP da banco de dados '${BANCO}
mysqldump -u${DUMP_USUARIO} -h${DUMP_LOCAL} --databases ${BANCO} > ${LOCAL_DUMP}/${BANCO}.sql
geralog '   DUMP da banco de dados '${BANCO}' finalizado'

done < ${ARQ_DBS}
geralog '##### Finalizado DUMP completo de bancos'

geralog 'Compactando diretorio'
tar -vcf ${DIR_DUMP}.tar ${DIR_DUMP} >> ${ARQ_LOG}
geralog 'Diretorio compactado'

geralog 'Comprimindo arquivo'
gzip -9 -f ${DIR_DUMP}.tar >> ${ARQ_LOG}
geralog 'Arquivo comprimido'

geralog 'Removendo diretorio de DUMP diario'
rm -rdf ${DIR_DUMP} >> ${ARQ_LOG}
geralog 'Diretorio removido'

geralog '################### Script finalizado ###################'

exit 0
