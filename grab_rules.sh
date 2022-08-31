#!/bin/bash

RULES_TAR="snort3-community-rules.tar.gz"
RULES_DIR=${RULES_TAR%.tar.gz}
RULES_FILE="snort3-community.rules"
MASTER_RULES="snort.rules"

# Retrieve rules
cd ./etc/rules/
wget https://www.snort.org/downloads/community/$RULES_TAR
tar xvfz $RULES_TAR
# Combine rules
mv ${RULES_DIR}/* .
cat ${RULES_FILE} >> ${MASTER_RULES}
# Clean up
rm -rf ${RULES_TAR} ${RULES_DIR} ${RULES_FILE}
rm AUTHORS LICENSE VRT-License.txt

