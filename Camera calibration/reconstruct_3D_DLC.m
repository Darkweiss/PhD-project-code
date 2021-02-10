function[] = reconstruct_3D_DLC()
%load label data
load('multi_camera_data');
Np = 5;  %number of body landmarks
Ncam = 4; %number of cameras
n_frames =numel(multi_camera_data{1}(1,:));
%n_frames = 100;
%transform data format
x_multi = cell(1,Np);
good_camera = true(Np,Ncam);



for u = 1:n_frames
    for n = 1:Np
        for m = 1:Ncam           
            x_multi{n}(:,m) = multi_camera_data{m}((n*3-2):(n*3),u);
            if isnan(multi_camera_data{m}(n*3,u))
                good_camera(n,m) = false;
            end
        end
    end
    %triangulate
    load('Pcal_rp.mat','P');
    for n = 1:Np
        ind_ok = find((good_camera(n,:)));
        X(:,n) = ls_triangulate(x_multi{n}(:,ind_ok),P(ind_ok));
    end
    x_multi = cell(1,Np);
    good_camera = true(Np,Ncam);
    stored_3D_coordinates{u}=X;
    u
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%FIGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig = figure; set(fig,'Position',[100 100 900 400]);
%
subplot(1,2,1); hold on;
cval = 'rbcgmy';

frame= 162;
for n = 1:Np
    if sum([stored_3D_coordinates{frame}(1,n),stored_3D_coordinates{frame}(2,n),stored_3D_coordinates{frame}(3,n)])~=0
        plot3(stored_3D_coordinates{frame}(1,n),stored_3D_coordinates{frame}(2,n),stored_3D_coordinates{frame}(3,n),'.','MarkerSize',15,'Color',cval(n));
    end
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
    plot3(stored_3D_coordinates{frame}(1,n),stored_3D_coordinates{frame}(2,n),stored_3D_coordinates{frame}(3,n),'.','MarkerSize',15,'Color',cval(n));
end
grid on; 
mx = mean(X(1,:)); my = mean(X(2,:));
xlim([-10 10]+mx); ylim([-10 10]+my); zlim([-1 15]);
view(0,90); 
xlabel('X','FontSize',14); ylabel('Y','FontSize',14); zlabel('Z','FontSize',14);