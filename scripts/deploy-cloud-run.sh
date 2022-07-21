PROJECT_ID="test-alex-cb960"
SERVICE="day-log"
REGION="europe-central2"
INSTANCE_CONNECTION_NAME="test-alex-cb960:europe-central2:test-alex-db"

gcloud config set project $PROJECT_ID

# gcloud builds submit --tag gcr.io/$PROJECT_ID/day_log_api

# gcloud run deploy --image gcr.io/$PROJECT_ID/day_log_api

gcloud beta run deploy $SERVICE \
  --source=. \
  --platform managed \
  --region=$REGION \
  --max-instances=2 \
  --allow-unauthenticated 
  
gcloud run services update $SERVICE \
--add-cloudsql-instances=$INSTANCE_CONNECTION_NAME \
--update-env-vars=INSTANCE_CONNECTION_NAME=$INSTANCE_CONNECTION_NAME \
--update-secrets=DB_USER=DB_USER_SECRET:latest \
--update-secrets=DB_PASS=DB_PASS_SECRET:latest \
--update-secrets=DB_NAME=DB_NAME_SECRET:latest
