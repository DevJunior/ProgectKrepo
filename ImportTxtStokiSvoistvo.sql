IF (EXISTS(Select * from sys.sysprocedure where LCase(proc_name) = LCase('ImportTxtStokiSvoistvo')))
THEN Drop procedure ImportTxtStokiSvoistvo
END IF

GO

create function DBA.ImportTxtStokiSvoistvo(in InSession integer,in FileName char(30))
returns char(250)
begin atomic
  declare OldStoinost integer;
  declare KodStoka integer;
  declare MaxRow integer;
  declare @row integer;
  declare @DostN integer;
  declare @StokaN varchar(50);
  declare Error exception for sqlstate value '40W02';
  
  set MaxRow=(select Count(*) from Importdata where "session" = InSession);
  
  message string('Svoistva za importirane ' || Maxrow) type info to console;
  set @row=1;
  
  for curs1 as "scroll" dynamic scroll cursor for
    select D0 as @kod,d1 as @ImeStoka,
      convert(varchar(50),d2) as @MinOsn,convert(varchar(50),d3) as @OptOsn,
      convert(varchar(50),d4) as @MinKoko,convert(varchar(50),d5) as @OptKoko,
      convert(varchar(50),d6) as @MinBazaKrepo,convert(varchar(50),d7) as @OptBazaKrepo,
      convert(varchar(50),d8) as @MinMagazin2,convert(varchar(50),d9) as @OptMagazin2,
      convert(varchar(50),d10) as @DostavchikIme
      from Importdata where "Session" = InSession 
	  do
    set @row=@row+1;
    set @DostN=(select N from Partnior where Ime = Trim(@DostavchikIme));
    if bvrStkImportMode = 0 then
      set @StokaN=(select N from Stoki where Ime = @kod)
    else
      set @StokaN=(select N from Stoki where kod = @kod)
    end if;
    if mod(@row,10) = 0 then
      message string('Update ' || @row || 'Of' || Maxrow) type info to console
    end if;
    if(select count(*) from Stoki where kod = @kod) is null then
      set bvrErrorMessage='няма стока с този код' || @kod || ' ---';
      signal Error
    else
    end if;
	if(select count(*) from SvostokiStn where Glava = @stokaN and Svoistvo = 23 and Stoinost <> @DostN) > 0 then
      update SvostokiStn set Stoinost = @DostN where Glava = @stokaN and Svoistvo = 23
    else if(select Glava from SvostokiStn where Glava = @stokaN and Svoistvo = 23) is null then
        insert into SvoStokiStn( Glava,Svoistvo,Stoinost) values( @StokaN,'23',@DostN) 
      end if
    end if;
    if(select * from SvostokiStn where Glava = @stokaN and svoistvo = 202) is null then
      insert into SvoStokiStn( Glava,Svoistvo,stoinost) values( @StokaN,202,@MinOsn) 
    else if(select Count(*) from SvostokiStn where glava = @StokaN and Svoistvo = 202 and Stoinost <> @MinOsn) > 0 then
        update DBA.SvoStokiStn set Stoinost = @MinOsn where Glava = @StokaN and svoistvo = 202
      end if
    end if;
    if(select * from SvostokiStn where Glava = @stokaN and svoistvo = 203) is null then
      insert into SvoStokiStn( Glava,Svoistvo,stoinost) values( @StokaN,203,@OptOsn) 
    else if(select Count(*) from SvostokiStn where glava = @StokaN and Svoistvo = 203 and Stoinost <> @OptOsn) > 0 then
        update SvoStokiStn set Stoinost = @OptOsn where Glava = @StokaN and svoistvo = 203
      end if
    end if;
    if(select * from SvostokiStn where Glava = @stokaN and svoistvo = 45) is null then
      insert into SvoStokiStn( Glava,svoistvo,Stoinost) values( @StokaN,45,@MinKoko) 
    else if(select count(*) from SvoStokiStn where glava = @StokaN and svoistvo = 45 and Stoinost <> @MinKoko) > 0 then
        update SvoStokiStn set Stoinost = @MinKoko where glava = @StokaN and svoistvo = 45
      end if
    end if;
    if(select * from SvostokiStn where Glava = @stokaN and svoistvo = 46) is null then
      insert into SvoStokiStn( Glava,Svoistvo,Stoinost) values( @StokaN,46,@OptKoko) 
    else if(select Count(*) from SvoStokiStn where Glava = @StokaN and Svoistvo = 46 and Stoinost <> @OptKoko) > 0 then
        update SvoStokiStn set Stoinost = @OptKoko where Glava = @StokaN and Svoistvo = 46
      else
      end if
    end if;
    if(select * from SvostokiStn where Glava = @StokaN and Svoistvo = 205) is null then
      insert into SvoStokiStn( glava,svoistvo,stoinost) values( @stokaN,205,@MinBazaKrepo) 
    else if(select Count(*) from Svostokistn where glava = @StokaN and Svoistvo = 205 and stoinost <> @MinBazaKrepo) > 0 then
        update DBA.SvoStokiStn set Stoinost = @MinBazaKrepo where Glava = @StokaN and Svoistvo = 205
      end if
    end if;
    if(select * from SvostokiStn where Glava = @StokaN and Svoistvo = 118) is null then
      insert into SvoStokiStn( glava,Svoistvo,stoinost) values( @StokaN,118,@OptBazaKrepo) 
    else if(select count(*) from SvoStokiStn where glava = @StokaN and svoistvo = 118 and stoinost <> @OptBazaKrepo) > 0 then
        update DBA.SvoStokiStn set stoinost = @OptBazaKrepo where glava = @StokaN and Svoistvo = 118
      end if
    end if;
    if(select * from SvostokiStn where Glava = @StokaN and Svoistvo = 313) is null then
      insert into SvostokiStn( glava,svoistvo,stoinost) values( @StokaN,313,@MinMagazin2) 
    else if(select Count(*) from Svostokistn where glava = @StokaN and svoistvo = 313 and stoinost <> @MinMagazin2) > 0 then
        update DBA.Svostokistn set Stoinost = @MinMagazin2 where glava = @StokaN and svoistvo = 313
      end if
    end if;
    if(select * from SvoStokiStn where Glava = @stokaN and svoistvo = 314) is null then
      insert into svostokistn( Glava,svoistvo,stoinost) values( @StokaN,314,@OptMagazin2) 
    else if(select Count(*) from Svostokistn where Glava = @StokaN and svoistvo = 314 and stoinost <> @OptMagazin2) > 0 then
        insert into svostokistn( Glava,svoistvo,stoinost) values( @StokaN,314,@OptMagazin2) 
      end if
    end if end for
end