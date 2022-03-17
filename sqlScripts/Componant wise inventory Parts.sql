SELECT p.PART_NO, Inventory_Part_API.Get_Description('UNIT2', p.PART_NO) Part_Description
  FROM PROD_STRUCTURE p
 WHERE p.COMPONENT_PART like nvl('&Componant_Part', '%')
   and p.CONTRACT = 'UNIT2'
