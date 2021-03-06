function depth = depth_in_camera(X, P)
    % depth = depth_in_camera(X, P)
    %
    % Computes depth(s) of point(s) X with respect to finite camera given by
    % camera matrix P.  Based on result 6.1 in [H&Z (2nd ed.), p. 162].
    %
    % Input:    X - 4xn matrix containing n points in homogeneous coords
    %           P - camera matrix
    %
    % Ouptut:   depth - 1xn matrix of depths of points in X with respect to
    %                   camera given by P
    %
    % Points in X have to be in projective coordinates. X can contain
    % multiple points (columns).
    
    if ~all(size(P) == [3 4])
        error('Wrong camera matrix size. It has to be 3x4.');
    end
    
    if size(X,1) == 3
        X = e2p(X);
    end
    
    if size(X,1) ~= 4
        error('Wrong dimensions of the X parameter (has to be 3xn or 4xn).');
    end
    
    M = P(:,1:3);
    w = P(3,:)*X;
    detM = det(M);
    
    if (abs(detM) < 1000*eps)
        error('Can only compute depth of point with respect to FINITE camera');
    end
    
    depth = sign(detM) .* w ./ X(4,:) / norm(M(3,:));

end