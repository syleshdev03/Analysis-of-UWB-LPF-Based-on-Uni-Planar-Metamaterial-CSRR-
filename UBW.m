% Set variables for ground plane
gndL = 18e-3;
gndW = 7e-3;

% Set variables for feeding transmission line
ZA_Width = 4e-3;
ZA_Length = 4e-3;

% Define unit cell length
Cell_Length = 5e-3;

% Create feeding microstrip line
ZA = traceRectangular("Length",ZA_Length,"Width",ZA_Width,...
    "Center",[-ZA_Length/2-Cell_Length 0]);

% Create rectangular unit cell
Cell_A = traceRectangular("Length",Cell_Length,"Width",Cell_Length,...
    "Center",[-Cell_Length/2 0]);

% Join feeding line and rectangular unit cell
LeftSection = ZA + Cell_A;

% Create shapes for various slots 
s1 = traceLine('StartPoint',[-Cell_Length/2-0.2e-3  -1.9e-3],...
    'Angle',[-180 -270 0],'Length',[1.75e-3 3.8e-3 1.75e-3],'Width',0.2e-3);

s2 = traceLine('StartPoint',[-Cell_Length/2+0.2e-3  -1.9e-3],...
    'Angle',[0 90 180],'Length',[1.75e-3 3.8e-3 1.75e-3],'Width',0.2e-3);

s3 = traceLine('StartPoint',[-Cell_Length/2-1.2e-3  -0.2e-3],...
    'Angle',[-90 0 90],'Length',[0.8e-3 2.4e-3 0.8e-3],'Width',0.2e-3);

s4 = traceLine('StartPoint',[-Cell_Length/2-1.2e-3   0.2e-3],...
    'Angle',[90 0 -90],'Length',[0.8e-3 2.4e-3 0.8e-3],'Width',0.2e-3);

s5 = traceRectangular("Length",0.2e-3,"Width",1.8e-3,...
    "Center",[-Cell_Length/2 0]);

% Create slots of U-CSRR on hosted micrsotrip line
LeftSection = LeftSection -s1 -s2 -s3 -s4 -s5;
figure; 
show(LeftSection);

RightSection = copy(LeftSection);
RightSection = mirrorY(RightSection);
figure; 
show(RightSection);

filter = LeftSection + RightSection;
show(filter);

% Define Substrate and its thickness
substrate = dielectric("RO4730JXR");
substrate.Thickness = 1.52e-3;

% Define bottom ground plane
ground = traceRectangular("Length",gndL,"Width",gndW,...
   "Center",[0,0]);

pcb = pcbComponent;
pcb.BoardShape = ground;
pcb.BoardThickness = 1.52e-3;
pcb.Layers ={filter,substrate,ground};
pcb.FeedDiameter = ZA_Width/2;
pcb.FeedLocations = [-gndL/2 0 1 3;gndL/2 0 1 3];
figure; 
show(pcb);

figure;
mesh(pcb,'MaxEdgeLength',1e-3);

spar = sparameters(pcb,linspace(0.1e9,15e9,30));
figure;
rfplot(spar);

figure;
rfplot(spar,[1 2],1);

figure;
charge(pcb,5e9);

figure;
charge(pcb,5e9,'dielectric');

figure;
current(pcb,5e9);

figure;
current(pcb,5e9,'dielectric');