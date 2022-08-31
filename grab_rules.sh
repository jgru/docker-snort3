#!/bin/bash
# Just a simple script to grab the newest community rules
# Eventually, change this to use pulledpork in the future
#
RULES_TAR="snort3-community-rules.tar.gz"
RULES_DIR=${RULES_TAR%.tar.gz}
RULES_FILE="snort3-community.rules"
MASTER_RULES="snort.rules"

# Retrieve rules
cd ./etc/rules/
echo "[*] Downloading ${RULES_TAR}"
wget https://www.snort.org/downloads/community/$RULES_TAR 2> /dev/null && echo "[+] Retrieved ${RULES_TAR}"
tar xvfz $RULES_TAR > /dev/null && echo "[+] Extracted ${RULES_TAR}"

# Combine rules
mv ${RULES_DIR}/* .
CNT=$(wc -l ${MASTER_RULES} | cut -f1 -d' ')
cat ${RULES_FILE} >> ${MASTER_RULES}
echo "$(sort -u ${MASTER_RULES})" > ${MASTER_RULES}
CNTNEW=$(wc -l ${MASTER_RULES} | cut -f1 -d' ')
echo "[*] Added $((CNTNEW - CNT)) rules"
# Clean up
rm -rf ${RULES_TAR} ${RULES_DIR} ${RULES_FILE}
rm AUTHORS LICENSE VRT-License.txt

