create table RoomType (
roomTypeID int not null,
roomTypeName varchar(45) not null unique,
constraint roomTypeID_pk primary key(roomTypeID));

create table Room (
roomID int not null,
roomName varchar(45) not null,
roomTypeID int not null,
constraint roomID_pk primary key(roomID),
constraint roomTypeID_fk foreign key(roomTypeID) references RoomType(RoomTypeID) on update cascade on delete restrict);

create table Payment (
paymentID int not null,
amount decimal(8, 2) not null,
paymentDateTime datetime not null,
paymentMethod varchar(45) not null,
slipImage varchar(255),
statusPayment boolean not null,
constraint paymentID primary key(paymentID));

ALTER TABLE Payment
change paymentMethod paymentTypeID int not null;

ALTER TABLE Payment
change amount price decimal(8, 2) not null;

create table PaymentType (
paymentTypeID int,
paymentTypeName varchar(45),
constraint paymentTypeID primary key(paymentTypeID));

ALTER TABLE PaymentType
change paymentTypeName paymentTypeName varchar(45) not null;

alter table Payment
add constraint paymentTypeID_fk foreign key(paymentTypeID) references paymentType(paymentTypeID) on update cascade on delete restrict;

create table Admin_shop (
adminID int not null,
taxID varchar(13) not null unique,
fname varchar(45) not null,
sname varchar(45) not null,
constraint adminID primary key(adminID));

ALTER TABLE Admin_shop
change TaxID taxID varchar(13) not null unique;
ALTER TABLE Admin_shop
change Fname fname varchar(45) not null;
ALTER TABLE Admin_shop
change Sname sname varchar(45) not null;

drop table Admin_shop;

create table Employee (
employeeID int not null,
fname varchar(45) not null,
sname varchar(45) not null,
phone varchar(10) not null,
positoin varchar(45) not null,
salary decimal(8, 2) not null,
adminID int not null,
constraint employeeID_pk primary key(employeeID),
constraint adminID_fk foreign key(adminID) references Admin_shop(adminID) on update cascade on delete restrict);

ALTER TABLE Employee
change positoin positionID varchar(45) not null;

ALTER TABLE Employee
change positionID positionID int not null;

create table Service (
serviceID int not null,
serviceName varchar(70) not null,
serviceDetail text,
price decimal(6, 2) not null, 
constraint serviceID_pk primary key(serviceID));


create table Employee_service (
dateTime_Service datetime not null,
employeeID int not null,
serviceID int not null,
constraint employeeID_fk foreign key(employeeID) references Employee(employeeID) on update cascade on delete restrict,
constraint serviceID_fk foreign key(serviceID) references Service(serviceID) on update cascade on delete restrict,
primary key(employeeID, serviceID, dateTime_Service));

ALTER TABLE Employee_service
ADD PRIMARY KEY (dateTime_Service);

drop table Employee_service;

create table Customer (
customerID int not null,
fname varchar(45) not null,
sname varchar(45) not null,
phone varchar(10) not null unique,
address varchar(255),
constraint customerID_pk primary key(customerID));

create table Pet (
petID int not null,
petName varchar(45) not null,
age int not null,
species varchar(45) not null,
breed varchar(45) not null,
gender varchar(45) not null,
customerID int not null,
constraint petID_pk primary key(petID),
constraint customerID_fk foreign key(customerID) references Customer(customerID) on update cascade on delete restrict);

create table HealthInfo (
healthID int not null,
petID int not null,
constraint healthID_pk primary key(healthID),
constraint petID_fk foreign key(petID) references Pet(petID) on update cascade on delete cascade);

create table Allergy (
allergyID int not null,
allergyName varchar(100) not null,
constraint allergyID_pk primary key(allergyID));

create table Disease (
diseaseID int not null,
diseaseName varchar(100) not null,
constraint diseaseID_pk primary key(diseaseID));

create table Vaccine (
vaccineID int not null,
vaccineName varchar(100) not null,
constraint vaccineID_pk primary key(vaccineID));

