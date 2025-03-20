clc
clear
epsilon = 1e-4;

% Get path loss model and parameters
[L, params] = PathLossModel();
d0 = params.d0;
dv = params.dv;
sigmaK2 = params.sigmaK2;
alpha_AI = params.alpha_AI;
alpha_Iu = params.alpha_Iu;
alpha_Au = params.alpha_Au;
beta_IU = params.beta_IU;

% System parameters
M = 10; 
N = 70; 
d = 60;
frame = 3;

% Define power range (dBm)
P_dBm = 30:5:50;
P_linear = db2pow(P_dBm);

% Initialize sum rate arrays
R_sdr = zeros(length(P_dBm),1); % SDR
R_lb = zeros(length(P_dBm),1); % Lower bound
R_random = zeros(length(P_dBm),1); % Random phase
R_wo_irs = zeros(length(P_dBm),1); % Without IRS
R_ao = zeros(length(P_dBm),1); % AO

for i = 1:length(P_dBm)
    fprintf('Current transmit power: %d dBm\n', P_dBm(i));  
    for j = 1:frame
        fprintf('Current frame: %d\n', j);
        
        d1 = sqrt(d(1)^2+dv^2);
        d2 = sqrt((d0-d(1))^2+dv^2);
        
        G = sqrt(L(d0,alpha_AI))*ones(N,M);
        hr = sqrt(L(d2,alpha_Iu)/(2*sigmaK2))*(randn(1,N)+1i*randn(1,N));
        hd = sqrt(L(d1,alpha_Au)/(2*sigmaK2))*(randn(1,M)+1i*randn(1,M));
        
        % SDR-based solution
        [v_sdr, lower_bound] = SDR_solving2(hr, G, hd, N, P_linear(i));
        R_sdr(i) = R_sdr(i) + log2(1 + P_linear(i)*norm(v_sdr'*(diag(hr)*G)+hd)^2);
        R_lb(i) = R_lb(i) + log2(1 + P_linear(i)*lower_bound);
        
        % Alternating optimization
        [v_ao, w_ao] = AO2(hd,hr,G,epsilon,P_linear(i));
        R_ao(i) = R_ao(i) + log2(1 + P_linear(i)*norm((v_ao.'*(diag(hr)*G)+hd)*w_ao)^2);
        
        % Random phase shifts
        theta_random = 2*pi*rand(1,N);
        V_random = diag(exp(1i*theta_random));
        R_random(i) = R_random(i) + log2(1 + P_linear(i)*norm(hr*V_random*G+hd)^2);
        
        % Without IRS
        R_wo_irs(i) = R_wo_irs(i) + log2(1 + P_linear(i)*norm(hd)^2);
    end
end

% Average over frames
R_sdr = R_sdr / frame;
R_lb = R_lb / frame;
R_random = R_random / frame;
R_wo_irs = R_wo_irs / frame;
R_ao = R_ao / frame;

% Plot results
plot(P_dBm, R_sdr, 'g-','LineWidth',2.5)
hold on
plot(P_dBm, R_lb, 'mo-','LineWidth',1)
plot(P_dBm, R_random, 'kp:','LineWidth',2)
plot(P_dBm, R_wo_irs, 'ks:','LineWidth',2)
plot(P_dBm, R_ao, 'b:','LineWidth',2)
xlabel('Transmit power (dBm)')
ylabel('Sum rate (bps/Hz)')
grid on
legend('SDR','Lower bound','Random phase shift','Without IRS','Alternating optimization','location','best')