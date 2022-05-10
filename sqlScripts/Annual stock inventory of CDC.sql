SELECT S.contract,
       S.part_no,
       IFSAPP.INVENTORY_PART_API.Get_Description(S.contract,S.part_no) Description,
       S.lot_batch_no,
       SUM(S.qty_onhand),
       SUM(S.qty_reserved),
       SUM(S.qty_onhand)-SUM(S.qty_reserved) Available_Qty,
       S.location_no,
       S.location_type,
       IFSAPP.Purchase_Req_Line_Part_API.C_Get_Part_Mrp(S.PART_NO) MRP,
       S.UNIT_COST,
       Inventory_Part_In_Stock_Cfp.Get_CF$_Basiccategorycode(S.objkey) Basic_Category_Code,
       Inventory_Part_In_Stock_Cfp.Get_CF$_Basiccatdescr(S.objkey) Basic_Category_Description
  FROM IFSAPP.INVENTORY_PART_IN_STOCK_UIV S
 Where S.CONTRACT = 'U2CDC'
       --and S.part_no Like '%'
       
 Group By S.contract,
       S.part_no,
       IFSAPP.INVENTORY_PART_API.Get_Description(S.contract,S.part_no),
       S.lot_batch_no,
       S.location_no,
       S.location_type,
       IFSAPP.Purchase_Req_Line_Part_API.C_Get_Part_Mrp(S.PART_NO),
       S.UNIT_COST,
       Inventory_Part_In_Stock_Cfp.Get_CF$_Basiccategorycode(S.objkey),
       Inventory_Part_In_Stock_Cfp.Get_CF$_Basiccatdescr(S.objkey)
