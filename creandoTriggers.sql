Create trigger actualizarSaldosPorTransferencia 
	on Transferencias
	for insert, update, delete
	as
	Begin transaction 
	if ((select count (*) from inserted)>0)
	begin
	Declare cursor_deInsertados Cursor
	for (select Cod_cuenta_origen,Cod_cuenta_destino,sum(Importe),Moneda.Conversion From inserted,Moneda
	where inserted.Cod_moneda=Moneda.Id_moneda
	group by Cod_cuenta_origen,Cod_cuenta_destino,Moneda.Conversion)
	Declare @cuentaOrigen int
	Declare @cuentaDestino int
	Declare @sumaDeImporte int	
	Declare @conversion int
	Declare @ConversionFinal int
	open cursor_deInsertados
	fetch next from cursor_deInsertados into @cuentaOrigen,@cuentaDestino,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from Moneda,Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuentaDestino)
	Update Cuenta set Saldo=Saldo+@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuentaDestino
	select @ConversionFinal=(Select Moneda.Conversion from Moneda,Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuentaDestino)
	Update Cuenta set Saldo=Saldo-@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuentaOrigen
	fetch next from cursor_deInsertados into @cuentaOrigen,@cuentaDestino,@sumaDeImporte,@conversion
	end
	close cursor_deInsertados
	deallocate cursor_deInsertados
	end
	
	if ((select count (*) from deleted)>0)
	begin
	Declare cursor_deBorrados Cursor
	for (select Cod_cuenta_origen,Cod_cuenta_destino,sum(Importe),Moneda.Conversion From deleted,Moneda
	group by Cod_cuenta_origen,Cod_cuenta_destino,Moneda.Conversion)
		
	
	open cursor_deBorrados
	fetch next from cursor_deBorrados into @cuentaOrigen,@cuentaDestino,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from Moneda,Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuentaDestino)
	Update Cuenta set Saldo=Saldo-@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuentaDestino
	select @ConversionFinal=(Select Moneda.Conversion from Moneda,Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuentaOrigen)
	Update Cuenta set Saldo=Saldo+@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuentaOrigen
	fetch next from cursor_deBorrados into @cuentaOrigen,@cuentaDestino,@sumaDeImporte,@conversion
	end
	close cursor_deBorrados
	deallocate cursor_deBorrados
	end
	
	commit;
	go