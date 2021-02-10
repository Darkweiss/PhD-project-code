function[] = reconstruct_3D_images(which_image)
%show labelled images
figure; title('Camera1');
imshow(imread(['sample_images/camera1_image' num2str(which_image) '.tif']));
figure;  title('Camera4');
imshow(imread(['sample_images/camera4_image' num2str(which_image) '.tif']));
%load label data
load(['sample_images/image' num2str(which_image) '_data'],'x');
Np = 6;  %number of body landmarks
Ncam = 4; %number of cameras
%transform data format
x_multi = cell(1,Np);
good_camera = true(Np,Ncam);
for n = 1:Np
    for m = 1:Ncam
        x_multi{n}(:,m) = x{m}(:,n);
        if isnan(x{m}(1,n))
            good_camera(n,m) = false;
        end
    end
end
%triangulate
load('Pcal_rp.mat','P');
for n = 1:Np
    ind_ok = find(good_camera(n,:));
    X(:,n) = ls_triangulate(x_multi{n}(:,ind_ok),P(ind_ok));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%FIGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig = figure; set(fig,'Position',[100 100 900 400]);
%
subplot(1,2,1); hold on;
cval = 'rbcgmy';
for n = 1:Np
    plot3(X(1,n),X(2,n),X(3,n),'.','MarkerSize',15,'Color',cval(n));
end
grid on; 
mx = mean(X(1,:)); my = mean(X(2,:));
xlim([-10 10]+mx); ylim([-10 10]+my); zlim([-1 15]);
view(10,20); 
xlabel('X','FontSize',14); ylabel('Y','FontSize',14); zlabel('Z','FontSize',14);
%
subplot(1,2,2); hold on;
cval = 'rbcgmy';
for n = 1:Np
    plot3(X(1,n),X(2,n),X(3,n),'.','MarkerSize',15,'Color',cval(n));
end
grid on; 
mx = mean(X(1,:)); my = mean(X(2,:));
xlim([-10 10]+mx); ylim([-10 10]+my); zlim([-1 15]);
view(0,90); 
xlabel('X','FontSize',14); ylabel('Y','FontSize',14); zlabel('Z','FontSize',14);