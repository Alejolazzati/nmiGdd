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
select  Cuenta.Num_cuenta from Cuenta,Cliente
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