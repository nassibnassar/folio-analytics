DROP TABLE IF EXISTS folio_derived.finance_transaction_invoices;

-- Create a derived table that joins invoice and invoice_lines fields to transactions for expenditure reports in system currency
--
-- Tables included:
--   folio_finance.transaction
--   folio_invoice.invoices
--   folio_invoice.invoice_lines
--   folio_finance.fund
--   folio_finance.budget
CREATE TABLE folio_derived.finance_transaction_invoices AS
SELECT
    ft.id AS transaction_id,
    json_extract_path_text(ft.jsonb, 'amount') AS transaction_amount,
    json_extract_path_text(ft.jsonb, 'currency') AS transaction_currency,
    ft.expenseclassid AS transaction_expense_class_id,
    ft.fiscalyearid AS transaction_fiscal_year_id,
    ft.fromfundid AS transaction_from_fund_id,
    json_extract_path_text(ff.jsonb, 'name') AS transaction_from_fund_name,
    json_extract_path_text(ff.jsonb, 'code') AS transaction_from_fund_code,
    fb.id AS transaction_from_budget_id,
    json_extract_path_text(fb.jsonb, 'name') AS transaction_from_budget_name,
    json_extract_path_text(ft.jsonb, 'sourceInvoiceId') AS invoice_id,
    json_extract_path_text(ft.jsonb, 'sourceInvoiceLineId') AS invoice_line_id,
    json_extract_path_text(ft.jsonb, 'transactionType') AS transaction_type,
    json_extract_path_text(ii.jsonb, 'invoiceDate') AS invoice_date,
    json_extract_path_text(ii.jsonb, 'paymentDate') AS invoice_payment_date,
    json_extract_path_text(ii.jsonb, 'exchangeRate') AS invoice_exchange_rate,
    json_extract_path_text(il.jsonb, 'total') AS invoice_line_total,
    json_extract_path_text(ii.jsonb, 'currency') AS invoice_currency,
    json_extract_path_text(il.jsonb, 'poLineId') AS po_line_id,
    json_extract_path_text(ii.jsonb, 'vendorId') AS invoice_vendor_id,
    json_extract_path_text(oo.jsonb, 'name') AS invoice_vendor_name
FROM
    folio_finance.transaction AS ft
    LEFT JOIN folio_invoice.invoices AS ii ON json_extract_path_text(ft.jsonb, 'sourceInvoiceId') = ii.id
    LEFT JOIN folio_invoice.invoice_lines AS il ON json_extract_path_text(ft.jsonb, 'sourceInvoiceLineId') = il.id
    LEFT JOIN folio_finance.fund AS ff ON ft.fromfundid = ff.id
    LEFT JOIN folio_finance.budget AS fb ON ft.fromfundid = fb.fundid AND ft.fiscalyearid = fb.fiscalyearid
    LEFT JOIN folio_organizations. organizations AS oo ON json_extract_path_text(ii.jsonb, 'vendorId') = oo.id
WHERE (json_extract_path_text(ft.jsonb, 'transactionType') = 'Pending payment'
    OR json_extract_path_text(ft.jsonb, 'transactionType') = 'Payment');

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_amount);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_currency);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_expense_class_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_fiscal_year_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_fund_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_fund_name);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_fund_code);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_budget_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_budget_name);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_line_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_type);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_date);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_payment_date);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_exchange_rate);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_line_total);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_currency);

CREATE INDEX ON folio_derived.finance_transaction_invoices (po_line_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_vendor_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_vendor_name);
