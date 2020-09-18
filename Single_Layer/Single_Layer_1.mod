param I > 0;  #core nodes
param J > 0;  #access nodes
param K1 > 0;  #no of VNFs
param K2 > 0; 


set Core_Nodes 		:= 1..I; 
set Access_Nodes	:= 1..J;
set VNF_Nos1		:= 1..K1;
set VNF_Nos2		:= 1..K2;

set Links1 within (Core_Nodes cross Access_Nodes);
set Links2 within (Access_Nodes cross Access_Nodes);
set Links3 within (Core_Nodes cross Core_Nodes);


param Cc {Core_Nodes} >= 0;  				#capacity of Core Nodes

param Ca {Access_Nodes} >= 0;   			#capacity of Access Nodes

param Acost {Access_Nodes}>=0;

param f >= 0; 								#Size of VNF 

param Lc {Core_Nodes}>=0;					#No of Users connected to Core Nodes

param La {Access_Nodes}>=0; 				#No of users connected to Access nodes

param U>=0; 								#No of users a VNF can handle

param e1 >=0;   #cost on deploying users on access

param e2 >=0;   #cost of deploying excess users

param Access_adjacency{(i,j) in Links2}		#If Access 'i' is connected to Access 'j', then 1 else 0
		:= if i*j != '-' then 1 else 0; 
		


#variables

var r{Access_Nodes, VNF_Nos1} binary;		#kth VNF is deployed on jth access node, otherwise 0 in step 1

var m{Access_Nodes, VNF_Nos2} binary;		#kth VNF is deployed on jth access node, otherwise 0 in step 2

var Spare_Users_Core{Core_Nodes} integer;	#users left at Core after initial VNF deployment

var Spare_Users_Access{Access_Nodes} integer; #users left at Access after initial VNF deployment

var Spare_Capacity_Access{Access_Nodes} integer; #capacity left at Access after initial VNF deployment

var p1{Access_Nodes, Access_Nodes};


var w1 >= 0;

var w2 >= 0;

var d{Access_Nodes, VNF_Nos2} binary;

#objective function

maximize Deployment: sum{k in VNF_Nos1} sum{j in Access_Nodes} r[j,k];


#constraints

s.t. VNF_Deployment_Constraint {k in VNF_Nos1}:
	sum{j in Access_Nodes} r[j,k]  <= 1;


s.t. Access_Capacity_Constraint {j in Access_Nodes}:
	sum {k in VNF_Nos1} r[j,k] * f <= Ca[j];


s.t. Access_User_Constraint {j in Access_Nodes}:
	sum {k in VNF_Nos1} r[j,k] * U <= La[j];	


#--------------------spare_capacity------------------

s.t. Spare_Access_Capacity_Constraint {i in Access_Nodes}:
	Spare_Capacity_Access[i] = Ca[i] - sum {k in VNF_Nos1} (r[i,k] * f) ;	
		

s.t. Spare_User_Constraint_Access {i in Access_Nodes}:
	Spare_Users_Access[i] = La[i] - sum {k in VNF_Nos1} (r[i,k] * U)  ;	
	
#--------------------remaining_users------------------
	
s.t. Total_Spare_Users_Access:
		w1 = sum {i in Access_Nodes} Spare_Users_Access[i];


s.t. Total_Spare_Users_Core:
		w2 = sum {i in Core_Nodes} Lc[i];
		
	
#--------------------Adjacency Constraints------------------	


s.t. Access_Adjacency_Constraint {(i,j) in Links2}:
	p1[i, j] = Access_adjacency[i,j] * Spare_Capacity_Access[i];	

	
	
	
	
	
	
	
	
	
	
	