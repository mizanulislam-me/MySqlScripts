SELECT SOM.LINE_ITEM_NO, SOM.ORDER_NO as Shop_Order,
       SOM.PART_NO as Component_Part,
       Inventory_Part_API.Get_Description(SOM.contract, SOM.part_no) as Component_Part_Description,
       INVENTORY_PART_API.Get_Unit_Meas(SOM.Contract, SOM.Part_No) as UoM,
       SOM.OP_NO,
       SOM.QTY_PER_ASSEMBLY,
       SOM.QTY_REQUIRED,
       SOM.QTY_ISSUED,
       ROUND(COST.UNIT_COST,2) Cost_per_Unit,
       ROUND((SOM.QTY_REQUIRED*COST.UNIT_COST),2) "Total Value as Required",
       ROUND((SOM.QTY_ISSUED*COST.UNIT_COST),2) "Total Value as Issued",
       ROUND(((SOM.QTY_REQUIRED*COST.UNIT_COST)-(SOM.QTY_ISSUED*COST.UNIT_COST)),2) "Total Value Variance",
       ROUND((SOM.QTY_REQUIRED-SOM.QTY_ISSUED),2) "Qty Variance",
       ROUND((((SOM.QTY_REQUIRED-SOM.QTY_ISSUED)/SOM.QTY_REQUIRED)*100),2) "% Of Variance",
       NVL(ALLOC.Required_Qty,0) "Re-Cutting Required Qty",
       NVL(ROUND(((ALLOC.Required_Qty/SOM.QTY_REQUIRED)*100),2),0) "% of Re-Cutting Required Material",
       NVL(ALLOC.ISSUED,0) "Re-Cutting Issued Qty",
       NVL(ROUND((COST.UNIT_COST*ALLOC.Required_Qty),2),0) "Total Value of SO Re-cutting  Required Qty",
       NVL(ROUND((COST.UNIT_COST*ALLOC.Issued),2),0) "Total Value of SO Re-cutting  Issued Qty"

       --CASE ALLOC.Required_Qty WHEN (ALLOC.OP_NO = SOM.OP_NO and ALLOC.INFO_1 = SOM.INFO1) THEN ALLOC.Required_Qty ELSE 0 END "Re-Cutting Required Qty",
       --CASE ALLOC.ISSUED WHEN (ALLOC.OP_NO = SOM.OP_NO and ALLOC.INFO_1 = SOM.INFO1) THEN ALLOC.ISSUED ELSE 0 END "Re-Cutting Issued Qty"

      
FROM 
       SHOP_MATERIAL_ALLOC_UIV SOM LEFT JOIN
        
       (Select DISTINCT(Shop_Material_Alloc_API.Get_Op_No(r.order_no, r.release_no, r.sequence_no, r.line_item_no)) OP_NO, Shop_Material_Alloc_API.Get_Part_No(R.ORDER_NO,R.RELEASE_NO,R.SEQUENCE_NO,R.LINE_ITEM_NO) Componant, R.REQUIRED_QTY, R.ORDER_NO ORDERNO,
         C_Shop_Ord_Mat_Req_Dtl_API.Get_Request_Issued_Qty(REQ_NO, R.ORDER_NO, R.RELEASE_NO, R.SEQUENCE_NO, R.LINE_ITEM_NO) Issued, Shop_Material_Alloc_API.Get_Info1(R.ORDER_NO,R.RELEASE_NO,R.SEQUENCE_NO,R.LINE_ITEM_NO) INFO_1
        FROM C_SHOP_ORD_MAT_REQ_DTL R WHERE C_Shop_Ord_Mat_Req_Head_API.Get_Request_Type(REQ_NO) = 'Re-Cutting' and R.order_no='2107LS1-53') ALLOC
        
        ON ALLOC.OP_NO=SOM.OP_NO and ALLOC.INFO_1 = SOM.INFO1 and ALLOC.ORDERNO=SOM.order_no and ALLOC.Componant=SOM.part_no,
       
       (SELECT avg(h2.cost) UNIT_COST, h2.part_no PART
          FROM IFSAPP.INVENTORY_TRANSACTION_HIST2 h2
          WHERE h2.source_ref1 like ('2107LS1-53')
         GROUP BY h2.part_no) COST
         
        
              
WHERE
         SOM.order_no='2107LS1-53'
         --and SOM.part_no='02-GOAT-63'
         and SOM.PART_NO=COST.PART
         --and SOM.order_no=ALLOC.ORDERNO
         --and SOM.part_no=ALLOC.Componant
         
         
         --and (CASE WHEN ALLOC.OP_NO=SOM.OP_NO and ALLOC.INFO_1=SOM.INFO1 THEN ALLOC.Required_Qty ELSE 0 END)=ALLOC.Required_Qty
         --and (CASE WHEN ALLOC.OP_NO=SOM.OP_NO and ALLOC.INFO_1=SOM.INFO1 THEN ALLOC.ISSUED ELSE 0 END)=ALLOC.ISSUED
         


ORDER BY 3
