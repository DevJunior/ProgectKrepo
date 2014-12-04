IF (EXISTS(Select * from sys.sysprocedure where LCase(proc_name) = LCase('GetSaleKol')))
THEN Drop procedure GetSaleKol
END IF

GO

create function GetSaleKol(in @StokaN integer,in @days integer,in @SkladN integer)
returns decimal(16,4)
begin
declare @Kol decimal(12,4);
select Sum(dd.kol) into @Kol from docdata as dd
  join dochead as hd
  on hd.n=dd.DocN
  where stoka = @StokaN 
  and dokument in(1,2) and hd.VidDoc in (1) and hd.store=@SkladN
  and hd.dokdata >=dateadd(day,@days,Now(*))
  and hd.dokdata <=Now(*);
  return @kol
  end;