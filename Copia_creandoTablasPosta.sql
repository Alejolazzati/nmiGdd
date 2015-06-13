use GD1C2015;
create table Usuario
(Id_usuario int  identity(1,1) primary key ,
Useranme Varchar(30) not null,
Contraseña varchar(30) not null,
Fecha_creacion date default GETDATE(),
Ultima_modificacion date not null default GETDATE(), 
Pregunta_secreta varchar(50) not null,
Respuesta varchar(50) not null
);

create table Pais
(Id_Pais int primary key,
Descripcion varchar(20) not null
);
create table Tipo_DNI(
Id_DNI int primary key,
Descripcion Varchar(20) not null 
);

Create table Localidad (
Id_localidad int identity(1,1) primary key,
Descripcion varchar(30) not null,
);

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
);

Create table Intentos_login(
	Id_login int identity(1,1) primary key,
	Codigo_usuario int not null,
	Es_correcto bit not null,
	foreign key (Codigo_usuario) references Usuario(Id_usuario)
); 

Create table Intentos_fallidos(
	Id_fallido int identity(1,1) primary key,
	Cod_login int not null,
	foreign key (Cod_login) references Intentos_login(Id_login)
);

Create table Estado_rol(
	Id_estado int identity(1,1) primary key,
	Descripcion varchar(20) not null
);

Create table Rol(
	Id_rol int identity(1,1) primary key,
	Nombre_rol varchar(30) not null,
	Cod_estado int not null,
	foreign key (Cod_estado) references Estado_rol(Id_estado),
);
Create table Usuario_rol(
	Cod_usuario int not null,
	Cod_rol int not null,
	Foreign key (Cod_usuario) references Usuario(Id_usuario),
	Foreign key (Cod_rol) references Rol(Id_rol)
);

Create table Funcionalidad(
	Id_funcionalidad int identity(1,1) primary key, --Agrego identity
	Descripcion varchar(30) not null
);

Create table Rol_funcionalidad(
	Cod_rol int not null,
	Cod_funcionalidad int not null
	foreign key (Cod_rol) references Rol(Id_rol),
	foreign key (Cod_funcionalidad) references Funcionalidad(Id_funcionalidad)
);	

create table Categoria(
	Id_categoria int identity(1,1) primary key,
	Descripcion varchar(30) not null,
	Costo float not null
);

create table Moneda(
	Id_moneda int identity(1,1) primary key,
	Descripcion varchar(20) not null,
	Conversion float not null default 1	
);

create table Estado_cuenta(
	Id_estado int identity(1,1) primary key,
	Descripcion varchar(20) not null
);

create table Cuenta(
	Num_cuenta numeric(18) primary key, -- modificacion del identity NO TIENE Q SER IDENTITY
	Fecha_apertura date not null default getdate(),
	Fecha_cierre date default null,
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
);

Create table Transacciones(
	Id_transaccion int identity(1,1) primary key,
	Cod_estado int not null,
	Costo float not null,
	Fecha date not null default getdate(),
	foreign key (Cod_estado) references Estado_transaccion(Id_estado)
);

create table Tipo_modificacion(
	Id_tipo int identity(1,1) primary key,
	Descripcion varchar(30) not null,
);

create table Modificacion_cuenta(
	Id_modificacion int identity(1,1) primary key,
	Cod_tipo int not null,
	Cod_cuenta numeric(18) not null,
	Cod_transaccion int not null,
	foreign key (Cod_tipo) references Tipo_modificacion(Id_tipo),
	foreign key (Cod_cuenta) references Cuenta(Num_cuenta),
	foreign key (Cod_transaccion) references Transacciones(Id_transaccion)
);

create table Transferencias(
	Id_transferencia int identity(1,1) primary key,
	Importe float not null,
	Cod_cuenta_origen numeric(18) not null,
	Cod_cuenta_destino numeric(18) not null,
	Cod_transaccion int not null,
	foreign key (Cod_cuenta_origen) references Cuenta(Num_cuenta),
	foreign key (Cod_cuenta_destino) references Cuenta(Num_cuenta),
	foreign key (Cod_transaccion) references Transacciones(Id_transaccion)
);
	
