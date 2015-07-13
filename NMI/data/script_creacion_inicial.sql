create schema NMI
go
create table NMI.fechaDeSistema(
fecha date not null
)
go
insert into NMI.fechaDeSistema values (getdate())
go
create function NMI.fechaSistema()
returns datetime 
as
begin
Declare @fecha date
select @fecha=max(fecha) from NMI.fechaDeSistema	
	return @fecha
end
go

create function NMI.encriptarSha256(@texto varchar(30))
returns varchar(50)
as
begin
Declare @temp varchar(30)
select @temp=Hashbytes('sha1',@texto)
return @temp
end
go

create function NMI.agregarDias(@fecha date , @dias int)
returns date
as
begin
Declare @temp date
select @temp=dateadd(day,@dias,@fecha)
return @temp
end
go

Create table NMI.ultimaCuenta (
numero numeric(18)
)
go
/*
insert into NMI.ultimaCuenta values (0) 
go*/

create table NMI.Usuario
(Id_usuario int  identity(1,1) primary key ,
Useranme Varchar(30) unique not null,
Contrasenia varchar(50) not null,
Fecha_creacion date default NMI.fechaSistema(),
Ultima_modificacion date not null default NMI.fechaSistema(), 
Pregunta_secreta varchar(50) not null,
Respuesta varchar(50) not null
)
go


 
create table NMI.Pais
(Id_Pais int primary key,
Descripcion varchar(50) not null
)
go

create table NMI.Tipo_DNI(
Id_DNI int primary key,
Descripcion Varchar(20) not null 
)
go


Create Table NMI.Cliente(  --elimino localidad
Id_cliente int identity(1,1) primary key,
Cod_usuario int not null,
Nombre varchar (50) not null,
Apellido varchar(50) not null,
Tipo_documento int not null,
Numero_documento int not null,
Mail varchar(50) not null,
Cod_pais int not null,
Calle varchar(50) not null,
Numero int not null,
Piso smallint,
Depto char,
Fecha_nacimiento date not null,
unique (Tipo_documento,Numero_Documento),
unique (mail),
foreign key (Cod_pais) references NMI.Pais(Id_pais),
foreign key (Cod_usuario) references NMI.Usuario(Id_usuario),
)
go

Create table NMI.Intentos_login(
	Id_login int identity(1,1) primary key,
	Codigo_usuario int not null,
	Es_correcto bit not null,
	foreign key (Codigo_usuario) references NMI.Usuario(Id_usuario)
)
go

Create table NMI.Intentos_fallidos(
	Id_fallido int identity(1,1) primary key,
	Cod_login int not null,
	foreign key (Cod_login) references NMI.Intentos_login(Id_login)
)
go

Create table NMI.Estado_rol(
	Id_estado int identity(1,1) primary key,
	Descripcion varchar(20) not null
)
go

Create table NMI.Rol(
	Id_rol int identity(1,1) primary key,
	Nombre_rol varchar(30) not null,
	Cod_estado int not null,
	foreign key (Cod_estado) references NMI.Estado_rol(Id_estado),
)
go

Create table NMI.Usuario_rol(
	Cod_usuario int not null,
	Cod_rol int not null,
	Foreign key (Cod_usuario) references NMI.Usuario(Id_usuario),
	Foreign key (Cod_rol) references NMI.Rol(Id_rol)
)
go

Create table NMI.Funcionalidad(
	Id_funcionalidad int identity(1,1) primary key, --Agrego identity
	Descripcion varchar(30) not null
)
go

Create table NMI.Rol_funcionalidad(
	Cod_rol int not null,
	Cod_funcionalidad int not null
	foreign key (Cod_rol) references NMI.Rol(Id_rol),
	foreign key (Cod_funcionalidad) references NMI.Funcionalidad(Id_funcionalidad)
)
go	

create table NMI.Categoria(
	Id_categoria int identity(1,1) primary key,
	Descripcion varchar(30) not null,
	Costo float not null,
	precioSuscripcion float,
	Duracion int
)
go

create table NMI.Moneda(
	Id_moneda int identity(1,1) primary key,
	Descripcion varchar(20) not null,
	Conversion float not null default 1	
)
go

create table NMI.Estado_cuenta(
	Id_estado int identity(1,1) primary key,
	Descripcion varchar(20) not null
)
go

create table NMI.Cuenta(
	Num_cuenta numeric(18) primary key, -- modificacion del identity NO TIENE Q SER IDENTITY
	Fecha_apertura date not null default NMI.fechaSistema(),
	Fecha_cierre date default null,
	Fecha_vencimiento date,
	Codigo_pais int not null,
	Codigo_moneda int not null,
	Codigo_categoria int not null,
	Codigo_cliente int not null,
	Codigo_estado int not null default 3,
	Saldo float not null default 0,
	foreign key (Codigo_pais) references NMI.Pais(Id_pais),
	foreign key (Codigo_moneda) references NMI.Moneda(Id_moneda),
	foreign key (Codigo_categoria) references NMI.Categoria(Id_categoria),
	foreign key (Codigo_cliente) references NMI.Cliente(Id_cliente),
	foreign key (Codigo_estado) references NMI.Estado_cuenta(Id_estado)
)
go	

Create table NMI.Estado_transaccion(
	Id_estado int identity(1,1) primary key,
	Descripcion varchar(30) not null,
)
go

Create table NMI.Transacciones(
	Id_transaccion int identity(1,1) primary key,
	Cod_estado int not null,
	Costo float not null,
	Fecha date not null default NMI.fechaSistema(),
	foreign key (Cod_estado) references NMI.Estado_transaccion(Id_estado)
)
go

create table NMI.Tipo_modificacion(
	Id_tipo int identity(1,1) primary key,
	Descripcion varchar(30) not null,
)
go

create table NMI.Modificacion_cuenta(
	Id_modificacion int identity(1,1) primary key,
	Cod_tipo int not null,
	Cod_cuenta numeric(18) not null,
	Cod_transaccion int not null,
	foreign key (Cod_tipo) references NMI.Tipo_modificacion(Id_tipo),
	foreign key (Cod_cuenta) references NMI.Cuenta(Num_cuenta),
	foreign key (Cod_transaccion) references NMI.Transacciones(Id_transaccion)
)
go

create table NMI.Transferencias(
	Id_transferencia int identity(1,1) primary key,
	Importe float not null,
	Cod_cuenta_origen numeric(18) not null,
	Cod_cuenta_destino numeric(18) not null,
	Cod_transaccion int not null,
	foreign key (Cod_cuenta_origen) references NMI.Cuenta(Num_cuenta),
	foreign key (Cod_cuenta_destino) references NMI.Cuenta(Num_cuenta),
	foreign key (Cod_transaccion) references NMI.Transacciones(Id_transaccion),
	check (Importe>=0)
	

)
go



create table NMI.Bancos(
	Id_banco int identity(1,1) primary key,
	Nombre_banco varchar(30) not null,
	Cod_pais int not null,
	foreign key (Cod_pais) references NMI.Pais(Id_pais)
)
go

create table NMI.inhabilitacionesDeCuenta(
	num_cuenta numeric(18) foreign key references NMI.Cuenta(num_cuenta),
	fecha datetime
)
go

