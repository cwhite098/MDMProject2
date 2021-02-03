function [data] = modelNetworkSIR(a, b, infectivePeriod, tf, n, I0, A)

hwait = waitbar(0,'Please wait. Generating Networked Model');

%set population size for the networks
popSize = n;

%clusterCoeff = global_clustering_coefficient(A);

R = 0;              %initial recovered population
S = popSize - I0;    %susceptible population
I = I0;

IVec = [I];
RVec = [R];
SVec = [S];

G = graph(A);

%tracking who is S, I and R
%  in row 2, 0=susceptible, 1=infected, 2=recovered
tracking = [1:popSize];
tracking(2,:) = zeros;
tracking(3,:) = Inf;
tracking(7,:) = zeros;

%randomly assign initially infected
for i = 1:I

    %random number generator
    r = randi(popSize, 1);
    patient0 = r;

    %setting infection status and time of infection
    tracking(2,r) = 1;
    tracking(3,r) = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t = 2:tf
    waitbar(t/tf,hwait,sprintf('Please wait. Generating networked model\n%.1f %%',(t/tf)*100));
    S = 0;
    I = 0;
    R = 0;
    for p = tracking(1,:)
        neighbours = neighbors(G,p)';
    
        for i = 1:b
            if not(isempty(neighbours))
                ind = randperm(length(neighbours), 1);
                visits(i) = neighbours(ind);                
                neighbours(neighbours==visits(i)) = [];
            end
        end
        
        r = rand;
        if tracking(2,p) == 1 && r < sum(poisspdf(0:(t-tracking(3,p)), infectivePeriod))
               tracking(2,p) = 2; 
               R = R+1;
               I = I-1;
        end  
        
        for visit = visits
            
            
            if tracking(2,p) == 1 && tracking(2, visit) == 0
               r = rand;
               if r <= a
                  tracking(2, visit) = 1;
                  tracking(3,visit) = t;
                  I = I+1;
                  S = S-1;
                  tracking(7,p) = tracking(7,p) + 1;
               end
            end           
        end        
    end
    
    IVec(t) = IVec(t-1)+I;
    RVec(t) = RVec(t-1)+R;
    SVec(t) = SVec(t-1)+S;
   
end

%for n = 1:popSize
%    tracking(4,n) = local_clustering_coefficient(A,n);
%end
%for n = 1:popSize
%    tracking(5,n) = degree(G,n);
%end
%for n = 1:popSize
%    [TR,D] = shortestpathtree(G, n, patient0);
%    tracking(6,n) = D;
%end

data = tracking;

delete(hwait);

figure;
tiledlayout(2,1);

nexttile;
plot((0:length(SVec)-1), SVec, '-g', 'LineWidth', 2)
hold on
plot((0:length(IVec)-1), IVec, '-r', 'LineWidth', 2)
plot((0:length(RVec)-1), RVec, '-b', 'LineWidth', 2)
legend('S','I','R');
title(sprintf('SIR Network Model GCC =%0.5f'), 'FontSize', 20);
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