function [v, lower_bound] = SDR_solving2(hr, G, hd, N, P)
    L = 1000;
    Phi = diag(hr)*G;
    h_eq = [Phi; hd];
    
    cvx_clear 
    cvx_begin sdp quiet
        variable V(N+1,N+1) hermitian
        expression h_eff
        h_eff = [Phi*Phi' Phi*hd'; hd*Phi' hd*hd'];
        maximize(log(1 + P*real(trace(h_eff*V))))
        subject to
            diag(V) == 1;
            V == hermitian_semidefinite(N+1);
    cvx_end
    
    lower_bound = cvx_optval;
    
    % Gaussian randomization
    max_R = 0;
    max_v = 0;
    [U, Sigma] = eig(V);
    for l = 1 : L
        r = sqrt(2) / 2 * (randn(N+1, 1) + 1j * randn(N+1, 1));
        v_tmp = U * Sigma^(0.5) * r;
       
        channel_gain = norm((v_tmp(1:N).'*diag(hr)*G + hd))^2;
        rate = log2(1 + P*channel_gain);
        
        if rate > max_R
            max_v = v_tmp;
            max_R = rate;
        end
    end
    
    v = exp(1j * angle(max_v / max_v(end)));
    v = v(1 : N);
end