create trigger NMI.asentarCuentaInhabiltada on NMI.inhabilitacionesDeCuenta
for insert
as begin transaction
Declare cursorPasados cursor for
(
select num_cuenta from inserted
)
	open cursorPasados 
	declare @cuentaOrigen numeric(18)
	fetch next from cursorPasados into @cuentaOrigen
	
	while (@@Fetch_status=0)
	Begin
		  update NMI.cuenta
		  set NMI.cuenta.codigo_estado= 2
		  where NMI.cuenta.num_cuenta=@cuentaOrigen
			
			fetch next from cursorPasados into @cuentaOrigen
	end				
	
	close cursorPasados
	deallocate cursorPasados
	commit
go

create table NMI.Tarjeta_Emisor(           --Tabla de las emisoras de las tarjes american, visa etc
	Id_tarjeta_emisor int identity(1,1) primary key,
	Descripcion varchar(40)
)
go

create table NMI.Tarjetas_credito( --Cambio la pk, porque puede haber mismo numero con diferente emisor
	Id_tarjeta int identity(1,1) primary key,
	Num_tarjeta numeric(18) not null,
	Cod_cliente int,
	Cod_emisor int not null,
	Fecha_emision date not null,
	Fecha_vencimiento date not null,
	Cod_seguridad int,
	foreign key (Cod_cliente) references NMI.Cliente(Id_cliente),
	foreign key (Cod_emisor) references NMI.Tarjeta_Emisor(Id_tarjeta_emisor)
)
go

create table NMI.Depositos(
	Id_deposito numeric(18) primary key,
	Cod_cuenta numeric(18) not null,
	Cod_moneda int not null,
	Importe float not null,
	Cod_TC int not null,
	Fecha date,
	check(Importe>1),
	foreign key (Cod_cuenta) references NMI.Cuenta(Num_cuenta),
	foreign key (Cod_moneda) references NMI.Moneda(Id_moneda),
	foreign key (Cod_TC) references NMI.Tarjetas_credito(Id_tarjeta)
)
go
create table NMI.Cheque(
	Id_cheque int identity(1,1) primary key,
	Num_cheque int not null,
	Cod_banco int not null,
	Cod_cliente int not null,
	Fecha date not null default NMI.fechaSistema(),
	unique (Num_cheque,Cod_banco),
	
	foreign key (Cod_banco) references NMI.Bancos(Id_banco),
	foreign key (Cod_cliente) references NMI.Cliente(Id_cliente)
)
go

Create Table NMI.Facturas(
	Num_factura numeric(18) primary key,
	Fecha_factura Date not null,
)
go


create table NMI.Retiros (
	Id_retiro numeric(18) primary key,
	Cod_cuenta numeric(18) not null,
	Cod_cheque int not null,
	foreign key (Cod_cuenta) references NMI.Cuenta(Num_cuenta),
	Foreign key (Cod_cheque) references NMI.Cheque(Id_cheque)
)
go



	
Alter table NMI.Usuario
add Estado Varchar(20) not null
go	
Alter table NMI.Transferencias
add Cod_moneda int not null
go
Alter table NMI.Transferencias
add foreign key (Cod_moneda) references NMI.Moneda(Id_moneda)
go
ALTER TABLE NMI.Cheque
add Importe float not null
go
Alter table NMI.Cheque 
add Cod_moneda int not null
go
Alter table NMI.Cheque 
add foreign key (Cod_moneda) references NMI.Moneda(Id_moneda)
go
alter table NMI.Transacciones
add  cod_factura numeric(18)
go
alter table NMI.Transacciones
add foreign key (cod_factura) references NMI.Facturas(Num_factura)
go

create table NMI.tablaTemporal (
	Id_transferencia int identity(1,1) primary key,
	Importe float not null,
	Cod_cuenta_origen numeric(18) not null,
	Cod_cuenta_destino numeric(18) not null,
	Id_transaccion int ,
	Cod_estado int not null,
	Costo float not null,
	Fecha date not null default NMI.fechaSistema(),
	cod_moneda int,
	cod_factura int

)
go






Create trigger NMI.miTrigger on NMI.tablaTemporal
instead of insert
as
begin transaction
set IDENTITY_INSERT NMI.Transacciones ON
insert into NMI.Transacciones(Id_transaccion,Cod_estado,Costo,Fecha,cod_factura)
select Id_transaccion,Cod_estado,Costo,Fecha,cod_factura from inserted
set IDENTITY_INSERT NMI.Transacciones Off
insert into NMI.Transferencias (Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda)
select Importe,Cod_cuenta_origen,Cod_cuenta_destino,Id_transaccion,Cod_moneda from inserted


commit


go

Create trigger NMI.actualizarSaldosPorTransferencia 
	on NMI.Transferencias
	for insert, update, delete
	as
	Begin transaction 
	if ((select count (*) from inserted)>0)
	begin
	Declare cursor_deInsertados Cursor
	for (select Cod_cuenta_origen,Cod_cuenta_destino,sum(Importe),Moneda.Conversion From inserted,Moneda
	where inserted.Cod_moneda=Moneda.Id_moneda
	group by Cod_cuenta_origen,Cod_cuenta_destino,Moneda.Conversion)
	Declare @cuentaOrigen numeric(18)
	Declare @cuentaDestino numeric(18)
	Declare @sumaDeImporte int	
	Declare @conversion int
	Declare @ConversionFinal int
	open cursor_deInsertados
	fetch next from cursor_deInsertados into @cuentaOrigen,@cuentaDestino,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from NMI.Moneda,NMI.Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuentaDestino)
	Update NMI.Cuenta set Saldo=Saldo+@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuentaDestino
	select @ConversionFinal=(Select Moneda.Conversion from NMI.Moneda,NMI.Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuentaDestino)
	Update NMI.Cuenta set Saldo=Saldo-@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuentaOrigen
	fetch next from cursor_deInsertados into @cuentaOrigen,@cuentaDestino,@sumaDeImporte,@conversion
	end
	close cursor_deInsertados
	deallocate cursor_deInsertados
	end
	
	if ((select count (*) from deleted)>0)
	begin
	Declare cursor_deBorrados Cursor
	for (select Cod_cuenta_origen,Cod_cuenta_destino,sum(Importe),Moneda.Conversion From deleted,NMI.Moneda
	group by Cod_cuenta_origen,Cod_cuenta_destino,Moneda.Conversion)
		
	
	open cursor_deBorrados
	fetch next from cursor_deBorrados into @cuentaOrigen,@cuentaDestino,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from NMI.Moneda,NMI.Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuentaDestino)
	Update NMI.Cuenta set Saldo=Saldo-@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuentaDestino
	select @ConversionFinal=(Select Moneda.Conversion from NMI.Moneda,NMI.Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuentaOrigen)
	Update NMI.Cuenta set Saldo=Saldo+@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuentaOrigen
	fetch next from cursor_deBorrados into @cuentaOrigen,@cuentaDestino,@sumaDeImporte,@conversion
	end
	close cursor_deBorrados
	deallocate cursor_deBorrados
	end
	
	commit;
	
go
	
	create trigger NMI.ActualizarSaldosPorDeposito
