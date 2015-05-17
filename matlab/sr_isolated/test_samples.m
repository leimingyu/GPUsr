function llh = test_samples(test_observ, hmm_prop)
N       = hmm_prop.N;
prior   = hmm_prop.prior;
A       = hmm_prop.A;
mu      = hmm_prop.mu;
Sigma   = hmm_prop.Sigma;


B = zeros(N, size(test_observ, 2));            
for s = 1:N
    B(s, :) = mvnpdf(test_observ', mu(:, s)', Sigma(:, :, s));
end

log_likelihood = 0;
T = size(test_observ, 2);
alpha = zeros(N, T);

for t = 1:T
    if t == 1
        alpha(:, t) = B(:, t) .* prior;
    else
        alpha(:, t) = B(:, t) .* (A' * alpha(:, t - 1));
    end
    
    % Scaling
    alpha_sum      = sum(alpha(:, t));
    alpha(:, t)    = alpha(:, t) ./ alpha_sum;
    log_likelihood = log_likelihood + log(alpha_sum);
end

llh = log_likelihood;
end