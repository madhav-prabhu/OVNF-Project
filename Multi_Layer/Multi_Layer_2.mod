

maximize Deployment2: sum{k in VNF_Nos2} sum{i in Core_Nodes} t[i,k] + sum{k in VNF_Nos2} sum{j in Access_Nodes} d[j,k];



s.t. VNF_Deployment_Constraint1 {k in VNF_Nos2}:
	sum {i in Core_Nodes} t[i,k] + sum {j in Access_Nodes} d[j,k] <= 1;


s.t. Core_Capacity_Constraint1 {(i,j) in Links3}:
	sum {k in VNF_Nos2} t[i,k] * f <= p1[j,i];


s.t. Access_Capacity_Constraint1 {(i,j) in Links2}:
	sum {k in VNF_Nos2} d[i,k] * f <= p2[j,i];


s.t. Core_User_Constraint1 {i in Core_Nodes}:
	sum {k in VNF_Nos2} t[i,k] * U  <=  w1;


s.t. Access_User_Constraint1 {j in Access_Nodes}:
	sum {k in VNF_Nos2} d[j,k] * U <= w2;
	

	