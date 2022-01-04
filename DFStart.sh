CDF_INSTANCE_ID=testfusion1
CDF_REGION=us-west1
CDF_PIPELINE=NewFromDB1toGCS
NAMESPACE=default

export AUTH_TOKEN=$(gcloud auth print-access-token)

export CDAP_ENDPOINT=$(gcloud beta data-fusion instances describe --location=${CDF_REGION} --format="value(apiEndpoint)" ${CDF_INSTANCE_ID})

#Without params
#curl -X POST -H "Authorization: Bearer ${AUTH_TOKEN}" "${CDAP_ENDPOINT}/v3/namespaces/default/apps/${CDF_PIPELINE}/workflows/DataPipelineWorkflow/start"

export RUNTIME_ARGS='{ "foldername":"tbl212", "tblname":"tbl1" }'

curl -s -X POST -d "${RUNTIME_ARGS}" \
    -H "Authorization: Bearer ${AUTH_TOKEN}" \
    "${CDAP_ENDPOINT}/v3/namespaces/${NAMESPACE}/apps/${CDF_PIPELINE}/workflows/DataPipelineWorkflow/start"

