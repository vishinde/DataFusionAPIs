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
for run_id in ${RUN_IDS}
do

## For Logs    
    echo ""
    echo "Run ID ${run_id} INFO logs:"
    echo ""
    curl -s -X GET -H "Authorization: Bearer ${AUTH_TOKEN}" "${CDAP_ENDPOINT}/v3/namespaces/default/apps/${CDF_PIPELINE}/workflows/DataPipelineWorkflow/runs/${run_id}/logs?format=json" | jq -r '.[] | select(.log.logLevel == "INFO") | .log.message'
    
    echo ""
    echo "Run ID ${run_id} ERROR logs:"
    echo ""
    curl -s -X GET -H "Authorization: Bearer ${AUTH_TOKEN}" "${CDAP_ENDPOINT}/v3/namespaces/default/apps/${CDF_PIPELINE}/workflows/DataPipelineWorkflow/runs/${run_id}/logs?format=json" | jq -r '.[] | select(.log.logLevel == "ERROR") | .log.message'

done