clc
clear
epsilon = 1e-4; % Convergence threshold

% Get path loss model and parameters
[L, params] = PathLossModel();
d0 = params.d0;
dv = params.dv;
sigmaK2 = params.sigmaK2;
gamma = params.gamma;
alpha_AI = params.alpha_AI;
alpha_Iu = params.alpha_Iu;
alpha_Au = params.alpha_Au;
beta_IU = params.beta_IU;

% System parameters
M = 10; % Number of AP antennas
N = 40; % Number of RIS elements
d = 60:5:100; % Sum rate (bps/Hz)
frame = 5;

% Initialize arrays
P1 = zeros(length(d),1); % SDR
P4 = zeros(length(d),1); % Lower bound
P5 = zeros(length(d),1); % Random phase
P6 = zeros(length(d),1); % Without IRS
P7 = zeros(length(d),1); % AO

for i = 1:length(d)
    fprintf('Sum rate (bps/Hz): %d ', d(i));
    d1 = sqrt(d(i)^2+dv^2); 
    d2 = sqrt((d0-d(i))^2+dv^2);
    for j = 1:frame
        fprintf('Current frame: %d\n', j);
        
        G = sqrt(L(d0,alpha_AI))*ones(N,M);
        hr = sqrt(L(d2,alpha_Iu)/(2*sigmaK2))*(randn(1,N)+1i*randn(1,N));
        hd = sqrt(L(d1,alpha_Au)/(2*sigmaK2))*(randn(1,M)+1i*randn(1,M));
        
        % SDR-based optimal solution
        [v, lower_bound] = SDR_solving(hr, G, hd, N);
        P_opt = gamma/(norm(v'*(diag(hr)*G)+hd)^2);
        P1(i) = P1(i) + P_opt;
        P4(i) = P4(i) + gamma / lower_bound;

        % Alternating optimization
        P_AO = AO(hd,hr,G,epsilon,gamma);
        P7(i) = P7(i) + P_AO;

        % Random phase shifts
        theta = 2*pi*rand(1,N);
        Theta = diag(exp(1i*theta));
        P_rand = gamma / (norm(hr*Theta*G+hd)^2);
        P5(i) = P5(i) + P_rand;

        % Without IRS
        P6(i) = P6(i) + gamma / (norm(hd)^2);
    end
end

% Average over frames
P1 = pow2db(P1 / frame);
P4 = pow2db(P4 / frame);
P5 = pow2db(P5 / frame);
P6 = pow2db(P6 / frame);
P7 = pow2db(P7 / frame);

% Plot results
plot(d, P1, 'g-','LineWidth',2.5)
hold on
plot(d, P4, 'mo-','LineWidth',1)
plot(d, P5, 'kp:','LineWidth',2)
plot(d, P6, 'ks:','LineWidth',2)
plot(d, P7, 'b:','LineWidth',2)
xlabel('Sum rate (bps/Hz)')
ylabel('Transmit power at the AP (dBm)')
grid on
legend('SDR','Lower bound','Random phase shift','Without IRS','Alternating optimization','location','best')