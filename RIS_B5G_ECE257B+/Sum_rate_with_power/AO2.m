function [v, w] = AO2(hd, hr, G, epsilon, P)
    % Initialize variables
    N = length(hr);
    M = size(G, 2);
    v = exp(1j * 2 * pi * rand(N, 1));
    w = ones(M, 1) / sqrt(M);
    R_old = 0;
    R_new = 1;
    
    max_iter = 10;  
    iter = 0;    
    cvx_clear   
    
    min_iter = 3;  
    while (abs(R_new - R_old) > epsilon || iter < min_iter) && iter < max_iter  
        iter = iter + 1;  
        
        % Update w with fixed v
        h_eq = v.' * (diag(hr) * G) + hd;
        w = h_eq' / norm(h_eq);  
        
        % Update v with fixed w
        % 修改目标函数，使其直接优化速率
        cvx_begin quiet
            variable V(N+1, N+1) hermitian
            Phi = diag(hr) * G;
            R = [Phi*w*w'*Phi' Phi*w*w'*hd'; hd*w*w'*Phi' hd*w*w'*hd'];
            maximize(log(1 + P*real(trace(R*V))))  % 直接优化速率而不是信道增益
            subject to
                diag(V) == 1;
                V == hermitian_semidefinite(N+1);
        cvx_end
        
        % Gaussian randomization
        L = 1000;
        max_obj = 0;
        max_v = zeros(N,1);
        [U, Sigma] = eig(V);
        
        for l = 1:L
            r = sqrt(2)/2 * (randn(N+1,1) + 1j*randn(N+1,1));
            v_tmp = U * Sigma^(0.5) * r;
            v_tmp = exp(1j * angle(v_tmp/v_tmp(end)));
            v_tmp = v_tmp(1:N);
            obj = log2(1 + P * norm((v_tmp.' * (diag(hr) * G) + hd) * w)^2); 
            if obj > max_obj
                max_obj = obj;
                max_v = v_tmp;
            end
        end
        v = max_v;
        
        % Update rate
        R_old = R_new;
        R_new = log2(1 + P * norm((v.' * (diag(hr) * G) + hd) * w)^2);
    end
end