CREATE TABLE DonorID(
	NIC varchar(12),
	FullName varchar(255),
	Email varchar(255),
	DOB date,
	Sex char(1),
	Password varchar(60),
	ABO varchar(2),
	RHD char(1),
	AddressLine1 varchar(255),
	AddressLine2 varchar(255),
	AddressLine3 varchar(255),
	MobileNo int,
	DonateFreq tinyint,
	WishToBeContacted char(1),
	PRIMARY KEY (NIC)
)
