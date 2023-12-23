%% load data

close all; clear;

% load dataset
load fluttering_eyelashes.mat

% plot 3rd trail
figure(1), clf
plot(timevec,EEGdat(:, 3), timevec,eyedat(:, 3),'linew',1)
legend({'EEG (raw)';'EOG'})
xlabel('Time (ms)')
ylabel('Amplitude [a.u.]')

%% find the regression coefficients and residual

% initialize residual data
resdat = zeros(size(EEGdat));

% loop over trials (resdat)
for trial_i=1:size(resdat,2)
    
    % build the least-squares model
    X = [ ones(npnts,1) eyedat(:,trial_i) ];
    
    % compute regression coefficients for EEG trials
    b = (X'*X) \ (X'*EEGdat(:,trial_i));
    
    % predicted data
    y_hat = X*b;
    
    % new data are the residuals after projecting out the best EKG fit
    resdat(:,trial_i) = ( EEGdat(:,trial_i) - y_hat )';
end
%% brute-force-cleaning-service

% initialize rude-brute-data
rudedat = zeros(size(EEGdat));
% loop over trials (rudedat)
for trial_i=1:size(rudedat,2)
    % new data are the residuals after projecting out the best EKG fit
    rudedat(:,trial_i) = ( EEGdat(:,trial_i) - eyedat(:,trial_i) )';
end

%% plot the all-right 3nd trial data
figure(2), clf
plot(timevec,eyedat(:, 3), timevec,EEGdat(:, 3), timevec,resdat(:, 3),'linew',1)
legend({'EOG';'EEG (raw)';'EEG (cleared)'})
title('Least-squares template-matching result for 3rd trial')
xlabel('Time (ms)')
ylabel('Amplitude [a.u.]')

%% plot the rude-brute-3rd data trial
figure(3), clf
plot(timevec,eyedat(:, 3), timevec,EEGdat(:, 3), timevec,rudedat(:, 3),'linew',1)
legend({'EOG';'EEG (raw)';'EEG (cleared)'})
title('Rude result for 3rd trial')
xlabel('Time (ms)')
ylabel('Amplitude [a.u.]')
%% plot the average all-right data

% trial averages
figure(4), clf
plot(timevec,mean(eyedat,2), timevec,mean(EEGdat,2), timevec,mean(resdat,2),'linew',2)
legend({'EOG';'EEG (raw)';'EEG (cleared)'})
title('Least-squares template-matching result averaged')
xlabel('Time (ms)')
ylabel('Amplitude [a.u.]')
%% plotting the average rude-brute-data

% trial averages
figure(5), clf
plot(timevec,mean(eyedat,2), timevec,mean(EEGdat,2), timevec,mean(rudedat,2),'linew',2)
legend({'EOG';'EEG (raw)';'EEG (cleared)'})
title('Rude result averaged')
xlabel('Time (ms)')
ylabel('Amplitude [a.u.]')
%% all amplitudes in trial-time thingy
% show all trials in a map
clim = [-1 1]*20;

figure(3), clf
subplot(131)
imagesc(timevec,[],eyedat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('EOG')

subplot(132)
imagesc(timevec,[],EEGdat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('EEG (raw)')

subplot(133)
imagesc(timevec,[],resdat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('EEG (cleared)')

%% done.
