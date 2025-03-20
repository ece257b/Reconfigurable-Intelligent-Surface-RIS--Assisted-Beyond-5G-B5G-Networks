clear all
close all
clc 

Uk = 4; % Number of users 
epsilon = 1e-3; % Convergence threshold

% Get path loss model and parameters
[L, params] = PathLossModel2();
d0 = params.d0;
dv = params.dv;
d1 = params.d1;
d2 = params.d2;
sigmaK2 = params.sigmaK2;
gamma = params.gamma;
alpha_AI = params.alpha_AI;
alpha_Iu = params.alpha_Iu;
alpha_Au = params.alpha_Au;
beta_Au = params.beta_Au;
beta_AI = params.beta_AI;
beta_Iu = params.beta_Iu;

% Calculate distances and angles
d_Au = [d1; sqrt((d0-d2*cos(2*pi/5))^2+(d2*sin(2*pi/5)^2));d1;sqrt((d0-d2*cos(pi/5))^2+(d2*sin(pi/5)^2))];
theta_Au = [7*pi/4;2*pi-atan(d2*sin(2*pi/5)/(d0-d2*cos(2*pi/5)));pi/4;2*pi-atan(d2*sin(pi/5)/(d0-d2*cos(pi/5)))];
d_Iu = [sqrt((d0-d1*cos(pi/4))^2+(d1*sin(pi/4)^2));d2;sqrt((d0-d1*cos(pi/4))^2+(d1*sin(pi/4)^2));d2];
theta_Iu = [atan(d1*sin(pi/4)/(d0-d1*cos(pi/4)));2*pi/5;-atan(d1*sin(pi/4)/(d0-d1*cos(pi/4)));pi/5];

% System parameters
M = 4;
Nx = 5;
Ny = 6;
N = Nx*Ny;

G = sqrt(L(d0,alpha_AI))*(sqrt(beta_AI/(1+beta_AI))*ones(N,M)+sqrt(1/(1+beta_AI))*((randn(N,M)+1i*randn(N,M)/sqrt(2)))); % Channel matrix between AP and IRS
Hr = zeros(N,Uk);
Hd = zeros(M,Uk);
for i=1:Uk
    Hr(:,i) = sqrt(L(d_Iu(i),alpha_Iu)/sigmaK2)*(sqrt(beta_Iu/(1+beta_Iu))*URA_sv(theta_Iu(i),0,Nx,Ny)+sqrt(1/(1+beta_Iu))*((randn(N,1)+1i*randn(N,1)/sqrt(2)))); % IRS-User channel
    Hd(:,i) = sqrt(L(d_Au(i),alpha_Au)/sigmaK2)*((randn(M,1)+1i*randn(M,1)/sqrt(2))); % AP-User channel
end

theta = 2*pi*rand(1,N); % Initial random IRS phase shifts
Theta = diag(exp(1i*theta));

H = zeros(Uk,M);
P_old = 0 ;
P_new = 100;
maxIter = 30;
P = zeros(maxIter);
count = 0;
% 修改功率计算和存储
while(abs(P_old-P_new)>epsilon && count < maxIter)
    count = count + 1;
    for i=1:Uk 
        H(i,:) = Hr(:,i)'*Theta*G+Hd(:,i)';
    end
    W = PMQoSSOCP(H, gamma,M,Uk);
    P_opt = norm(W,'fro')^2;  % 移除pow2db
    P(count) = P_opt;
    P_old = P_new;
    P_new = P_opt;
    v = IRS_MultiUser(W,Hr,Hd,G,N,Uk,gamma);
    Theta = diag(v');   
end



% Use AO function
[P_final, iter_count, P_history] = AO_MultiUser(Hr, Hd, G, epsilon, gamma, Uk, M, N);

% Compare SDR and AO convergence
[P_final_sdr, iter_count_sdr, P_history_sdr] = SDR_MultiUser(Hr, Hd, G, epsilon, gamma, Uk, M, N);
[P_final_ao, iter_count_ao, P_history_ao] = AO_MultiUser(Hr, Hd, G, epsilon, gamma, Uk, M, N);

% Plot comparison


figure;

plot(1:count,pow2db(P(1:count)),'-^k','LineWidth',2);
hold on;
plot(1:length(P_history_ao), P_history_ao, '-or', 'LineWidth', 2);
xlabel('Number of iterations');
ylabel('Transmit power at the AP (dBm)');
grid on;
legend('SDR', 'AO', 'Location', 'best');


fprintf('AO iterations: %d, Final power: %.2f dBm\n', iter_count_ao, P_final_ao);
fprintf('SDR iterations: %d, Final power: %.2f dBm\n', count, pow2db(P_new));
fprintf('Total iterations: %d\n', iter_count);
fprintf('Final transmit power: %.2f dBm\n', P_final);