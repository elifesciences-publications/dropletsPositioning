function [Fig ,sections] = clutch_simulation(params,times, format, outputDir)
    k = params.k;
    V0 = params.V0;
    r = params.r;
    c = params.c;
    dt = params.dt; % time step (unit is minute)
    Tmax = params.Tmax;
    t=(0:dt:Tmax); % duration of the numerical experiment
    % k=0.5; % contraction coefficient in V=-kx (unit is minute^-1)
    D=0.5; % diffusion coefficient, in um^2/min
    N=100; % number of trajectories
    % V0=2; r=0.2; c=0.1; % average decentering velocity and clutch frequencies
    Rmin = 15; Rmax = 100;
    R = (exp(linspace(0,2,N))-1)/(exp(2)-1)*(Rmax-Rmin) + Rmin;
    % R=60; % droplet radius
    pos=zeros(N, length(t));
    % rofR = R./R * r;%exp((-R + Rmin)/20)*r;
    % rofR = r*30./R;%exp((-R + Rmin)/20)*r;
    % cofR = c*R/30;%exp((-R + Rmin)/20)*r;
    % kofR = R*k/30;
    % kofR = R./R*k;
    
    x=zeros(N,length(t)) ;y=zeros(N,length(t)); z=zeros(N,length(t)); V=zeros(N,length(t));
    
    
    for s=1:N
        for j=1:length(t)-1
            d = sqrt(x(s,j)^2+y(s,j)^2+z(s,j)^2);
            %         rofd = exp((d-R(s) + Rmin)/(Rmax-Rmin))*r;
            %         cofd = (R(s) - d)*c/30;
            cofs = c*(R(s)-d)/40;
            rofs = r*40/(R(s)-d);
            %         rofs = r*30/(R(s));
            %rofs = r*3;
%             kofs = (R(s).^2)*k/50.^2;
                     kofs = k;
            rr=rand;
            if V(s,j)==0 & rr<rofs*dt
                V(s,j+1)=V0;
                kofs = 0;
            elseif V(s,j)==0 & rr>rofs*dt
                V(s,j+1)=0;
            elseif V(s,j)==V0 & rand<cofs*dt
                V(s,j+1)=0;
            else V(s,j+1)=V0;
                kofs = 0;
            end
            x(s,j+1)=x(s,j)-dt*((kofs*x(s,j))-V(s,j)*x(s,j)/(d+0.0000001))+sqrt(2*D*dt)*randn;
            y(s,j+1)=y(s,j)-dt*((kofs*y(s,j))-V(s,j)*y(s,j)/(d+0.0000001))+sqrt(2*D*dt)*randn;
            z(s,j+1)=z(s,j)-dt*((kofs*z(s,j))-V(s,j)*z(s,j)/(d+0.0000001))+sqrt(2*D*dt)*randn;
            if sqrt(x(s,j+1)^2+y(s,j+1)^2+z(s,j+1)^2)>R(s)*0.75
                pos(s,j+1:end)=R(s)*0.75;
                break;
            else
                pos(s,j+1)=sqrt(x(s,j+1)^2+y(s,j+1)^2+z(s,j+1)^2);
            end
        end
    end
    frame = 0;
    for j=1:5:length(t)
        frame = frame+1;
        displacement(:,frame) = sqrt(x(:,j).^2 + y(:,j).^2 + z(:,j).^2);
    end
    Vr = (displacement(:,2:end) - displacement(:,1:end-1))/dt;
    
    dPlot = displacement(:,2:end);
    dPlot = dPlot(:);
    VrPlot = Vr(:);
%     figure;
%     scatter(dPlot,VrPlot,100,'.');
%     ylim([-25,50]);
% 
%     [dSorted, sortInd] = sort(dPlot);
%     VrSorted = VrPlot(sortInd);
%     VrSmooth = smooth(VrSorted,50);
%     hold on;
%     plot(dSorted, VrSmooth);
%     xlabel('Displacement [{\mu}m]');
%     ylabel('Velocity [{\mu}m/min]')
        for j=1:length(times)
            ind = find(t>=times(j),1);
            clear sim;
            posError = pos(:,ind);%; + rand(size(pos(:,j)))*2;
            time = t(ind);
            sim.description = sprintf('simulation k=%g, D=%g, V0=%g, r=%g, c=%g, T = %dm%ds' ,k,D,V0,r,c,floor(time), round(mod((time)*60,60)));
            sim.dropRadius = R;
            sim.blobDistanceMinusPlus(1,:) = posError';
            sim.blobDistanceMinusPlus(2:3,:) = [posError'./posError' * 0; posError'./posError' * 0];
            % sim.blobDistanceMinusPlus(2:3,:) = [-3 * ones(size(posError')); 3 * ones(size(posError'))];
            sim.dropEffectiveRadius = R*0.75;
            [Fig(j,1), sectionsSim] = scatter_displacement_paper2(sim ,1, -1, format, outputDir);
            text(20,50,sprintf('T = %d''%d"',floor(t(ind)), round(mod(t(ind)*60,60))));            
        end
if ~isempty(sectionsSim)
    sections = sectionsSim(:,1)';
end

end
    
    % figure;
    % scatter(R,pos);
    % xlim([Rmin,Rmax]);
    % ylim([0,Rmax]);