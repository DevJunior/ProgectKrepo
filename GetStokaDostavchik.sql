IF (EXISTS(Select * from sys.sysprocedure where LCase(proc_name) = LCase('GetStokaDostavchik')))
THEN Drop procedure GetStokaDostavchik
END IF

GO

create function DBA.GetStokaDostavchik(in @StokaKod varchar(15))
returns varchar(250)
begin
  declare @StokaN integer;
  declare @Dostavchik varchar(50);
  set @StokaN=(select N from Stoki where kod = @StokaKod);
  set @Dostavchik=(select Ime from partnior as p
      join SvostokiStn as STS on p.n = STS.stoinost and svoistvo = 23 and glava = @StokaN);
  return @Dostavchik
end