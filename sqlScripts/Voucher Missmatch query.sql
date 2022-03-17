select Q.voucher_type,
       Q.voucher_no,
       sum(Q.debet_amount),
       sum(Q.credit_amount)
  from GEN_LED_VOUCHER_ROW_UNION_QRY Q
 where Q.accounting_year = 2021
   and Q.accounting_period = 12
   and CODE_B = 'UNIT2'
 group by Q.voucher_type, Q.voucher_no