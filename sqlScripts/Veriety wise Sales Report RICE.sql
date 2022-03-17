SELECT nvl(ifsapp.sales_region_api.Get_Description(DECODE(i.LINE_NO,NULL,(DECODE(i.ORDER_NO,NULL,ifsapp.Cust_Ord_Customer_Address_API.Get_Region_Code(i.DELIVERY_CUSTOMER,
        ifsapp.Return_Material_API.Get_Ship_Addr_No(i.RMA_NO)),ifsapp.Customer_Order_API.Get_Region_Code(i.ORDER_NO))),ifsapp.Customer_Order_Line_API.Get_Region_Code(i.ORDER_NO,
        i.LINE_NO,i.RELEASE_NO,i.LINE_ITEM_NO))),'NGO and Others') ""Region"",
            SUBSTR(IFSAPP.Inventory_Part_Api.Get_Part_Product_Code(contract,i.catalog_no),0,2) ""Product_Family"",
              ifsapp.inventory_part_api.Get_Type_Designation(contract, i.catalog_no) ""Variety_Name"",
             sum( ifsapp.i.INVOICED_QTY*DECODE(i.ORDER_NO,NULL,i.SALE_UNIT_PRICE*(i.CURR_RATE /i.DIV_FACTOR),DECODE(i.CHARGE_GROUP,NULL,NVL(i.SALE_UNIT_PRICE*(i.CURR_RATE / i.DIV_FACTOR),ifsapp.Sales_Part_API.Get_List_Price
              (i.CONTRACT, i.CATALOG_NO)),i.SALE_UNIT_PRICE*(i.CURR_RATE / i.DIV_FACTOR)))) Value_BDT,
              sum(ifsapp.inventory_part_api.Get_Weight_Net(contract,i.CATALOG_NO)*i.INVOICED_QTY) ""KG_Weight""   
FROM  IFSAPP.CUSTOMER_ORDER_INV_ITEM_JOIN i
 WHERE i.INVOICE_DATE between to_date(&fromYYYYMMDD, 'YYYYMMDD' ) and to_date(&toYYYYMMDD, 'YYYYMMDD' ) and   (IFSAPP.RETURN_MATERIAL_LINE_API.Get_Return_Reason_Code(i.rma_no, i.rma_line_no) =  'WDE' OR IFSAPP.RETURN_MATERIAL_LINE_API.Get_Return_Reason_Code(i.rma_no, i.rma_line_no) IS NULL) and i.CATALOG_NO like '%RICE%'    
Group by nvl(ifsapp.sales_region_api.Get_Description(DECODE(i.LINE_NO,NULL,(DECODE(i.ORDER_NO,NULL,ifsapp.Cust_Ord_Customer_Address_API.Get_Region_Code(i.DELIVERY_CUSTOMER,
        ifsapp.Return_Material_API.Get_Ship_Addr_No(i.RMA_NO)),ifsapp.Customer_Order_API.Get_Region_Code(i.ORDER_NO))),ifsapp.Customer_Order_Line_API.Get_Region_Code(i.ORDER_NO,
        i.LINE_NO,i.RELEASE_NO,i.LINE_ITEM_NO))),'NGO and Others'),IFSAPP.Inventory_Part_Api.Get_Part_Product_Code(contract,i.catalog_no),ifsapp.inventory_part_api.Get_Type_Designation(contract, i.catalog_no)
ORDER BY 1