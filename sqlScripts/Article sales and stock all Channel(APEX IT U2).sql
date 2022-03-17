SELECT A.Site
    ,A.Site_Description
    ,A.Article Part_No
    ,A.Shoe_Size
    ,A.MRP
    ,A.BRAND
    ,sum(A.Sales_Qty) Sales_Qty
    ,sum(A.stock_Qty) stock_Qty
    ,Sum(A.Available_Qty) Available_Qty
    ,Sum(A.Return_Qty) Return_Qty
    ,round(sum(A.UNIT_COST),2) UNIT_COST
FROM (
    SELECT INS.CONTRACT Site
        ,SITE_API.Get_Description(CONTRACT) Site_Description
        ,substr(INS.PART_NO, 0, 8) Article
        ,substr(INS.PART_NO, 9, 10) Shoe_Size
        ,ifsapp.Purchase_Req_Line_Part_API.C_Get_Part_Mrp(ins.PART_NO) MRP
        ,ifsapp.CUST_BRAND_API.GET_BRAND_DESCRIPTION(ifsapp.SALES_PART_API.GET_BRAND_CODE(ins.CONTRACT, ins.PART_NO)) AS BRAND
        ,nvl((
                SELECT SUM(CASE 
                            WHEN IH.TRANSACTION_CODE = 'CASHSHIP'
                                THEN ih.quantity
                            ELSE 0
                            END)
                FROM ifsapp.INVENTORY_TRANSACTION_HIST2 ih
                WHERE IH.TRANSACTION_CODE IN ('CASHSHIP')
                     AND to_date(to_date(IH.DATE_CREATED, 'dd/mm/rrrr'), 'dd/mm/rrrr') BETWEEN to_date('&Form_Date', 'dd/mm/rrrr')
                        AND to_date('&To_Date', 'dd/mm/rrrr')
                    AND IH.PART_NO = INS.PART_NO
                    AND IH.CONTRACT = INS.CONTRACT
                ), 0) Sales_Qty
        ,sum((INS.QTY_ONHAND + INS.QTY_RESERVED)) Stock_Qty
        ,sum((INS.QTY_ONHAND - INS.QTY_RESERVED)) Available_Qty
        ,nvl((
                SELECT SUM(CASE 
                            WHEN IH.TRANSACTION_CODE = 'CASHRETURN'
                                THEN ih.quantity
                            ELSE 0
                            END)

                FROM ifsapp.INVENTORY_TRANSACTION_HIST2 ih
                WHERE IH.TRANSACTION_CODE IN ('CASHRETURN')
                     AND to_date(to_date(IH.DATE_CREATED, 'dd/mm/rrrr'), 'dd/mm/rrrr') BETWEEN to_date('&Form_Date', 'dd/mm/rrrr')
                        AND to_date('&To_Date', 'dd/mm/rrrr')
                    AND IH.PART_NO = INS.PART_NO
                    AND IH.CONTRACT = INS.CONTRACT
                ), 0) Return_Qty,
                SUM(ins.UNIT_COST) UNIT_COST
    FROM INVENTORY_PART_IN_STOCK_UIV ins
    WHERE INS.PART_NO LIKE  upper('&Part_No')
        AND INS.CONTRACT LIKE upper('&Site')
    GROUP BY INS.CONTRACT
        ,INS.PART_NO
    ORDER BY INS.CONTRACT
    ) A
WHERE A.Sales_Qty + A.stock_Qty > 0
GROUP BY A.Site
    ,A.Site_Description
    ,A.Article
    ,A.Shoe_Size
    ,A.MRP
    ,A.BRAND
