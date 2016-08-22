#!/bin/sh

# jq: extract each JSON and generate script taking care of folders and files creation.
# sed: for each script line, remove heading and trailing quote (").
# xargs: execute each line of the script.

#cat /data.json \
#  | jq 'to_entries | .[] | @sh "mkdir -p $DATA_DIR\(.key) && cat $SRC_FILE | jq '"'"'.[______\(.key)______]'"'"' > $DATA_DIR\(.key)\/$DST_FILENAME"' \
#  | sed -e 's/______/\"/g' \
#  | sed -e 's/^"//' -e 's/"$//' \
#  | xargs -t -n 1 -I "{}" sh -c "{}"

# Create directory structure and list endpoints.
cat /data.json \
 | jq 'to_entries | .[] | @sh "mkdir -p $DATA_DIR\(.key) && echo \(.key) >> $ENDPOINTS_FILE"' \
 | sed -e 's/^"//' -e 's/"$//' \
 | xargs -t -n 1 -I "{}" sh -c "{}"

# Create an 'index.json' file for each endpoint.
while read ENDPOINT; do
  cat /data.json | jq '.["'$ENDPOINT'"]' > "$DATA_DIR$ENDPOINT/$DST_FILENAME"
done < $ENDPOINTS_FILE

# Log endpoints.
echo "Active endpoints:"
cat $ENDPOINTS_FILE