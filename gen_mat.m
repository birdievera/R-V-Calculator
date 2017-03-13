   function [A,b] = gen_mat(n, V)
    % creates a matrix and right hand side vector from the form Ax=b
    %   n = the number of loops in the circuit
    %   V = voltage source, default = 100
    
    if ~exist('V','var')
        V = 100;
    end
    
    % n loops + 2(n-1) nodes total
    N = 3*n - 2;
    
    % initialize sparse matrix
    A = speye(N, N);
    b = zeros(1, N);
    b(1,1) = V; % leftmost loop: 3 res + voltage source
    
    A(1, 1:3) = [1 1 1];
    A(2, 1:4) = [1 -1 0 -1];
      
    for k=1:3:(3*n)
        
        %%%%%%%%%%%%%%%% LOOPS %%%%%%%%%%%%%%%%%%%%%%
        if k == 1
            % first loop: x1 + x2 + x3 = V
            A(k, k:k+2) = [1 1 1];
            fprintf('LEFT LOOP. k=%d, [ x%d + x%d + x%d ]\n', k, k, k+1, k+2);
        elseif k > (3*n-3)
            % k = 10 for n = 4
            % last loop: -x8 + 2x10 = 0
            A(k, k-2:k) = [-1 0 2];
            fprintf('RIGHT LOOP. k=%d, [ -x%d + 0x%d + 2x%d ]\n', k, k-2, k-1, k);
        else
            % create loops (general eqn)
            A(k, k-2:k+2) = [-1 0 1 1 1];
            fprintf('MID LOOP. k=%d, [ -x%d + 0x%d + x%d + x%d + x%d ]\n', k, k-2, k-1, k, k+1, k+2);
        end
        
        %%%%%%%%%%%%%%%% NODES %%%%%%%%%%%%%%%%%%%%%%
        
        % create top nodes (general eqn)
        if k <= (3*n-5)
            A(k+1, k:k+3) = [1 -1 0 -1];
            fprintf('TOP NODE. k=%d, [ x%d - x%d + 0x%d - x%d ]\n', k, k, k+1, k+2, k+3);
        end
        
        % create bottom nodes (including left bottom)
        if k < (3*n-5)
            % general eqn
            A(k+2, k+1:k+5) = [1 -1 0 0 1];
            fprintf('BOT NODE. k=%d, [ x%d - x%d + 0x%d + 0x%d + x%d ]\n', k, k+1, k+2, k+3, k+4, k+5);
        elseif k < (3*n-3)
            % rightmost node: x8-x9+x10 = 0
            A(k+2, k+1:k+3) = [1 -1 1];
            fprintf('BOT NODE. k=%d, [ x%d - x%d + x%d ]\n', k, k+1, k+2, k+3);
        end        
    end
    
    spy(A);
    
    