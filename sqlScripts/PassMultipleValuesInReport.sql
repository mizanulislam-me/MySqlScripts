SELECT t.CountryId, t.CountryName
FROM Countries t
WHERE Report_SYS.Perse_Paprameter(t.CountryId,'CountryId_') = 'TRUE';

-- CountryId_ could be replaced by multiple values seperated by ; (semecolon)
-- e.g. 'IN;LK;SE' / 'S%' / '%' / '' etc
