%% Load nominal robot dynamics parameters
% Values taken from Barrett WAM booklet

% definitions
ZSFE  =  0.346;              %!< z height of SAA axis above ground
ZHR  =  0.505;              %!< length of upper arm until 4.5cm before elbow link
YEB  =  0.045;              %!< elbow y offset
ZEB  =  0.045;              %!< elbow z offset
YWR  = -0.045;              %!< elbow y offset (back to forewarm)
ZWR  =  0.045;              %!< elbow z offset (back to forearm)
ZWFE  =  0.255;              %!< forearm length (minus 4.5cm)

% link 0 is the base
link0.m = 9.9706;
link0.mcm(1) = link0.m * -0.02017671;
link0.mcm(2) = link0.m * -0.26604706;
link0.mcm(3) = link0.m * -0.14071720;
link0.inertia(1,1) = 1.01232865; 
link0.inertia(1,2) = 0.05992441; 
link0.inertia(1,3) = 0.05388736; 
link0.inertia(2,2) = 0.38443311; 
link0.inertia(2,3) = 0.37488748;
link0.inertia(3,3) = 0.82739198;                             
% SFE joint
links(1).m = 10.768; 
links(1).mcm(1) = links(1).m * -0.0044342;   
links(1).mcm(2) = links(1).m * 0.12189;    
links(1).mcm(3) = links(1).m * -0.00066489;
links(1).inertia(1,1) = 0.29486;    
links(1).inertia(1,2) = -0.0079502;  
links(1).inertia(1,3) = -0.00009311;  
links(1).inertia(2,2) = 0.11350;    
links(1).inertia(2,3) = -0.00018711;  
links(1).inertia(3,3) = 0.25065;
% SAA joint
links(2).m = 3.8749;
links(2).mcm(1) = links(2).m * -0.0023698;   
links(2).mcm(2) = links(2).m * 0.031056;    
links(2).mcm(3) = links(2).m * 0.015421;
links(2).inertia(1,1) = 0.026068;  
links(2).inertia(1,2) = -0.00001346; 
links(2).inertia(1,3) = -0.00011701;  
links(2).inertia(2,2) = 0.014722;    
links(2).inertia(2,3) = 0.00003659;  
links(2).inertia(3,3) =  0.019348;         
% HR joint    
links(3).m = 1.8023;
links(3).mcm(1) = links(3).m * -0.038259;    
links(3).mcm(2) = links(3).m * 0.20751;     
links(3).mcm(3) = links(3).m * 0.00003309;
links(3).inertia(1,1) = 0.13672;    
links(3).inertia(1,2) = -0.016804;    
links(3).inertia(1,3) = 0.00000510;  
links(3).inertia(2,2) = 0.0058835; 
links(3).inertia(2,3) = -0.00000530;  
links(3).inertia(3,3) = 0.13951;
% EB joint (elbow)
links(4).m = 2.4007;                        
links(4).mcm(1) = links(4).m * 0.0049851;
links(4).mcm(2) = links(4).m * -0.00022942;
links(4).mcm(3) = links(4).m * 0.13272; 
links(4).inertia(1,1) = 0.057193;
links(4).inertia(1,2) = 0.00001467;
links(4).inertia(1,3) = 0.00008193;
links(4).inertia(2,2) = 0.057165;
links(4).inertia(2,3) = -0.00009417;
links(4).inertia(3,3) = 0.0030044;
% WR joint (wrist 1)
links(5).m = 0.12376;                    
links(5).mcm(1) = links(5).m * 0.00008921;
links(5).mcm(2) = links(5).m * 0.0051122; 
links(5).mcm(3) = links(5).m * 0.0043582; 
links(5).inertia(1,1) = 0.00005587;
links(5).inertia(1,2) = 0.00000026;
links(5).inertia(1,3) = 0.00000000;
links(5).inertia(2,2) = 0.00007817;
links(5).inertia(2,3) = -0.00000083;
links(5).inertia(3,3) = 0.00006594;
% WFE joint (wrist 2)
links(6).m = 0.41797;                   
links(6).mcm(1) = links(6).m * 0.00012262; 
links(6).mcm(2) = links(6).m * -0.017032;  
links(6).mcm(3) = links(6).m * 0.024683; 
links(6).inertia(1,1) = 0.00093106; 
links(6).inertia(1,2) = 0.00000148; 
links(6).inertia(1,3) = -0.00000201; 
links(6).inertia(2,2) = 0.00049833; 
links(6).inertia(2,3) = -0.00022162;
links(6).inertia(3,3) = 0.00057483;
% WAA joint (wrist 3)     
links(7).m = 0.068648; 
links(7).mcm(1) = links(7).m * -0.00007974;  
links(7).mcm(2) = links(7).m * 0.00016313;  
links(7).mcm(3) = links(7).m * -0.0032355;  
links(7).inertia(1,1) = 0.00003845; 
links(7).inertia(1,2) = -0.00000019;
links(7).inertia(1,3) = 0.00000002;  
links(7).inertia(2,2) = 0.00003878; 
links(7).inertia(2,3) = -0.00000004;  
links(7).inertia(3,3) = 0.00007408;

% make sure inertia matrices are symmetric
for i = 1:7
    for j = 1:3
        for k = j:3
            links(i).inertia(k,j) = links(i).inertia(j,k);
        end
    end
end

% Set default end effector parameters
eff(1).m = 0.0;
eff(1).mcm(1) = 0.0;
eff(1).mcm(2) = 0.0;
eff(1).mcm(3) = 0.0;
eff(1).x(1)  = 0.0;
eff(1).x(2)  = 0.0;
eff(1).x(3)  = 0.06; 
eff(1).a(1)  = 0.0;
eff(1).a(2)  = 0.0;
eff(1).a(3)  = 0.0;

% External forces
for j = 1:3
    % I guess this is the external force to the base
    uex0.f(j) = 0.0;
    uex0.t(j) = 0.0;
    for i = 1:7
        uex(i).f(j) = 0.0;
        uex(i).t(j) = 0.0;
    end
end

% base cartesian position and orientation (quaternion)
basec.x  = [0.0,0.0,0.0];
basec.xd = [0.0,0.0,0.0];
basec.xdd = [0.0,0.0,0.0];
baseo.q = [0.0,1.0,0.0,0.0];
baseo.qd = [0.0,0.0,0.0,0.0];
baseo.qdd = [0.0,0.0,0.0,0.0];
baseo.ad = [0.0,0.0,0.0];
baseo.add = [0.0,0.0,0.0];