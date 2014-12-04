IF (EXISTS(Select * from sys.sysprocedure where LCase(proc_name) = LCase('GetStokaGrupa')))
THEN Drop procedure GetStokaGrupa
END IF

GO

create function DBA.GetStokaGrupa(in @StokaKod varchar(15))
returns varchar(250)
begin
  declare @GS integer;
  declare @Grupa varchar(250);
  set @GS=(select GS from Stoki where Kod = @StokaKod);
  set @Grupa=(select Ime from StokiGrupi where N = @GS);
  return @Grupa
end