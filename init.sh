#!/bin/sh

# jq: extract each JSON and generate script taking care of folders and files creation.
# sed: for each script line, remove heading and trailing quote (").
# xargs: execute each line of the script.

#cat $SRC_FILE \
#  | jq 'to_entries | .[] | @sh "mkdir -p $DATA_DIR\(.key) && cat $SRC_FILE | jq '"'"'.[______\(.key)______]'"'"' > $DATA_DIR\(.key)\/$DST_FILENAME"' \
#  | sed -e 's/______/\"/g' \
#  | sed -e 's/^"//' -e 's/"$//' \
#  | xargs -t -n 1 -I "{}" sh -c "{}"

MULTI_ENDPOINT=$(cat $SRC_FILE | jq 'keys | map(test("^/")) | all')

# Check if several endpoints are configured.
if [ "$MULTI_ENDPOINT" = true ] ; then
  # Create directory structure and list endpoints.
  cat $SRC_FILE \
   | jq 'to_entries | .[] | @sh "mkdir -p $DATA_DIR\(.key) && echo \(.key) >> $ENDPOINTS_FILE"' \
   | sed -e 's/^"//' -e 's/"$//' \
   | xargs -t -n 1 -I "{}" sh -c "{}"

  # Create an 'index.json' file for each endpoint.
  while read ENDPOINT; do
    cat $SRC_FILE | jq '.["'$ENDPOINT'"]' > "$DATA_DIR$ENDPOINT/$DST_FILENAME"
  done < $ENDPOINTS_FILE
# Else directly use the source file as response.
else
  cp $SRC_FILE $DATA_DIR
  echo "/" >> $ENDPOINTS_FILE
fi

# Log endpoints.
echo "Active endpoints:"
cat $ENDPOINTS_FILE