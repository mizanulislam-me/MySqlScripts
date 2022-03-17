SELECT 
       v.invoice_id, 
       v.PO_REF_NO,
       v.invoice_date,
       v.invoice_no,
       v.Voucher_No,
       v.identity,
       v.supplier_name,
       v.Net_Amount,
       v.Gross_Amount,
    (SELECT sum(NVL(t.tax_dom_amount,0)) FROM ifsapp.tax_item_qry t WHERE t.invoice_id=v.invoice_id AND t.fee_code like 'TDS%') tds,
    (SELECT sum(NVL(t.tax_dom_amount,0)) FROM ifsapp.tax_item_qry t WHERE t.invoice_id=v.invoice_id AND t.fee_code like 'VDS%') vds, v.Payment_Reference
       
    
    FROM(
    SELECT 
    i.invoice_id,
    i.po_ref_number PO_REF_NO,
    i.invoice_date,
    i.invoice_no,
    i.voucher_no_ref Voucher_No,
    i.identity,
    ifsapp.supplier_info_api.get_name(i.identity) supplier_name,
    i.inv_actual_net_curr_amt   Net_Amount,
    i.inv_gross_curr_amt        Gross_Amount,
    i.NCF_REFERENCE Payment_Reference
    
FROM
    ifsapp.man_supp_invoice   i
)v

WHERE 
 v.INVOICE_DATE between to_date( &FROMYYYYMMDD, 'YYYYMMDD' ) and to_date( &TOYYYYMMDD, 'YYYYMMDD' ) and v.identity like UPPER('&SUPPLIER') and v.invoice_no like '&INVOICE_NO'