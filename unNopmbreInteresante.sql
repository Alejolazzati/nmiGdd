create trigger inhabilitarCuentasConMas5
on Transacciones
after insert
as
	Begin transaction
	Declare cursorPasados Cursor for
	
	Select * from (select cuenta=t1.cod_cuenta_origen 
	From transferencias t1 join transacciones t2
	on (t2.Id_transaccion=t1.cod_transaccion)
	where COD_factura is null
	UNION
	select cuenta=m.Cod_cuenta
	from Modificacion_Cuenta m join transacciones t
	on (m.cod_transaccion=t.Id_transaccion)
	where cod_factura is null) tabla
	group by cuenta
	having count (*) > 5
	
	
	open cursorPasados 
	declare @cuentaOrigen numeric(18,2)
	fetch next from cursorPasados into @cuentaOrigen
	
	while (@@Fetch_status=0)
	Begin
		  update cuenta
		  set codigo_estado= 2
		  where num_cuenta=@cuentaOrigen
			
			fetch next from cursorPasados into @cuentaOrigen
	end				
	
	close cursorPasados
	deallocate cursorPasados
	commit 
go

create trigger noPermitirTransferenciasEnInhabilitadas
on transferencias
instead of insert

as
	begin transaction
		if ((select count(*) from inserted,cuenta where inserted.cod_cuenta_origen=cuenta.num_cuenta and cuenta.codigo_estado=2) > 0 )
			begin
			raiserror ('Cuenta inhabilitada',16,150)
			rollback
			end
		else 
		insert into transferencias(Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda) select Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda from inserted
		commit	
go

create trigger noPermitirModificacionesEnInhabilitadas
on Modificacion_cuenta
instead of insert

as
	begin transaction
		if ((select count(*) from inserted,cuenta where inserted.cod_cuenta=cuenta.num_cuenta and cuenta.codigo_estado=2) > 0 )
			begin
			raiserror ('Cuenta inhabilitada',16,150)
			rollback
			end
		else 
		insert into Modificacion_cuenta(Cod_tipo,Cod_cuenta,Cod_transaccion) select Cod_tipo,Cod_cuenta,Cod_transaccion from inserted
		commit
go	

create trigger habilitarCuenta
on transacciones
instead of update
as
	begin transaction
		update cuentas
		set codigo_estado=1
		where num_cuenta in  
							((select c1.num_cuenta
							from cuentas c1  join transferencias t1 
												on (t1.num_cuenta_origen=c1.num_cuenta)
							where (select cod_factura from deleted where Id_transaccion=t1.cod_transaccion) is null and (select cod_factura from inserted where Id_transaccion=t1.cod_transaccion) is not null				
							and c1.Codigo_estado=2) 
							UNION
							(select c2.num_cuenta
							from cuentas c2 join modificaciones m1
												on(m1.num_cuenta=c2.num_cuenta)
							where (select cod_factura from deleted where Id_transaccion=m1.cod_transaccion) is null and (select cod_factura from inserted where Id_transaccion=m1.cod_transaccion) is not null				
							and c2.Codigo_estado=2))
		
		
	commit               
go


create procedure facturar @numCliente numeric(18)

as
Begin
	Begin transaction set transaction isolation level serializable
	Declare @fact numeric(18)
	select @fact=MAX(Facturas.Num_factura)+1 from Facturas
	insert into Facturas values (@fact,GETDATE())	
	update Transacciones
	set cod_factura=@fact
	where ((Select Cod_cuenta_origen from Transferencias
			where Cod_transaccion=Id_transaccion
			)union(
			Select Cod_cuenta from Modificacion_cuenta
			where Cod_transaccion=Id_transaccion)) in (select * from cuentasPorCliente(544) as d )
	
	
	commit

end
go