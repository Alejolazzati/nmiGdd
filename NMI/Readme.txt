Curso: K3013
Número de grupo: 53 Grupo: NMI
Integrantes:
1. Nombre: Basile Martin	Legajo: 149414-4
2. Nombre: Lazzati Alejo	Legajo: 149599-9
3. Nombre: Bec Martin		Legajo: 146693-8
4. Nombre: Perez Federico	Legajo: 147364-5
Email responsable: martinnbasile@gmail.com


--------------------------------
create procedure NMI.clietesMasFacturas 
@anio char(4), @trimestre int
as
begin 
declare @mesdiadesde char(4)
declare @mesdiahasta char(4)

if @trimestre=1
begin
set @mesdiadesde='0101'
set @mesdiahasta='0331'
end
if @trimestre=2
begin
set @mesdiadesde='0401'
set @mesdiahasta='0630'
end
if @trimestre=3
begin
set @mesdiadesde='0701'
set @mesdiahasta='0930'
end
if @trimestre=4
begin
set @mesdiadesde='1001'
set @mesdiahasta='1231'
end
select top 5 sum(a.Costo),d.Nombre,d.Apellido 
from (select costo, Id_transaccion from NMI.Transacciones 
where Fecha between @anio+@mesdiadesde and @anio+@mesdiahasta) a 
inner join NMI.Transferencias b
on a.Id_transaccion=b.Cod_transaccion
inner join NMi.Cuenta c on b.Cod_cuenta_origen=c.Num_cuenta
inner join NMI.cliente d on c.Codigo_cliente=d.Id_cliente 
group by d.Nombre,d.Apellido
order by 1 desc
end
