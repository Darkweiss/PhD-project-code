function[frame_id] = segment_tracks(bright_th, TH)
N = numel(bright_th); 
bright_th_bin = bright_th<TH;
%
frame_start = [true diff(bright_th_bin)==1];
frame_stop = [false diff(bright_th_bin)==-1];
frame_start(end) = true; 
frame_stop(end) = true;
%
ind_start = find(frame_start);
ind_stop = find(frame_stop);
count = 0;
frame_id = [];
for n = 1:numel(ind_start)-1
    ind_temp = ind_stop(find(ind_stop>ind_start(n),1));
    if ind_temp<=ind_start(n+1)
        count = count+1;
        frame_id{count} = ind_start(n):ind_temp;
    end
end
Nsegment = count;
%
figure;
%
subplot(2,1,1); hold on;
plot(bright_th,'.','MarkerSize',12); 
line([1 N],[TH TH]);
xlim([1 N]); 
xlabel('id frame'); ylabel('bright th');
%
subplot(2,1,2); hold on;
for n = 1:Nsegment
    line([frame_id{n}(1) frame_id{n}(end)],[1 1],'LineWidth',2,'Color',rand(1,3));
end
xlim([1 N]); ylim([0 2]);
xlabel('id frame'); ylabel('mouse visible');
