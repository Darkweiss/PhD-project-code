%%plot 3D coordinates as video%%%
load('data_3D_raw.mat')
Np = numel(X);
Fn= 10800; %frame number numel(X{1}(1,:))


line_color = 'k';
cval = 'rbbgykc';
figure; h = subplot(1,1,1);

writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 30;
open(writerObj);


for i=1:Fn
    title(string(i));
    for u = 1:Np
        Y(u,:) = X{u}(1:3,i)';
    end
    for n = 1:Np
%         if sum(miss(:,i))~=0
%             text(0,0,'Whole mouse not in frame')
%             break
%         else
    if sum([Y(n,1),Y(n,2),Y(n,3)])~=0          
            plot3(Y(n,1),Y(n,2),Y(n,3),'.','MarkerSize',15,'Color',cval(n));
            title(string(i));
            hold on
    end
%         end
    if sum([Y(1,1), Y(1,2), Y(1,3)])~=0 && sum([Y(2,1), Y(2,2), Y(2,3)])~=0 && sum([Y(3,1), Y(3,2), Y(3,3)])~=0
        line([Y(1,1) Y(2,1)],[Y(1,2) Y(2,2)],[Y(1,3) Y(2,3)],'Color',line_color,'LineWidth',2); %Link snout with left ear
        line([Y(1,1) Y(3,1)],[Y(1,2) Y(3,2)],[Y(1,3) Y(3,3)],'Color',line_color,'LineWidth',2); %Link snout with right ear
    end
    if sum([Y(2,1), Y(2,2), Y(2,3)])~=0 && sum([Y(3,1), Y(3,2), Y(3,3)])~=0 && sum([Y(4,1),Y(4,2),Y(4,3)])~=0
        line([Y(2,1) Y(4,1)],[Y(2,2) Y(4,2)],[Y(2,3) Y(4,3)],'Color',line_color,'LineWidth',2); %Link left ear with neck base
        line([Y(3,1) Y(4,1)],[Y(3,2) Y(4,2)],[Y(3,3) Y(4,3)],'Color',line_color,'LineWidth',2); %Link right ear with neck base
    end
    
    if sum([Y(4,1),Y(4,2),Y(4,3)])~=0 && sum([Y(5,1), Y(5,2),Y(5,3)])~=0
        line([Y(4,1) Y(5,1)],[Y(4,2) Y(5,2)],[Y(4,3) Y(5,3)],'Color',line_color,'LineWidth',2); %Link neck base with tail base
    end
    end
    xlabel('X'); ylabel('Y'); zlabel('Z');
    view([-44,38]);%camera 093
    %view([140 38]); %camera 385
    %view([90 30]); 
    %view([0 90]); 
    %view(45,0)
    xlim([-30 30]); ylim([-30 30]); zlim([0 30]);
    F = getframe(gcf);
    writeVideo(writerObj, F);
    clear F
    hold off
end

close(writerObj);
% open(writerObj);


% for i=1:length(F)
%     % convert the image to a frame
%     frame = F(i) ;    
%     writeVideo(writerObj, frame);
% end
% clear F

