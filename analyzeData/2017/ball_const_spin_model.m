%% Nonlinear ballistic flight model involving air drag and spin

% with spin xdot is 6-dimensional
function xddot = ball_const_spin_model(xdot,Cdrag,Clift,w0,g)

    v = sqrt(xdot(1,:).^2 + xdot(2,:).^2 + xdot(3,:).^2);
    xddot(1,:) = -Cdrag * v .* xdot(1,:);
    xddot(2,:) = -Cdrag * v .* xdot(2,:);
    xddot(3,:) = g - Cdrag * v .* xdot(3,:);

    % add lift force due to spin
    xddot = xddot + Clift * crossprod(w0,xdot(1:3,:));

end

% crossproduct between a and b
function out = crossprod(v1,v2)

    out(1,:) = v1(2,:) .* v2(3,:) - v1(3,:) .* v2(2,:);
    out(2,:) = v1(3,:) .* v2(1,:) - v1(1,:) .* v2(3,:);
    out(3,:) = v1(1,:) .* v2(2,:) - v1(2,:) .* v2(1,:);
end