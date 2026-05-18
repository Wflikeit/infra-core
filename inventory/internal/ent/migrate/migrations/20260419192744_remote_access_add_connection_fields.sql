-- Modify "remote_access_configurations" table
ALTER TABLE "remote_access_configurations" ADD COLUMN "proxy_host" character varying NULL, ADD COLUMN "session_token" character varying NULL;

-- Enforce at most one RemoteAccessConfiguration per Instance (proto ent.edge unique on instance).
-- If this migration fails, remove duplicate rows for the same remote_access_configuration_instance
-- (e.g. infra-managers/remote-access seed -cleanup-for-host) then re-apply.

-- Keep the row with the highest internal id per instance (typically the newest insert).
DELETE FROM "remote_access_configurations" AS rac
WHERE rac."id" NOT IN (
    SELECT MAX(r2."id")
    FROM "remote_access_configurations" AS r2
    GROUP BY r2."remote_access_configuration_instance"
);

-- atlas:nolint MF101 -- duplicates removed above
CREATE UNIQUE INDEX "remoteaccessconfiguration_instance_key"
    ON "remote_access_configurations" ("remote_access_configuration_instance");
