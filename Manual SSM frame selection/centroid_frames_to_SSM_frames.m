%%%%%%%%%% code for selecting and readjusting frames for the SSM%%%%%%%%%%%
%% load the data and get idx of random frames
SSM_frames = 3; %%number of frames to extract
Ncam = 4; %num cameras
Np =5; %number of body landmarks
TH = -0.8; % set the threshold for centroid tracking

%% select a number of frames(SSM_frames) on random
%it is important track_mouse_box_rp.m has already been run and all the
%files are saved as camera[number]_test_track.mat

%select the centroid frames from all cameras
for i = 1:Ncam
    load (['camera' num2str(i) '_test_track']);
    frame_id= segment_tracks(bright_th,TH,0);
    centroid_frames{i} = cell2mat(frame_id);
end

%select the overlapping frames
overlap=intersect(intersect(centroid_frames{1}, centroid_frames{2}),intersect(centroid_frames{3}, centroid_frames{4}));

%get random indicies and select SSM_frames number of frames from the
%overlapped frames
idx=randperm(numel(overlap));
random_frames=overlap(idx(1:SSM_frames));

%% read videos and DLC coordinates
%coordinates{n} contains DLC data by frames; n= camera number 
likelyhood_idx =3:3:Np*3;
coordinates={};
for n = 1:Ncam
    obj(n) = VideoReader(['camera' num2str(n) '_test.avi']);
    coordinates{n}=readmatrix(['camera' num2str(n) '_DLC.csv']);
    coordinates{n}(:,1)=[];%delete frame numbers
    coordinates{n}(:,[likelyhood_idx])=[];%delete likelyhood
end

%% plot the random frames and adjust the body landmarks
% if the landmarks are good click with the mouse if they are bad press any
% key and then readjust them
fig = figure;
%h = subplot(1,1,1);
cval = 'rbcgmy';
txt=({'mouse click = I want to correct a landmark'; 'keyboard press = Happy with the landmarks'});

for n=1:SSM_frames %iterate over frames
    for m=1:Ncam %iterate over cameras
        %subplot(h);cla;
        imshow(read(obj(m),random_frames(1,n)))
        hold on;        
        landmarks =zeros(Np,2); %%%make a matrix to store the landmark coordinates for this camera
        for u=1:Np
            plot((coordinates{m}(random_frames(1,n),u*2-1)),(coordinates{m}(random_frames(1,n),u*2)), '.','MarkerSize',15,'Color',cval(u)); %% plot landmarks
            text(1000,100,txt)%%?????
            landmarks(u,1)=coordinates{m}(random_frames(1,n),u*2-1);
            landmarks(u,2)=coordinates{m}(random_frames(1,n),u*2);
        end
        legend('snout', 'left ear', 'right ear', 'neck base', 'tail base', 'Location', 'northwest')

        new_coordinates{m}(n,:)=coordinates{m}(random_frames(n),:); %get landmarks for the specific camera frame
        
        w=0;
        while w==0
            w=waitforbuttonpress; %%if mouse click the image is bad, if keyboard press the image is good or all landmarks have been corrected
            if w==1% stop if keyboard press
                break
            end
            [idxselect,idyselect] = ginput(1); %% click on a point to relabel
            select=[idxselect',idyselect'];
            distances=sqrt(sum(bsxfun(@minus,landmarks,select).^2,2)); %% calculate the distance between select and landmarks
            landmark_index = find(distances==min(distances));%% find the index of the landmark
            
            ii = waitforbuttonpress;
            if ii==0
                [idx,idy] = ginput(1);
                x = [idx'; idy'];
            else
                x = NaN*ones(2,1);
            end
            new_coordinates{m}(n, landmark_index*2-1)=x(1,1); %save x and y coordinates for newly positioned landmarks
            new_coordinates{m}(n, landmark_index*2)=x(2,1);
            
            plot(x(1,1),x(2,1),'.','MarkerSize',15,'Color','y')
        end % end while loop       
    end % end camera iteration
end %end frame iteration

%% save the data
save('data_for_SSM', 'new_coordinates')
