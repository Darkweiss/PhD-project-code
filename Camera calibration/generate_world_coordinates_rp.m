function[] = generate_world_coordinates_rp()
%generate real world coordinates for Lego(R) objects
%z coordinates from camera 1-4
h0 = [0 3 5 8 10]; 
Nh = length(h0);
%x,y coordinates camera 1-4
y0 = [7 13 20 26 7 13 20 26]; y0 = y0-mean(y0); Ny0 = length(y0); 
x0 = [13 13 13 13 20 20 20 20]; x0 = x0-mean(x0); Nx0 = length(x0);
Np = Nx0*Nh;
%generate all points
X = [];
for h = 1:Nh
    for n = 1:Nx0
        X = [X [x0(n); y0(n); h0(h); 1]];
    end
end

%fig
figure; plot3(X(1,:),X(2,:),X(3,:),'.','MarkerSize',15);
xlim([-10 10]); ylim([-10 10]); zlim([-1 15]); 
%save
save('world_coordinates_rp','X');