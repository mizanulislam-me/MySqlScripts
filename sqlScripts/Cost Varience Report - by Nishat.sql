SELECT o.ORDER_NO as Shop_Order,
       o.PART_NO as Component_Part,
       cost.unit_cost,
       Inventory_Part_API.Get_Description(o.contract, o.part_no) as Component_Part_Description,
       INVENTORY_PART_API.Get_Unit_Meas(o.Contract, o.Part_No) as UoM,
       o.OP_NO,
       o.QTY_PER_ASSEMBLY,
       o.QTY_REQUIRED,
       o.QTY_ISSUED,
       (o.QTY_REQUIRED * cost.unit_cost) Total_Value_Against_Req_qty,
       (o.QTY_ISSUED * cost.unit_cost) Total_Value_Against_Issued_qty,
       ((o.QTY_REQUIRED * cost.unit_cost) - (o.QTY_ISSUED * cost.unit_cost)) Total_Value_Variance,
       (o.QTY_REQUIRED - o.QTY_ISSUED) Qty_Variance,
       to_char(round(((o.QTY_REQUIRED - o.QTY_ISSUED) / o.QTY_REQUIRED) * 100,
                     2)) || '%' Percent_of_Variance,
       
       recutting.REQUIRED_QTY as Recutting_Required_material,
       to_char(round((recutting.REQUIRED_QTY / o.QTY_REQUIRED) * 100, 2)) || '%' Percent_of_Recutting_Required_material,
       recutting.Recutting_Issued_Material,
       
       (cost.unit_cost * recutting.REQUIRED_QTY) Total_Value_Against_Recutting_Request_Qty,
       (cost.unit_cost * recutting.Recutting_Issued_Material) Total_Value_Against_Recutting_Issued_Qty,
       ((cost.unit_cost * recutting.REQUIRED_QTY) -
       (cost.unit_cost * recutting.Recutting_Issued_Material)) Variance

  from SHOP_MATERIAL_ALLOC_UIV o,
       (SELECT c.contract CONTRACT,
               c.part_no PART_NO,
               round(c.unit_cost, 2) UNIT_COST
          FROM INVENTORY_PART_IN_STOCK_UIV c) cost,
       (Select R.REQUIRED_QTY,
               R.ORDER_NO,
               C_Shop_Ord_Mat_Req_Dtl_API.Get_Request_Issued_Qty(REQ_NO,
                                                                 R.ORDER_NO,
                                                                 RELEASE_NO,
                                                                 SEQUENCE_NO,
                                                                 LINE_ITEM_NO) Recutting_Issued_Material
          from C_SHOP_ORD_MAT_REQ_DTL R
         where C_Shop_Ord_Mat_Req_Head_API.Get_Request_Type(REQ_NO) =
               'Re-Cutting') recutting

 where o.order_no = '1048-4-SS19'
--   and o.order_no = recutting.order_no
   and o.contract = cost.contract
   and o.part_no = cost.part_no
