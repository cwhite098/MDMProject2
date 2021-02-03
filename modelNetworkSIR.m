function [data] = modelNetworkSIR(a, b, infectivePeriod, tf, n, I0, A)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function MODELNETWORKSIR produces an SIR graph against time and graphs the
%network.
%
%INPUTS
% a = probability of transmission
% b = the number of people an infected individual encounters each day
% infectivePeriod = mean number of days a person is sick for
% tf = end time for simulatoin
% n = population size
% I0 = number of initially infected
% A = adjacency matrix for network
%
%OUTPUTS
% data = matrix containing:
%       row1 = node number
%       row2 = infection status (0=S,1=I,2=R)
%       row3 = time of infection
%       row4 = LCC of node
%       row5 = degree of node
%       row6 = distance to a patient 0
%       row7 = number of people infected by this node
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% init loading bar
hwait = waitbar(0,'Please wait. Generating Networked Model');

%set population size for the networks
popSize = n;

%calculate GCC (commented out because it is slow)
%clusterCoeff = global_clustering_coefficient(A);

%initial infection status of population
R = 0;              %initial recovered population
S = popSize - I0;   %susceptible population
I = I0;             %initially infected

%vectors tracking numbers of S, I and R
IVec = [I];
RVec = [R];
SVec = [S];

G = graph(A);

%tracking who is S, I and R
%  in row 2, 0=susceptible, 1=infected, 2=recovered
data = [1:popSize];
data(2,:) = zeros;
data(3,:) = Inf;
data(7,:) = zeros;

%randomly assign initially infected
for i = 1:I
    %random number generator
    r = randi(popSize, 1);
    %setting infection status and time of infection
    data(2,r) = 1;
    data(3,r) = 0;
end

%Algorithm for spread of disease
for t = 2:tf
    %update loading bar
    waitbar(t/tf,hwait,sprintf('Please wait. Generating networked model\n%.1f %%',(t/tf)*100));
    %counters for changes in S,I and R numbers
    S = 0;
    I = 0;
    R = 0;
    
    for p = data(1,:)
        
        %choose b random neighbours
        neighbours = neighbors(G,p)';    
        for i = 1:b
            if not(isempty(neighbours))
                ind = randperm(length(neighbours), 1);
                visits(i) = neighbours(ind);                
                neighbours(neighbours==visits(i)) = [];
            end
        end
        
        %check to see if I becomes R
        r = rand;
        if data(2,p) == 1 && r < sum(poisspdf(0:(t-data(3,p)), infectivePeriod+1))
               data(2,p) = 2; 
               R = R+1;
               I = I-1;
        end  
        
        %nodes visit each other
        for visit = visits
            %if I person visits S person, infection may occur
            if data(2,p) == 1 && data(2, visit) == 0
               r = rand;
               if r <= a
                  data(2, visit) = 1;
                  data(3,visit) = t;
                  I = I+1;
                  S = S-1;
                  data(7,p) = data(7,p) + 1;
               end
            end           
        end        
    end
    
    %update vectors
    IVec(t) = IVec(t-1)+I;
    RVec(t) = RVec(t-1)+R;
    SVec(t) = SVec(t-1)+S;
   
end

%calculate LCC for each node (commented out because slow)
%for n = 1:popSize
%    tracking(4,n) = local_clustering_coefficient(A,n);
%end

%calculate degree for each node (commented out because slow)
%for n = 1:popSize
%    tracking(5,n) = degree(G,n);
%end

%calculate shortest dist to p0 for each node (commented out because slow)
%for n = 1:popSize
%    [TR,D] = shortestpathtree(G, n, patient0);
%    tracking(6,n) = D;
%end

delete(hwait);

%plot graphs
figure;
tiledlayout(2,1);

nexttile;
plot((0:length(SVec)-1), SVec, '-g', 'LineWidth', 2)
hold on
plot((0:length(IVec)-1), IVec, '-r', 'LineWidth', 2)
plot((0:length(RVec)-1), RVec, '-b', 'LineWidth', 2)
legend('S','I','R');
title(sprintf('SIR Network Model GCC =%0.5f'), 'FontSize', 20); %add back GCC here
xlabel('time', 'FontSize', 20),ylabel('people', 'FontSize', 20);
grid on;
ax = gca; ax.YAxis.FontSize = 15; ax.XAxis.FontSize = 15;
hold off

nexttile;
p=plot(G);
title('network graph');
G.Nodes.NodeColors = degree(G);
p.NodeCData = G.Nodes.NodeColors;
colorbar;


end