on Depositos 
for insert, update, delete
	as
	Begin transaction 
	if ((select count (*) from inserted)>0)
	begin
	Declare cursor_deInsertados Cursor
	for (select Cod_cuenta,sum(Importe),Moneda.Conversion From inserted,NMI.Moneda
	where inserted.Cod_moneda=Moneda.Id_moneda
	group by Cod_cuenta,Moneda.Conversion)
	Declare @cuenta numeric(18)
	Declare @sumaDeImporte int	
	Declare @conversion int
	Declare @ConversionFinal int
	open cursor_deInsertados
	fetch next from cursor_deInsertados into @cuenta,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from NMI.Moneda,NMI.Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuenta)
	Update NMI.Cuenta set Saldo=Saldo+@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuenta
	fetch next from cursor_deInsertados into @cuenta,@sumaDeImporte,@conversion
	end
	close cursor_deInsertados
	deallocate cursor_deInsertados
	end
	
	if ((select count (*) from deleted)>0)
	begin
	Declare cursor_deBorrados Cursor
	for (select Cod_cuenta,sum(Importe),Moneda.Conversion From deleted,NMI.Moneda
	group by Cod_cuenta,Moneda.Conversion)
		
	
	open cursor_deBorrados
	fetch next from cursor_deBorrados into @cuenta,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from NMI.Moneda,NMI.Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuenta)
	Update NMI.Cuenta set Saldo=Saldo-@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuenta
	fetch next from cursor_deBorrados into @cuenta,@sumaDeImporte,@conversion
	end
	close cursor_deBorrados
	deallocate cursor_deBorrados
	end
	
	commit;
go
	
create trigger NMI.ActualizarSaldosPorRetiro
on Retiros 
for insert, update, delete
	as
	Begin transaction 
	if ((select count (*) from inserted)>0)
	begin
	Declare cursor_deInsertados Cursor
	for (select Cod_cuenta,sum(Cheque.Importe),Moneda.Conversion From NMI.Cheque,inserted,NMI.Moneda
	where Cheque.Cod_moneda=Moneda.Id_moneda and Cheque.Id_cheque=inserted.Cod_cheque
	group by Cod_cuenta,Moneda.Conversion)
	Declare @cuenta numeric(18)
	Declare @sumaDeImporte int	
	Declare @conversion int
	Declare @ConversionFinal int
	open cursor_deInsertados
	fetch next from cursor_deInsertados into @cuenta,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from NMI.Moneda,NMI.Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuenta)
	Update NMI.Cuenta set Saldo=Saldo-@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuenta
	fetch next from cursor_deInsertados into @cuenta,@sumaDeImporte,@conversion
	end
	close cursor_deInsertados
	deallocate cursor_deInsertados
	end
	
	if ((select count (*) from deleted)>0)
	begin
	Declare cursor_deBorrados Cursor
	for (select Cod_cuenta,sum(Cheque.Importe),Moneda.Conversion From NMI.Cheque,deleted,NMI.Moneda
	where Cheque.Cod_moneda=Moneda.Id_moneda and Cheque.Id_cheque=deleted.Cod_cheque
	group by Cod_cuenta,Moneda.Conversion)
	
	open cursor_deBorrados
	fetch next from cursor_deBorrados into @cuenta,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from NMI.Moneda,NMI.Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuenta)
	Update NMI.Cuenta set Saldo=Saldo+@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuenta
	fetch next from cursor_deBorrados into @cuenta,@sumaDeImporte,@conversion
	end
	close cursor_deBorrados
	deallocate cursor_deBorrados
	end
	
	commit;
go
	
	Create  trigger NMI.CuaandoSeIngresanLoginsIncorrectos
on NMI.Intentos_login
for  insert
as
Begin transaction
Declare @num_login int
Declare @Correcto bit 
select Id_login,Es_Correcto into #tablaIncorrectos  from inserted
where Es_Correcto=0

if ((select count(*) from #tablaIncorrectos
)>0)
begin
Declare cursorDeIncorrectos Cursor
for select * from #tablaIncorrectos
open cursorDeIncorrectos
fetch next from cursorDeIncorrectos into @num_login,@Correcto
while(@@FETCH_STATUS=0)
begin
Insert into NMI.Intentos_fallidos (Cod_login)values (@num_login)
fetch next from cursorDeIncorrectos into @num_login,@Correcto
end

close cursorDeIncorrectos
deallocate cursorDeIncorrectos
end
drop table #tablaIncorrectos
commit;
go


Create  trigger NMI.CuaandoSeIngresanLoginsCorrectos
on NMI.Intentos_login
for  insert
as
Begin transaction
Declare @num_login int
Declare @Correcto bit 
Declare @cantidad int
select Id_login,Es_Correcto into #tablaCorrectos  from inserted
where Es_Correcto=1

if ((select count(*) from #tablaCorrectos
)>0)
begin
Declare cursorDeIncorrectos Cursor
for select * from #tablaCorrectos
open cursorDeIncorrectos
fetch next from cursorDeIncorrectos into @num_login,@Correcto
while(@@FETCH_STATUS=0)
begin
Delete from NMI.Intentos_fallidos where Cod_login=@num_login
fetch next from cursorDeIncorrectos into @num_login,@Correcto
end
close cursorDeIncorrectos
deallocate cursorDeIncorrectos
end
drop table #tablaCorrectos

commit;
go


Create  trigger NMI.CuandoSeIngresaUnTercerLoginFallidoSEInhabilita
on NMI.Intentos_fallidos
for  insert
as
Begin transaction
Declare @num_fallido int
Declare @Cod_login int
Declare cursorDeFallidos Cursor
for select * from inserted
open cursorDeFallidos
fetch next from cursorDeFallidos into @num_fallido,@Cod_login
while(@@FETCH_STATUS=0)
begin
if ((select count(*) from NMI.Intentos_fallidos,NMI.Usuario,NMI.Intentos_login
where NMI.Intentos_fallidos.Cod_login=NMI.Intentos_login.Id_login and NMI.Intentos_login.Codigo_usuario=NMI.Usuario.Id_usuario)>2)
update NMI.Usuario
set Estado='inhabilitado'
where Id_usuario = (Select Codigo_usuario from NMI.Intentos_login where Id_login=@Cod_login)
fetch next from cursorDeFallidos into @num_fallido,@Cod_login

end
close cursorDeFallidos
deallocate cursorDeFallidos
commit;
go	

--Pais
insert into NMI.Pais
select * from (select distinct Cli_Pais_Codigo, Cli_Pais_Desc 
from gd_esquema.Maestra 
union
select distinct Cuenta_Dest_Pais_Codigo, Cuenta_Dest_Pais_Desc
from gd_esquema.Maestra
where Cli_Pais_Codigo is not null and Cuenta_Dest_Pais_Codigo is not null
)A

go

--Moneda
insert into NMI.Moneda(Descripcion,Conversion) values ('Dolar',1);

go
--Tipo de dni
insert into NMI.Tipo_DNI
select distinct Cli_Tipo_Doc_Cod, Cli_Tipo_Doc_Desc
from gd_esquema.Maestra

go
--Bancos
insert into NMI.Bancos(Nombre_banco,Cod_pais) values ((select distinct 
top 1 Banco_Nombre from gd_esquema.Maestra where Banco_Nombre is not null),8)
go
insert into NMI.Bancos(Nombre_banco,Cod_pais) values ((select distinct top 1 Banco_Nombre 
from gd_esquema.Maestra where Banco_Nombre is not null and Banco_Nombre like '%Nac%'),8)
go

--Categorias de cuentas
insert into NMI.Categoria (Descripcion,precioSuscripcion,Costo,Duracion) values ('oro',30,0.03,365)
insert into NMI.Categoria (Descripcion,precioSuscripcion,Costo,Duracion) values ('plata',20,0.05,90)
insert into NMI.Categoria (Descripcion,precioSuscripcion,Costo,Duracion) values ('bronce',10,0.07,30)
insert into NMI.Categoria (Descripcion,precioSuscripcion,Costo,Duracion) values ('gratuita',0,0.1,10)

