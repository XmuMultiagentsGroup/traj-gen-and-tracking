%% Ball flight model and symplectic integration functions
% Note: can also be run backwards in time by specifying -dt
% TODO: bounce time calculation problematic sometimes! Iterating to five
%       for now!


function xNext = discreteBallFlightModel(x,dt,params)

C = params.C;
g = params.g;
zTable = params.zTable;
yNet = params.yNet;
ballRadius = params.radius;
tableLength = params.table_length;
tableWidth = params.table_width;
% coeff of restitution-friction matrix
% M = params.BMAT;
M = diag([params.CFTX; params.CFTY; -params.CRT]);
alg = params.ALG;

xNext = zeros(6,1);

switch alg
    case 'Euler'
        xNext(4:6) = x(4:6) + dt * ballFlightModel(x(4:6),C,g);
        xNext(1:3) = x(1:3) + dt * xNext(4:6);
    case 'RK4'
        ballFlightFnc = @(x) [x(4:6);ballFlightModel(x(4:6),C,g)];
        k1 = dt * ballFlightFnc(x);
        x_k1 = x + k1/2;
        k2 = dt * ballFlightFnc(x_k1);
        x_k2 = x + k2/2;
        k3 = dt * ballFlightFnc(x_k2);
        x_k3 = x + k3;
        k4 = dt * ballFlightFnc(x_k3);
        xNext = x + (k1 + 2*k2 + 2*k3 + k4)/6;
    otherwise
        error('Not implemented!');
end

% condition for bouncing
if xNext(3) < zTable + ballRadius && ...
        abs(xNext(2) - yNet) < tableLength/2 && abs(xNext(1)) < tableWidth/2
    tol = 1e-4;
    dt1 = 0;
    dt2 = dt;
    xBounce = x;
    dtBounce = 0.0;
    iter = 0;
    % doing bisection to find the bounce time
    while iter < 5 %abs(xBounce(3) - zTable) > tol
        dtBounce = (dt1 + dt2) / 2;
        xBounce(4:6) = x(4:6) + dtBounce * ballFlightModel(x(4:6),C,g);
        xBounce(1:3) = x(1:3) + dtBounce * xBounce(4:6);
        if xBounce(3) > zTable
            % increase the time
            dt1 = dtBounce;
        else
            dt2 = dtBounce;
        end
        iter = iter + 1;
    end
    % rebound
    xBounce(4:6) = reboundModel(xBounce(4:6),M);
    % integrate for the rest
    dt = dt - dtBounce;
    xNext(4:6) = xBounce(4:6) + dt * ballFlightModel(xBounce(4:6),C,g);
    xNext(1:3) = xBounce(1:3) + dt * xNext(4:6);
end

end

% K is the coefficient values in x-y-z directions
function xdot = reboundModel(xdot,M)

xdot = M * xdot;
    
end
