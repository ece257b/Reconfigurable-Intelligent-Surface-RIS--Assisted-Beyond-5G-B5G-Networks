function [L, params] = PathLossModel()
    % Initialize path loss model parameters
    params.d0 = 20;        % Distance between AP and IRS
    params.dv = 1;         % Vertical distance
    params.C0 = db2pow(-30); % Path loss at reference distance
    params.D0 = 1;         % Reference distance
    params.sigmaK2 = db2pow(-80); % Noise power
    params.gamma = db2pow(10);    % SINR threshold 10dB
    
    % Path loss exponents
    params.alpha_AI = 2.2;  % AP-IRS path loss exponent
    params.alpha_Iu = 2.2;  % IRS-User path loss exponent
    params.alpha_Au = 5;    % AP-User path loss exponent
    params.beta_IU = 0;     % Rician factor for IRS-User channel
    
    % Path loss function
    L = @(d, alpha) params.C0*(d/params.D0)^(-alpha);
end