# Optimal VNF Placement Algorithm

+ The objective of this basic algorithm is to deploy VNFs on nodes based on user requirement and node capacity constraints. The diagram shows the network topology implemented [AMPL](https://ampl.com/) that used to test the algorithm.

<p align="center">
  <img src="https://github.com/madhav-prabhu/OVNF-Project/blob/master/Multi_Layer/Architecture.PNG" width='700' title="Architecture">
</p>


+ The algorithm is based on **Topological Design** model disucssed in the [Network Design & Algorithms](https://engineering.nyu.edu/sites/default/files/2019-11/ECE_GY_7363_S20.pdf) course. The OVNF model runs in the VNFM sub-system of the NFV MANO entity. The VNFM sub-system is responsible for deployment of VNFs, the algorithm uses capacity data obtained by VIM sub-system and user requirement data from the Orchestrator. 

+ The algorithm implementation consists of **two** stages:  
The first stage of the algorithm involves deployment of VNFs based on requirement of each node, i.e. the number of users connected to each node and the capacity of that node.  
The second stage of the model involves deployment of VNFs based on adjacency of nodes and spare capacity of each adjacent node. If the capacity of a node is depleted, VNFs are deployed on adjacent nodes taking into account spare capacities as well.

+ The algorithm analysis is based on **two** scenarios:  
In the first scenario, VNFs are allowed to be deployed on both Core and Access nodes.  
In the second scenario, VNFs are allowed to be deployed only on Access nodes. In each scenario, the 2-stage Model is implemented.

+ Different cost is assigned for VNF deployment on both core and access nodes.  
Cost of deployment of VNFs is higher in core nodes than in access nodes as in a real-world scenario, Deployment of core nodes requires long term commitment and considerable budget whereas it is easier to instantiate an access node as compared to a core node based on user demands. Also, The model maximizes deployment of VNFs but only does so in the limits of capacity and requirement, therefore no extra VNFs are deployed which in turn optimizes deployment cost.

+ A detailed workflow is demonstarted in the [Presentation document](https://github.com/madhav-prabhu/OVNF-Project/blob/master/OVNF_Placement_Algorithm.pdf)
