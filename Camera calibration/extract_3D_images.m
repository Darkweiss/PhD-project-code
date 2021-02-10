function[] = extract_3D_images()
frame_id = [7000];
Nframe = numel(frame_id);
Ncam = 4; %num cameras
for n = 1:Ncam
    obj(n) = VideoReader(['camera' num2str(n) '_test.avi']);
end
fig = figure; h = subplot(1,1,1);
Np = 6; cval = 'rbcgmy';
disp('tu')
for n =1:Nframe
    x = [];
    for m = 1:Ncam
        %camera1
        subplot(h); cla;
        imshow(read(obj(m),frame_id(n)));
        hold on;
        try
            [idy,idx] = ginput(Np);
            for p = 1:Np
                plot(idy(p),idx(p),'.','Color',cval(p),'MarkerSize',15);
            end   
            x{m} = [idx'; idy'; ones(1,Np)];
            saveas(fig,['sample_images_2/camera' num2str(m) '_image' num2str(n) '.tif'],'tif');
        catch
            x{m} = NaN*ones(3,Np);
            fig = figure; h = subplot(1,1,1);
        end
    end
    save(['sample_images_2/image' num2str(n) '_data'],'x');
end

