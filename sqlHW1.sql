--Rodrigo Gil 

--a
	select org.NomOrg, c.nomcar
	from ORGANIZACIÓN org, Imparte I, Carrera c
	where org.idorg = i.idorg and c.idCar = i.idcar and c.área = 'Ingeniería'

--b
	SELECT  NomCon, NomT
	from Tesis t, GANÓ g, concurso c
	where t.idt = g.idt and c.idCon = g.idcon and extract(YEAR from c.fechaini) = extract(YEAR from sysdate) -1
	order by c.nomCon desc, t.nomT asc;
--c
	select org.nomorg, o.monto, extract(year from c.fechaini)
	from ORGANIZACIÓN org, ORGANIZÓ o, concurso c
	where org.idorg = o.idorg and c.idcon = o.idcon and org.idorg in
    		(SELECT  idorg
    		from ORGANIZÓ 
    		where o.monto >= 40000 
    		group by idorg)
	order by extract(year from c.fechaini) desc, o.monto desc;
--d
	select c.nomcar, org.nomorg
	from carrera c, imparte i, ORGANIZACIÓN org
	where org.tipo='esc' and org.idorg=i.idorg and i.idcar = c.idcar and c.nomcar like 'Lic%'
--e

	Select Nomcon, fechaIni
	from Concurso
	where idcon not in
    		(SELECT c.IdCon
    		from GANÓ g, concurso c, ESTUDIÓ e, ORGANIZACIÓN org
    		where org.nomorg != 'ITAM' and org.idorg = e.idorg and e.idt = g.idt and c.idcon = g.idcon)
	order by extract(Year from fechaIni) asc;

--f

select nomT, extract(year from c.fechaini)
from ORGANIZACIÓN org, ORGANIZÓ o, GANÓ g, tesis t, concurso c
where org.nomorg = 'BANAMEX' and org.idorg = o.idorg and o.idcon = g.idcon and g.idt = t.idt and c.idcon = o.idcon and extract(year from c.fechaini)=extract(year from SYSDATE)-1 and t.idT in 
(select t.idT
from ORGANIZACIÓN org, ORGANIZÓ o, GANÓ g, tesis t, concurso c
where org.nomorg = 'AMIME' and org.idorg = o.idorg and o.idcon = g.idcon and g.idt = t.idt and c.idcon = o.idcon and extract(year from c.fechaini)=extract(year from SYSDATE)-1) ;
--g

select noma , nomcar
from ESTUDIÓ e, GANÓ g, concurso c, Autor a, carrera ca, imparte i
where ca.idcar = i.idcar and i.idorg = e.idorg and e.ida = a.ida and e.idt = g.idt and g.idcon = c.idcon and extract(YEAR from c.fechaini)= extract(YEAR from SYSDATE) and a.ida in
    (select idA
    from  ESTUDIÓ e, GANÓ g, concurso c
    where  e.idt = g.idt and g.idcon = c.idcon and extract(YEAR from c.fechaini)= extract(YEAR from SYSDATE)-1)
order by noma;	

--h)

select noma 
from ESTUDIÓ e, Autor a, carrera ca, imparte i
where ca.área like 'Admi%' and ca.idcar = i.idcar and i.idorg = e.idorg and e.ida = a.ida union
    (select noma
    from  ESTUDIÓ e, GANÓ g, concurso c, autor a
    where  e.idA = a.ida and e.idt = g.idt and g.idcon = c.idcon and extract(YEAR from c.fechaini)= extract(YEAR from SYSDATE)-1)
order by noma;

--i
select NomOrg, extract(YEAR from c.fechaIni), COUNT(*)
from ORGANIZACIÓN org, ORGANIZÓ o, concurso c
where org.idorg = o.idorg and o.idcon = c.idcon and org.tipo='emp'
group by NomOrg, extract(YEAR from c.fechaIni)
--j

 select nomorg
 from ORGANIZACIÓN
 where idorg in 
    (select  e.idorg
    from  ESTUDIÓ e, GANÓ g
    where e.idt = g.idt
    group by e.idorg
    having COUNT(DISTINCT g.idcon)>2);

--k)

select nomcon, nomorg
from ORGANIZACIÓN org, concurso c, ORGANIZÓ o
where org.idorg = o.idorg and o.idcon = c.idcon and c.idcon in 
    (select idCon
    from ORGANIZÓ
    group by idcon
    having SUM(monto)>=100000)
order by nomcon asc, nomorg desc

--l

select a.noma
from ESTUDIÓ e, GANÓ g, concurso c, autor a
where  g.lugar =1 and e.idT = g.idt and g.idcon = c.idcon and a.ida = e.ida and c.idcon in
(select c.idcon
from ESTUDIÓ e, GANÓ g, concurso c, autor a
where extract(YEAR from c.fechaini) = extract(YEAR from SYSDATE)-1 and g.lugar =1 and e.idT = g.idt and g.idcon = c.idcon and a.ida = e.ida
group by c.idcon
having COUNT(c.idcon)<2)

--m

select nomorg
from ORGANIZACIÓN
where idorg in
(
select idorg
from ORGANIZÓ 
group by idorg
having COUNT(idcon)>= all(select COUNT(idcon)
                        from ORGANIZÓ
                         group by idorg));

--n

select nomcar
from carrera
where idcar in

(select ca.idcar
from carrera ca, imparte i, ESTUDIÓ e, GANÓ g
where ca.idcar = i.idcar and i.idorg = e.idorg and e.idt = g.idt 
group by ca.idcar
having COUNT(ca.idcar)=

(select MIN(count(ca.idcar))
from carrera ca, imparte i, ESTUDIÓ e, GANÓ g
where ca.idcar = i.idcar and i.idorg = e.idorg and e.idt = g.idt
group by ca.idcar))

--o

select nomT, nomA
from tesis t, ESTUDIÓ e, autor a
where t.idt=e.idt and e.ida = a.ida and t.idt in

(select idt
from GANÓ
group by idt
having COUNT(idt)=

(select max(COUNT (idt))
from GANÓ
group by idt));

--p

select o.idorg, nomorg
from ORGANIZÓ o, ORGANIZACIÓN org
where o.idorg = org.idorg
group by o.idorg, nomorg
having COUNT(o.idorg)=
    (select COUNT(*)
    from concurso)





