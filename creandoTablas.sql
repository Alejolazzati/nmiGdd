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

Create Table Cliente(
Id_cliente int identity(1,1) primary key,
Cod_usuario int not null,
Nombre varchar (30) not null,
Apellido varchar(30) not null,
Tipo_documento int not null,
Numero_documento int not null,
Mail varchar(30) not null,
Cod_pais int not null,
Localidad int not null,
Calle varchar(30) not null,
Numero int not null,
Piso smallint,
Depto char,
Fecha_nacimiento date not null,
unique (Tipo_documento,Numero_Documento),
unique (mail),
foreign key (Cod_pais) references Pais(Id_pais),
foreign key (Cod_usuario) references Usuario(Id_usuario),
foreign key (Localidad) references Localidad(Id_localidad)
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
	Num_cuenta numeric(8) identity(11111111,1) primary key, -- modificacion del identity
	Fecha_apertura date not null default getdate(),
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
	Cod_cuenta int not null,
	Cod_transaccion int not null,
	foreign key (Cod_tipo) references Tipo_modificacion(Id_tipo),
	foreign key (Cod_cuenta) references Cuenta(Num_cuenta),
	foreign key (Cod_transaccion) references Transacciones(Id_transaccion)
);

create table Transferencias(
	Id_transferencia int identity(1,1) primary key,
	Importe float not null,
	Cod_cuenta_origen int not null,
	Cod_cuenta_destino int not null,
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

create table Tarjetas_credito(
	Num_tarjeta int primary key,
	Cod_cliente int not null,
	Cod_emisor int not null,
	Fecha_emision date not null,
	Fecha_vencimiento date not null,
	Cod_seguridad int,
	foreign key (Cod_cliente) references Cliente(Id_cliente),
	foreign key (Cod_emisor) references Tarjeta_Emisor(Id_Tarjeta_Emisor)
);

create table Depositos(
	Id_deposito int primary key,
	Cod_cuenta int not null,
	Cod_moneda int not null,
	Importe float not null,
	Cod_TC int not null,
	check(Importe>1),
	foreign key (Cod_cuenta) references Cuenta(Num_cuenta),
	foreign key (Cod_moneda) references Moneda(Id_moneda),
	foreign key (Cod_TC) references Tarjetas_credito(Num_tarjeta)
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
	Id_retiro int primary key,
	Cod_cuenta int not null,
	Cod_cheque int not null,
	foreign key (Cod_cuenta) references Cuenta(Num_cuenta),
	Foreign key (Cod_cheque) references Cheque(Id_cheque)
);


create table Tarjeta_Emisor(           --Tabla de las emisoras de las tarjes american, visa etc
	Id_tarjeta_Emisor int identity(1,1) primary key,
	Descripcion varchar(40)
);
	
	
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
Alter table Cheque add check(Importe>=1);

-----------------------------------------
alter table Pais alter column descripcion varchar(50);

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
insert into Bancos(Id_banco,Nombre_banco,Cod_pais) values ((select distinct 
top 1 Banco_Nombre from gd_esquema.Maestra where Banco_Nombre is not null),8)
insert into Bancos(Id_banco,Nombre_banco,Cod_pais) values ((select distinct top 1 Banco_Nombre 
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

--Tabla de usuarios
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LuceroA','LuceroA','Nombre de la madre','Julia')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('TesiraA','TesiraA','Nombre del padre','Roberto')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('BraulioA','BraulioA','Nombre del tio','Juan')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('HeliosA','HeliosA','Nombre de la hermana','Carla')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('KarelA','KarelA','Nombre del hermano','Ricardo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CrisolinoA','CrisolinoA','Ciudad de nacimiento','Ribera')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('SoledadA','SoledadA','Figura favorita','Figurita chiquitita')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('SamaiA','SamaiA','Nombre abuela','Mirtha')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('VladimirA','VladimirA','Nombre del perro','Tito')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('NarellaB','NarellaB','Nombre del gato','Felipe')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('YokebedB','YokebedB','Nombre hermano','Julian')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GianB','GianB','Nombre tio','Carloncho')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('Francisco deC','FranciscodeC','Deporte favorito','Squash')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LicanC','LicanC','Nombre del hermanastro','Malvado Gutierrez')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('BelindaC','BelindaC','Ciudad de nacimiento','La boca del rio')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MatildaC','MatildaC','Tio muerto en accidente','Juan Carlos')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MireyaC','MireyaC','Hermana linda','Estanisla')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('NefferC','NefferC','Ciudad de nacimiento','Kisjoff')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ValeriaC','ValeriaC','Cumpleaños del tio','4 de Abril')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GiovanniC','GiovanniC','Nombre de hermanastra','Josefina')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LahuenC','LahuenC','Nombre del tio','Federico Perez')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CesiaC','CesiaC','Color favorito','Rojo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AyumiC','AyumiC','Color favorito','Azul')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LeonidasC','LeonidasC','Color favorito','Verde')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('StabrosC','StabrosC','Color favorito','Violeta')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AlejoC','AlejoC','Color favorito','Blanco')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ArgimiroC','ArgimiroC','Color favorito','Negro')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('JesusC','JesusC','Color favorito','Marron')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CarlaC','CarlaC','Color favorito','Naranja')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('IlvaC','IlvaC','Nombre del hermano','Juan Cruz')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('EmilianaD','EmilianaD','Nombre del tio','Roberto')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('FortunaD','FortunaD','Hijo mayor','Martin')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('IndraD','IndraD','Hijo menor','Santiago')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('VidaD','VidaD','Hija mayor','Jimena')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AgataD','AgataD','Hija menor','Fiorella')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ValeriaD','ValeriaD','Hijo del medio','Facundo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('HilariaE','HilariaE','Hija del medio','Santina')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LoretoE','LoretoE','Ciudad de nacimiento','Pigue')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('FiammaF','FiammaF','Nombre del abuelo','Hernan')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('NancyF','NancyF','Comida favorita','Fideos')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AlejandroF','AlejandroF','Comida favorita','Asado')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LaicoF','LaicoF','Comida favorita','Mondongo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('PaulinaF','PaulinaF','Primera novia','Laura')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('BartoloF','BartoloF','Primera novia','Sabrina')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('RyanF','RyanF','Primer auto','Gol')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('KeylaF','KeylaF','Primera vez','Gonzalo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ZulmaF','ZulmaF','Gusto musical','Rock')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AlenkaG','AlenkaG','Gusto musical','Pop')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('Janko janoG','JankoJanoG','Gusto musical','Reguuea')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('JesusG','JesusG','Gusto musical','Rock & Pop')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LaureanoG','LaureanoG','Color favorito','Amarillo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('EvangelinoG','EvangelinoG','Nombre madre','Carlita')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('JeremiG','JeremiG','Nombre abuela','Catalina')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GenovesaG','GenovesaG','Nombre perro','Cachi')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AnastasiaG','AnastasiaG','Nombre gato','Kiki')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MaiteG','MaiteG','Nombre tio','Cachito')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ClemaG','ClemaG','Boliche Favorito','Kika')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('DolfinaG','DolfinaG','Boliche favorito','Apple')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('VitoldoG','VitoldoG','Boliche favorito','Larc')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('BenildeG','BenildeG','Materia favorita','Matematica')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('EliG','EliG','Jugador Favorito','JRR')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ArchibaldoH','ArchibaldoH','Club favorito','Boca')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ElianaH','ElianaH','Club favorito','Riber')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('HanadiH','HanadiH','Club favorito','Ferro')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('HernanH','HernanH','club favorito','All Boys')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MagnoliaH','MagnoliaH','Club favorito','Lanus')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MohamedH','MohamedH','Club favorito','Racing')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('SoteroH','SoteroH','Club favorito','Independiente')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CoraH','CoraH','Club favorito','Casla')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('IñakiH','IñakiH','Club favorito','Huracan')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LaloH','LaloH','Club favorito','Banfield')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('NoraL','NoraL','Club favorito','Estudiantes')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('UbaldoL','UbaldoL','Club favorito','Gimnasia')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('EmanuelL','EmanuelL','Club favorito','Ñewells')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ExaltacionL','ExaltacionL','Club favorito','Rosario')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MinnaL','MinnaL','Club favorito','Defensa')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MyriamL','MyriamL','Club favorito','Belgrano')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('FrancineL','FrancineL','Club favorito','Union')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CaioM','CaioM','Club favorito','Aldosivi')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('JeremiM','JeremiM','Club favorito','Los andes')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('DulceM','DulceM','Club favorito','Alvarado')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('Facundo falkoM','FacundoFalkoM','Club favorito','Boca unidos')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CatuloM','CatuloM','Club favorito','Yupanki')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MarisabelM','MarisabelM','Club favorito','Riestra')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('SoniaM','SoniaM','Club favorito','Quilmes')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('DalmiroM','DalmiroM','Cerveza favorita','Quilmes')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MarlemM','MarlemM','Cerveza favorita','Heineken')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AntoninoM','AntoninoM','Cerveza favorita','Guinees')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('PuelM','PuelM','Cerveza favorita','Isenbeck')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AmaremaM','AmaremaM','Cerveza favorita','Cristal')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('JavierM','JavierM','Cerveza favorita','Palermo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('YamileM','YamileM','Cerveza favorita','Santiaguers')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('SabinoM','SabinoM','Tenista favorita','Gaudio')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('BelisaN','BelisaN','Tenista favorito','Federer')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ElvisN','ElvisN','Tenista favorito','Nadal')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ThelmaN','ThelmaN','Tenista favorito','Gasquet')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('OlindaN','OlindaN','Tenista favorito','Morris')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CesiaO','CesiaO','Futbolista favorito','JRR')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GautamaO','GautamaO','Futbolista favorito','Ortega')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('JulianaO','JulianaO','Futbolista favorito','Messi')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AndinaO','AndinaO','Futbolista favorito','Cristiano')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CecilioO','CecilioO','Futbolista favorito','Tevez')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('OnofreO','OnofreO','Futbolista favorito','Aguero')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('KaylaO','KaylaO','Futbolista favorito','Calleri')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('TabareP','TabareP','Futbolista favorito','Orion')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('StephanoP','StephanoP','Futbolista favorito','Perez')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('KumenP','KumenP','Futbolista favorito','Baez')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('UxueP','UxueP','Futbolista favorito','Lopez')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('HermenegildoP','HermenegildoP','Futbolista favorito','Koris')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('TelmoP','TelmoP','Futbolista favorito','Jueres')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CleopatraP','CleopatraP','Futbolista favorito','Funes Mori')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GalaP','GalaP','Futbolista favorito','Rogelio')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LolaP','LolaP','Futbolista favorito','Kuz')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('JovP','JovP','Futbolista favorito','Gallardo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('InmaculadaP','InmaculadaP','Jugador favorito','Maradona')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CorazonP','CorazonP','Jugador favorito','Pele')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('Danisa daraR','DanisaDaraR','Postre favorito','Danette')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('HuilenR','HuilenR','Postre favorito','Vainilla')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('Josemaria josephR','JosemariaJosephR','Postre favorito','Chocolate')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('FlorealR','FlorealR','Postre favorito','Americana')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('EfrainR','EfrainR','Postre favorito','Volcan')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AienR','AienR','Postre favorito','Helado')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AonikenkR','AonikenkR','Postre favorito','Lemon pie')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MirkoR','MirkoR','Postre favorito','Cheesecake')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('RosendoR','RosendoR','Postre favorito','CarCan')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('SocorroR','SocorroR','Deporte favorito','Futbol')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AyeshaR','AyhesaR','Deporte favorito','Handball')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('CristabelR','CristabelR','Deporte favorito','Basquet')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ElianaR','ElianaR','Deporte favorito','Cestoball')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ElliotR','ElliotR','Deporte favorito','Baseball')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GerominaR','GerominaR','Deporte favorito','Natacion')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GuiladR','GuiladR','Deporte favorito','Musculacion')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('OlivaR','OlivaR','Deporte favorito','Voley')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('NimaiR','NimaiR','Deporte favorito','Beach voley')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('Raul raulinoR','RaulRaulino','Deporte favorito','Beach soccer')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('De las nievesS','DelasnievesS','Carrera','Medico')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('HelviaS','HelviaS','Carrera','Ing en sistemas')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('KalemS','KalemS','Carrera','Matematico')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('EmilS','EmilS','Carrera','Literatura')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('DivinaS','DivinaS','Carrera','Lengua')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('FaraonS','FaraonS','Carrera','Programador')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GuiomarS','GuiomarS','Carrera','Instrumentador')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('IaelS','IaelS','Carrera','Profesor de musica')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('IntiS','IntiS','Carrera','Profesor de biologia')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('RaiquenS','RaiquenS','Carrera','Biologo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('DulceS','DulceS','Carrera','Fisica')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('LailaS','LailaS','Carrera','Quimica')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('ShantiS','ShantiS','Carrera','Fisica-Quimica')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('IdiraS','IdiraS','Carrera','Preparador fisico')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('Del rosarioT','DelrosarioT','Carrera','Director tecnica')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('IsmeniaT','IsmentiaT','Carrera','Profesor de violonchelo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GonzaloT','GonzaloT','Carrera','Profesor de guitarra')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('FlorentinaT','FlorentinaT','Carrera','Profesor de handaball')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('HernandoT','HernandoT','Carrera','Profesor de futbol')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('JackT','JackT','Carrera','Abogado')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('SibilaT','SibilaT','Carrera','Periodista')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('BrigidaV','BrigidaV','Carrera','Periodista deportivo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('GianV','GianV','Carrera','Administrador de empresas')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('BrunildaV','BrunildaV','Carrera','Profesora de gimnasia')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('DelV','DelrosarioV','Carrera','Profesora de hockey')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('VictorinaV','VictorinaV','Carrera','Profesora de meditacion')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('EliaV','EliaV','Carrera','Catequista')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('AmbrosioV','AmbrosioV','Carrera','Kinesiolo')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('TrinidadV','TrinidadV','Carrera','Sociologa')
insert into Usuario(Useranme,Contraseña,Pregunta_secreta,Respuesta) values ('MichelleY','MichelleY','Carrera','Psicologa')

--Tabla de usuario_rol
insert into Usuario_rol (Cod_usuario,Cod_rol) (select Id_usuario,1 from Usuario);
