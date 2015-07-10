create function fechaSistema()
returns datetime 
as
begin
	return getdate()
end
go


Create table ultimaCuenta (
numero numeric(18)
)
go
insert into ultimaCuenta values (0) 
go
create table Usuario
(Id_usuario int  identity(1,1) primary key ,
Useranme Varchar(30) not null,
Contrase�a varchar(30) not null,
Fecha_creacion date default dbo.fechaSistema(),
Ultima_modificacion date not null default dbo.fechaSistema(), 
Pregunta_secreta varchar(50) not null,
Respuesta varchar(50) not null
)
go

create table Pais
(Id_Pais int primary key,
Descripcion varchar(50) not null
)
go
create table Tipo_DNI(
Id_DNI int primary key,
Descripcion Varchar(20) not null 
)
go


Create Table Cliente(  --elimino localidad
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
foreign key (Cod_pais) references Pais(Id_pais),
foreign key (Cod_usuario) references Usuario(Id_usuario),
)
go
Create table Intentos_login(
	Id_login int identity(1,1) primary key,
	Codigo_usuario int not null,
	Es_correcto bit not null,
	foreign key (Codigo_usuario) references Usuario(Id_usuario)
)
go 
Create table Intentos_fallidos(
	Id_fallido int identity(1,1) primary key,
	Cod_login int not null,
	foreign key (Cod_login) references Intentos_login(Id_login)
)
go
Create table Estado_rol(
	Id_estado int identity(1,1) primary key,
	Descripcion varchar(20) not null
)
go
Create table Rol(
	Id_rol int identity(1,1) primary key,
	Nombre_rol varchar(30) not null,
	Cod_estado int not null,
	foreign key (Cod_estado) references Estado_rol(Id_estado),
)
go
Create table Usuario_rol(
	Cod_usuario int not null,
	Cod_rol int not null,
	Foreign key (Cod_usuario) references Usuario(Id_usuario),
	Foreign key (Cod_rol) references Rol(Id_rol)
)
go
Create table Funcionalidad(
	Id_funcionalidad int identity(1,1) primary key, --Agrego identity
	Descripcion varchar(30) not null
)
go
Create table Rol_funcionalidad(
	Cod_rol int not null,
	Cod_funcionalidad int not null
	foreign key (Cod_rol) references Rol(Id_rol),
	foreign key (Cod_funcionalidad) references Funcionalidad(Id_funcionalidad)
)
go	
create table Categoria(
	Id_categoria int identity(1,1) primary key,
	Descripcion varchar(30) not null,
	Costo float not null,
	precioSuscripcion float,
	Duracion int
)
go
create table Moneda(
	Id_moneda int identity(1,1) primary key,
	Descripcion varchar(20) not null,
	Conversion float not null default 1	
)
go
create table Estado_cuenta(
	Id_estado int identity(1,1) primary key,
	Descripcion varchar(20) not null
)
go
create table Cuenta(
	Num_cuenta numeric(18) primary key, -- modificacion del identity NO TIENE Q SER IDENTITY
	Fecha_apertura date not null default dbo.fechaSistema(),
	Fecha_cierre date default null,
	Fecha_vencimiento date,
	Codigo_pais int not null,
	Codigo_moneda int not null,
	Codigo_categoria int not null,
	Codigo_cliente int not null,
	Codigo_estado int not null,
	Saldo float not null default 0,
	foreign key (Codigo_pais) references Pais(Id_pais),
	foreign key (Codigo_moneda) references Moneda(Id_moneda),
	foreign key (Codigo_categoria) references Categoria(Id_categoria),
	foreign key (Codigo_cliente) references Cliente(Id_cliente),
	foreign key (Codigo_estado) references Estado_cuenta(Id_estado)
);	
Create table Estado_transaccion(
	Id_estado int identity(1,1) primary key,
	Descripcion varchar(30) not null,
)
go
Create table Transacciones(
	Id_transaccion int identity(1,1) primary key,
	Cod_estado int not null,
	Costo float not null,
	Fecha date not null default dbo.fechaSistema(),
	foreign key (Cod_estado) references Estado_transaccion(Id_estado)
)
go
create table Tipo_modificacion(
	Id_tipo int identity(1,1) primary key,
	Descripcion varchar(30) not null,
)
go
create table Modificacion_cuenta(
	Id_modificacion int identity(1,1) primary key,
	Cod_tipo int not null,
	Cod_cuenta numeric(18) not null,
	Cod_transaccion int not null,
	foreign key (Cod_tipo) references Tipo_modificacion(Id_tipo),
	foreign key (Cod_cuenta) references Cuenta(Num_cuenta),
	foreign key (Cod_transaccion) references Transacciones(Id_transaccion)
);

