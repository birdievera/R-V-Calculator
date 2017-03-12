function calc_diff ()
    % calculates the difference between the sum up until saturation
    % and Euler's convergence theory (pi^2/6), as well as the
    % proposed 'better' method
    %   s0 = 'exact' sum s
    %   s1 = calculated sum 
    %   s2 = more precise sum
    
    
    %%%%%%%%%%%%%%         FIRST ALGORITHM              %%%%%%%%%%%%%%%%%%
    
    s0 = (pi.^2)/6; % Euler approximation
    [i, s1] = basel();
    acc = (s0-s1)/s0;
    
    fprintf('%12d %18.16f %18.16f %8.1e\n', i-1, s0, s1, acc);
    
    %%%%%%%%%%%%%%         SECOND ALGORITHM              %%%%%%%%%%%%%%%%%%
    
    [i2, s2] = approx();
    acc2 = (s0-s2)/s0;
    
    fprintf('%12d %18.16f %18.16f %8.1e\n', i-1, s0, s2, acc2);
    
function [A,b] = gen_mat(n, V)
    % creates a matrix and right hand side vector from the form Ax=b
    %   n = the number of loops in the circuit
    %   V = voltage source, default = 100
    
    % note: size of array = n-7/3
    %sz = round(n-7/3);
    
    % initialize matrix 3 x n-7/3
    %A = speye(3, sz); 
    
    % create top nodes
    % xi - xi+1 - xi+3 = 0, i = 1, 4, 7, 10, . . . , 3n - 5
    
    % n loops + 2(n-1) nodes total
    N = 3*n - 2;
    
    A = speye(N, N);
    b = zeros(1, N);
    b(1,1) = V
    
    A(1, 1:3) = [1 1 1];
    A(2, 1:4) = [1 -1 0 -1];
    
    
    
    for k=1:3:(3*n-2)
        %%%%%%%%%%%%%%%% LOOPS %%%%%%%%%%%%%%%%%%%%%%
        if k == 1
            % first loop: x1 + x2 + x3 = V
            A(k, k:k+2) = [1 1 1];
        else if k > (3*n-3)
            % last loop: -x8 + 2x10 = 0
            A(k, k-2:k) = [-1 0 2];
        else
            % follow general eqn
            A(k, k-2:k+2) = [-1 0 1 1 1];
            end
        
        % create top nodes
        A(k+1, k:k+3) = [1 -1 0 -1];
        % create bottom nodes (including left bottom)
        A(k-1, k-2:k+2) = [1 -1 0 0 1];
    end
    
    