create table Bancos(
	Id_banco int identity(1,1) primary key,
	Nombre_banco varchar(30) not null,
	Cod_pais int not null,
	foreign key (Cod_pais) references Pais(Id_pais)
);
create table Tarjeta_Emisor(           --Tabla de las emisoras de las tarjes american, visa etc
	Id_tarjeta_emisor int identity(1,1) primary key,
	Descripcion varchar(40)
);
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
);

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
);

create table Cheque(
	Id_cheque int identity(1,1) primary key,
	Num_cheque int not null,
	Cod_banco int not null,
	Cod_cliente int not null,
	Fecha date not null default getdate(),
	
	foreign key (Cod_banco) references Bancos(Id_banco),
	foreign key (Cod_cliente) references Cliente(Id_cliente)
);

create table Retiros (
	Id_retiro numeric(18) primary key,
	Cod_cuenta numeric(18) not null,
	Cod_cheque int not null,
	foreign key (Cod_cuenta) references Cuenta(Num_cuenta),
	Foreign key (Cod_cheque) references Cheque(Id_cheque)
);



	
Alter table Usuario
add Estado Varchar(20) not null;	
Alter table Transferencias
add Cod_moneda int not null;
Alter table Transferencias
add foreign key (Cod_moneda) references Moneda(Id_moneda);
ALTER TABLE Cheque
add Importe float not null;
Alter table Cheque 
add Cod_moneda int not null;
Alter table Cheque 
add foreign key (Cod_moneda) references Moneda(Id_moneda);




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

-----------------------------------------
alter table Pais alter column descripcion varchar(50);

alter table Usuario 
add Nro_Doc Numeric(8)


--Pais
insert into Pais
select * from (select distinct Cli_Pais_Codigo, Cli_Pais_Desc 
from gd_esquema.Maestra 
union
select distinct Cuenta_Dest_Pais_Codigo, Cuenta_Dest_Pais_Desc
from gd_esquema.Maestra
where Cli_Pais_Codigo is not null and Cuenta_Dest_Pais_Codigo is not null
)A

--Moneda
insert into Moneda(Descripcion,Conversion) values ('Dolar',1);

--Tipo de dni
insert into Tipo_DNI
select distinct Cli_Tipo_Doc_Cod, Cli_Tipo_Doc_Desc
from gd_esquema.Maestra

--Bancos
insert into Bancos(Nombre_banco,Cod_pais) values ((select distinct 
top 1 Banco_Nombre from gd_esquema.Maestra where Banco_Nombre is not null),8)
insert into Bancos(Nombre_banco,Cod_pais) values ((select distinct top 1 Banco_Nombre 
from gd_esquema.Maestra where Banco_Nombre is not null and Banco_Nombre like '%Nac%'),8)

--Categorias de cuentas
insert into Categoria (Descripcion,Costo) values ('oro',30)
insert into Categoria (Descripcion,Costo) values ('plata',20)
insert into Categoria (Descripcion,Costo) values ('bronce',10)
insert into Categoria (Descripcion,Costo) values ('gratuita',0)

--Tabla de Estados_Rol
insert into Estado_rol (Descripcion) values ('Activo')
insert into Estado_rol (Descripcion) values ('Inactivo')

--Tabla de roles
insert into Rol (Nombre_rol,Cod_estado) values ('Cliente',1)
insert into Rol (Nombre_rol,Cod_estado) values ('Administrador',1)

--Tabla de funcionalidades
insert into Funcionalidad (Descripcion) values ('ABM Usuarios')
insert into Funcionalidad (Descripcion) values ('ABM Clientes')
insert into Funcionalidad (Descripcion) values ('ABM Cuentas')
insert into Funcionalidad (Descripcion) values ('ABM Credit Card')
insert into Funcionalidad (Descripcion) values ('ABM Despositos')
insert into Funcionalidad (Descripcion) values ('ABM Retiros')
insert into Funcionalidad (Descripcion) values ('ABM Transferencias')
insert into Funcionalidad (Descripcion) values ('ABM Facturacion')
insert into Funcionalidad (Descripcion) values ('ABM Estadisticas')
insert into Funcionalidad (Descripcion) values ('ABM Consulta Saldo')

--Tabla Rol_Funcionalidades
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (1,2)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (2,2)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (3,2)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (3,1)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (4,1)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (5,1)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (6,1)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (7,1)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (8,1)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (8,2)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (9,2)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (10,2)
insert into Rol_funcionalidad(Cod_funcionalidad,Cod_rol) values (10,1)

