DECLARE
   module_ VARCHAR2(50):= 'TRNENT';
   name_ VARCHAR2 (50):= 'Training Enterprise';
   version_ VARCHAR2(50):= '7.0.0';
   description_ VARCHAR2(50):= 'Training Order 7.0.0';
   patch_version_ VARCHAR2(50):= NULL;
BEGIN
   Module_API.Create_And_Set_Version (module_,name_,version_,description_,patch_version_);
   Dbms_Output.Put_Line('module_= ' || module_);
   Dbms_Output.Put_Line('name_= '|| name_);
   Dbms_Output.Put_Line('version_= ' || version_);
   Dbms_Output.Put_Line('description_= ' || description_);
   Dbms_Output.Put_Line('patch_version_= ' || patch_version_);
END;
 
COMMIT;
/
