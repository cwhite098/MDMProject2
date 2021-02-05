function [data] = modelNetworkSIRD(a, b, mu, infectivePeriod, tf, n, I0, A)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function MODELNETWORKSIRD produces an SIRD graph against time and graphs the
%network.
%
%INPUTS
% a = probability of transmission
% b = the number of people an infected individual encounters each day
% mu = rate of mortality
% infectivePeriod = mean number of days a person is sick for
% tf = end time for simulatoin
% n = population size
% I0 = number of initially infected
% A = adjacency matrix for network
%
%OUTPUTS
% data = matrix containing:
%       row1 = node number
%       row2 = infection status (0=S,1=I,2=R,3=D)
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
a = a;
%calculate GCC (commented out because it is slow)
%clusterCoeff = global_clustering_coefficient(A);

%initial infection status of population
R = 0;              %initial recovered population
S = popSize - I0;   %susceptible population
I = I0;             %initially infected
D = 0;

%vectors tracking numbers of S, I, R and D
IVec = [I];
RVec = [R];
SVec = [S];
DVec = [D];

G = graph(A);


%tracking who is S, I, R and D
%  in row 2, 0=susceptible, 1=infected, 2=recovered, 3=dead
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
for t = 1:tf
    %update loading bar
    waitbar(t/tf,hwait,sprintf('Please wait. Generating networked model\n%.1f %%',(t/tf)*100));
    %counters for changes in S,I,R and D numbers
    S = 0;
    I = 0;
    R = 0;
    D = 0;
    
    for p = data(1,:)
        
        %checks to see if person is infected
        if data(2,p) == 1
            
            %if I person visits S person, infection may occur         
            neighbours = neighbors(G,p)';                
            visits = [];
            while length(visits) < b && not(isempty(neighbours))
                ind = randperm(length(neighbours), 1);
                if not(data(2,neighbours(ind)) == 3)
                    visits(end+1) = neighbours(ind);
                end
                neighbours(ind) = [];                        
            end
            for visit = visits 
                r = rand;
                if r <= a && data(2,visit) ==0
                    data(2, visit) = 1;
                    data(3,visit) = t;
                    I = I+1;
                    S = S-1;
                    data(7,p) = data(7,p) + 1;
                end
            end                 
           
           

            %check to see if I becomes R
            r = rand;
            if r < 1/infectivePeriod
                   data(2,p) = 2; 
                   R = R+1;
                   I = I-1;
            end 

            %check to see if infected person dies
            r = rand;
            if r < mu
                   data(2,p) = 3; 
                   D = D+1;
                   I = I-1;                 
            end
        end

        %update vectors
        IVec(t+1) = IVec(t)+I;
        RVec(t+1) = RVec(t)+R;
        SVec(t+1) = SVec(t)+S;
        DVec(t+1) = DVec(t)+D;
    end
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
plot((0:tf), SVec, '-g', 'LineWidth', 2)
hold on
plot((0:tf), IVec, '-r', 'LineWidth', 2)
plot((0:tf), RVec, '-b', 'LineWidth', 2)
plot((0:tf), DVec, '-k', 'LineWidth', 2)
legend('S','I','R','D');
title(sprintf('SIRD Network Model GCC =%0.5f'), 'FontSize', 20); %add back GCC here
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