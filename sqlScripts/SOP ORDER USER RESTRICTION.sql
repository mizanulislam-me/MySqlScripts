DECLARE
contract_ VARCHAR2(100);
order_no_ VARCHAR2(100);
customer_no_ VARCHAR2(100);
cnt_ NUMBER := 0;
 
CURSOR get_orders_planned IS
SELECT count(1) FROM CUSTOMER_ORDER
WHERE CONTRACT = contract_
AND customer_no_ = customer_no_
AND OBJSTATE = 'Planned';
BEGIN
 
contract_ := '&NEW:CONTRACT';
customer_no_ := '&NEW:CUSTOMER_NO';
 
OPEN get_orders_planned;
FETCH get_orders_planned INTO cnt_;
CLOSE get_orders_planned;
 
IF cnt_ > 0 THEN
  ERROR_Sys.Appl_General('CustomerOrder', 'CPLANNEDORDEXISTS: There are :P1 Planned orders exist. New orders are not allowed.', cnt_);
END IF;
END;
