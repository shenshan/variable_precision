function prediction = computePredGuessing(pred_in,guess)
%COMPUTEPREDGUESSING Computes prediction table with guessing 
%   pred_in is the input prediction table without guessing, guess is a
%   vector for guessing rate

sz = size(pred_in);
guess_adj = repmat(permute(guess,[1,3:1+length(sz),2]),[sz,1]);

prediction = bsxfun(@times,pred_in,1-guess_adj) + 0.5*guess_adj;

