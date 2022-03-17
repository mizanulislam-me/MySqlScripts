SELECT SUPP.ORDER_NO, SUPP.SUPPLIER_NO, SUPP.SUPPLIER, SUPP.ARITCLE, SUPP.ORDER_QTY, NVL(RECV.RECEIVE_QTY,0) RECEIVED_QTY, NVL((SUPP.ORDER_QTY - RECV.RECEIVE_QTY),SUPP.ORDER_QTY) REMAINING_QTY, COMP.COMPONENT, round(COST.UNIT_COST, 2) RM_UNIT_VALUE, ROUND((NVL((SUPP.ORDER_QTY - RECV.RECEIVE_QTY),SUPP.ORDER_QTY)* COST.UNIT_COST),2) "TOTAL_VALUE"

  FROM (select t.ORDER_NO Order_No,
               t.VENDOR_NO Supplier_No,
               IFSAPP.Supplier_API.Get_Vendor_name(IFSAPP.PURCHASE_ORDER_API.Get_Vendor_No(t.ORDER_NO)) Supplier,
               substr2(t.PART_NO, 1, 8) Aritcle,
               sum(t.BUY_QTY_DUE) Order_QTY
          from PURCHASE_ORDER_LINE_PART t
         where t.contract = 'U2CDC'
           and t.OBJSTATE != 'Cancelled'
           and t.VENDOR_NO like NVL('&Supplier_No','%FG')
           and t.ORDER_NO like NVL('&PurchaseOrder_No','B%')
         group by substr2(t.PART_NO, 1, 8), t.VENDOR_NO, t.ORDER_NO) SUPP LEFT JOIN
       
       (Select prn.order_no OrderNo, prn.vendor_no SupplierNo,
               substr2(prn.part_no, 1, 8) Part_No,
               sum(prn.INV_QTY_ARRIVED) Receive_Qty
          From PURCHASE_RECEIPT_NEW prn
         where prn.contract = 'U2CDC'
           and PRN.OBJSTATE = 'Received'
           and PRN.vendor_no like NVL('&Supplier_No','%FG') 
           and PRN.order_no like NVL('&PurchaseOrder_No','B%')
         group by substr2(prn.part_no, 1, 8), prn.order_no, prn.vendor_no) RECV ON RECV.PART_NO = SUPP.ARITCLE and RECV.ORDERNO = SUPP.ORDER_NO and RECV.SUPPLIERNO = SUPP.SUPPLIER_NO,
       
       (SELECT h.ORDER_NO ORDER_NO,
               substr2(h.PART_NO, 1, 8) ARTICLE,
               c.component_part COMPONENT
          FROM PURCHASE_ORDER_LINE_COMP c, PURCHASE_ORDER_LINE_PART h
         where c.order_no = h.order_no
           and c.line_no = h.LINE_NO
           and h.BUY_QTY_DUE=c.qty_issued
           and c.order_no like NVL('&PurchaseOrder_No','B%')
         group by substr2(h.PART_NO, 1, 8), h.ORDER_NO, c.component_part) COMP,
       
       (SELECT avg(h2.cost) UNIT_COST, h2.part_no PART
          FROM IFSAPP.INVENTORY_TRANSACTION_HIST2 h2
         WHERE h2.source_ref1 like NVL('&PurchaseOrder_No','B%')
           and h2.contract = 'U2CDC'
         GROUP BY h2.part_no) COST

WHERE SUPP.Order_No = COMP.ORDER_NO
   and SUPP.ARITCLE = COMP.ARTICLE
   and COMP.COMPONENT = COST.PART
   and NVL((SUPP.ORDER_QTY - RECV.RECEIVE_QTY),SUPP.ORDER_QTY) >0
   
   
 ORDER BY 1,4


-- by Mizanul Islam
