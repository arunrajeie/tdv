%% Use perspective_camera script

cameras = [6 4];
perspective_camera;

%% Plot selected points in two pictures and relevant cameras

u1 = e2p(points{cameras(1)});
u2 = e2p(points{cameras(2)});

P1 = Ps(:,:,cameras(1));
P2 = Ps(:,:,cameras(2));

C1 = null(P1);
C2 = null(P2);

%% Overall scene view

C = [1.5;-5;-4];
alpha = 0.08; c = cos(alpha); s = sin(alpha);
Ry = [ ...
    c  0  s; ...
    0  1  0; ...
   -s  0  c];
alpha = 0.8; c = cos(alpha); s = sin(alpha);
Rx = [ ...
    1  0  0; ...
    0  c -s; ...
    0  s  c];
R = Rx*Ry;
P = K*R*[eye(3) -1*C];

x1 = p2e(P*X1);
x2 = p2e(P*X2);

figure(7);
set(gca, 'ydir', 'reverse');
axis equal;
hold on;

% house
plot(x1(1,:), x1(2,:), 'r-', 'linewidth', 2); % Front side of the house in red

plot(x2(1,:), x2(2,:), 'b-', 'linewidth', 2); % Back side of the house in blue
plot([x1(1,:); x2(1,:)], [x1(2,:); x2(2,:)], 'k-', 'linewidth', 2); % Lines connecting front and back side

% camera centers
c = p2e(P*[C1 C2]);
plot(c(1,:), c(2,:), 'LineStyle', 'none', 'markerfacecolor', 'r', 'markersize', 7, 'marker', 'o');

% world coordinate frame and P1, P2 coordinate frames:
plot_coordinate_frame([0 0 0]', eye(3), P, 'O');
plot_coordinate_frame(p2e(C1), K\P1(:,1:3), P, 'C1');
plot_coordinate_frame(p2e(C2), K\P2(:,1:3), P, 'C2');

% origin
o = p2e(P(:,4));
plot(o(1,:), o(2,:), 'markerfacecolor', 'b', 'markersize', 7, 'marker', 'o');

% compute ray direction vectors and normalize them
d1 = P1(:,1:3)\u1;
d2 = P2(:,1:3)\u2;
d1 = d1 ./ (ones(3,1)*vlen(d1));
d2 = d2 ./ (ones(3,1)*vlen(d2));

% endpoints of rays coming out of camera centers
D1 = e2p(p2e(C1)*ones(1,size(d1,2)) + d1);
D2 = e2p(p2e(C2)*ones(1,size(d2,2)) + d2);

% images of these endpoints
i1 = p2e(P*D1);
i2 = p2e(P*D2);

% images of camera centers
CC1 = p2e(P*C1);
CC2 = p2e(P*C2);

% plot the rays
plot([CC1(1)*ones(1,size(i1,2)); i1(1,:)], [CC1(2)*ones(1,size(i1,2)); i1(2,:)], '-b');
plot([CC2(1)*ones(1,size(i2,2)); i2(1,:)], [CC2(2)*ones(1,size(i2,2)); i2(2,:)], '-b');

%% plot images of intersections of rays of both cameras

X = Pu2X(P1, P2, u1, u2);
xs = p2e(P*X);
for j = 1:size(xs,2);
    plot(xs(1,j), xs(2,j), 'markerfacecolor', color_hash(j), 'markersize', 7, 'marker', 'o');
end

hold off;

%% Epipolar geometry

% (un)calibrated points (un - ?)
v1 = K\u1;
v2 = K\u2;

addpath calibrated_p5/

% "candidate solutions"
Evec = calibrated_fivepoint(v1, v2);
clear R;, clear b;
for i=1:size(Evec,2)
    [R{i}, b{i}] = EutoRb(reshape(Evec(:,i), 3, 3)', v1, v2);
end
