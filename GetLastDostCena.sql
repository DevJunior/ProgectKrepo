IF (EXISTS(Select * from sys.sysprocedure where LCase(proc_name) = LCase('GetLastDostCena')))
THEN Drop procedure GetLastDostCena
END IF

GO

create function GetLastDostCena(in @StokaN integer)
returns decimal(16,4)
begin 
declare @dostcena decimal(16,4);
set @dostcena=(select Dostcena from Nalichnosti where Sklad =5 and stoka=@StokaN) ;
return @dostcena;
end;