function [P_final, iter_count, P_history] = AO_MultiUser(Hr, Hd, G, epsilon, gamma, Uk, M, N)
    % Initialize variables
    theta = 2*pi*rand(1,N);
    Theta = diag(exp(1i*theta));
    H = zeros(Uk,M);
    P_old = 0;
    P_new = 50;
    maxIter = 30;
    P_history = zeros(maxIter,1);
    iter_count = 0;
    
    while(iter_count < maxIter)
        iter_count = iter_count + 1;
        
        % 更新复合信道
        for i = 1:Uk 
            H(i,:) = Hr(:,i)'*Theta*G + Hd(:,i)';
        end
        
        % 使用线性功率值
        W = PMQoSSOCP(H, gamma, M, Uk);
        P_opt = norm(W,'fro')^2;
        P_history(iter_count) = P_opt;
        
        % 更新功率值
        P_old = P_new;
        P_new = P_opt;
        
        if abs(P_new - P_old) < epsilon && iter_count > 3
            break;
        end
        
        % 更新IRS相位
        v = IRS_MultiUser(W, Hr, Hd, G, N, Uk, gamma);
        Theta = diag(v');
    end
    
    P_final = pow2db(P_new);  % 最后输出时转换为dB
    P_history = pow2db(P_history(1:iter_count));  % 历史记录转换为dB
end