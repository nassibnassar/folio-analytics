DROP TABLE IF EXISTS folio_derived.agreements_package_content_item;

-- Creates a derived table on all needed data of package_content_items that either 
-- are linked directly to an entitlement or have an package linked that is linked to an entitlement
CREATE TABLE folio_derived.agreements_package_content_item AS
SELECT
    pci_list.pci_id,
    pci_list.pci_access_start,
    pci_list.pci_access_end,
    pci_list.pci_package_id,
    pci_list.pci_removed_ts, 
    pci_list.package_source,
    pci_list.package_vendor_id,
    pci_list.org_vendor_name,
    pci_list.package_remote_kb_id,
    pci_list.remotekb_remote_kb_name,
    pci_list.package_reference,
    pci_list.pci_platform_title_instance_id,
    pci_list.pti_platform_id,
    pci_list.pt_platform_name,
    pci_list.pti_title_instance_id,
    pci_list.pti_url,
    pci_list.ti_id,
    pci_list.ti_work_id,
    pci_list.ti_date_monograph_published,
    pci_list.ti_first_author,
    pci_list.ti_monograph_edition,
    pci_list.ti_monograph_volume,
    pci_list.ti_first_editor,
    pci_list.identifier_id,
    pci_list.identifier_value,
    pci_list.identifier_namespace_id,
    pci_list.identifiernamespace_name,
	pci_list.entitlement_id
