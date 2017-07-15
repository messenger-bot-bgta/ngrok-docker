set -m

echo "Starting ngrok"
./ngrok start -config ngrok.yml bot &

echo "Ngrok started waiting 5 seconds..."
sleep 5

URL=$(curl -s http://localhost:4040/api/tunnels/bot | jq -r .public_url)

echo "Public url: $URL"

echo "Configuring Webhook..."

echo "object=page"
echo "callback_url=$URL"
echo "fields=$FIELDS"
echo "verify_token=$VERIFY_TOKEN"
echo "access_token=$APP_ID%7C$APP_SECRET"

RESPONSE=$(curl -s -X POST \
 -d "object=page" \
 -d "callback_url=$URL" \
 -d "fields=$FIELDS" \
 -d "verify_token=$VERIFY_TOKEN" \
 -d "access_token=$APP_ID%7C$APP_SECRET" \
 "https://graph.facebook.com/v2.8/$APP_ID/subscriptions")

echo "Graph API: $RESPONSE"

fg