go
--Tabla de Estados_Rol
insert into NMI.Estado_rol (Descripcion) values ('Activo')
insert into NMI.Estado_rol (Descripcion) values ('Inactivo')

go
--Tabla de roles
insert into NMI.Rol (Nombre_rol,Cod_estado) values ('Cliente',1)
insert into NMI.Rol (Nombre_rol,Cod_estado) values ('Administrador',1)

go
/*--Tabla de funcionalidades
insert into NMI.Funcionalidad (Descripcion) values ('ABM Usuarios')
go
insert into NMI.Funcionalidad (Descripcion) values ('ABM Clientes')
go
insert into NMI.Funcionalidad (Descripcion) values ('ABM Cuentas')
go
insert into NMI.Funcionalidad (Descripcion) values ('ABM Credit Card')
go
insert into NMI.Funcionalidad (Descripcion) values ('ABM Despositos')
go
insert into NMI.Funcionalidad (Descripcion) values ('ABM Retiros')
go
insert into NMI.Funcionalidad (Descripcion) values ('ABM Transferencias')
go
insert into NMI.Funcionalidad (Descripcion) values ('ABM Facturacion')
go
insert into NMI.Funcionalidad (Descripcion) values ('ABM Estadisticas')
go
insert into NMI.Funcionalidad (Descripcion) values ('ABM Consulta Saldo')
go

--Tabla Rol_Funcionalidades
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (1,2)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (2,2)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (3,2)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (3,1)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (4,1)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (5,1)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (6,1)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (7,1)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (8,1)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (8,2)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (9,2)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (10,2)
go
insert into NMI.Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (10,1)
go
*/
--Tabla Tarjeta Emisor
insert into NMI.Tarjeta_Emisor (Descripcion)
select distinct Tarjeta_Emisor_Descripcion
from gd_esquema.Maestra
where Tarjeta_Emisor_Descripcion is not null;
go

--clientes
begin transaction
Declare cursorCliente Cursor for
select distinct Cli_Nombre,Cli_Apellido,Cli_Tipo_Doc_Cod,Cli_Nro_Doc,
Cli_Mail,Cli_Pais_Codigo,Cli_Dom_Calle,
Cli_Dom_Nro,Cli_Dom_Piso,Cli_Dom_Depto,
Cli_Fecha_Nac
from gd_esquema.Maestra
Declare @nombre varchar(30)
Declare @apellido varchar(30)
Declare @cod_tipoDoc int
Declare @numDoc int
Declare @piso int
Declare @dpto char
Declare @fnac date 
Declare @mail varchar(30)
Declare @cod_pais int
Declare @calle varchar(30)
Declare @numero int
open cursorCliente
fetch next from cursorCliente into @nombre,@apellido,@cod_tipoDoc,@numDoc,
@mail,@cod_pais,@calle,@numero,@piso,@dpto,@fnac
while @@FETCH_STATUS=0
begin
Insert into NMI.Usuario(Useranme,Contrasenia,Pregunta_secreta,Respuesta,Estado) values(Rtrim (@nombre)+left(@apellido,1),Rtrim (@nombre)+left(@apellido,1),'nombre',@nombre,'habilitado')
Insert into NMI.Cliente(Cod_usuario,Nombre,Apellido,Tipo_documento,Numero_documento,Mail,Cod_pais,Calle,Numero,Piso,Depto,Fecha_nacimiento) values((Select MAX(Id_usuario)from NMI.Usuario),@nombre,@apellido,@cod_tipoDoc,@numDoc,@mail,@cod_pais,@calle,@numero,@piso,@dpto,@fnac)
fetch next from cursorCliente into @nombre,@apellido,@cod_tipoDoc,@numDoc,
@mail,@cod_pais,@calle,@numero,@piso,@dpto,@fnac
end
close cursorCliente
deallocate cursorCliente
commit

go


--Tabla de usuario_rol
insert into NMI.Usuario_rol (Cod_usuario,Cod_rol) (select Id_usuario,1 from NMI.Usuario);
go


--Tarjetas de credito
insert into NMI.Tarjetas_credito(Num_tarjeta,Cod_cliente,Cod_emisor,Fecha_emision,Fecha_vencimiento
,Cod_seguridad)
select distinct a.Tarjeta_Numero,b.Id_cliente,c.Id_tarjeta_emisor,a.Tarjeta_Fecha_Emision,
a.Tarjeta_Fecha_Vencimiento,a.Tarjeta_Codigo_Seg
from (gd_esquema.Maestra a inner join NMI.Cliente b on a.Cli_Nro_Doc=b.Numero_documento 
inner join NMI.Tarjeta_Emisor c on a.Tarjeta_Emisor_Descripcion=c.Descripcion) 

go

--Estado de cuentas
insert into NMI.Estado_cuenta(Descripcion) values ('Habilitada')
go
insert into NMI.Estado_cuenta(Descripcion) values ('Inahilitada')
go
insert into NMI.Estado_cuenta(Descripcion) values ('Pendiente')
go
insert into NMI.Estado_cuenta(Descripcion) values ('Cerrada')

go



--Cuentas

insert into NMI.Cuenta(Num_cuenta,Fecha_apertura,Fecha_cierre,Codigo_pais,Codigo_moneda,
Codigo_categoria,Codigo_cliente,Codigo_estado,Saldo)
select distinct a.Cuenta_Numero,a.Cuenta_Fecha_Creacion,a.Cuenta_Fecha_Cierre,a.Cuenta_Pais_Codigo,1,4,b.Id_cliente,1,0
from (gd_esquema.Maestra a inner join NMI.Cliente b on a.Cli_Nro_Doc=b.Numero_documento) 

go
update NMI.ultimaCuenta
set numero=(Select MAX(Num_cuenta) from NMI.Cuenta)
go

--Depositos
insert NMI.Depositos(Id_deposito,Cod_cuenta,Cod_moneda,Importe,Cod_TC,Fecha)
select distinct a.Deposito_Codigo,c.Num_cuenta,1,a.Deposito_Importe,
d.Id_tarjeta,a.Deposito_Fecha
from gd_esquema.Maestra a inner join NMI.Cliente b 
on a.Cli_Nro_Doc=b.Numero_documento
inner join NMI.Cuenta c 
on b.Id_cliente=c.Codigo_cliente and c.Num_cuenta=a.Cuenta_Numero
inner join NMI.Tarjetas_credito d on
b.Id_cliente=d.Cod_cliente and d.Num_tarjeta=a.Tarjeta_Numero
where Deposito_Codigo is not null

go

--Cheques

insert into NMI.Cheque (Num_cheque,Importe,Fecha,Cod_moneda,Cod_cliente,Cod_banco)
select distinct Cheque_Numero, Cheque_Importe, Cheque_Fecha,1,b.Id_cliente,c.Id_banco
from gd_esquema.Maestra a inner join NMI.Cliente b on a.Cli_Nro_Doc=b.Numero_documento
inner join NMI.Bancos c on a.Banco_Nombre=c.Nombre_banco 

go

