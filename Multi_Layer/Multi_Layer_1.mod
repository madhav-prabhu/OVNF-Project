param I > 0;  #core nodes
param J > 0;  #access nodes
param K1 > 0;  #no of VNFs
param K2 > 0; 

set Core_Nodes 		:= 1..I; 
set Access_Nodes	:= 1..J;
set VNF_Nos1		:= 1..K1;
set VNF_Nos2		:= 1..K2;

#Link generation
set Links1 within (Core_Nodes cross Access_Nodes);
set Links2 within (Access_Nodes cross Access_Nodes);
set Links3 within (Core_Nodes cross Core_Nodes);


#constants
param Cc {Core_Nodes} >= 0;  				#capacity of Core Nodes

param Ca {Access_Nodes} >= 0;   			#capacity of Access Nodes

param f >= 0; 								#Size of VNF 

param e1 >=0;                               #cost of deploying a VNF on core node in step 1

param e2 >=0;                       		#cost of deploying a VNF on access node in step 1

param e3 >=0;								#cost of deploying a VNF on core node in step 2

param e4 >=0;								#cost of deploying a VNF on access node in step 2

param Acost {Access_Nodes}>=0;				#total cost of deploying a VNF on Access node in both steps

param Ccost {Core_Nodes}>=0;				#total cost of deploying a VNF on Core node in both steps

param Lc {Core_Nodes}>=0;					#No of Users connected to Core Nodes

param La {Access_Nodes}>=0; 				#No of users connected to Access nodes

param U>=0; 								#No of users a VNF can handle

param Core_adjacency{(i,j) in Links3}
		:= if i*j != '-' then 1 else 0;		#If Core 'i' is connected to Core 'j', then 1 else 0 

param Access_adjacency{(i,j) in Links2}		#If Access 'i' is connected to Access 'j', then 1 else 0
		:= if i*j != '-' then 1 else 0; 
		

#variables

var x{Core_Nodes, VNF_Nos1} binary; 		#kth VNF is deployed on ith core node, otherwise 0 

var r{Access_Nodes, VNF_Nos1} binary;		#kth VNF is deployed on jth access node, otherwise 0

var Spare_Users_Core{Core_Nodes} integer;	#users left at Core after initial VNF deployment

var Spare_Users_Access{Access_Nodes} integer; #users left at Access after initial VNF deployment

var Spare_Capacity_Core{Core_Nodes} integer;  #capacity left at Core after initial VNF deployment

var Spare_Capacity_Access{Access_Nodes} integer; #capacity left at Access after initial VNF deployment

var p1{Core_Nodes, Core_Nodes}; 

var p2{Access_Nodes, Access_Nodes};


var w1 >= 0;

var w2 >= 0;

var t{Core_Nodes, VNF_Nos2} binary;

var d{Access_Nodes, VNF_Nos2} binary;




#objective function

maximize Deployment1: sum{k in VNF_Nos1}sum{i in Core_Nodes} x[i,k] + sum{k in VNF_Nos1} sum{j in Access_Nodes} r[j,k];
						

#constraints

#-----------------------------basic_deployment------------------------------

s.t. VNF_Deployment_Constraint {k in VNF_Nos1}:
	sum{i in Core_Nodes} x[i,k] + sum{j in Access_Nodes} r[j,k]  <= 1;


s.t. Core_Capacity_Constraint {i in Core_Nodes}:
	sum {k in VNF_Nos1} x[i,k] * f <= Cc[i];


s.t. Access_Capacity_Constraint {j in Access_Nodes}:
	sum {k in VNF_Nos1} r[j,k] * f <= Ca[j];


s.t. Core_User_Constraint {i in Core_Nodes}:
	sum {k in VNF_Nos1} x[i,k] * U  <= Lc[i];


s.t. Access_User_Constraint {j in Access_Nodes}:
	sum {k in VNF_Nos1} r[j,k] * U <= La[j];	

#--------------------spare_capacity------------------		

s.t. Spare_Core_Capacity_Constraint {i in Core_Nodes}:
	Spare_Capacity_Core[i] = Cc[i] - sum {k in VNF_Nos1} (x[i,k] * f);
	 

s.t. Spare_Access_Capacity_Constraint {i in Access_Nodes}:
	Spare_Capacity_Access[i] = Ca[i] - sum {k in VNF_Nos1} (r[i,k] * f) ;	
		

#--------------------remaining_users------------------

s.t. Spare_User_Constraint_Core {i in Core_Nodes}:
	Spare_Users_Core[i] = Lc[i] - sum {k in VNF_Nos1} (x[i,k] * U)  ;


s.t. Total_Spare_Users_Core:
		w1 = sum {i in Core_Nodes} Spare_Users_Core[i];


s.t. Spare_User_Constraint_Access {i in Access_Nodes}:
	Spare_Users_Access[i] = La[i] - sum {k in VNF_Nos1} (r[i,k] * U)  ;

	
s.t. Total_Spare_Users_Access:
		w2 = sum {i in Access_Nodes} Spare_Users_Access[i];


#------------------finding_adjacent_capacity---------------------


s.t. Core_Adjacency_Constraint {(i,j) in Links3}:  
    p1[j, i] = Core_adjacency[i,j] * Spare_Capacity_Core[i];  
     

s.t. Access_Adjacency_Constraint {(i,j) in Links2}:
	p2[j, i] = Access_adjacency[i,j] * Spare_Capacity_Access[i];

		







	
	
	