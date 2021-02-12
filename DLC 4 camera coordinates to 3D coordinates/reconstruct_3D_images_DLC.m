function[] = reconstruct_3D_images_DLC()

%%%%%%%%%%%%%%%%%%%%initial parameters%%%%%%%%%%%%%%%%%%%%
Ncam = 4;
Nbp = 5; %number of body landmarks
bp = cell(Ncam,Nbp);
like = cell(Ncam,Nbp);
THlike = 0.9;

%%%%%%%%%%%%%%%%%%%%load the 3d camera calibration%%%%%%%%%
load('Pcal_rp.mat','P');

%%%%%%%%%%%%%%%%%%%load DLC coordinates%%%%%%%%%%%%%%%%%%%%
Ncam = 4;
xcam = [];
for n = 1:Ncam
    %load camera csv file
    temp = csvread(['camera' num2str(n) '_DLC.csv'],3,1);
    %get Nframe (number of frames) and Nbp (number body points)  
    [Nframe,Nbp] = size(temp);
    Nbp = Nbp/3;
    %store bp (body point measures) and like (likelihood)
    %bp: has cameras on cell rows and body points on cell columns
    %like: has cameras on cell rows and body points on cell columns
    for m = 1:Nbp
        bp{n,m} = temp(:,3*(m-1)+1:3*(m-1)+2); %bp coordinates
        like{n,m} = temp(:,3*m); %bp likelihood
    end
end

%THIS FUNCTION: facilitates triangulation by pooling coordinate on each
%frame. Specifically it:
%1) Reformat the dimensions: 
%   FROM bp - cell(Ncam,Nbp), each cell containing Nframe-by-2 points
%   TO bp_t - cell(Nbp,Nframe), each cell containing 3-by-Ncam points 
bp_t = transform_coord(bp);

%THIS FUNCTION: trasnforms like: 
%   FROM like - cell(Ncam,Nbp), each cell containing Nframe-by-1 points
%   TO like_t - cell(Nbp,Nframe), each cell containing 1-by-Ncam points
like_t = transform_like(like);

%THIS FUNCTION: initial raw estimates in homogeneous coordinates. Outputs:
%   Y - cell(1,Nbp), each cell containing 4-by-Nframe points (homogeneous)
%   miss - logic Nbp-by-Nframe matrix, flagging false when <2 cameras have
%          reliable landmarks (reliability defined by like_t)
[X, miss] = reconstruct_3d(bp_t,P,like_t,THlike);

save('data_3D_raw','X','miss');

%%%%%%%%%%%%%%%%%%SUB FUCTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[x] = transform_coord(x0)
[Ncam,Nbp] = size(x0);
Nframe = size(x0{1},1);
x = cell(Nbp,Nframe);
for n = 1:Nbp
    for m = 1:Nframe
        x{n,m} = ones(3, Ncam);
        for p = 1:Ncam
            x{n,m}(1,p) = x0{p,n}(m,2); 
            x{n,m}(2,p) = x0{p,n}(m,1); 
        end
    end
end

function[x] = transform_like(x0)
[Ncam,Nbp] = size(x0);
Nframe = size(x0{1},1);
x = cell(Nbp,Nframe);
for n = 1:Nbp
    for m = 1:Nframe
        x{n,m} = ones(1, Ncam);
        for p = 1:Ncam
            x{n,m}(1,p) = x0{p,n}(m,1); 
        end
    end
end

function[X,miss] = reconstruct_3d(x,P,like,TH)
[Nbp,Nframe] = size(x); %size of both x and like
X = cell(1,Nbp);
miss = false(Nbp,Nframe);
for n = 1:Nbp
    X{n} = zeros(4,Nframe);
    for m = 1:Nframe
        ind = find(like{n,m}>TH); %camera indexes with good likelihood
        if length(ind) >= 2
            X{n}(:,m) = ls_triangulate(x{n,m}(:,ind), P(ind));
        else
            miss(n,m) = true;
        end
    end
    n
end