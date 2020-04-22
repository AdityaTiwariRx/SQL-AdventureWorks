After Insert:

CREATE TRIGGER tr_EmployeeForInsert
on Employee
FOR INSERT 
AS
BEGIN
      Declare @Id int
	  Select @Id =Id from inserted

	  insert into EmployeeAud
	  values ('New Emp Id = '+ cast(@Id as nvarchar(5))+
	  ' is added at' + cast(getdate() as nvarchar(20))
	  )
END
-------------------------------------------------------------------
After Delete:

CREATE TRIGGER tr_EmployeeForDelete
on Employee
FOR DELETE
AS
BEGIN
      Declare @Id int
	  Select @Id =Id from deleted

	  insert into EmployeeAud
	  values ('Existing Emp Id = '+ cast(@Id as nvarchar(5))+
	  ' is deleted at' + cast(getdate() as nvarchar(20))
	  )
END
------------------------------------------------------------------
After Update:

CREATE TRIGGER tr_EmployeeForUpdate
on Employee
FOR Update
AS
BEGIN
      DECLARE @Id int
      DECLARE @OldName nvarchar(20), @NewName nvarchar(20)
      DECLARE @OldGender nvarchar(20), @NewGender nvarchar(20)
      DECLARE @OldDeptId int, @NewDeptId int
      
      DECLARE @AuditString nvarchar(1000)

      select *
      into #TempTable from inserted

     While(Exists(select Id from #TempTable))

     Begin
           set @AuditString= ''
           Select Top 1 @Id=Id, @NewName=Name,
           @NewGender=Gender, @NewDeptId=DepartmentId
           from #TempTable

           Select @OldName=Name, @OldGender=Gender,
           @OldDeptId=DepartmentId
           from deleted where Id=@Id

           set @AuditString ='Employee Id = '+ Cast(@Id as nvarchar(4)) + ' changed '
           if(@OldName<>@NewName)
                set @AuditString=@AuditString + 'NAME from' + @OldName +' to '+@NewName

            set @AuditString ='Employee Id = '+ Cast(@Id as nvarchar(4)) + ' changed '
           if(@OldGender<>@NewGender)
                set @AuditString=@AuditString + 'Gender from' + @OldGender +' to '+@NewGender

           insert into EmployeeAud values(@AuditString)

           Delete from #TempTable where Id=@Id

      END
END
--------------------------------------------------------------------------------------------
Instead Of Insert:

CREATE TRIGGER tr_vEmployeeDetails_IoI
on vEmployeeDetails
Instead of insert
as
Begin
      Declare @DeptId int

      select @DeptId=DeptId
      from Department
      join inserted.DeptName=Department.DeptName

      if(@DeptId is null)
      Begin
           Print 'Invalid Dept Name ' 
           Return
      End

      Insert into Employee(Id,Name,Gender,DepartmentId)
      select Id,Name,Gender,@DeptId
      from inserted
End
------------------------------------------------------------
Instead of Delete:

CREATE TRIGGER tr_vEmployeeDetails_Iod
on vEmployeeDetails
Instead of delete
as
Begin
     Delete Employee
     from Employee
     join deleted
      on Employee.Id=deleted.Id
End

Delete from vEmployeeDetails where Id In (1,2)
------------------------------------------------------
           