create table Health_allergy (
allergyID int not null,
healthID int not null,
constraint allergyID_fk foreign key(allergyID) references Allergy(allergyID),
constraint health_allergyID_fk foreign key(healthID) references HealthInfo(healthID) on update cascade on delete cascade,
primary key(allergyID, healthID));

drop table Health_allergy;

create table Health_disease (
diseaseID int not null,
healthID int not null,
constraint diseaseID_fk foreign key(diseaseID) references Disease(diseaseID),
constraint health_diseaseID_fk foreign key(healthID) references HealthInfo(healthID) on update cascade on delete cascade,
primary key(diseaseID, healthID));

create table Health_vaccine (
vaccineID int not null,
healthID int not null,
constraint vaccineID_fk foreign key(vaccineID) references Vaccine(vaccineID),
constraint health_vaccineID_fk foreign key(healthID) references HealthInfo(healthID) on update cascade on delete cascade,
primary key(vaccineID, healthID));

create table Operation (
operationID int not null,
checkInDateTime datetime not null,
checkOutDateTime datetime,
roomID int not null,
petID int not null,
constraint operationID_pk primary key(operationID),
constraint op_roomID_fk foreign key(roomID) references Room(roomID) on update cascade on delete restrict,
constraint op_petID_fk foreign key(petID) references Pet(petID) on update cascade on delete restrict);

alter table Operation
add column employeeID int not null,
add constraint empID_op_fk foreign key(employeeID) references Employee(employeeID);

alter table Payment
add column operationID int not null;
alter table Payment
add constraint operationID_fk foreign key(operationID) references Operation(operationID) on update cascade on delete restrict;

alter table payment
add constraint operationID_fk unique (operationID);

create table Operation_service (
operationID int not null,
serviceID int not null,
quantity int not null,
status_op_service boolean not null,
serviceDateTime datetime not null,
primary key (operationID, serviceID),
constraint OpService_Operation_fk foreign key(operationID) references Operation(operationID) on update cascade on delete cascade,
constraint OpService_Service_fk foreign key(serviceID) references Service(serviceID) on update cascade on delete restrict);

drop table Operation_service;

create table review (
reviewID int not null,
rating double not null,
commentReview text not null,
reviewDateTime datetime not null,
customerID int not null,
operationID int not null,
constraint review_op_fk foreign key(operationID) references Operation(operationID) on update cascade on delete cascade,
constraint review_customer_fk foreign key(customerID) references Customer(customerID) on update cascade on delete cascade,
constraint review_rating check(rating between 1 and 5),
constraint reviewID_pk primary key(reviewID));

drop table employee_service;

alter table Operation_service
add column employeeID int not null;

alter table Operation_service
add constraint empID_op_service_fk foreign key(employeeID) references employee(employeeID) on update cascade on delete restrict;

alter table Operation drop foreign key empID_op_fk;

alter table Operation
add constraint empID_op_fk foreign key(employeeID) references Employee(employeeID) on update cascade on delete restrict;

create table Positions (
positionID int,
positionName varchar(45) not null,
constraint positionID_pk primary key(positionID));

ALTER TABLE Positions
change positionName positionName varchar(45) not null;

alter table employee
add constraint positionID_fk foreign key(positionID) references Positions(positionID) on update cascade on delete restrict;

alter table RoomType
add column price decimal(5,2) not null;

alter table RoomType
drop column price;

drop table health_allergy;
drop table health_disease;
drop table health_vaccine;
drop table allergy;
drop table disease;
drop table vaccine;
drop table HealthInfo;

alter table employee drop foreign key adminID_fk;
alter table employee drop column adminID;
alter table employee add column taxID varchar(13);
alter table employee drop column taxID;

drop table admin_shop;

alter table positions add column taxID varchar(13);
alter table positions drop column taxID;

alter table review drop foreign key review_customer_fk;
alter table review drop column customerID;
