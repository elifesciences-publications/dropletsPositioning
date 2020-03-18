%%%%Calculate average intensity over theta as a function of T
%%%%Capture_folder=the folder in which the movie located in.
%%%%MovieName=name of the movie
%%%%Microscope calibration [um/pixel]
%%%%V_Length=Vertical length [pixel]
%%%%H_Length=Horizontal length [pixel]


function CalculateRhoVsTForNiv(Capture_folder,MovieName,calibration,V_Length,H_Length,varargin)
TYPES = [1,2];
if numel(varargin) == 0
    type = 1;
else
    type = varargin{1}; % type 1: choose chunk. type 2: choose chunk and drop.
end
if ~isnumeric(type) || ~any(TYPES == type)
    type = 1;
end

FirstFrame=imread(fullfile(Capture_folder,MovieName),1);
imshow(FirstFrame,[])
if type == 1 || type == 2
    display('Choose: Chunk circle')
    title('Choose: Chunk circle')
    
    h = imellipse;
    vert=wait(h);
    CHUNK_mask=createMask(h);
    CHUNK_Position=getPosition(h);
    CHUNK_radius=ceil( ((CHUNK_Position(3)+CHUNK_Position(4))/4) * calibration );
    MinRr=CHUNK_radius;
    X0=ceil(CHUNK_Position(1)+(CHUNK_Position(3)/2));
    Y0=ceil(CHUNK_Position(2)+(CHUNK_Position(4)/2));
    if type == 2
        display('Choose: Drop circle')
        title('Choose: Drop circle')
        h2 = imellipse;
        vert=wait(h2);
        DROP_Position=getPosition(h);
        DROP_radius=ceil( ((DROP_Position(3)+DROP_Position(4))/4) * calibration );
        MaxRr=DROP_radius;
        X1=ceil(DROP_Position(1)+(DROP_Position(3)/2));
        Y1=ceil(DROP_Position(2)+(DROP_Position(4)/2));
    end
    
    title('Calculating Coordinate transformation...')
    drawnow;
    display('Calculating Coordinate transformation...')
    
    info=imfinfo([Capture_folder,MovieName]);
    
    Size_info=size(info);
    Number_of_frames=Size_info(1,1);
    
    %%%% Calculate R
    for i=1:V_Length
        for j=1:H_Length
            y0(i,j)=i-Y0;
            x0(i,j)=j-X0;
            if type == 2
                y1(i,j)=i-Y1;
                x1(i,j)=j-X1;
            
                t = exp(log(2) * ((MaxRr - sqrt((x1(i,j)^2) + (y1(i,j)^2))) / (sqrt((x0(i,j)^2) + (y0(i,j)^2)) - MinRr)) );
                t = max([0,min([1,t])]);
                Yt = Y0 + t * (Y1 - Y0);
                Xt = X0 + t * (X1 - X0);
            else
                Yt = Y0;
                Xt = X0;
            end
            
            Y(i,j) = i-Yt;
            X(i,j) = i-Xt;
            
            R(i,j)=sqrt( (X(i,j)^2) + (Y(i,j)^2) );
            theta(i,j)=atan(Y(i,j)/X(i,j));
            
            if (X(i,j)<0)
                theta(i,j)=theta(i,j)+pi;
            end
            
        end
    end
end
%%%Set scale
R=R*calibration;
theta=theta(:);
R=R(:);
title('Calculating Kymograph...')
drawnow;
display('Calculating Kymograph...')

for k=1:Number_of_frames;
    
    %     pix_C0=imread([Capture_folder ,'16bitC0.tiff'],k);
    pix_C0=imread(fullfile(Capture_folder,MovieName),'Index',k);
    
    Rho=pix_C0(:);
    RhoDILUTE=Rho;
    RhoDILUTE=double(RhoDILUTE);
    [RhoT(:,k),lowerLine,upperLine,R_T] = meanGaussian(R(:),RhoDILUTE(:), 1);
    
end

close all
if ~exist(fullfile(Capture_folder,'Rho'),'dir')
    mkdir(Capture_folder,'Rho');
end
save([Capture_folder,'Rho\RhoT.m'],'RhoT');
save([Capture_folder,'Rho\R_T.m'],'R_T');

%%% Density Kymograph

h=figure
imshow(RhoT',[]);
colormap(jet);
axis normal
axis off
ylabel('time')
xlabel('Distance from center')
set(gcf,'units','centimeter')
set(gcf,'position', [2 2 10 8])

savefig([Capture_folder,'Density Kymograph.fig']);
saveas(h,[Capture_folder,'Density Kymograph.tiff']);

end