--Tabla Tarjeta Emisor
insert into Tarjeta_Emisor (Descripcion)
select distinct Tarjeta_Emisor_Descripcion
from gd_esquema.Maestra
where Tarjeta_Emisor_Descripcion is not null;
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
Insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta,Estado) values(Rtrim (@nombre)+left(@apellido,1),Rtrim (@nombre)+left(@apellido,1),'nombre',@nombre,'habilitado')

Insert into Cliente(Cod_usuario,Nombre,Apellido,Tipo_documento,Numero_documento,Mail,Cod_pais,Calle,Numero,Piso,Depto,Fecha_nacimiento) values((Select MAX(Id_usuario)from Usuario),@nombre,@apellido,@cod_tipoDoc,@numDoc,@mail,@cod_pais,@calle,@numero,@piso,@dpto,@fnac)

fetch next from cursorCliente into @nombre,@apellido,@cod_tipoDoc,@numDoc,
@mail,@cod_pais,@calle,@numero,@piso,@dpto,@fnac
end
close cursorCliente
deallocate cursorCliente
commit



--Tabla de usuario_rol
insert into Usuario_rol (Cod_usuario,Cod_rol) (select Id_usuario,1 from Usuario);


--Tarjetas de credito
insert into Tarjetas_credito(Num_tarjeta,Cod_cliente,Cod_emisor,Fecha_emision,Fecha_vencimiento
,Cod_seguridad)
select distinct a.Tarjeta_Numero,b.Id_cliente,c.Id_tarjeta_emisor,a.Tarjeta_Fecha_Emision,
a.Tarjeta_Fecha_Vencimiento,a.Tarjeta_Codigo_Seg
from (gd_esquema.Maestra a inner join Cliente b on a.Cli_Nro_Doc=b.Numero_documento 
inner join Tarjeta_Emisor c on a.Tarjeta_Emisor_Descripcion=c.Descripcion) 


--Estado de cuentas
insert into Estado_cuenta(Descripcion) values ('Habilitada')
insert into Estado_cuenta(Descripcion) values ('Inahilitada')
insert into Estado_cuenta(Descripcion) values ('Pendiente')
insert into Estado_cuenta(Descripcion) values ('Cerrada')

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



Insert into Estado_transaccion(Descripcion) values ('Sin Facturar');
Insert into Estado_transaccion(Descripcion) values ('Facturado');
begin transaction
Declare cursorTransferencias Cursor 
for(
select Cuenta_Numero,Cuenta_Dest_Numero,Trans_Importe,Item_Factura_Importe,Transf_Fecha from gd_esquema.Maestra
where (Transf_Fecha is not null) and Item_Factura_Importe is not null)
Declare @CuentaOrigen1 numeric(18)
Declare @CuentaDestino1 numeric(18)
Declare @Importe1 float
Declare @Costo1 float
Declare @Fecha1 Date
Declare @IDTrans1 int
open cursorTransferencias
fetch next from cursorTransferencias into @CuentaOrigen1,@CuentaDestino1,@Importe1,@Costo1,@Fecha1
while @@FETCH_STATUS =0
begin
Insert into Transacciones values (1,@Costo1,@Fecha1)
select @IDTrans1=(Select MAX(Id_transaccion) from Transacciones)
Insert into Transferencias values(@Importe1,@CuentaOrigen1,@CuentaDestino1,@IDTrans1,1)
fetch next from cursorTransferencias into @CuentaOrigen1,@CuentaDestino1,@Importe1,@Costo1,@Fecha1
end;close cursorTransferencias Deallocate cursorTransferencias 
commit


Create Table Facturas(
	Num_factura numeric(18) primary key,
	Fecha_factura Date not null,
);

alter table Transacciones
add  cod_factura numeric(18);

alter table Transacciones
add foreign key (cod_factura) references Facturas(Num_factura);

insert into Facturas
select distinct Factura_Numero,Factura_Fecha from gd_esquema.Maestra
where Factura_Numero is not null;

--update Transacciones
--set cod_factura = (select m.Factura_Numero from gd_esquema.Maestra m join Transferencias t
--on (t.Cod_transaccion=Id_transaccion and t.Cod_cuenta_destino=m.Cuenta_Dest_Numero and t.Cod_cuenta_origen=m.Cuenta_Numero and m.Transf_Fecha=Fecha and m.Factura_Numero is not null))

