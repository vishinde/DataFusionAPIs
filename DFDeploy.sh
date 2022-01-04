CDF_INSTANCE_ID=testfusion1
CDF_REGION=us-west1
CDF_PIPELINE=NewFromDB1toGCS

export AUTH_TOKEN=$(gcloud auth print-access-token)

export CDAP_ENDPOINT=$(gcloud beta data-fusion instances describe --location=${CDF_REGION} --format="value(apiEndpoint)" ${CDF_INSTANCE_ID})

curl -X PUT -H "Authorization: Bearer ${AUTH_TOKEN}" "${CDAP_ENDPOINT}/v3/namespaces/default/apps/${CDF_PIPELINE}" -d "@/home/admin_vs/DataFusion/FromDB2toGCSwithpwd.json"

