SELECT 
       ct.pay_date "Payment Date",
       lt.identity "Dealer_ID",
       lt.name "Dealer Name",
       ad.address_lov "Dealer Address",
       cs.D_Code "Depot ID",
       cs.D_Name "Depot Name",
       --ct.short_name "Cash Account",
       ct.payment_id,
       ct.voucher_no,
       ct.curr_amount "Amount"

FROM 
       IFSAPP.CASH_TRANSACTION_CU_QRY ct, IFSAPP.LEDGER_TRANSACTION_CU_QRY lt, CUSTOMER_INFO_ADDRESS ad,
       (SELECT short_name D_ID, regexp_substr(DESCRIPTION,'[^-]+$') D_Name, regexp_substr(DESCRIPTION,'[^ ]+',1,4) D_Code FROM CASH_ACCOUNT WHERE SHORT_NAME like 'U2%' and account_identity like 'D%')cs

WHERE 
       ct.series_id=lt.SERIES_ID and
       ct.payment_id=lt.PAYMENT_ID and
       lt.IDENTITY=ad.customer_id and
       ct.short_name=cs.D_ID and
       ct.SERIES_ID = 'CUPAY' and
       lt.IDENTITY like 'U2%' and
       ct.pay_date between to_date('&From_Date','dd/mm/yyyy') and to_date('&To_Date','dd/mm/yyyy') 

ORDER BY ct.short_name

-- Date format:  dd/mm/yyyy