go
/*
create table Suscripcion(
Cod_cuenta numeric(18),

)*/

create table Transferencias(
	Id_transferencia int identity(1,1) primary key,
	Importe float not null,
	Cod_cuenta_origen numeric(18) not null,
	Cod_cuenta_destino numeric(18) not null,
	Cod_transaccion int not null,
	foreign key (Cod_cuenta_origen) references Cuenta(Num_cuenta),
	foreign key (Cod_cuenta_destino) references Cuenta(Num_cuenta),
	foreign key (Cod_transaccion) references Transacciones(Id_transaccion),
	check (Importe>=0)
	

)
go



create table Bancos(
	Id_banco int identity(1,1) primary key,
	Nombre_banco varchar(30) not null,
	Cod_pais int not null,
	foreign key (Cod_pais) references Pais(Id_pais)
)
go

create table inhabilitacionesDeCuenta(
	num_cuenta numeric(18) foreign key references Cuenta(num_cuenta),
	fecha datetime
)
go
create trigger asentarCuentaInhabiltada on inhabilitacionesDeCuenta
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
		  update cuenta
		  set codigo_estado= 2
		  where num_cuenta=@cuentaOrigen
			
			fetch next from cursorPasados into @cuentaOrigen
	end				
	
	close cursorPasados
	deallocate cursorPasados
	commit
go

create table Tarjeta_Emisor(           --Tabla de las emisoras de las tarjes american, visa etc
	Id_tarjeta_emisor int identity(1,1) primary key,
	Descripcion varchar(40)
)
go
create table Tarjetas_credito( --Cambio la pk, porque puede haber mismo numero con diferente emisor
	Id_tarjeta int identity(1,1) primary key,
	Num_tarjeta numeric(18) not null,
	Cod_cliente int not null,
	Cod_emisor int not null,
	Fecha_emision date not null,
	Fecha_vencimiento date not null,
	Cod_seguridad int,
	foreign key (Cod_cliente) references Cliente(Id_cliente),
	foreign key (Cod_emisor) references Tarjeta_Emisor(Id_tarjeta_emisor)
)
go

create table Depositos(
	Id_deposito numeric(18) primary key,
	Cod_cuenta numeric(18) not null,
	Cod_moneda int not null,
	Importe float not null,
	Cod_TC int not null,
	Fecha date,
	check(Importe>1),
	foreign key (Cod_cuenta) references Cuenta(Num_cuenta),
	foreign key (Cod_moneda) references Moneda(Id_moneda),
	foreign key (Cod_TC) references Tarjetas_credito(Id_tarjeta)
)
go
create table Cheque(
	Id_cheque int identity(1,1) primary key,
	Num_cheque int not null,
	Cod_banco int not null,
	Cod_cliente int not null,
	Fecha date not null default dbo.fechaSistema(),
	
	foreign key (Cod_banco) references Bancos(Id_banco),
	foreign key (Cod_cliente) references Cliente(Id_cliente)
)
go
Create Table Facturas(
	Num_factura numeric(18) primary key,
	Fecha_factura Date not null,
)
go


create table Retiros (
	Id_retiro numeric(18) primary key,
	Cod_cuenta numeric(18) not null,
	Cod_cheque int not null,
	foreign key (Cod_cuenta) references Cuenta(Num_cuenta),
	Foreign key (Cod_cheque) references Cheque(Id_cheque)
)
go



	
Alter table Usuario
add Estado Varchar(20) not null
go	
Alter table Transferencias
add Cod_moneda int not null
go
Alter table Transferencias
add foreign key (Cod_moneda) references Moneda(Id_moneda)
go
ALTER TABLE Cheque
add Importe float not null
go
Alter table Cheque 
add Cod_moneda int not null
go
Alter table Cheque 
add foreign key (Cod_moneda) references Moneda(Id_moneda)
go
alter table Transacciones
add  cod_factura numeric(18)
go
alter table Transacciones
add foreign key (cod_factura) references Facturas(Num_factura)
go

