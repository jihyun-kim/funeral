CREATE TABLE tb_master (
   room_no		integer   PRIMARY KEY NOT NULL,
   dname		char(12),
   sname		char(100),
   pname		char(20),
   balin		char(20),
   trans		integer		default  0,
   jangji		char(50)
   );