--Retiros
insert into NMI.Retiros(Id_retiro,Cod_cuenta,Cod_cheque)
select distinct a.Retiro_Codigo,a.Cuenta_Numero,c.Id_cheque
from gd_esquema.Maestra a inner join NMI.Cliente b on
a.Cli_Nro_Doc=b.Numero_documento inner join NMI.Cheque c
on  a.Retiro_Fecha=c.Fecha and a.Retiro_Importe=c.importe and 
b.Id_cliente=c.Cod_cliente and a.Cheque_Numero=c.Num_cheque 
inner join NMI.Cuenta d on b.Id_cliente=d.Codigo_cliente 
go

insert into NMI.Facturas
select distinct Factura_Numero,Factura_Fecha from gd_esquema.Maestra
where Factura_Numero is not null
go

Insert into NMI.Estado_transaccion(Descripcion) values ('Sin Facturar');

go
Insert into NMI.Estado_transaccion(Descripcion) values ('Facturado');
go
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


insert into NMI.tablaTemporal(Importe,Cod_cuenta_origen,Cod_cuenta_destino,Id_transaccion,Cod_estado,Costo,Fecha,cod_moneda,cod_factura)
select
Trans_Importe,Cuenta_Numero,Cuenta_Dest_Numero,ROW_NUMBER()over (order by Transf_Fecha),2,Item_Factura_Importe,Transf_Fecha,1,Factura_Numero from gd_esquema.Maestra
where (Transf_Fecha is not null) and Item_Factura_Importe is not null
go


drop table NMI.tablaTemporal
go

--select * from facturas
--select * from Transferencias


--update Transacciones
--set cod_factura = (select m.Factura_Numero from gd_esquema.Maestra m join Transferencias t
--on (t.Cod_transaccion=Id_transaccion and t.Cod_cuenta_destino=m.Cuenta_Dest_Numero and t.Cod_cuenta_origen=m.Cuenta_Numero and m.Transf_Fecha=Fecha and m.Factura_Numero is not null))

create function NMI.cuentasPorUsuario(@username varchar(30))
returns  @tabla table(
cuenta numeric(18))
as
begin
insert into @tabla 
select  Cuenta.Num_cuenta from NMI.Cuenta,NMI.Cliente,NMI.Usuario
where Cuenta.Codigo_cliente=Cliente.Id_cliente and Cliente.Cod_usuario=Id_usuario
and Useranme=@username
return
end

go

create function NMI.cuentasPorCliente(@cliente numeric(18))
returns  @tabla table(
cuenta numeric(18))
as
begin
insert into @tabla 
select  Cuenta.Num_cuenta from NMI.Cuenta
where Cuenta.Codigo_cliente=@cliente
return
end

go

create Function NMI.saldoCuenta(@cuenta numeric(18))
returns int
as 
begin
declare @saldo int
select @saldo=(
select Saldo from NMI.Cuenta
where num_cuenta=@cuenta

) 
return @saldo

end
go

create  trigger NMI.inhabilitarCuentasConMas5
on NMI.Transacciones
after insert
as
begin transaction
insert into 	NMI.inhabilitacionesDeCuenta
	Select cuenta,fecha from (select cuenta=t1.cod_cuenta_origen,fecha=convert(varchar(30),NMI.fechaSistema(),101) 
	From NMI.transferencias t1 join NMI.transacciones t2
	on (t2.Id_transaccion=t1.cod_transaccion)
	where COD_factura is null -- and t2.id_transaccion in (select id_transaccion from inserted)
	 and t1.cod_cuenta_origen in (select t4.cod_cuenta_origen from  inserted,NMI.Transferencias t4
	where t4.cod_transaccion=inserted.id_transaccion ) 
	/*UNION
	select cuenta=m.Cod_cuenta,fecha=convert(varchar(30),NMI.fechaSistema(),101)
	from NMI.Modificacion_Cuenta m join NMI.transacciones t
	on (m.cod_transaccion=t.Id_transaccion)
	where cod_factura is null*/
	) tabla
	group by cuenta,fecha
	having count (*) > 5 
	
	commit 
go

create Trigger NMI.inhabilitarCuentasConMasDe5
on NMI.Transferencias
for insert
as
begin transaction
insert into 	NMI.inhabilitacionesDeCuenta
Select cuenta,fecha from (select cuenta=t1.cod_cuenta_origen,fecha=convert(varchar(30),NMI.fechaSistema(),101) 
	From NMI.transferencias t1 join NMI.transacciones t2
	on (t2.Id_transaccion=t1.cod_transaccion),Cuenta
	where COD_factura is null -- and t2.id_transaccion in (select id_transaccion from inserted)
	 --and t1.cod_cuenta_origen in (select cod_cuenta_origen from  inserted
	and Cuenta.num_cuenta=t1.cod_cuenta_origen and Codigo_estado=1
	
	 ) --)
	tabla
	group by cuenta,fecha
	having count (*) > 5 
	
	commit 
	
go

create trigger NMI.noPermitirTransferenciasEnInhabilitadas
on NMI.transferencias
after insert

as
	begin transaction
		if ((select count(*) from inserted,NMI.cuenta where inserted.cod_cuenta_origen=cuenta.num_cuenta and cuenta.codigo_estado=2) > 0 )
			begin
			raiserror ('Cuenta inhabilitada',16,150)
			delete from NMI.Tansferencias
			where id_tranferencia in (select id_transferencia from inserted) 
			end
		else 
		--insert into transferencias(Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda) select Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda from inserted
		commit	
go

create trigger NMI.noPermitirModificacionesEnInhabilitadas
on NMI.Modificacion_cuenta
after insert

as
	begin transaction
		if ((select count(*) from inserted,NMI.cuenta where inserted.cod_cuenta=cuenta.num_cuenta and cuenta.codigo_estado=2) > 0 )
			begin
			raiserror ('Cuenta inhabilitada',16,150)
			delete from NMI.Transferencias
			where id_transferencia in (select id_transferencia from inserted
			)
			end
		else 
	--	insert into Modificacion_cuenta(Cod_tipo,Cod_cuenta,Cod_transaccion) select Cod_tipo,Cod_cuenta,Cod_transaccion from inserted
		commit
go	

create trigger NMI.habilitarCuenta
on NMI.transacciones
for update
as
	begin transaction
		update NMI.Cuenta
		set codigo_estado=1
		where num_cuenta in  
							((select c1.num_cuenta
							from NMI.cuenta c1  join NMI.transferencias t1 
												on (t1.cod_cuenta_origen=c1.num_cuenta)
							where (select cod_factura from deleted where Id_transaccion=t1.cod_transaccion) is null and (select cod_factura from inserted where Id_transaccion=t1.cod_transaccion) is not null				
							and c1.Codigo_estado=2) 
							/*UNION
							(select c2.num_cuenta
							from NMI.cuenta c2 join NMI.modificaciones m1
												on(m1.cod_cuenta=c2.num_cuenta)
							where (select cod_factura from deleted where Id_transaccion=m1.cod_transaccion) is null and (select cod_factura from inserted where Id_transaccion=m1.cod_transaccion) is not null				
							and c2.Codigo_estado=2)*/)
		
		
	commit               
go



create procedure NMI.facturar @numCliente numeric(18),@fact numeric(18) output

as
Begin
	Begin transaction set transaction isolation level serializable
	
	select @fact=MAX(Facturas.Num_factura)+1 from NMI.Facturas
	insert into NMI.Facturas values (@fact,NMI.fechaSistema())	
	update NMI.Transacciones
	set cod_factura=@fact
	where ((Select Cod_cuenta_origen from NMI.Transferencias
			where Cod_transaccion=Id_transaccion and cod_factura IS null
			)union(
			Select Cod_cuenta from NMI.Modificacion_cuenta
			where cod_factura is null and Cod_transaccion=Id_transaccion)) in (select * from cuentasPorCliente(@numCliente) as d )
	
	
	commit