create table tablaTemporal (
	Id_transferencia int identity(1,1) primary key,
	Importe float not null,
	Cod_cuenta_origen numeric(18) not null,
	Cod_cuenta_destino numeric(18) not null,
	Id_transaccion int ,
	Cod_estado int not null,
	Costo float not null,
	Fecha date not null default dbo.fechaSistema(),
	cod_moneda int,
	cod_factura int

)
go






Create trigger miTrigger on tablaTemporal
instead of insert
as
begin transaction
set IDENTITY_INSERT Transacciones ON
insert into Transacciones(Id_transaccion,Cod_estado,Costo,Fecha,cod_factura)
select Id_transaccion,Cod_estado,Costo,Fecha,cod_factura from inserted
set IDENTITY_INSERT Transacciones Off
insert into Transferencias (Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda)
select Importe,Cod_cuenta_origen,Cod_cuenta_destino,Id_transaccion,Cod_moneda from inserted


commit


go

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
	Declare @cuentaOrigen numeric(18)
	Declare @cuentaDestino numeric(18)
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
	
	create trigger ActualizarSaldosPorDeposito
on Depositos 
for insert, update, delete
	as
	Begin transaction 
	if ((select count (*) from inserted)>0)
	begin
	Declare cursor_deInsertados Cursor
	for (select Cod_cuenta,sum(Importe),Moneda.Conversion From inserted,Moneda
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
	select @ConversionFinal=(Select Moneda.Conversion from Moneda,Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuenta)
	Update Cuenta set Saldo=Saldo+@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuenta
	fetch next from cursor_deInsertados into @cuenta,@sumaDeImporte,@conversion
	end
	close cursor_deInsertados
	deallocate cursor_deInsertados
	end
	
	if ((select count (*) from deleted)>0)
	begin
	Declare cursor_deBorrados Cursor
	for (select Cod_cuenta,sum(Importe),Moneda.Conversion From deleted,Moneda
	group by Cod_cuenta,Moneda.Conversion)
		
	
	open cursor_deBorrados
	fetch next from cursor_deBorrados into @cuenta,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from Moneda,Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuenta)
	Update Cuenta set Saldo=Saldo-@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuenta
	fetch next from cursor_deBorrados into @cuenta,@sumaDeImporte,@conversion
	end
	close cursor_deBorrados
	deallocate cursor_deBorrados
	end
	
	commit;
go
	
