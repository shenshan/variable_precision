function response = addLapseTrials(response,guess)
%ADDLAPSETRIALS function response = addLapseTrials(response,guess)
% add lapse trials with a rate of "guess" to the response
% SS 04-21-16
%   response is a vector with values 1 or -1, guess is a number from 0 to 1

idx = rand(size(response))<guess;
response = idx .* (2*randi(2,size(response))-3) + (1-idx) .* response;
