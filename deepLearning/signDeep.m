clear();
clc();

baseDir = '/opt/dataset/FullIJCNN2013'
baseDirGTSRB = '/opt/dataset/GTSRB/Final_Training/Images'

cifar10Data = tempdir;

url = 'https://www.cs.toronto.edu/~kriz/cifar-10-matlab.tar.gz';
helperCIFAR10Data.download(url, cifar10Data);

%% Set FALSE!
doTraining = true
doTrainingBase = false

numImageCategories = 10;

%%
% Part 1: Train Network / inspired by CIFAR-10
%%

% Load the CIFAR-10 training and test data.
[trainingImages, trainingLabels, testImages, testLabels] = helperCIFAR10Data.load(cifar10Data);

%[trainingImages, trainingLabels] = loadTrainingImageBig(baseDirGTSRB);
[testImages, testLabels] = loadTrainingImage(baseDir);


% Show the size of the vector
size(trainingImages)

if doTrainingBase
    
    categories(trainingLabels)

    [height, width, numChannels, ~] = size(trainingImages);

    imageSize = [height width numChannels];

    layers = getNetworkStructure(imageSize, numImageCategories);

    filterSize = [5 5];
    numFilters = 32;

    layers(2).Weights = 0.0001 * randn([filterSize numChannels numFilters]);


    % Set the network training options
    opts = trainingOptions('sgdm', ...
        'Momentum', 0.9, ...
        'InitialLearnRate', 0.001, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropFactor', 0.1, ...
        'LearnRateDropPeriod', 8, ...
        'L2Regularization', 0.004, ...
        'MaxEpochs', 50, ...
        'MiniBatchSize', 128, ...
        'Verbose', true);
    
    % Train a network.
    baseNet = trainNetwork(trainingImages, trainingLabels, layers, opts);
    save('signDetector.mat','baseNet', '-append');
else
    % Load pre-trained detector for the example.
    load('signDetector.mat','baseNet');
end

YTest = classify(baseNet,testImages);
TTest = testLabels;

%% 
% Calculate the accuracy. 
accuracy = sum(YTest == TTest)/numel(TTest)   


%%
% Part 2: Specialize Network for given Signs
%%

gtFilePath = strcat(baseDir, '/gt.txt')
gtFile = readtable(gtFilePath);


if doTraining

    imgDataset = getCustomDetectorMatrix(baseDir, gtFile);

    % Set training options
    options = trainingOptions('sgdm', ...
        'MiniBatchSize', 128, ...
        'InitialLearnRate', 1e-3, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropFactor', 0.1, ...
        'LearnRateDropPeriod', 100, ...
        'MaxEpochs', 100, ...
        'Verbose', true);

    % Train an R-CNN object detector. This will take several minutes.
    rcnn = trainFastRCNNObjectDetector(imgDataset, baseNet, options, ...
    'NegativeOverlapRange', [0 0.3], 'PositiveOverlapRange',[0.5 1])
    save('signDetector.mat', 'rcnn', '-append')
else
    % Load pre-trained network for the example.
    load('signDetector.mat','rcnn')
end

