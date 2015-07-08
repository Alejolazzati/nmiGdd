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
costo float
)

As
Begin
	insert into @tablita
	select *
	from categoria
	
	return
end
go 

create procedure modificarProcedure (@cuenta numeric (18), @nuevaCategoria int, @duracion int)
as
begin
	begin transaction
	update Cuenta
	set cuenta.Codigo_categoria=@nuevaCategoria,
		cuenta.Fecha_cierre=GETDATE()+@duracion
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