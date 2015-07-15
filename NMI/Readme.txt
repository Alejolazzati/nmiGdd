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
select top 5 d.Nombre,d.Apellido 
from (select costo, Id_transaccion from NMI.Transacciones 
where Fecha between @anio+@mesdiadesde and @anio+@mesdiahasta) a 
inner join NMI.Transferencias b
on a.Id_transaccion=b.Cod_transaccion
inner join NMi.Cuenta c on b.Cod_cuenta_origen=c.Num_cuenta
inner join NMI.cliente d on c.Codigo_cliente=d.Id_cliente 
group by d.Nombre,d.Apellido
order by sum(a.Costo) desc
end
-----------------

create procedure NMI.PaisesMasMov 
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
select top 5 l.Descripcion from 
(select MovCuentas.B, sum (MovCuentas.A) k from (select Cod_cuenta_origen B,COUNT(Cod_cuenta_origen) A
from NMI.transferencias e inner join NMI.Transacciones g
on e.Id_transferencia=g.Id_transaccion where 
Fecha between @anio+@mesdiadesde and @anio+@mesdiahasta
group by Cod_cuenta_origen
UNION ALL
select Cod_cuenta_destino B,COUNT(cod_cuenta_destino) A
from NMI.transferencias 
group by Cod_cuenta_destino ) MovCuentas
group by MovCuentas.B ) Z inner join nmi.Cuenta Y on z.b=y.num_cuenta
inner join NMI.Pais l on y.Codigo_pais=l.Id_Pais
group by l.Descripcion
order by sum(z.k)  desc 
end

---------------------------

create procedure NMI.SaldoPorFacturas 
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
select top 5 Cod_cuenta_origen from
nmi.Transferencias a inner join nmi.Transacciones b on
a.Cod_transaccion=b.Id_transaccion where Fecha
between @anio+@mesdiadesde and @anio+@mesdiahasta
group by Cod_cuenta_origen
order by SUM(importe) desc
end