create trigger ActualizarSaldosPorRetiro
on Retiros 
for insert, update, delete
	as
	Begin transaction 
	if ((select count (*) from inserted)>0)
	begin
	Declare cursor_deInsertados Cursor
	for (select Cod_cuenta,sum(Cheque.Importe),Moneda.Conversion From Cheque,inserted,Moneda
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
	select @ConversionFinal=(Select Moneda.Conversion from Moneda,Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuenta)
	Update Cuenta set Saldo=Saldo-@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuenta
	fetch next from cursor_deInsertados into @cuenta,@sumaDeImporte,@conversion
	end
	close cursor_deInsertados
	deallocate cursor_deInsertados
	end
	
	if ((select count (*) from deleted)>0)
	begin
	Declare cursor_deBorrados Cursor
	for (select Cod_cuenta,sum(Cheque.Importe),Moneda.Conversion From Cheque,deleted,Moneda
	where Cheque.Cod_moneda=Moneda.Id_moneda and Cheque.Id_cheque=deleted.Cod_cheque
	group by Cod_cuenta,Moneda.Conversion)
	
	open cursor_deBorrados
	fetch next from cursor_deBorrados into @cuenta,@sumaDeImporte,@conversion
	while(@@FETCH_STATUS=0)
	begin
	select @ConversionFinal=(Select Moneda.Conversion from Moneda,Cuenta
	where Moneda.Id_moneda=Cuenta.Codigo_moneda and Cuenta.Num_Cuenta=@cuenta)
	Update Cuenta set Saldo=Saldo+@sumaDeImporte*@conversion/@ConversionFinal where Num_cuenta=@cuenta
	fetch next from cursor_deBorrados into @cuenta,@sumaDeImporte,@conversion
	end
	close cursor_deBorrados
	deallocate cursor_deBorrados
	end
	
	commit;
go
	
	Create trigger CuaandoSeIngresanLoginsIncorrectos
on Intentos_login
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
Insert into Intentos_fallidos (Cod_login)values (@num_login)
fetch next from cursorDeIncorrectos into @num_login,@Correcto
end
end
close cursorDeIncorrectos
deallocate cursorDeIncorrectos
drop table #tablaIncorrectos
commit;
go


Create trigger CuaandoSeIngresanLoginsCorrectos
on Intentos_login
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
Delete from Intentos_fallidos where Cod_login=@num_login
fetch next from cursorDeIncorrectos into @num_login,@Correcto
end
end
drop table #tablaCorrectos
close cursorDeIncorrectos
deallocate cursorDeIncorrectos
commit;
go


Create trigger CuandoSeIngresaUnTercerLoginFallidoSEInhabilita
on Intentos_fallidos
for  insert
as
Begin transaction
Declare @num_fallido int
Declare @Cod_loguin int
Declare cursorDeFallidos Cursor
for select * from inserted
open cursorDeIncorrectos
fetch next from cursorDeFallidos into @num_fallido,@Cod_loguin
while(@@FETCH_STATUS=0)
begin
if ((select count(*) from Intentos_fallidos,Usuario,Intentos_loguin
where Intentos_fallidos.Cod_loguin=Intentos_loguin.Id_loguin and Intentos_loguin.Cod_usuario=Usuario.Id_usuario)>2)
update Usuario
set Estado="inhabilitado"
where Id_usuario = (Select Cod_usuario from Intentos_loguin where Id_loguin=@Cod_loguin)
fetch next from cursorDeFallidos into @num_fallido,@Cod_loguin

end
close cursorDeFallidos
deallocate cursorDeFallidos
commit;
go

--Pais
insert into Pais
select * from (select distinct Cli_Pais_Codigo, Cli_Pais_Desc 
from gd_esquema.Maestra 
union
select distinct Cuenta_Dest_Pais_Codigo, Cuenta_Dest_Pais_Desc
from gd_esquema.Maestra
where Cli_Pais_Codigo is not null and Cuenta_Dest_Pais_Codigo is not null
)A

go
--Moneda
insert into Moneda(Descripcion,Conversion) values ('Dolar',1);

go
--Tipo de dni
insert into Tipo_DNI
select distinct Cli_Tipo_Doc_Cod, Cli_Tipo_Doc_Desc
from gd_esquema.Maestra

go
--Bancos
insert into Bancos(Nombre_banco,Cod_pais) values ((select distinct 
top 1 Banco_Nombre from gd_esquema.Maestra where Banco_Nombre is not null),8)
go
insert into Bancos(Nombre_banco,Cod_pais) values ((select distinct top 1 Banco_Nombre 
from gd_esquema.Maestra where Banco_Nombre is not null and Banco_Nombre like '%Nac%'),8)
go

--Categorias de cuentas
insert into Categoria (Descripcion,precioSuscripcion,Costo,Duracion) values ('oro',30,0.03,365)
insert into Categoria (Descripcion,precioSuscripcion,Costo,Duracion) values ('plata',20,0.05,90)
insert into Categoria (Descripcion,precioSuscripcion,Costo,Duracion) values ('bronce',10,0.07,30)
insert into Categoria (Descripcion,precioSuscripcion,Costo,Duracion) values ('gratuita',0,0.1,10)

go
--Tabla de Estados_Rol
insert into Estado_rol (Descripcion) values ('Activo')
insert into Estado_rol (Descripcion) values ('Inactivo')

go
--Tabla de roles
insert into Rol (Nombre_rol,Cod_estado) values ('Cliente',1)
insert into Rol (Nombre_rol,Cod_estado) values ('Administrador',1)

go
/*--Tabla de funcionalidades
insert into Funcionalidad (Descripcion) values ('ABM Usuarios')
go
insert into Funcionalidad (Descripcion) values ('ABM Clientes')
go
insert into Funcionalidad (Descripcion) values ('ABM Cuentas')
go
insert into Funcionalidad (Descripcion) values ('ABM Credit Card')
go
insert into Funcionalidad (Descripcion) values ('ABM Despositos')
go
insert into Funcionalidad (Descripcion) values ('ABM Retiros')
go
insert into Funcionalidad (Descripcion) values ('ABM Transferencias')
go
insert into Funcionalidad (Descripcion) values ('ABM Facturacion')
go
insert into Funcionalidad (Descripcion) values ('ABM Estadisticas')
go
insert into Funcionalidad (Descripcion) values ('ABM Consulta Saldo')
go

--Tabla Rol_Funcionalidades
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (1,2)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (2,2)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (3,2)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (3,1)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (4,1)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (5,1)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (6,1)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (7,1)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (8,1)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (8,2)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (9,2)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (10,2)
go
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (10,1)
go
*/
--Tabla Tarjeta Emisor
insert into Tarjeta_Emisor (Descripcion)
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
Insert into Usuario(Useranme,Contrase�a,Pregunta_secreta,Respuesta,Estado) values(Rtrim (@nombre)+left(@apellido,1),Rtrim (@nombre)+left(@apellido,1),'nombre',@nombre,'habilitado')
Insert into Cliente(Cod_usuario,Nombre,Apellido,Tipo_documento,Numero_documento,Mail,Cod_pais,Calle,Numero,Piso,Depto,Fecha_nacimiento) values((Select MAX(Id_usuario)from Usuario),@nombre,@apellido,@cod_tipoDoc,@numDoc,@mail,@cod_pais,@calle,@numero,@piso,@dpto,@fnac)
fetch next from cursorCliente into @nombre,@apellido,@cod_tipoDoc,@numDoc,
@mail,@cod_pais,@calle,@numero,@piso,@dpto,@fnac
end
close cursorCliente
deallocate cursorCliente
commit

go


--Tabla de usuario_rol
insert into Usuario_rol (Cod_usuario,Cod_rol) (select Id_usuario,1 from Usuario);
go


--Tarjetas de credito
insert into Tarjetas_credito(Num_tarjeta,Cod_cliente,Cod_emisor,Fecha_emision,Fecha_vencimiento
,Cod_seguridad)
select distinct a.Tarjeta_Numero,b.Id_cliente,c.Id_tarjeta_emisor,a.Tarjeta_Fecha_Emision,
a.Tarjeta_Fecha_Vencimiento,a.Tarjeta_Codigo_Seg
from (gd_esquema.Maestra a inner join Cliente b on a.Cli_Nro_Doc=b.Numero_documento 
inner join Tarjeta_Emisor c on a.Tarjeta_Emisor_Descripcion=c.Descripcion) 

go

--Estado de cuentas
insert into Estado_cuenta(Descripcion) values ('Habilitada')
go
insert into Estado_cuenta(Descripcion) values ('Inahilitada')
go
insert into Estado_cuenta(Descripcion) values ('Pendiente')
go
insert into Estado_cuenta(Descripcion) values ('Cerrada')

go



--Cuentas

insert into Cuenta(Num_cuenta,Fecha_apertura,Fecha_cierre,Codigo_pais,Codigo_moneda,
Codigo_categoria,Codigo_cliente,Codigo_estado,Saldo)
select distinct a.Cuenta_Numero,a.Cuenta_Fecha_Creacion,a.Cuenta_Fecha_Cierre,a.Cuenta_Pais_Codigo,1,4,b.Id_cliente,1,0
from (gd_esquema.Maestra a inner join Cliente b on a.Cli_Nro_Doc=b.Numero_documento) 

go
update ultimaCuenta
set numero=(Select MAX(Num_cuenta) from Cuenta)
go
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

go

--Cheques

insert into Cheque (Num_cheque,Importe,Fecha,Cod_moneda,Cod_cliente,Cod_banco)
select distinct Cheque_Numero, Cheque_Importe, Cheque_Fecha,1,b.Id_cliente,c.Id_banco
from gd_esquema.Maestra a inner join Cliente b on a.Cli_Nro_Doc=b.Numero_documento
inner join Bancos c on a.Banco_Nombre=c.Nombre_banco 

go

--Retiros
insert into Retiros(Id_retiro,Cod_cuenta,Cod_cheque)
select distinct a.Retiro_Codigo,a.Cuenta_Numero,c.Id_cheque
from gd_esquema.Maestra a inner join Cliente b on
a.Cli_Nro_Doc=b.Numero_documento inner join Cheque c
on  a.Retiro_Fecha=c.Fecha and a.Retiro_Importe=c.importe and 
b.Id_cliente=c.Cod_cliente and a.Cheque_Numero=c.Num_cheque 
inner join Cuenta d on b.Id_cliente=d.Codigo_cliente 
go

insert into Facturas
select distinct Factura_Numero,Factura_Fecha from gd_esquema.Maestra
where Factura_Numero is not null;
go

Insert into Estado_transaccion(Descripcion) values ('Sin Facturar');

go
Insert into Estado_transaccion(Descripcion) values ('Facturado');
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


insert into tablaTemporal(Importe,Cod_cuenta_origen,Cod_cuenta_destino,Id_transaccion,Cod_estado,Costo,Fecha,cod_moneda,cod_factura)
select
Trans_Importe,Cuenta_Numero,Cuenta_Dest_Numero,ROW_NUMBER()over (order by Transf_Fecha),2,Item_Factura_Importe,Transf_Fecha,1,Factura_Numero from gd_esquema.Maestra
where (Transf_Fecha is not null) and Item_Factura_Importe is not null
go


drop table tablaTemporal
go

--select * from facturas
--select * from Transferencias


--update Transacciones
--set cod_factura = (select m.Factura_Numero from gd_esquema.Maestra m join Transferencias t
--on (t.Cod_transaccion=Id_transaccion and t.Cod_cuenta_destino=m.Cuenta_Dest_Numero and t.Cod_cuenta_origen=m.Cuenta_Numero and m.Transf_Fecha=Fecha and m.Factura_Numero is not null))

create function cuentasPorUsuario(@username varchar(30))
returns  @tabla table(
cuenta numeric(18))
as
begin
insert into @tabla 
select  Cuenta.Num_cuenta from Cuenta,Cliente,Usuario
where Cuenta.Codigo_cliente=Cliente.Id_cliente and Cliente.Cod_usuario=Id_usuario
and Useranme=@username
return
end

go

create function cuentasPorCliente(@cliente numeric(18))
returns  @tabla table(
cuenta numeric(18))
as
begin
insert into @tabla 
select  Cuenta.Num_cuenta from Cuenta
where Cuenta.Codigo_cliente=@cliente
return
end

go

create Function saldoCuenta(@cuenta numeric(18))
returns int
as 
begin
declare @saldo int
select @saldo=(
select Saldo from Cuenta
where num_cuenta=@cuenta

) 
return @saldo

end
go

/*create  trigger inhabilitarCuentasConMas5
on Transacciones
after insert
as
begin transaction
insert into 	inhabilitacionesDeCuenta
	Select cuenta,fecha from (select cuenta=t1.cod_cuenta_origen,fecha=convert(varchar(30),dbo.fechaSistema(),101) 
	From transferencias t1 join transacciones t2
	on (t2.Id_transaccion=t1.cod_transaccion)
	where COD_factura is null -- and t2.id_transaccion in (select id_transaccion from inserted)
	 and t1.cod_cuenta_origen in (select t4.cod_cuenta_origen from  inserted,Transferencias t4
	where t4.cod_transaccion=inserted.id_transaccion ) 
	/*UNION
	select cuenta=m.Cod_cuenta,fecha=convert(varchar(30),dbo.fechaSistema(),101)
	from Modificacion_Cuenta m join transacciones t
	on (m.cod_transaccion=t.Id_transaccion)
	where cod_factura is null*/
	) tabla
	group by cuenta,fecha
	having count (*) > 5 
	
	commit 
