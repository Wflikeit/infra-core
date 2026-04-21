-- Modify "remote_access_configurations" table
ALTER TABLE "remote_access_configurations" ADD COLUMN "proxy_host" character varying NULL, ADD COLUMN "session_token" character varying NULL;
