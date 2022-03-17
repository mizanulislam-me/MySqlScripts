
select i.part_product_code
  from INVENTORY_PRODUCT_CODE i
 where NOT EXISTS (SELECT null
          from POSTING_CTRL_DETAIL p
         where p.code_part_value = i.part_product_code
               and p.code_part='G' or p.code_part='E')
