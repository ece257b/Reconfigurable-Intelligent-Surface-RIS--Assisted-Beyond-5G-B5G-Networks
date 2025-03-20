function [L, params] = PathLossModel2()
    % Path loss parameters
    params.d0 = 51;      
    params.dv = 2;       
    params.d1 = 20;      
    params.d2 = 3;      
    
    % Basic parameters
    params.C0 = db2pow(-30);  % Path loss at reference distance
    params.D0 = 1;            % Reference distance
    params.sigmaK2 = db2pow(-80);  % Noise power
    params.gamma = db2pow(0);      % SINR threshold
    
    % Path loss exponents
    params.alpha_AI = 2.8;    % AP-IRS path loss exponent
    params.alpha_Iu = 2.8;    % IRS-User path loss exponent
    params.alpha_Au = 3.5;    % AP-User path loss exponent
    
    % Rician factors
    params.beta_Au = 0;           % AP-User Rician factor
    params.beta_AI = db2pow(10);  % AP-IRS Rician factor (3dB)
    params.beta_Iu = db2pow(10);  % IRS-User Rician factor (3dB)
    
    % Path loss function
    L = @(d, alpha) params.C0*(d/params.D0)^(-alpha);
end