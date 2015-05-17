function framefrequencies = extract_features(sound)
% 
% extract frequency peaks from each frame of sound
%

    Fs = 16000; % sampling frequency , 16k
    framesize = 128;
    overlap = 96;
    D = 6; % Number of frequencies stored from each signal frame

    frames = buffer(sound, framesize, overlap);
    w = hamming(framesize);
    [~, N] = size(frames);
    framefrequencies = zeros(D, N);

    i = 1;
    NFFT = 2^nextpow2(framesize);
    for frame = frames
        x = frame .* w;
        X = fft(x, NFFT)/framesize; % fast fourier transform
        f = Fs/2*linspace(0, 1, NFFT/2 + 1);

        % Finding local maxima in single-sided amplitude spectrum
        [~, peaklocations] = findpeaks(abs(X(1:(NFFT/2 + 1))), 'SORTSTR', 'descend');

        if isempty(peaklocations)
            peaklocations = ones(D, 1);
        elseif length(peaklocations) < D
            peaklocations = padarray(peaklocations, D - length(peaklocations), 1, 'post');
        end

        framefrequencies(:, i) = f(peaklocations(1:D))';
        i = i + 1;
    end
end






