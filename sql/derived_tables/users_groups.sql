DROP TABLE IF EXISTS local.angelazoss_users_group;

-- Create a derived table that takes the user_users table and joins
-- in the group information
-- Does not include addresses - see additional derived tables for addresses
-- in different arrangements
-- Query also depends on separate derived table for user departments
CREATE TABLE local.angelazoss_users_group AS
WITH user_departments AS (
    SELECT
        user_id,
        --STRING_AGG(distinct department_name, '|'::text) AS departments
        string_agg(DISTINCT department_id, '|'::text) AS departments
    FROM
        local.angelazoss_users_departments_unpacked
    GROUP BY
        user_id
)
SELECT
    uu.id AS user_id,
    uu.active,
    uu.barcode,
    uu.created_date,
    uu.enrollment_date,
    uu.expiration_date,
    uu.external_system_id,
    uu.patron_group,
    ug.desc AS group_description,
    ug.group AS group_name,
    ud.departments,
    json_extract_path_text (
        uu.data,
        'personal',
        'lastName'
) AS user_last_name,
    json_extract_path_text (
        uu.data,
        'personal',
        'firstName'
) AS user_first_name,
    json_extract_path_text (
        uu.data,
        'personal',
        'middleName'
) AS user_middle_name,
    json_extract_path_text (
        uu.data,
        'personal',
        'preferredFirstName'
) AS user_preferred_first_name,
    json_extract_path_text (
        uu.data,
        'personal',
        'email'
) AS user_email,
    json_extract_path_text (
        uu.data,
        'personal',
        'phone'
) AS user_phone,
    json_extract_path_text (
        uu.data,
        'personal',
        'mobilePhone'
) AS user_mobile_phone,
    json_extract_path_text (
        uu.data,
        'personal',
        'dateOfBirth'
) AS user_date_of_birth,
    json_extract_path_text (
        uu.data,
        'personal',
        'preferredContactTypeId'
) AS user_preferred_contact_type_id,
    uu.type AS user_type,
    uu.updated_date,
    uu.username,
    json_extract_path_text (
        uu.data,
        'tags'
) AS user_tags,
    json_extract_path_text (
        uu.data,
        'customFields'
) AS user_custom_fields
FROM
    user_users AS uu
    LEFT JOIN user_groups AS ug ON uu.patron_group = ug.id
    LEFT JOIN user_departments AS ud ON uu.id = ud.user_id;

CREATE INDEX ON local.angelazoss_users_group (user_id);

CREATE INDEX ON local.angelazoss_users_group (active);

CREATE INDEX ON local.angelazoss_users_group (barcode);

CREATE INDEX ON local.angelazoss_users_group (created_date);

CREATE INDEX ON local.angelazoss_users_group (enrollment_date);

CREATE INDEX ON local.angelazoss_users_group (expiration_date);

CREATE INDEX ON local.angelazoss_users_group (external_system_id);

CREATE INDEX ON local.angelazoss_users_group (patron_group);

CREATE INDEX ON local.angelazoss_users_group (group_description);

CREATE INDEX ON local.angelazoss_users_group (group_name);

CREATE INDEX ON local.angelazoss_users_group (departments);

CREATE INDEX ON local.angelazoss_users_group (user_last_name);

CREATE INDEX ON local.angelazoss_users_group (user_first_name);

CREATE INDEX ON local.angelazoss_users_group (user_middle_name);

CREATE INDEX ON local.angelazoss_users_group (user_preferred_first_name);

CREATE INDEX ON local.angelazoss_users_group (user_email);

CREATE INDEX ON local.angelazoss_users_group (user_phone);

CREATE INDEX ON local.angelazoss_users_group (user_mobile_phone);

CREATE INDEX ON local.angelazoss_users_group (user_date_of_birth);

CREATE INDEX ON local.angelazoss_users_group (user_preferred_contact_type_id);

CREATE INDEX ON local.angelazoss_users_group (user_type);

CREATE INDEX ON local.angelazoss_users_group (updated_date);

CREATE INDEX ON local.angelazoss_users_group (username);

CREATE INDEX ON local.angelazoss_users_group (user_tags);

CREATE INDEX ON local.angelazoss_users_group (user_custom_fields);

VACUUM local.angelazoss_users_group;

ANALYZE local.angelazoss_users_group;

