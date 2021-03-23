function[idx, idy, bright_th] = track_mouse_box_rp(fname, fname_bg, usefilt, graph)
%Use:
%track_mouse_box_rp('camera1', 'camera1_bg', False, True)

block_size = 100; %num images per block

%get images filenames
filename = [fname '.avi'];
filename_bg = [fname_bg '.tif'];
filesave_track = [fname '_track'];

%load the movie and movie parameters
obj = VideoReader(filename);
Nx = obj.Width; Ny = obj.Height;
N = obj.NumFrames;
Nblock = ceil(N/block_size); %num block of images

%define two filters respectively for colour and silouhette smoothing
Nmask = 15; 
wind = gausswin(Nmask)*gausswin(Nmask)';
wind = wind/sum(wind(:));

%load background
mx = imread(filename_bg);
mx = mean(mx,3);
mx = mx/mean(mx(:));
if usefilt
    mx = filter2(wind,mx); 
end

%init indexes and pixelcount
idx = zeros(1,N); idy = zeros(1,N);
bright_th = zeros(1,N);

%scan all images
for nb = 1:Nblock
    
    %load a block of frames
    id_frame = [(nb-1)*block_size+1 nb*block_size];
    if nb*block_size > N
       id_frame(2) = N;
       block_size1 = diff(id_frame+1);
    else
       block_size1 = block_size;
    end
    x0 = read(obj, id_frame); 
    
    %image extraction & filtering
    for m = 1:block_size1
        n = (nb-1)*block_size+m;
        %normalize image
        x = mean(double(squeeze(x0(:,:,:,m))),3);
        x = x/mean(x(:));
        if usefilt
            x = filter2(wind,x); 
        end
        %subtract background
        x = x-mx; 
        %brightness threshold (look for dark object)
        bright_th(n) = quantile(x(:),0.01);
        xs = double(x<bright_th(n));
        %get marker position & pixel count
        [idxtemp,idytemp] = find(xs==1);
        idx(n) = median(idxtemp); 
        idy(n) = median(idytemp);
        %pix_cnt(n) = sum(xs(:));
        %figure
        if graph           
            imshow(rgb2gray(squeeze(x0(:,:,:,m)))); 
            hold on;
            plot(idy(n),idx(n),['.g'],'MarkerSize',12);
            title(sprintf('frame %s, brightTH: %s',num2str(n),num2str(bright_th(n))));
            drawnow; pause(0.01); 
        end
        %shell display
        disp(sprintf('frame %s',num2str(n)));
    end
    %clear
    if graph
       clf
    end
end

%save
clear obj;
save(filesave_track,'idy','idx','bright_th');