FROM
(
	SELECT
	    pci.id AS pci_id,
	    pci.pci_access_start,
	    pci.pci_access_end,
	    pci.pci_pkg_fk AS pci_package_id,
	    pci.pci_removed_ts,
	    pack.pkg_source AS package_source,
	    pack.pkg_vendor_fk AS package_vendor_id,
	    org.org_name AS org_vendor_name,
	    pack.pkg_remote_kb AS package_remote_kb_id,
	    remotekb.rkb_name AS remotekb_remote_kb_name,
	    pack.pkg_reference AS package_reference,
	    pci.pci_pti_fk AS pci_platform_title_instance_id,
	    pti.pti_pt_fk AS pti_platform_id,
	    pt.pt_name AS pt_platform_name,
	    pti.pti_ti_fk AS pti_title_instance_id,
	    pti.pti_url,
	    ti.id AS ti_id,
	    ti.ti_work_fk AS ti_work_id,
	    ti.ti_date_monograph_published,
	    ti.ti_first_author,
	    ti.ti_monograph_edition,
	    ti.ti_monograph_volume,
	    ti.ti_first_editor,
	    id.id_id AS identifier_id,
	    id.id_value AS identifier_value,
	    id.id_ns_fk AS identifier_namespace_id,
	    idns.idns_value AS identifiernamespace_name,
		ent.ent_id AS entitlement_id
	FROM
	    folio_agreements.package_content_item AS pci
	    INNER JOIN folio_agreements.entitlement AS ent ON pci.id = ent.ent_resource_fk
	    LEFT JOIN folio_agreements.package AS pack ON pci.pci_pkg_fk = pack.id
	    LEFT JOIN folio_agreements.org AS org ON pack.pkg_vendor_fk = org.org_id
	    LEFT JOIN folio_agreements.remotekb AS remotekb ON pack.pkg_remote_kb = remotekb.rkb_id
	    LEFT JOIN folio_agreements.platform_title_instance AS pti ON pci.pci_pti_fk = pti.id
	    LEFT JOIN folio_agreements.platform AS pt ON pti.pti_pt_fk = pt.pt_id
	    LEFT JOIN folio_agreements.title_instance AS ti ON pti.pti_ti_fk = ti.id
	    LEFT JOIN folio_agreements.identifier_occurrence AS oc ON ti.id = oc.io_ti_fk
	    LEFT JOIN folio_agreements.identifier AS id ON oc.io_identifier_fk = id.id_id
	    LEFT JOIN folio_agreements.identifier_namespace AS idns ON id.id_ns_fk = idns.idns_id
	UNION 
	SELECT
	    pci.id AS pci_id,
	    pci.pci_access_start,
	    pci.pci_access_end,
	    pci.pci_pkg_fk AS pci_package_id,
	    pci.pci_removed_ts,
	    pack.pkg_source AS package_source,
	    pack.pkg_vendor_fk AS package_vendor_id,
	    org.org_name AS org_vendor_name,
	    pack.pkg_remote_kb AS package_remote_kb_id,
	    remotekb.rkb_name AS remotekb_remote_kb_name,
	    pack.pkg_reference AS package_reference,
	    pci.pci_pti_fk AS pci_platform_title_instance_id,
	    pti.pti_pt_fk AS pti_platform_id,
	    pt.pt_name AS pt_platform_name,
	    pti.pti_ti_fk AS pti_title_instance_id,
	    pti.pti_url,
	    ti.id AS ti_id,
	    ti.ti_work_fk AS ti_work_id,
	    ti.ti_date_monograph_published,
	    ti.ti_first_author,
	    ti.ti_monograph_edition,
	    ti.ti_monograph_volume,
	    ti.ti_first_editor,
	    id.id_id AS identifier_id,
	    id.id_value AS identifier_value,
	    id.id_ns_fk AS identifier_namespace_id,
	    idns.idns_value AS identifiernamespace_name,
		ent.ent_id AS entitlement_id
	FROM
	    folio_agreements.package_content_item AS pci 
	    LEFT JOIN folio_agreements.package AS pack ON pci.pci_pkg_fk = pack.id
	    INNER JOIN folio_agreements.entitlement AS ent ON ent.ent_resource_fk = pack.id
	    LEFT JOIN folio_agreements.org AS org ON pack.pkg_vendor_fk = org.org_id
	    LEFT JOIN folio_agreements.remotekb AS remotekb ON pack.pkg_remote_kb = remotekb.rkb_id
	    LEFT JOIN folio_agreements.platform_title_instance AS pti ON pci.pci_pti_fk = pti.id
	    LEFT JOIN folio_agreements.platform AS pt ON pti.pti_pt_fk = pt.pt_id
	    LEFT JOIN folio_agreements.title_instance AS ti ON pti.pti_ti_fk = ti.id
	    LEFT JOIN folio_agreements.identifier_occurrence AS oc ON ti.id = oc.io_ti_fk
	    LEFT JOIN folio_agreements.identifier AS id ON oc.io_identifier_fk = id.id_id
	    LEFT JOIN folio_agreements.identifier_namespace AS idns ON id.id_ns_fk = idns.idns_id
) AS pci_list;

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_access_start);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_access_end);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_package_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_removed_ts);

CREATE INDEX ON folio_derived.agreements_package_content_item (package_source);

CREATE INDEX ON folio_derived.agreements_package_content_item (package_vendor_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (org_vendor_name);

CREATE INDEX ON folio_derived.agreements_package_content_item (package_remote_kb_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (remotekb_remote_kb_name);

CREATE INDEX ON folio_derived.agreements_package_content_item (package_reference);

CREATE INDEX ON folio_derived.agreements_package_content_item (pci_platform_title_instance_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pti_platform_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pt_platform_name);

CREATE INDEX ON folio_derived.agreements_package_content_item (pti_title_instance_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (pti_url);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_work_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_date_monograph_published);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_first_author);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_monograph_edition);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_monograph_volume);

CREATE INDEX ON folio_derived.agreements_package_content_item (ti_first_editor);

CREATE INDEX ON folio_derived.agreements_package_content_item (identifier_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (identifier_value);

CREATE INDEX ON folio_derived.agreements_package_content_item (identifier_namespace_id);

CREATE INDEX ON folio_derived.agreements_package_content_item (identifiernamespace_name);

CREATE INDEX ON folio_derived.agreements_package_content_item (entitlement_id);
