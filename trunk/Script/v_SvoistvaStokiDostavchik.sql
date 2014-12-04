IF (EXISTS(Select * from sys.systable where LCase(table_name) = LCase('V_SvoistvaStokiDostavchik')))
THEN Drop view V_SvoistvaStokiDostavchik
END IF

GO

create view DBA.V_SvoistvaStokiDostavchik
  as select SS.Kod,
    Ime=SS.ime,
    MinMagazin=SSS202.Stoinost,
    OptMagazin=SSS203.Stoinost,
    MinKoKo=SSS45.Stoinost,
    OptKoKo=SSS46.Stoinost,
    MinBaza=sss205.Stoinost,
    OptBaza=SSS118.Stoinost,
    MinMagazin2=sss313.Stoinost,
    OptMagazin2=sss314.Stoinost,
    Dostavchik=DBA.GetStokaDostavchik(SS.kod),
    NalichnostOsn=DBA.GetNalichnost(2,ss.n),
    --SaleKolOsn=DBA.GetSaleKol(ss.n,-30,2),
    NalichnostKrepo=DBA.GetNalichnost(4,ss.n),
    --SaleKolKrepo=DBA.GetSaleKol(ss.n,-30,4),
    NalichnostMagazin2=DBA.GetNalichnost(7,ss.n),
    --SaleKolmagazin2=DBA.GetSaleKol(ss.n,-30,7),
    Dostcena=Round(DBA.GetLastDostCena(ss.n),4),
    Cena=MC.Cena,
	 MenuKod=Menu.Kod,
    ImeGrupa=DBA.GetStokaGrupa(SS.Kod)
    from DBA.Stoki as SS join Dba.Menu 
    on Menu.SN = SS.N join Dba.MenuCena as MC
    on MC.MenuStoka = Menu.N
    left outer join DBA.SvoStokiStn as SSS202 on SS.N = SSS202.Glava and SSS202.Svoistvo = 202
    left outer join DBA.SvoStokiStn as SSS203 on SS.N = SSS203.Glava and SSS203.Svoistvo = 203
    left outer join DBA.SvoStokiStn as SSS45 on SS.N = SSS45.Glava and SSS45.Svoistvo = 45
    left outer join DBA.SvoStokiStn as SSS46 on SS.N = SSS46.Glava and SSS46.Svoistvo = 46
    left outer join DBA.SvoStokiStn as SSS118 on SS.N = SSS118.Glava and SSS118.Svoistvo = 118
    left outer join DBA.SvoStokiStn as SSS205 on SS.N = SSS205.Glava and SSS205.Svoistvo = 205
    left outer join DBA.SvoStokiStn as SSS313 on SS.N = SSS313.Glava and SSS313.Svoistvo = 313
    left outer join DBA.SvoStokiStn as SSS314 on SS.N = SSS314.Glava and SSS314.Svoistvo = 314
    where ss.miarka > 0 and MC.MenuNomer = 1 order by
    SS.Kod asc
	go
	