end
go

create function NMI.usernamesParecidos(@busqueda varchar(30))
returns @tabla table(username varchar(30))
as
begin
insert into @tabla
select useranme  from NMI.Usuario 
where useranme like '%'+@busqueda+'%'

return 
end
go

create function NMI.categoriasDisponibles()
returns @tablita table(id int,
Descr varchar(30),
costo float,
precioSuscr float,
Duracion int
)

As
Begin
	insert into @tablita
	select *
	from NMI.categoria
	
	return
end
go 
/*
create procedure modificarCuenta (@cuenta numeric (18), @nuevaCategoria int, @duracion int)
as
begin
	begin transaction
	update Cuenta
	set cuenta.Codigo_categoria=@nuevaCategoria,
		cuenta.Fecha_cierre=dbo.fechaSistema()+@duracion
	where Cuenta.Num_cuenta=@cuenta
	
	
	update Cuenta
	set Fecha_vencimiento=(Select dbo.agregarDias(dbo.fechaSistema(),Duracion) from Categoria
	where Cuenta.Num_cuenta=@cuenta 
	
	commit
end
go	
*/
create Procedure NMI.getUltimaCuenta @retorno numeric(18)

as
begin
 
select @retorno=(Select max(UltimaCuenta.numero) from NMI.UltimaCuenta)
Update NMI.UltimaCuenta
set numero=@retorno+1
return @retorno
end
go

create function NMI.rolesUsuario(@username varchar(30))
returns @tablaRetorno table
(rol varchar(30)
)
as
begin
insert into @tablaRetorno
select Nombre_rol from NMI.Usuario,NMI.Usuario_rol,NMI.Rol
where Id_rol=Cod_rol and Useranme=@username 
and Id_usuario=Cod_usuario
return
end

go

insert into NMI.Funcionalidad values(
'ABM Rol');

/*insert into Funcionalidad values(
'Login');
*/
insert into NMI.Funcionalidad values(
'ABM usuario');

insert into NMI.Funcionalidad values(
'ABM cliente');

insert into NMI.Funcionalidad values(
'ABM cuenta');

insert into NMI.Funcionalidad values(
'Depositos');

insert into NMI.Funcionalidad values(
'Retiro de efectivo');

insert into NMI.Funcionalidad values(
'Transferencias');

insert into NMI.Funcionalidad values(
'Facturacion');

insert into NMI.Funcionalidad values(
'Consultar saldo');

insert into NMI.Funcionalidad values(
'Listado estadistico');
insert into NMI.Funcionalidad values(
'Asociar/desasociar TC')


go

--insert into Rol_funcionalidad values(1,2);

insert into NMI.Rol_funcionalidad values(1,4);

insert into NMI.Rol_funcionalidad values(1,5);

insert into NMI.Rol_funcionalidad values(1,6);

insert into NMI.Rol_funcionalidad values(1,7);

insert into NMI.Rol_funcionalidad values(1,8);

insert into NMI.Rol_funcionalidad values(1,9);

insert into NMI.Rol_funcionalidad values(1,11);


insert into NMI.Rol_funcionalidad values(2,1);
--insert into Rol_funcionalidad values(2,2);
insert into NMI.Rol_funcionalidad values(2,2);
insert into NMI.Rol_funcionalidad values(2,3);
insert into NMI.Rol_funcionalidad values(2,4);
insert into NMI.Rol_funcionalidad values(2,8);
insert into NMI.Rol_funcionalidad values(2,9);
insert into NMI.Rol_funcionalidad values(2,10);

go

create function NMI.funcionalidadesRol(@Rol int)
returns @tabla table (
descripcion varchar(30)
)
as
begin
insert into @tabla
select Descripcion from NMI.Rol_funcionalidad,NMI.Funcionalidad
	where Cod_rol=@Rol and Id_funcionalidad=Cod_funcionalidad

return end
go


create function NMI.ultimos5Depositos(@cuenta numeric(18))
returns @tabla table(Importe float,
	Moneda varchar(30),
	Fecha date,
	NumTarjeta Numeric(18)
)

as
Begin
	insert into @tabla
	select top 5 d.Importe, m.Descripcion , d.Fecha, t.Num_tarjeta
	from NMI.Depositos d join NMI.Tarjetas_credito t on (d.Cod_TC=t.Id_tarjeta)
						join NMI.Moneda m on (d.Cod_moneda=m.Id_moneda)
	where d.Cod_cuenta=@cuenta
	order by d.fecha
	return
end
	
	
go

create function NMI.ultimos5Retiros(@cuenta numeric(18))
returns @tabla table(
	Num_cheque numeric(18),
	Banco varchar(30),
	Importe float,
	Moneda varchar(30),
	Fecha date
	
)

as
Begin
	insert into @tabla
	select top 5 Num_cheque,Bancos.Nombre_banco,Importe,Descripcion,Fecha from NMI.Retiros,NMI.Cheque,NMI.Bancos,NMI.Moneda
	where
	Cod_banco=Id_banco and
	Cod_cheque=Id_cheque
	and
	Cod_moneda=Id_moneda
	order by Fecha
	
	return
	end
	go
	
	create function NMI.ultimas10Transf(@cuenta numeric(18))
	returns @tablita table(
	Cuenta_destino	numeric(18),
	Importe float,
	moneda varchar(30),
	fecha date
	)
	as
	begin
	insert into @tablita 
	select top 10 Cod_cuenta_destino,Importe,Descripcion,Fecha from NMI.Transferencias,NMI.Moneda,NMI.Transacciones
	where Id_transaccion=Cod_transaccion
	and Cod_moneda=Id_moneda
	and Cod_cuenta_origen=@cuenta
	order by Fecha
	return 
	end
	go
	/*
	create function transferenciasAFacturar(@cliente int)
	returns @tabla table(
	
	
	)*/
	
	create  procedure NMI.transferir @cta_origen numeric(18), @cta_destino numeric(18),@importe float--,@fecha date
	as
	begin
	begin transaction set transaction isolation level serializable
	insert into NMI.Transacciones(Cod_estado,Costo) values(1,(select @importe*Costo from NMI.Cuenta,NMI.Categoria
		where Codigo_categoria=Id_categoria and Num_cuenta=@cta_origen)) 
	insert into NMI.Transferencias select
	@importe,@cta_origen,@cta_destino,MAX(Id_transaccion),1 from NMI.Transacciones
	commit 	
	end
	go
	
	Insert into NMI.Usuario(Useranme,Contrasenia,Pregunta_secreta,Respuesta,Estado) values('a','a','como es tu nombre?','a',1)
	go
	insert into NMI.Usuario_rol select MAX (Usuario.Id_usuario),2 from NMI.Usuario 
	go
	
	
create  trigger NMI.insertarTransferencia on NMI.Transferencias
instead of insert
as
begin transaction

update NMI.cuenta
set Codigo_estado=2
where Fecha_vencimiento < NMI.fechaSistema() and Codigo_estado=1

insert into NMI.Transferencias
select Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda
from inserted 

commit
go

create trigger NMI.validarSaldoMayorQueTransferencia
on NMI.Transferencias
for insert
as
begin transaction
if(0<( 
	select count(*) from inserted
	where 
	Importe>(Select Saldo from Cuenta where Num_cuenta=Cod_cuenta_origen)))
