

--Cuentas

insert into Cuenta(Num_cuenta,Fecha_apertura,Fecha_cierre,Codigo_pais,Codigo_moneda,
Codigo_categoria,Codigo_cliente,Codigo_estado,Saldo)
select distinct a.Cuenta_Numero,a.Cuenta_Fecha_Creacion,a.Cuenta_Fecha_Cierre,a.Cuenta_Pais_Codigo,1,4,b.Id_cliente,1,0
from (gd_esquema.Maestra a inner join Cliente b on a.Cli_Nro_Doc=b.Numero_documento) 



--Depositos
insert Depositos(Id_deposito,Cod_cuenta,Cod_moneda,Importe,Cod_TC,Fecha)
select distinct a.Deposito_Codigo,c.Num_cuenta,1,a.Deposito_Importe,
d.Id_tarjeta,a.Deposito_Fecha
from gd_esquema.Maestra a inner join Cliente b 
on a.Cli_Nro_Doc=b.Numero_documento
inner join Cuenta c 
on b.Id_cliente=c.Codigo_cliente and c.Num_cuenta=a.Cuenta_Numero
inner join Tarjetas_credito d on
b.Id_cliente=d.Cod_cliente and d.Num_tarjeta=a.Tarjeta_Numero
where Deposito_Codigo is not null



--Cheques

insert into Cheque (Num_cheque,Importe,Fecha,Cod_moneda,Cod_cliente,Cod_banco)
select distinct Cheque_Numero, Cheque_Importe, Cheque_Fecha,1,b.Id_cliente,c.Id_banco
from gd_esquema.Maestra a inner join Cliente b on a.Cli_Nro_Doc=b.Numero_documento
inner join Bancos c on a.Banco_Nombre=c.Nombre_banco 



--Retiros
insert into Retiros(Id_retiro,Cod_cuenta,Cod_cheque)
select distinct a.Retiro_Codigo,a.Cuenta_Numero,c.Id_cheque
from gd_esquema.Maestra a inner join Cliente b on
a.Cli_Nro_Doc=b.Numero_documento inner join Cheque c
on  a.Retiro_Fecha=c.Fecha and a.Retiro_Importe=c.importe and 
b.Id_cliente=c.Cod_cliente and a.Cheque_Numero=c.Num_cheque 
inner join Cuenta d on b.Id_cliente=d.Codigo_cliente 


insert into Facturas
select distinct Factura_Numero,Factura_Fecha from gd_esquema.Maestra
where Factura_Numero is not null;


Insert into Estado_transaccion(Descripcion) values ('Sin Facturar');


Insert into Estado_transaccion(Descripcion) values ('Facturado');
--begin transaction
--Declare cursorTransferencias Cursor 
--for(
--select Factura_Numero,Cuenta_Numero,Cuenta_Dest_Numero,Trans_Importe,Item_Factura_Importe,Transf_Fecha from gd_esquema.Maestra
--where (Transf_Fecha is not null) and Item_Factura_Importe is not null)
--Declare @CuentaOrigen1 numeric(18)
--Declare @CuentaDestino1 numeric(18)
--Declare @Importe1 float
--Declare @Costo1 float
--Declare @Fecha1 Date
--Declare @IDTrans1 int
--Declare @Factura numeric(18)
--open cursorTransferencias
--fetch next from cursorTransferencias into @Factura,@CuentaOrigen1,@CuentaDestino1,@Importe1,@Costo1,@Fecha1
--while @@FETCH_STATUS =0 
--begin
--Insert into Transacciones values (1,@Costo1,@Fecha1,@Factura)
--select @IDTrans1=(Select MAX(Id_transaccion) from Transacciones)
--Insert into Transferencias values(@Importe1,@CuentaOrigen1,@CuentaDestino1,@IDTrans1,1)
--fetch next from cursorTransferencias into @Factura,@CuentaOrigen1,@CuentaDestino1,@Importe1,@Costo1,@Fecha1
--end;close cursorTransferencias Deallocate cursorTransferencias 
--commit


insert into tablaTemporal(Importe,Cod_cuenta_origen,Cod_cuenta_destino,Id_transaccion,Cod_estado,Costo,Fecha,cod_moneda,cod_factura)
select
Trans_Importe,Cuenta_Numero,Cuenta_Dest_Numero,ROW_NUMBER()over (order by Transf_Fecha),1,Item_Factura_Importe,Transf_Fecha,1,Factura_Numero from gd_esquema.Maestra
where (Transf_Fecha is not null) and Item_Factura_Importe is not null
;


drop table tablaTemporal
;

--select * from facturas
--select * from Transferencias


--update Transacciones
--set cod_factura = (select m.Factura_Numero from gd_esquema.Maestra m join Transferencias t
--on (t.Cod_transaccion=Id_transaccion and t.Cod_cuenta_destino=m.Cuenta_Dest_Numero and t.Cod_cuenta_origen=m.Cuenta_Numero and m.Transf_Fecha=Fecha and m.Factura_Numero is not null))

