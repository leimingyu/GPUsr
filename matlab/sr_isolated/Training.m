%% Training

% Reference: isolated-word speech recognition using Hidden Markov Model 
% by Håkon Sandsmark , Dec 2010

 
clear
clc

[audio_signals, word_labels] = load_audio_from_folder('database');
[unique_word_labels, ~, indices] = unique(word_labels);

wordHMMs = word_hmm(1,size(unique_word_labels,2));

%%

display(sprintf('Training ...'));

for i = 1:length(unique_word_labels)

    w = word_hmm(); % set up properties
    w.name = char(unique_word_labels(i));
    display(sprintf('Training on ''%s''...', w.name));
    
    org_word = audio_signals(indices==i);

    % trucate the different length of words to the same (min) length
    % put all the training samples into one
    sample1 = trimSig(org_word);
    sample1 = sample1';
    sample_ele = size(sample1,1) * size(sample1,2);
    sample = reshape(sample1,1,sample_ele);
    
    % noise cancellation ???
    
    % feature extraction
    observations = extract_features(sample);
    
    for j = 1: 15
        if j==1
            w.prior = normalise(rand(w.N, 1));
            w.A     = mk_stochastic(rand(w.N));
            % All states start out with the empirical (diagonal) covariance
            w.Sigma = repmat(diag(diag(cov(observations'))), [1 1 w.N]);
            % Initialize each mean to a random data point
            ind = randperm(size(observations, 2));
            w.mu = observations(:, ind(1:w.N));
        end

        w = train_samples(observations, w);
        
    end
   
    % save HMM for current word
     wordHMMs(i) = w;
end

display(sprintf('Done!'));


