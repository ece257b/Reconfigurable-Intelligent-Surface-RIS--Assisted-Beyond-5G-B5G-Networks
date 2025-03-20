function [v, lower_bound] = SDR_solving(hr, G, hd, N)
    % 检查输入维度
    if size(hr,2) ~= N
        hr = hr.';  % 转置确保维度正确
    end
    if size(hd,2) ~= size(G,2)
        hd = hd.';  % 转置确保维度正确
    end
    
    % 构造信道矩阵
    Phi = diag(hr)*G;
    
    % 构造半正定规划问题
    cvx_begin sdp quiet
        variable V(N+1,N+1) hermitian
        R = [Phi*Phi' Phi*hd'; hd*Phi' hd*hd'];  % 修正矩阵构造
        maximize(real(trace(R*V)))
        subject to
            diag(V) == 1;
            V == hermitian_semidefinite(N+1);
    cvx_end
    
    % 高斯随机化
    L = 1000;
    max_obj = 0;
    max_v = zeros(N,1);
    [U,S] = eig(V);
    for l = 1:L
        r = sqrt(2)/2 * (randn(N+1,1) + 1i*randn(N+1,1));
        v_tmp = U*sqrt(S)*r;
        v_tmp = exp(1j*angle(v_tmp/v_tmp(end)));
        v_tmp = v_tmp(1:N);
        
        % 修改功率计算方式
        channel_vec = v_tmp'*Phi + hd;
        obj = norm(channel_vec)^2;  % 使用norm计算信道增益
        
        if obj > max_obj
            max_obj = obj;
            max_v = v_tmp;
        end
    end
    v = max_v;
    lower_bound = max_obj;
end