select substr(ifsapp.inventory_part_api.Get_Part_Product_Code('LTS-1',i.catalog_no),0,2) Crop, 
i.CATALOG_NO Variety, i.DESCRIPTION Description,
ifsapp.inventory_part_api.Get_Weight_Net('LTS-1',i.catalog_no)*1000 "Pack Size (Grams)"
,sum(i.invoiced_qty) "Total Packet",
ifsapp.inventory_part_api.Get_Weight_Net('LTS-1',i.catalog_no)*sum(i.invoiced_qty) Kg
,sum(DECODE(i.ORDER_NO,NULL,i.SALE_UNIT_PRICE*(i.CURR_RATE /i.DIV_FACTOR),DECODE(i.CHARGE_GROUP,NULL,NVL(i.SALE_UNIT_PRICE*(i.CURR_RATE / i.DIV_FACTOR),ifsapp.Sales_Part_API.Get_List_Price(i.CONTRACT, i.CATALOG_NO)),i.SALE_UNIT_PRICE*(i.CURR_RATE / i.DIV_FACTOR)))*i.invoiced_qty)  Tk
from IFSAPP.CUSTOMER_ORDER_INV_ITEM_JOIN i
Where  i.INVOICE_DATE between to_date( &FROMYYYYMMDD, 'YYYYMMDD' ) and to_date( &TOYYYYMMDD, 'YYYYMMDD' )  and (IFSAPP.RETURN_MATERIAL_LINE_API.Get_Return_Reason_Code(i.rma_no, i.rma_line_no) =  'WDE' OR IFSAPP.RETURN_MATERIAL_LINE_API.Get_Return_Reason_Code(i.rma_no, i.rma_line_no) IS NULL) and i.CATALOG_NO not like '%RICE%'
Group by i.CATALOG_NO, i.DESCRIPTION, ifsapp.inventory_part_api.Get_Weight_Net('LTS-1',i.catalog_no)                 
order by 1 asc, 2 asc