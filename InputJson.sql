use SqlAssign;

create procedure spInputJson
@json varchar(max)
as
begin

insert into JoinQuery.Employee(FirstName,LastName)
select FirstName,LastName from openjson(@json) 
with (FirstName varchar(50) '$.fName',LastName varchar(50) '$.lName')as jsonValues 
end

exec spInputJson @json ='{"fName":"Aditya","lName":"Tiwari"}'