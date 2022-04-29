#!/bin/bash

# Create Organisation
ORG_ID=$(curl --silent \
  --header "admin-auth: 12345" \
  --header "Content-Type:application/json" \
  --data '{ "owner_name": "Demo User", "cname_enabled": true, "cname": "example", "hybrid_enabled": true, "event_options": { "key_event": { "email": "test@test.com" }, "hashed_key_event": { "email": "test@test.com" } } }' \
  localhost:3000/admin/organisations | jq -r '.Meta')

# Create User
USER=$(curl --silent \
  --header "admin-auth: 12345" \
  --header "Content-Type:application/json" \
  --data '{ "first_name": "Demo", "last_name": "User", "email_address": "user@example.com", "active": true, "org_id": "'$ORG_ID'", "user_permissions": { "IsAdmin": "admin" } }' \
  localhost:3000/admin/users)

USER_ID=$(echo $USER | jq -r '.Meta.id')
USER_KEY=$(echo $USER | jq -r '.Meta.access_key')

# Set user password
USER=$(curl --silent \
  --header "authorization: $USER_KEY" \
  --header "Content-Type:application/json" \
  --data '{ "new_password": "topsecretpassword", "user_permissions": { "IsAdmin": "admin" } }' \
  localhost:3000/api/users/$USER_ID/actions/reset  | jq -r '.Meta')

# Add ORG_ID and USER_KEY values to .env file
sed "s/TYK_GW_SLAVEOPTIONS_RPCKEY=.*/TYK_GW_SLAVEOPTIONS_RPCKEY=$ORG_ID/" .env > .bootstrap.tmp && mv .bootstrap.tmp .env
sed "s/TYK_GW_SLAVEOPTIONS_APIKEY=.*/TYK_GW_SLAVEOPTIONS_APIKEY=$USER_KEY/" .env > .bootstrap.tmp && mv .bootstrap.tmp .env