begin
raiserror ('Cuenta sin saldo',16,150)	
rollback
end	
	else 
	commit
	
go	

create trigger NMI.validarDestinoValidoTransferencia
on NMI.Transferencias
for insert
as
begin transaction
if(0<(
	select count(*) from inserted
	where 
	(Select Codigo_estado from NMI.Cuenta where Num_cuenta=Cod_cuenta_destino )  in (3,4)))
begin
raiserror ('Cuenta no puede recibir',16,150)
rollback
end				
else 

commit
	
go

create trigger NMI.insertarDeposito on NMI.Depositos
instead of insert
as
begin transaction

update NMI.cuenta
set Codigo_estado=2
where Fecha_vencimiento < NMI.fechaSistema() and Codigo_estado=1
insert into NMI.Depositos
select *
from inserted 
commit
go

create trigger NMI.insertarRetiro on NMI.Retiros
instead of insert
as
begin transaction

update NMI.cuenta
set Codigo_estado=2
where Fecha_vencimiento < NMI.fechaSistema() and Codigo_estado=1
insert into NMI.Retiros
select *
from inserted 
commit
go

create trigger NMI.haySAldoParaRetiro on NMI.Retiros
for insert
as 
begin transaction 
if(0<(
select count(*) from inserted,NMI.Cheque
 where Cod_cheque=Id_Cheque and Importe > (select Saldo from NMI.Cuenta where Num_cuenta=Cod_cuenta)))
begin
raiserror ('Cuenta sin saldo',16,150)
rollback
end
else 
commit

go
create  procedure NMI.limpiar
as 
begin

drop table NMI.Depositos
drop table NMI.Retiros
drop Table NMI.modificacion_cuenta
drop table NMI.transferencias
drop table NMI.tipo_modificacion
drop table NMI.intentos_fallidos
drop table NMI.intentos_login
drop table NMI.tarjetas_credito
drop table NMI.tarjeta_emisor
drop table NMI.rol_funcionalidad
drop table NMI.transacciones
drop table NMI.suscripciones
drop table NMI.facturas
drop table NMI.usuario_rol
drop table NMI.ultimaCuenta
drop table NMI.inhabilitacionesDeCuenta
drop table NMI.cuenta
drop table NMI.cheque
drop table NMI.funcionalidad
drop table NMI.cliente
drop table NMI.bancos
drop table NMI.categoria
drop table NMI.estado_cuenta
drop table NMI.rol
drop table NMI.estado_rol
drop table NMI.estado_transaccion
drop table NMI.moneda
drop table NMI.pais
drop table NMI.tipo_dni
drop table NMI.usuario
drop table NMI.fechaDeSistema

end
go

create function NMI.clientesInhabilitados(@anio int,@trimestre int)
returns @tabla table(
num_cliente int,
nom_cliente varchar(32)
)
as
begin
insert into @tabla
select top 5 id_cliente,nombre from NMI.Cliente,NMI.Cuenta as c,NMI.inhabilitacionesDeCuenta as i
where i.num_cuenta=c.num_cuenta and c.codigo_cliente=id_cliente 
and (year(i.fecha)=@anio) and (month(i.fecha) between ((@trimestre-1)*3+1) and (@trimestre*3))
order by i.fecha
return
end


go

sp_settriggerorder 'NMI.inhabilitarCuentasConMasDe5','last','insert',null
go


create function NMI.documentosDisponibles()
returns @tabla table(
	descripcion varchar(30)
)

as
begin
	insert into @tabla
	select descripcion
	from NMI.tipo_dni
	return
end
go

insert into NMI.Tipo_DNI values (1001,'DNI')

go

create function NMI.getNacionalidades()
returns @tabla table(pais varchar(100))
as
begin
insert into @tabla
select Descripcion from NMI.Pais
return end
go




create procedure NMI.Loguear @username varchar(30),@contra varchar(30)
as
begin transaction set transaction isolation level serializable
if(not Exists (select ID_usuario from NMI.Usuario where
Useranme=@username
))begin
raiserror ('no existe usuario',16,150)
rollback
return
end
if (exists (select ID_usuario from NMI.Usuario where
Useranme=@username and Estado='inhabilitado'
))
begin
raiserror ('usuario inhabilitado',16,150)
rollback
return
end 
if (exists (select ID_usuario from NMI.Usuario where
Useranme=@username and Contrasenia=@contra
--dbo.encriptarSha256(@contra)
))
begin
insert into NMI.Intentos_login	 select ID_usuario,1 from NMI.Usuario where
Useranme=@username
end
else
begin
insert into NMI.Intentos_login	 select ID_usuario,0 from NMI.Usuario where
Useranme=@username
raiserror ('mal contra',16,150)
end
commit
go
create procedure NMI.ingresarCliente
@username varchar(50)/*,@pw varchar(50),
@pregunta varchar(50),@respuesta varchar(50)*/,
@nombre varchar(50),@apellido varchar(50),
@tipodoc varchar(50),@numerodedoc int,
@mail varchar(50),
@pais varchar(50),@calle varchar(50),
@numero int,@piso int,
@depto char(1),@fecha date
as

Begin transaction set transaction isolation level serializable
	declare @coduser int
	declare @numeropais int
	declare @tipoDeDocumentoNumero numeric(10)
	/*insert into NMI.Usuario(Useranme,Contrasenia,Pregunta_secreta,Respuesta,Estado) values 
						(@username,@pw,@pregunta,@respuesta,'habilitado')
	*/select @coduser = (select Id_usuario from NMI.Usuario where Useranme=@username)
	select @tipoDeDocumentoNumero=(select Id_DNI from NMI.Tipo_DNI where Descripcion=@tipodoc)
	insert into NMI.Usuario_rol(Cod_usuario,Cod_rol) values (@coduser,1)
	select @numeropais= (select Id_Pais from NMI.Pais where Descripcion=/*' '+*/@pais) 
	insert into NMI.Cliente(Cod_usuario,Nombre,Apellido,Tipo_documento,Numero_documento,Mail,Cod_pais,Calle,Numero,Piso,Depto,Fecha_nacimiento)
				values (@coduser,@nombre,@apellido,@tipoDeDocumentoNumero,@numerodedoc,@mail,@numeropais,@calle,@numero,@piso,@depto,@fecha)
	
	commit 
	 
go



create function NMI.clientesConMasTransferenciasEntreCuentas()
returns @tabla table(
nombre varchar(30),
apellido varchar(30)
)
as begin
insert into @tabla
select top 5 c1.Nombre,c1.Apellido from NMI.cliente c1,NMI.cuenta c2,NMI.Transferencias t,NMI.cuenta c3,NMI.cliente c4
where
c1.Id_cliente=c2.Codigo_cliente and c2.Num_cuenta=t.Cod_cuenta_origen and c3.Num_cuenta=t.Cod_cuenta_destino
and c3.Codigo_cliente=c4.Id_cliente and c1.Id_cliente=c4.Id_cliente
group by c1.Nombre,c1.Apellido
order by COUNT(*) desc
return
end
go



