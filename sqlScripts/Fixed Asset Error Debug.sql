select *
  from FA_OBJECT x
 where x.CODE_B is null
    or x.CODE_C is null
   and x.ACQUISITION_DATE is not null
