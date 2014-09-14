% Model superclass acts as an interface
% for holding specific submodel classes.

classdef (Abstract) Model < handle
    
    % Field necessary for all control algorithms
    properties (Abstract)        
        % parameters structure
        PAR
        % constraints structure
        CON
        % fields necessary for simulation and plotting, noise etc.
        SIM
        % cost structure, not necessarily quadratic
        COST
    end
    
    % methods to be implemented
    methods (Abstract)
        
        % generate trajectories
        trajectory(t,sp,s,unom)
        % set a nominal model
        [xdot,A,B] = nominal(obj,t,x,u)
        % add a disturbance model to the nominal model
        xdot = actual(obj,t,x,u)
        % lifted vector constraints
        
    end
    
    % methods that can be implemented here in abstract class
    methods (Access = public)
        
        % one step simulation along the trajectory
        % TODO: is it correct to assume u constant?
        function next = step(obj,t,prev,u,fun)
            
            h = obj.SIM.h;
            
            if strcmpi(obj.SIM.int,'Euler')
                delta = h * fun(t,prev,u);
                next = prev + delta;                
            elseif strcmpi(obj.SIM.int,'RK4')
                % get trajectory of states
                % using classical Runge-Kutta method (RK4)  
                k1 = h * fun(t,prev,u);
                x_k1 = prev + k1/2;
                k2 = h * fun(t,x_k1,u);
                x_k2 = prev + k2/2;
                k3 = h * fun(t,x_k2,u);
                x_k3 = prev + k3;
                k4 = h * fun(t,x_k3,u);
                next = prev + (k1 + 2*k2 + 2*k3 + k4)/6;
            else
                error('Method not implemented. Quitting...');
            end

        end
        
        % predict one step using nominal model
        function x_pre = predict(obj,t,x,u)         
            x_pre = step(obj,t,x,u,obj.nominal);
        end
        
        % predict next states using function
        % useful to calculate nominal model prediction error
        function x_pre = predict_full(obj,t,x,us,fun)
            N = length(t)-1;
            x_pre = zeros(size(x,1),N+1);
            x_pre(:,1) = x(:,1);
            for i = 1:N
                x_pre(:,i+1) = step(obj,t(i),x(:,i),us(:,i),fun);
            end            
        end
        
        % evolve one step
        function x_next = evolve(obj,t,x,u)            
            x_next = step(obj,t,x,u,obj.actual);
        end
        
        % useful to propagate one full iteration of
        % ILC input sequence
        function x_next = evolve_full(obj,t,x0,us)
            %fun = @(t,x,u) obj.actual(t,x,u);
            x_next = simulate(obj,t,x0,us,@obj.actual);
        end
        
        % simulates whole trajectory
        function x = simulate(obj,t,x0,us,fun)
            N = length(t)-1;
            h = t(2)-t(1);
            x = zeros(length(x0),N+1);
            x(:,1) = x0;
            for i = 1:N
                x(:,i+1) = step(obj,t(i),x(:,i),us(:,i),fun);
                % no constraint checking
            end
        end
        
        % linearizes the nominal dynamics around the trajectory
        function [A,B] = linearize(obj,trj)
            
            N = trj.N - 1; 
            t = trj.t;
            s = trj.s;
            dimx = obj.SIM.dimx;
            dimu = obj.SIM.dimu;
            h = obj.SIM.h;
            unom = trj.unom;
            A = zeros(dimx,dimx,N);
            B = zeros(dimx,dimu,N);
            for i = 1:N
                [~,A(:,:,i), B(:,:,i)] = obj.nominal(t(i),s(:,i),...
                                                 unom(:,i),true);
                % get discrete approximation from jacobian
                % crude approximation
                %A(:,:,i) = eye(dimx,dimx) + obj.h * A(:,:,i);
                %B(:,:,i) = obj.h * B(:,:,i);
                % exact matrix calculation 
                Mat = [A(:,:,i), B(:,:,i); zeros(dimu, dimx + dimu)];
                MD = expm(h * Mat);
                A(:,:,i) = MD(1:dimx,1:dimx);
                B(:,:,i) = MD(1:dimx,dimx+1:end);
            end
        end
        
        % plot the control inputs
        function plot_nom_controls(obj,trj)
            
            u = trj.unom;
            t = trj.t;
            num_inp = size(u,1);
            figure(1);
            for i = 1:num_inp
                subplot(num_inp,1,i);
                plot(t,u(i,:),'LineWidth',2);
                title(strcat(num2str(i),'. control input'));
                xlabel('Time (s)');
                ylabel('Scaled voltages u = r * K_m / R * V');
            end
            
        end
        
    end
end