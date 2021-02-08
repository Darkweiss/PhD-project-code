function[] = detect_lego_markers_simple_rp(which_camera,which_height)
%load to image 
x0 = imread(['calibration_images\camera' num2str(which_camera) '_lego_h' num2str(which_height) '.tif']);    
%init parameters
Np = 8; Nl = 2; Npl = Np/Nl;
Nmarkers = 50;
%smooth image
[Nrow0,Ncol0] = size(x0(:,:,1));
x0 = double(x0); 
for n = 1:3
    x0(:,:,n) = filter2(ones(3)/9,x0(:,:,n)+20*ones(Nrow0,Ncol0));
end
%reduce to red channel
x0 = x0(:,:,1);

%show image
fig1 = figure; 
imshow(uint8(x0)); hold on;

%detect markers
idx_final = []; idy_final = [];
for n = 1:Np
    title(['Click close point' num2str(n)],'FontSize',12);
    [idy_l,idx_l] = ginput(1);
    plot(idy_l,idx_l,'xr','MarkerSize',15,'LineWidth',2);
    text(idy_l+20,idx_l+20,num2str(n),'FontSize',14,'Color',[0 1 0]);
    idx_final = [idx_final idx_l];
    idy_final = [idy_final idy_l];
end

%save figure with ordered markers
saveas(fig1,['camera' num2str(which_camera) '_lego_h' num2str(which_height) '_marked_rp.tif'],'tif');

%save position data
save(['camera' num2str(which_camera) '_lego_h' num2str(which_height) '_data_rp'],'idx_final','idy_final');