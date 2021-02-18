--a

--funcion
create or replace function cuantosArea(Area char) return real is
 cuantos real;
begin
 select count(*) into cuantos
 from Carrera c,   Estudi� e, Gan� g
 where c.�rea = Area and c.idcar = e.idCar and e.idT=g.idT ;
  
 return cuantos;
 
end;

--ejecuci�n

begin
 dbms_output.put('numero de concursantes del �rea de Ingenier�a: ');
 dbms_output.put_line(cuantosArea('Ingenier�a'));
end; 

--b

create or replace 
procedure encuentraAreas(mayor out varchar, menor out varchar) is
i int;
n int;
t varchar(30);
begin

select count(distinct �rea) into n
from Carrera;

select Distinct (�rea) into t
from Carrera
where rownum =1
order by �rea desc;


mayor:=t;
menor:=t;

FOR counter IN 1..n LOOP


SELECT �rea into t from (SELECT �rea, ROWNUM AS RN from (SELECT DISTINCT(�rea) FROM carrera ORDER BY �REA)) WHERE RN = counter;


if(cuantosArea(t)>cuantosArea(mayor)) then
mayor:=t;
end if;

if(cuantosArea(t)<cuantosArea(menor)) then
menor:=t;
end if;

end loop;


end;

--ejecuci�n--

declare
 area1 varchar(30); area2 varchar(30);
begin
  
 encuentraAreas(area1,area2);
 dbms_output.put_line(area1 || area2);


end; 

--c

create or replace 
procedure altaTuplaOrganiz�(organizaci�n char, concurso char, monto number) is
 org int; con int;
begin
 select idorg into org
 from organizaci�n
 where nomOrg=organizaci�n;
 
 select idcon into con
 from concurso
 where nomCon = concurso;
 --inserta valores
 INSERT INTO ORGANIZ� values (org,con,monto);
 dbms_output.put_line('Se dio de alta la tupla con valores: ' || org|| ', '|| con ||' , ' ||monto);
 
end; 

--ejecuci�n

begin
  ALTATUPLAORGANIZ�('IPN', 'AMIME 19', 1000);
end;

--d

create or replace 
function organizantesDosA(primero int, segundo int) return char is
resp char(20);
 cursor uno is select idorg
 from Concurso c, Organiz� o
 where extract(year from c.fechaIni)=primero and c.idcon= o.idcon
 intersect
 select idorg
 from Concurso c, Organiz� o
 where extract(year from c.fechaIni)=segundo and c.idcon= o.idcon;
 cursor dos is select idorg
 from Concurso c, Organiz� o
 where extract(year from c.fechaIni)=primero and c.idcon= o.idcon;

 orgP int;
begin

 open uno;
 open dos;

 
if(uno%rowcount < dos%rowcount) then
 resp:= 'S�';
else resp:= 'No';
end if;
 
close uno;
close dos;

return resp;

end; 
--ejecuci�n

begin
dbms_output.put_line('�organizaciones 2018-2019?' || organizantesDosA(2018,2019));
end;

--e

create or replace trigger CambiaClaveTesis
 before update on Tesis
 for each row
 begin
 update Estudi� e set e.IdT= :new.IdT
 where e.IdT= :old.IdT;
  update Gan� g set g.IdT= :new.IdT
 where g.IdT= :old.IdT;
 dbms_output.put('Tambi�n se cambi� en Estudi� y en Gan� la clave anterior de la Tesis. ');
 dbms_output.put_line(:old.IdT || ' por su nueva clave: ' || :new.IdT);
 end;


--ejecuci�n

update Tesis t set t.idt=299
where t.idT=251;

--f

--1
create or replace 
trigger CambiaClaveOrg
 before update on Organizaci�n
 for each row
 begin

  update organiz� o set o.IdOrg= :new.IdOrg
 where o.IdOrg= :old.IdOrg;

  update Empresa em set em.IdOrg= :new.Idorg
  where em.IdOrg= :old.IdOrg;
  
    update Escuela es set es.IdOrg= :new.IdOrg
  where es.IdOrg= :old.IdOrg;

 dbms_output.put('Tambi�n se cambi� en Estudi�, Escuela e imparte o empresa, organiz�,  la clave anterior de la Oraganizaci�n. ');
 dbms_output.put_line(:old.IdOrg || ' por su nueva clave: ' || :new.IdOrg);
 end;

--2

create or replace 
trigger CambiaClaveOrg2
 before update on Escuela
 for each row
 begin
update Imparte i set i.idOrg = :new.IdOrg
  where i.IdOrg= :old.IdOrg;
 end;

--3

create or replace 
trigger CambiaClaveOrg3
 before update on Imparte
 for each row
 begin
update Estudi� e set e.IdOrg= :new.IdOrg
 where e.IdOrg= :old.IdOrg;
 end;

--ejecuci�n

update ORGANIZACI�N o set o.idorg=169
where o.idorg=150;



--g

create or replace trigger updateOrg
after Insert on Organiz�
declare cursor coso is select nomOrg, SUM(monto) as suma
from organizaci�n org, organiz� o
where org.idorg = o.idorg
group by nomOrg;

begin

for tupla in coso loop
dbms_output.put_line(tupla.nomOrg || ' ha aportado '||tupla.suma);

end loop;

end;

--ejecucion:

insert into organiz� values (150, 105, 69);


--h /4f

--requisito

create or replace function cantMatersAlum(nombre char) return integer is
  cantMaters integer;
begin
  select count(*) into cantMaters
  from Alum a, Inscrito i
  where Nomal=nombre and a.CU=i.CU;
  return cantMaters;
end;

--
 
create or replace procedure matCantAls(nom1 char, nom2 char, num out int) is
 cant int;
 cursor c1 is select nomMat
 from Alum a, Inscrito i, grupo g, mater m
 where a.nomal=nom1 and a.cu=i.cu and i.claveG =g.claveG and g.claveM = m.claveM
 order by nomMat asc;
  cursor c2 is select nomMat
 from Alum a, Inscrito i, grupo g, mater m
 where a.nomal=nom2 and a.cu=i.cu and i.claveG =g.claveG and g.claveM = m.claveM
 order by nomMat asc;
  flag boolean;
  mat1 char(20);
  mat2 char(20);
begin
flag:=true;
if(cantMatersAlum(nom1)=0 and cantMatersAlum(nom2)=0) then
    num:= 2;
  else 
    open c1;
    open c2;
    if(c1%rowcount = c2%rowcount) then

      loop 

        exit when c1%notfound or flag=false;

          fetch c1 into mat1;
          fetch c2 into mat2;

          if(mat1 != mat2) then
            flag:=false;
          end if;

      end loop;
      
      if(flag=false) then
        num:=0;
      else
        num:=1;
      end if;

    else
      num:=0;
    end if;
end if;


end; 








	