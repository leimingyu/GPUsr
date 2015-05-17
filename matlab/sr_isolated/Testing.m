function result = Testing(audiofile, wordHMMs, unique_word_labels)

% Testing('test/banana.wav', wordHMMs, unique_word_labels)

test_signal = wavread(audiofile);
test_obs = extract_features(test_signal); 

ll = zeros(size(wordHMMs));
for i = 1:length(unique_word_labels)
    ll(1,i) = test_samples(test_obs, wordHMMs(1,i));
end


[maxll,maxInd] = max(ll);
target = cell2mat(unique_word_labels(maxInd));
display(sprintf('Recognized word: %s', target));

target = mat2str(target);
strilink = strcat('images/', regexprep(target, '''',''),'.png');
% display(strilink);

ifile = imread( strilink );
image(ifile)

end
