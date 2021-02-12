function[] = plot_3D_pose_rp(which_frame)
load('data_3D_raw.mat')
Np = numel(X);
for n = 1:Np
    Y(n,:) = X{n}(1:3,which_frame)';
end
line_color = 'k';
cval = 'rbbgykc';
figure; h = subplot(1,1,1); hold on;
for n = 1:Np
    plot3(Y(n,1),Y(n,2),Y(n,3),'.','MarkerSize',15,'Color',cval(n));
end
line([Y(1,1) Y(2,1)],[Y(1,2) Y(2,2)],[Y(1,3) Y(2,3)],'Color',line_color,'LineWidth',2);
line([Y(1,1) Y(3,1)],[Y(1,2) Y(3,2)],[Y(1,3) Y(3,3)],'Color',line_color,'LineWidth',2);
line([Y(2,1) Y(4,1)],[Y(2,2) Y(4,2)],[Y(2,3) Y(4,3)],'Color',line_color,'LineWidth',2);
line([Y(3,1) Y(4,1)],[Y(3,2) Y(4,2)],[Y(3,3) Y(4,3)],'Color',line_color,'LineWidth',2);
line([Y(4,1) Y(5,1)],[Y(4,2) Y(5,2)],[Y(4,3) Y(5,3)],'Color',line_color,'LineWidth',2);
xlabel('X'); ylabel('Y'); zlabel('Z');
view([90 30]); 
%view([0 90]); 
%view(45,0)
xlim([-30 30]); ylim([-30 30]); zlim([-10 30]); 