go*/

create Trigger inhabilitarCuentasConMasDe5
on Transferencias
for insert
as
begin transaction
insert into 	inhabilitacionesDeCuenta
Select cuenta,fecha from (select cuenta=t1.cod_cuenta_origen,fecha=convert(varchar(30),dbo.fechaSistema(),101) 
	From transferencias t1 join transacciones t2
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

create trigger noPermitirTransferenciasEnInhabilitadas
on transferencias
after insert

as
	begin transaction
		if ((select count(*) from inserted,cuenta where inserted.cod_cuenta_origen=cuenta.num_cuenta and cuenta.codigo_estado=2) > 0 )
			begin
			raiserror ('Cuenta inhabilitada',16,150)
			delete from Tansferencias
			where id_tranferencia in (select id_transferencia from inserted) 
			end
		else 
		--insert into transferencias(Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda) select Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda from inserted
		commit	
go

create trigger noPermitirModificacionesEnInhabilitadas
on Modificacion_cuenta
after insert

as
	begin transaction
		if ((select count(*) from inserted,cuenta where inserted.cod_cuenta=cuenta.num_cuenta and cuenta.codigo_estado=2) > 0 )
			begin
			raiserror ('Cuenta inhabilitada',16,150)
			delete from Transferencias
			where id_transferencia in (select id_transferencia from inserted
			)
			end
		else 
	--	insert into Modificacion_cuenta(Cod_tipo,Cod_cuenta,Cod_transaccion) select Cod_tipo,Cod_cuenta,Cod_transaccion from inserted
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
	insert into Facturas values (@fact,dbo.fechaSistema())	
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

create function usernamesParecidos(@busqueda varchar(30))
returns @tabla table(username varchar(30))
as
begin
insert into @tabla
select useranme  from Usuarios 
where useranme like '%'+@busqueda+'%'

return 
end
go

create function categoriasDisponibles()
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
	from categoria
	
	return
end
go 

create procedure modificarCuenta (@cuenta numeric (18), @nuevaCategoria int, @duracion int)
as
begin
	begin transaction
	update Cuenta
	set cuenta.Codigo_categoria=@nuevaCategoria,
		cuenta.Fecha_cierre=dbo.fechaSistema()+@duracion
	where Cuenta.Num_cuenta=@cuenta
	
	
	update Cuenta
	set Fecha_vencimiento=(Select dbo.fechaSistema()+ from Categoria
	where Cuenta.Num_cuenta=@cuenta 
	
	commit
end
go	

create Procedure getUltimaCuenta @retorno numeric(18)

as
begin
 
select @retorno=(Select max(UltimaCuenta.numero) from UltimaCuenta)
Update UltimaCuenta
set numero=@retorno+1
return @retorno
end
go

create function rolesUsuario(@username varchar(30),@pass varchar(30))
returns @tablaRetorno table
(rol varchar(30)
)
as
begin
insert into @tablaRetorno
select Nombre_rol from Usuario,Usuario_rol,Rol
where Id_rol=Cod_rol and Useranme=@username and Contrase�a=@pass
and Id_usuario=Cod_usuario
return
end

go

insert into Funcionalidad values(
'ABM Rol');

/*insert into Funcionalidad values(
'Login');
*/
insert into Funcionalidad values(
'ABM usuario');

insert into Funcionalidad values(
'ABM cliente');

insert into Funcionalidad values(
'ABM cuenta');

insert into Funcionalidad values(
'Depositos');

insert into Funcionalidad values(
'Retiro de efectivo');

insert into Funcionalidad values(
'Transferencias');

insert into Funcionalidad values(
'Facturacion');

insert into Funcionalidad values(
'Consultar saldo');

insert into Funcionalidad values(
'Listado estadistico');
insert into Funcionalidad values(
'Asociar/desasociar TC')


go

--insert into Rol_funcionalidad values(1,2);

insert into Rol_funcionalidad values(1,4);

insert into Rol_funcionalidad values(1,5);

insert into Rol_funcionalidad values(1,6);

insert into Rol_funcionalidad values(1,7);

insert into Rol_funcionalidad values(1,8);

insert into Rol_funcionalidad values(1,9);

insert into Rol_funcionalidad values(1,11);


insert into Rol_funcionalidad values(2,1);
--insert into Rol_funcionalidad values(2,2);
insert into Rol_funcionalidad values(2,2);
insert into Rol_funcionalidad values(2,3);
insert into Rol_funcionalidad values(2,4);
insert into Rol_funcionalidad values(2,8);
insert into Rol_funcionalidad values(2,9);
insert into Rol_funcionalidad values(2,10);

go

create function funcionalidadesRol(@Rol int)
returns @tabla table (
descripcion varchar(30)
)
as
begin
insert into @tabla
select Descripcion from Rol_funcionalidad,Funcionalidad
	where Cod_rol=@Rol and Id_funcionalidad=Cod_funcionalidad

return end
go


create function ultimos5Depositos(@cuenta numeric(18))
returns @tabla table(Importe float,
	Moneda varchar(30),
	Fecha date,
	NumTarjeta Numeric(18)
)

as
Begin
	insert into @tabla
	select top 5 d.Importe, m.Descripcion , d.Fecha, t.Num_tarjeta
	from Depositos d join Tarjetas_credito t on (d.Cod_TC=t.Id_tarjeta)
						join Moneda m on (d.Cod_moneda=m.Id_moneda)
	where d.Cod_cuenta=@cuenta
	order by d.fecha
	return
end
	
	
go

create function ultimos5Retiros(@cuenta numeric(18))
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
	select top 5 Num_cheque,Bancos.Nombre_banco,Importe,Descripcion,Fecha from Retiros,Cheque,Bancos,Moneda
	where
	Cod_banco=Id_banco and
	Cod_cheque=Id_cheque
	and
	Cod_moneda=Id_moneda
	order by Fecha
	
	return
	end
	go
	
	create function ultimas10Transf(@cuenta numeric(18))
	returns @tablita table(
	Cuenta_destino	numeric(18),
	Importe float,
	moneda varchar(30),
	fecha date
	)
	as
	begin
	insert into @tablita 
	select top 10 Cod_cuenta_destino,Importe,Descripcion,Fecha from Transferencias,Moneda,Transacciones
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
	
	create  procedure transferir @cta_origen numeric(18), @cta_destino numeric(18),@importe float--,@fecha date
	as
	begin
	begin transaction set transaction isolation level serializable
	insert into Transacciones(Cod_estado,Costo) values(1,(select @importe*Costo from Cuenta,Categoria
		where Codigo_categoria=Id_categoria and Num_cuenta=@cta_origen)) 
	insert into Transferencias select
	@importe,@cta_origen,@cta_destino,MAX(Id_transaccion),1 from Transacciones
	commit 	
	end
	go
	
	Insert into Usuario(Useranme,Contrase�a,Pregunta_secreta,Respuesta,Estado) values('a','a','como es tu nombre?','a',1)
	go
	insert into Usuario_rol select MAX (Usuario.Id_usuario),2 from Usuario 
	go
	
	
create  trigger insertarTransferencia on Transferencias
instead of insert
as
begin transaction

update cuenta
set Codigo_estado=2
where Fecha_vencimiento < dbo.fechaSistema() and Codigo_estado=1

insert into Transferencias
select Importe,Cod_cuenta_origen,Cod_cuenta_destino,Cod_transaccion,Cod_moneda
from inserted 

commit
go

create trigger validarSaldoMayorQueTransferencia
on Transferencias
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

create trigger validarDestinoValidoTransferencia
on Transferencias
for insert
as
begin transaction
if(0<(
	select count(*) from inserted
	where 
	(Select Codigo_estado from Cuenta where Num_cuenta=Cod_cuenta_destino )  in (3,4)))
begin
raiserror ('Cuenta no puede recibir',16,150)
rollback
end
else 

commit
	
go

create trigger insertarDeposito on Depositos
instead of insert
as
begin transaction

update cuenta
set Codigo_estado=2
where Fecha_vencimiento < dbo.fechaSistema() and Codigo_estado=1
insert into Depositos
select *
from inserted 
commit
go

create trigger insertarRetiro on Retiros
instead of insert
as
begin transaction

update cuenta
set Codigo_estado=2
where Fecha_vencimiento < dbo.fechaSistema() and Codigo_estado=1
insert into Retiros
select *
from inserted 
commit
go

create trigger haySAldoParaRetiro on Retiros
for insert
as 
begin transaction 
if(0<(
select count(*) from inserted,Cheque
 where Cod_cheque=Id_Cheque and Importe > (select Saldo from Cuenta where Num_cuenta=Cod_cuenta)))
begin
raiserror ('Cuenta sin saldo',16,150)
rollback
end
else 
commit

go
create  procedure limpiar
as 
begin

drop table Depositos
drop table Retiros
drop Table modificacion_cuenta
drop table transferencias
drop table tipo_modificacion
drop table intentos_fallidos
drop table intentos_login
drop table tarjetas_credito
drop table tarjeta_emisor
drop table rol_funcionalidad
drop table transacciones
drop table facturas
drop table usuario_rol
drop table ultimaCuenta
drop table inhabilitacionesDeCuenta
drop table cuenta
drop table cheque
drop table funcionalidad
drop table cliente
drop table bancos
drop table categoria
drop table estado_cuenta
drop table rol
drop table estado_rol
drop table estado_transaccion
drop table moneda
drop table pais
drop table tipo_dni
drop table usuario

end
go

create function clientesInhabilitados(@a�o int,@trimestre int)
returns @tabla table(
num_cliente int,
nom_cliente varchar(32)
)
as
begin
insert into @tabla
select top 5 id_cliente,nombre from Cliente,Cuenta as c,inhabilitacionesDeCuenta as i
where i.num_cuenta=c.num_cuenta and c.codigo_cliente=id_cliente 
and (year(i.fecha)=@a�o) and (month(i.fecha) between ((@trimestre-1)*3+1) and (@trimestre*3))
order by i.fecha
return
end


go

sp_settriggerorder 'inhabilitarCuentasConMasDe5','last','insert',null
go


create function documentosDisponibles()
returns @tabla table(
	descripcion varchar(30)
)

as
begin
	insert into @tabla
	select descripcion
	from tipo_dni
	return
end
go
