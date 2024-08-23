CREATE TABLE BloodAppointment(
	NIC varchar(12),
	locationName varchar(255),
	FW char(1),
	UWL char(1),
	RD char(1),
	SG char(1),
	appointmentDateTime smalldatetime
	PRIMARY KEY (NIC)
)
