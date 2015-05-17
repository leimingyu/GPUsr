function  prop_output = train_samples(observations, hmm_prop)

prop_output = word_hmm();

N       = hmm_prop.N; % N=3 hidden states
prior   = hmm_prop.prior;
A       = hmm_prop.A;
mu      = hmm_prop.mu;
Sigma   = hmm_prop.Sigma;
Name    = hmm_prop.name;

D = size(observations, 1);  % feature dimension(number of features) f1-f6
T = size(observations, 2);  % time window number
    

B = zeros(N, size(observations, 2));
    

for s = 1:N
    B(s, :) = mvnpdf(observations', mu(:, s)', Sigma(:, :, s));
end


% Forward algorithm
log_likelihood = 0;
% Forward probability: the prob for an HMM generates the observed sequences
alpha = zeros(N, T);                                                       

for t = 1:T
    if t == 1
        % Initialization
        alpha(:, t) = B(:, t) .* prior;
    else
        % Induction
        % based on previous probability, 
        % add on Transmission and Emission Probability
        alpha(:, t) = B(:, t) .* (A' * alpha(:, t - 1));	                
    end
    % Scaling
    alpha_sum      = sum(alpha(:, t));
    % Upate current state probability
    alpha(:, t)    = alpha(:, t) ./ alpha_sum; 
    log_likelihood = log_likelihood + log(alpha_sum);
end





% display(sprintf('log_likelihood = %f',log_likelihood));

% Backward algorithm
beta = zeros(N, T);

beta(:, T) = ones(N, 1);
for t = (T - 1):-1:1
    % Induction
    beta(:, t) = A * (beta(:, t + 1) .* B(:, t + 1));
    % Scaling
    beta(:, t) = beta(:, t) ./ sum(beta(:, t));
end
    
    
% E-Step
xi_sum = zeros(N, N);
gamma  = zeros(N, T);
for t = 1:(T - 1)
    xi_sum      = xi_sum + normalise(A .* (alpha(:, t) * (beta(:, t + 1) .* B(:, t + 1))'));
    gamma(:, t) = normalise(alpha(:, t) .* beta(:, t));
end
gamma(:, T) = normalise(alpha(:, T) .* beta(:, T));
    

expected_prior = gamma(:, 1);
expected_A     = mk_stochastic(xi_sum);
expected_mu    = zeros(D, N);
expected_Sigma = zeros(D, D, N);
gamma_state_sum = sum(gamma, 2);
gamma_state_sum = gamma_state_sum + (gamma_state_sum == 0);

for s = 1:N
  gamma_observations = observations .* repmat(gamma(s, :), [D 1]);
  expected_mu(:, s)  = sum(gamma_observations, 2) / gamma_state_sum(s); 
  % Using Sigma = E(X * X') - mu * mu', make sure it's symmetric
  expected_Sigma(:, :, s) = symmetrize(gamma_observations * observations' / gamma_state_sum(s) - ...
  expected_mu(:, s) * expected_mu(:, s)');	% updated covariance
end
    
% Ninja trick to ensure positive semidefiniteness
expected_Sigma = expected_Sigma + repmat(0.01 * eye(D, D), [1 1 N]);
     
% M-step
prior = expected_prior;
A     = expected_A;
mu    = expected_mu;
Sigma = expected_Sigma;

prop_output.prior = prior;
prop_output.A = A;
prop_output.mu = mu;
prop_output.Sigma = Sigma;
prop_output.name = Name;

end

