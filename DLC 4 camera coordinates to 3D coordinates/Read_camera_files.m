%%%% READS CSV FILES PRODUCED BY DLC TRACKING AND COMBINES THEM INTO A
%%%% 1X number of cameras cell array


%select the directory to analyse
directory_to_3D_reconstruct = dir('C:\Users\mfbx5lg2\OneDrive - The University of Manchester\PhD project\Code\Calibration_Ric\Calibration_Ric2\reconstruct_directory_2\*.csv');

%% input the number of tracked landmarks
nuL = 5;
%% set the likelyhood limit
likehood= 0.90;

%iterate over the files
for m=1:numel(directory_to_3D_reconstruct)
%convert to array
    T = readtable(directory_to_3D_reconstruct(m).name, 'HeaderLines', 3);
    T= table2array(T);
    %% where likelyhood is over the threshold put 1 otherwise 0
    for n=1:nuL
        T(:,n+n*2+1)=T(:,n+n*2+1)>likehood;
        %%%IN THEORY THERE COULD BE X AND Y VALUES WHICH ARE 0 SO THIS
        %%%NEEDS TO BE CHANGED FOR SPECIFIC LIKELYHOOD COLUMNS
        T(T==0)=NaN;
    end
    %delete frame column
    T(:,1)=[];
    multi_camera_data{m} = T';
    clear T
end

save('multi_camera_data.mat', 'multi_camera_data')
