function A = complete_graph(n)

A = ones(n);
A(1:n+1:end) = 0;

end