create function NMI.datosDelCliente(@idDelCliente numeric(18))
returns @tabla table (id_cliente int, Cod_usuario int, Nombre varchar(50),
Apellido  varchar(50),Tipo_documento varchar(30),Numero_documento int, 
Mail varchar(50),Cod_pais numeric(10),Calle varchar(50),
Numero numeric(18),Piso int, Depto Char(1),Fecha date)
as
Begin
insert into @tabla
select Id_cliente,Cod_usuario,Nombre,Apellido,Descripcion,Numero_documento,mail,cod_pais,calle,numero,piso,depto,fecha_nacimiento from NMI.Cliente,NMI.Tipo_Dni where Tipo_Documento=Id_DNI and Id_cliente=@idDelCliente
return 
end

go

create procedure NMI.updeteaDatosDelCliente @id_cliente int,  @Nombre varchar(50),
@Apellido  varchar(50),@Tipo_documento varchar(50),@Numero_documento int,
@Mail varchar(50),@Calle varchar(50),
@Numero int,@Piso smallint, @Depto Char(1),@Fecha date
as
begin


update NMI.Cliente set Nombre=@Nombre,Apellido=@Apellido,
					Tipo_documento=(select Id_Dni from NMI.Tipo_DNI where Descripcion=@Tipo_documento),Numero_documento=@Numero_documento,
					Mail=@Mail,Calle=@Calle,Numero=@Numero,
					Piso=@Piso,Depto=@Depto,Fecha_nacimiento=@Fecha 

					
					where Id_cliente=@id_cliente
end

go


 
create table NMI.suscripciones
(id int identity(1,1) primary key,
cuenta numeric(18),
cantidad int,
factura numeric(18) foreign key references NMI.Facturas(Num_factura),
costo float)

go
create procedure NMI.pagarSuscripciones @cuenta numeric(18),@cantidad int, @numeroFactura numeric(18)
as
begin
insert into NMI.suscripciones (cuenta,cantidad,factura) values
			(@cuenta,@cantidad,@numeroFactura)
end
go







create trigger NMI.actualizarCosto 
on NMI.Suscripciones
for insert
as
begin transaction
	declare @costo float
	update NMI.suscripciones set costo = 
	cantidad*(select precioSuscripcion from NMI.Cuenta,NMI.Categoria where Cuenta.Codigo_categoria=Categoria.Id_categoria
	and Cuenta.Num_cuenta=cuenta) where id in (select id from inserted)  
	 
	commit 
	go

create trigger NMI.actualizarVencimiento
on NMI.Suscripciones 
for insert
as
begin transaction
	update NMI.Cuenta set Fecha_vencimiento = dateadd (day,(select inserted.cantidad from inserted
	where inserted.cuenta=Num_cuenta)*(select Duracion from NMI.Categoria where Codigo_categoria=Categoria.Id_categoria),Fecha_vencimiento)
	where Num_cuenta in (select Cuenta from inserted)
commit
go



create procedure NMI.nuevaContra @usuario varchar(30),@respuesta varchar(50),@contra varchar(30)
as
begin transaction
if(@respuesta
--dbo.encriptarSha256(@respuesta)
<> (select respuesta from NMI.Usuario where Useranme=@usuario)
)
begin
raiserror ('respuesta secreta incorrecta',15,250)
rollback
return
end

update NMI.Usuario
set Contrasenia=@contra
where Useranme=@usuario
commit 
GO

create function NMI.totalFactura(@fact numeric(18))
returns int
as
begin
Declare @i int
Select @i =sum(precio) from(
select precio=Costo from NMI.Transacciones
where cod_factura =@fact
union
select precio=costo from NMI.suscripciones
where factura=@fact

) sub

return @i
end
go

create function NMI.listadoFactura(@fact numeric(18))
returns @tabla table(
item varchar(50),
precio float
)
as
begin
insert into @tabla
select 'transferencia a cuenta '+convert(varchar(20),cod_cuenta_destino),costo from NMI.Transacciones t1,NMI.Transferencias t2
where t1.id_transaccion=t2.cod_transaccion and t1.cod_factura=@fact
union
select 'suscripcion por dias: '+convert(varchar(3),cantidad),costo from NMI.suscripciones where factura=@fact


return
end
go
create procedure NMI.asentarRetiro @cuenta numeric(18),@numCheque int,@Importe float, @banco varchar(50),@cliente int, @moneda varchar(50)
 as
 begin transaction
 set transaction isolation level serializable
 Declare @cod_banco int
 declare @cod_moneda int
 select @cod_banco=Id_banco from NMI.Bancos
 where Nombre_banco=@banco
 select @cod_moneda=Id_moneda from NMI.Moneda
 where Descripcion=@moneda
 Declare @fecha date
 select @fecha=NMI.fechaSistema()
 insert into NMI.Cheque values(@numCheque,@cod_banco,@cliente,@fecha,@Importe,@cod_moneda)
 Declare @Id_cheque int
 Declare @retiro numeric(18)
 select @retiro=MAX(Id_retiro)+1 from NMI.Retiros
 select @Id_cheque=max(Id_cheque) from NMI.Cheque
 insert into Retiros(Id_retiro,Cod_cuenta,Cod_cheque) values(@retiro,@cuenta,@Id_cheque)
 commit
 go


create procedure NMI.altaCuenta

@cliente int, @numero numeric(20), @pais varchar(50), @moneda varchar(20),

@apertura date,@tipo varchar(50)

 
 as
 begin

declare @idmoneda int

declare @idpais int	
declare @idecategoria int	
	set @idmoneda=(select id_moneda from NMI.Moneda where Descripcion=@moneda)
	set @idpais=(select id_pais from NMI.Pais where Descripcion=@pais)
	set @idecategoria=(select id_categoria from NMI.Categoria where Descripcion=@tipo)
	update NMI.ultimaCuenta set numero=@numero
	insert into NMI.Cuenta values (@numero,@apertura,NULL,NULL,@idpais,@idmoneda,@idecategoria,@cliente,3,0)
commit
 end
go	


create procedure NMI.bajaCuenta
@numero numeric(20)
as
begin
update NMI.Cuenta set Codigo_estado=4 where Num_cuenta=@numero
commit
end
go


create procedure NMI.modificarCuenta
@numero numeric(20),@pais varchar(50),@moneda varchar(50),@tipo varchar(50)
as
begin
declare @idmoneda int
declare @idpais int
declare @idecategoria int
	set @idmoneda=(select id_moneda from NMI.Moneda where Descripcion=@moneda)
	set @idpais=(select id_pais from NMI.Pais where Descripcion=@pais)
	set @idecategoria=(select id_categoria from NMI.Categoria where Descripcion=@tipo)


update NMI.Cuenta set Codigo_pais=@idpais,Codigo_moneda=@idmoneda,Codigo_categoria=@idecategoria
					where Num_cuenta=@numero

commit 
end

 go


create procedure NMI.ingresarUsuario @username varchar(30),@pw varchar(30),@pregunta varchar(50), @Respuesta varchar (50), @rol int 
as
begin transaction
insert into NMI.Usuario(Useranme,Contrasenia,Pregunta_secreta,Respuesta,Estado) values(@username,@pw,@pregunta,@Respuesta,'habilitado')
Declare @codUser int
select @codUser=Id_usuario from NMI.Usuario
where Useranme=@username
insert into NMI.Usuario_rol(Cod_rol,Cod_usuario) values(@rol,@codUser)
commit
go

create function NMI.tarjetasPorCliente(@cliente numeric(18))
returns  @tabla table(
tarjeta numeric(18))
as
begin
insert into @tabla 
select  Tarjetas_credito.Num_tarjeta from NMI.Tarjetas_credito
where Tarjetas_credito.Cod_cliente=@cliente
return
end
go