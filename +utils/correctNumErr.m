function prediction = correctNumErr(prediction, ntrials)
%CORRECTNUMERR corrects numerical error by resetting prediction 0 and to a
%small value or 1 minus that value
%    prediction = correctNumErr(prediction,dim)
%    prediction is the prediction matrix that needs to be corrected
%    ntrials is the number of simulation trials

prediction(prediction==0) = 1/ntrials/10;
prediction(prediction==1) = 1 - 1/ntrials/10;