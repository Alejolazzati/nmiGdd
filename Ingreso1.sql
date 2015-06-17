
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

go