SELECT i.ORDER_NO ""Order_No"",i.DELIVERY_CUSTOMER ""Dealer_ID"",IFSAPP.CUST_ORD_CUSTOMER_API.Get_Name(i.DELIVERY_CUSTOMER) ""Dealer_Name"",
nvl(ifsapp.sales_region_api.Get_Description(DECODE(i.LINE_NO,NULL,(DECODE(i.ORDER_NO,NULL,ifsapp.Cust_Ord_Customer_Address_API.Get_Region_Code(i.DELIVERY_CUSTOMER,
ifsapp.Return_Material_API.Get_Ship_Addr_No(i.RMA_NO)),ifsapp.Customer_Order_API.Get_Region_Code(i.ORDER_NO))),ifsapp.Customer_Order_Line_API.Get_Region_Code(i.ORDER_NO,
i.LINE_NO,i.RELEASE_NO,i.LINE_ITEM_NO))),'NGO and Others')""Region"", ifsapp.sales_district_api.Get_Description(( DECODE(i.LINE_NO, NULL,(DECODE(i.ORDER_NO, NULL,ifsapp.Cust_Ord_Customer_Address_API.Get_District_Code(i.DELIVERY_CUSTOMER, ifsapp.Return_Material_API.Get_Ship_Addr_No(i.RMA_NO)),
ifsapp.Customer_Order_API.Get_District_Code(i.ORDER_NO))),ifsapp.Customer_Order_Line_API.Get_District_Code(i.ORDER_NO, i.LINE_NO, i.RELEASE_NO, i.LINE_ITEM_NO)) )) ""District""
,i.INVOICE_NO ""Invoice No"",i.INVOICE_DATE ""Invoice Date"",
nvl(sum(ifsapp.i.INVOICED_QTY*DECODE(i.ORDER_NO,NULL,i.SALE_UNIT_PRICE*(i.CURR_RATE /i.DIV_FACTOR),DECODE(i.CHARGE_GROUP,NULL,NVL(i.SALE_UNIT_PRICE*(i.CURR_RATE / i.DIV_FACTOR),ifsapp.Sales_Part_API.Get_List_Price
(i.CONTRACT, i.CATALOG_NO)),i.SALE_UNIT_PRICE*(i.CURR_RATE / i.DIV_FACTOR)))),0)""Gross_Sale"",sum(i.net_dom_amount) ""Net_Total"",
nvl(((sum(ifsapp.i.INVOICED_QTY*DECODE(i.ORDER_NO,NULL,i.SALE_UNIT_PRICE*(i.CURR_RATE /i.DIV_FACTOR),DECODE(i.CHARGE_GROUP,NULL,NVL(i.SALE_UNIT_PRICE*(i.CURR_RATE / i.DIV_FACTOR),ifsapp.Sales_Part_API.Get_List_Price
(i.CONTRACT, i.CATALOG_NO)),i.SALE_UNIT_PRICE*(i.CURR_RATE / i.DIV_FACTOR)))))-sum (i.NET_DOM_AMOUNT)),0) ""Commission"",nvl(j.charge_amount,0) ""Transport_Cost"",MP.voucher_no ""Voucher No"",MP.pay_date ""Payment Date"",MP.paid_amount ""Collected Amount"",k.voucher_text ""BranchName""

FROM IFSAPP.CUSTOMER_ORDER_INV_ITEM_JOIN i, IFSAPP.CUSTOMER_ORDER_CHARGE j, IFSAPP.LEDGER_TRANSACTION_MP_QRY MP,  IFSAPP.MIXED_PAYMENT k
WHERE  IFSAPP.CUST_ORD_CUSTOMER_API.Get_Cust_Grp(i.DELIVERY_CUSTOMER)!='RICE' and (IFSAPP.RETURN_MATERIAL_LINE_API.Get_Return_Reason_Code(i.rma_no, i.rma_line_no) = 'WDE' OR IFSAPP.RETURN_MATERIAL_LINE_API.Get_Return_Reason_Code(i.rma_no, i.rma_line_no) IS NULL)
AND    (MP.pay_date between to_date( &FROMYYYYMMDD, 'YYYYMMDD' ) and to_date( &TOYYYYMMDD, 'YYYYMMDD' ) )  
AND i.order_no = j.order_no(+)
   AND MP.identity(+) = i.identity
   AND MP.ledger_item_id(+) = i.invoice_no and k.voucher_no_ref=MP.voucher_no and k.state='Approved'
GROUP BY i.ORDER_NO,i.INVOICE_NO,i.INVOICE_DATE,MP.pay_date ,i.DELIVERY_CUSTOMER,IFSAPP.CUST_ORD_CUSTOMER_API.Get_Name(i.DELIVERY_CUSTOMER),DECODE(i.LINE_NO, NULL,(DECODE(i.ORDER_NO,NULL,IFSAPP.Cust_Ord_Customer_Address_API.Get_Region_Code(i.DELIVERY_CUSTOMER, IFSAPP.Return_Material_API.Get_Ship_Addr_No(i.RMA_NO)),IFSAPP.Customer_Order_API.Get_Region_Code(i.ORDER_NO))),IFSAPP.Customer_Order_Line_API.Get_Region_Code(i.ORDER_NO, i.LINE_NO, i.RELEASE_NO, i.LINE_ITEM_NO)),
ifsapp.sales_district_api.Get_Description(( DECODE(i.LINE_NO, NULL,(DECODE(i.ORDER_NO, NULL,ifsapp.Cust_Ord_Customer_Address_API.Get_District_Code(i.DELIVERY_CUSTOMER, ifsapp.Return_Material_API.Get_Ship_Addr_No(i.RMA_NO)),
ifsapp.Customer_Order_API.Get_District_Code(i.ORDER_NO))),ifsapp.Customer_Order_Line_API.Get_District_Code(i.ORDER_NO, i.LINE_NO, i.RELEASE_NO, i.LINE_ITEM_NO)) )),MP.paid_amount,nvl(j.charge_amount,0),MP.voucher_no,k.voucher_text
ORDER BY 4,2,5