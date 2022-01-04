CDF_INSTANCE_ID=testfusion1
CDF_REGION=us-west1
CDF_PIPELINE=NewFromDB1toGCS
##
## Get initial access token and URLs
##
AUTH_TOKEN=$(gcloud auth print-access-token)

CDAP_ENDPOINT=$(gcloud beta data-fusion instances describe \
    --location=${CDF_REGION} \
    --format="value(apiEndpoint)" \
    ${CDF_INSTANCE_ID})

WF_URL="${CDAP_ENDPOINT}/v3/namespaces/default/apps/${CDF_PIPELINE}/workflows/DataPipelineWorkflow"

##
## Get the Run IDs for each run of our pipeline
##
RUN_IDS=`curl -s -X GET \
    -H "Authorization: Bearer ${AUTH_TOKEN}" \
    "${WF_URL}/runs" \
    | jq -r '.[].runid'`
##
## For each run, display information about the run
##
for RUN_ID in ${RUN_IDS}
do
    ##
    ## Get run details for when the run started and finished
    ##
    RUN_DETAILS=`curl -s -X GET \
        -H "Authorization: Bearer ${AUTH_TOKEN}" \
        "${WF_URL}/runs/${RUN_ID}" \
        | jq -r '.runid, .starting, .start, .end, .status'`
    
    RUN_DETAILS_ARRAY=(${RUN_DETAILS})
    
    ##
    ## The timestamp values come back as seconds since epoch, 
    ## so below we use "date --date @<SecondsSinceEpoch> to make 
    ## the output easier to read, but if you just want the 
    ## latest run, just get the largest epoch.
    ##
    echo ""
    echo "Run ID:        ${RUN_DETAILS_ARRAY[0]}"
    echo "Starting Time: `date --date @${RUN_DETAILS_ARRAY[1]}`"
    echo "Start Time:    `date --date @${RUN_DETAILS_ARRAY[2]}`"
    echo "End Time:      `date --date @${RUN_DETAILS_ARRAY[3]}`"
    echo "Status:        ${RUN_DETAILS_ARRAY[4]}"

done