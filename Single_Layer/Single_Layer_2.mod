


maximize Deployment2: sum{j in Access_Nodes} sum{k in VNF_Nos2} m[j,k];


s.t. VNF_Deployment_Constraint1 {k in VNF_Nos2}:
	sum{j in Access_Nodes} m[j,k] <= 1;

s.t. Access_Capacity_Constraint1 {(i,j) in Links2}:
	sum{k in VNF_Nos2} m[i,k] * f <= p1[i,j];

s.t. Access_User_Constraint1  :
	 sum {i in Access_Nodes} sum{k in VNF_Nos2}  m[i,k] * U <= Spare_Users_Total;






















