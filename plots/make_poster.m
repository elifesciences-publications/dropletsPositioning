function poster = make_poster(drops,Nx,Ny,L)
p = randperm(length(drops));
D = drops(p);
% N = length(params.BV);
N = min(Nx*Ny,length([D.centerPlane]));
S = [Ny*L,Nx*L];
poster = zeros([S,3]);
L=floor(S(2)/Nx);
pos_ind = 1;
for i = 1:length(D)
    drop = D(i);
    if ~isempty(drop.getRadius) && ~isempty(drop.getBlobCenter) && ~isempty(drop.blobPlane) && ~isempty(drop.centerPlane)
        [pos_indx,pos_indy] = ind2sub([Nx,Ny],pos_ind);
        Xindices = (1:L) + (pos_indx - 1)*L;
        Yindices = (1:L) + (pos_indy - 1)*L;
        ci = compact_image(drop,L);
%         Sci =size(ci);
%         Xindices = (1:Sci(2)) + (pos_indx - 1)*L;
%         Yindices = (1:Sci(1)) + (pos_indy - 1)*L;
        if(Xindices(end) <= S(2) && Yindices(end) <=S(1))
            poster(Yindices,Xindices,:) = ci;
        end
        pos_ind = pos_ind+1;
    end
    if pos_ind > N
        break
    end
end
colormap([(0:0.01:1)',(1:-0.01:0)',zeros(size((0:0.01:1)'))]);
end

function ci = compact_image(drop,L)
    image = drop.images{drop.blobPlane};
%     dx = length(image)/2 - drop.getRadius('pixels') +20;
%     dx = max(dx,0);
%     rect = floor([dx,dx,drop.getRadius('pixels')*2,drop.getRadius('pixels')*2]);
%     image = imcrop(image,rect);
    image = repmat(image,1,1,3);
%     c = drop.getBlobCenter;
%     r =  drop.getRadius('pixels')*0.25;
%     rs = r-1:r+1;
%     y = round(min(max(c(1) + rs'*sin(0:0.01:(2*pi)),1),size(image,1)));
%     x = round(min(max(c(2) + rs'*cos(0:0.01:(2*pi)),1),size(image,2)));
%     inds = sub2ind(size(image),x,y,repmat(1,size(x)));
% %     image(inds(inds<numel(image))) = 1;
%     image(inds) = 1;
    ci = imresize(image,[L,L]);
    
    scale = L/length(image);
    c = drop.getBlobCenter * scale;
    r =  drop.getRadius('pixels')*drop.blobRfactor * scale;
    rs = r:r+1;
    y = round(min(max(c(1) + rs'*sin(0:0.01:(2*pi)),1),size(ci,1)));
    x = round(min(max(c(2) + rs'*cos(0:0.01:(2*pi)),1),size(ci,2)));
    
    indsR = sub2ind(size(ci),x,y,ones(size(x)));
    indsG = sub2ind(size(ci),x,y,2*ones(size(x)));
    indsB = sub2ind(size(ci),x,y,3*ones(size(x)));

%     image(inds(inds<numel(image))) = 1;
    BV = blob_vectors(drop);
    rN = BV.blobRThetaPhiNormalized(1);
    color = [rN,1 - rN,0];
    ci(indsR) = color(1);
    ci(indsG) = color(2);
    ci(indsB) = color(3);
    ci = insertText(ci,[10,10],sprintf('R=%.0f mu,\nr/R=%.2f',BV.dropR,rN),'fontsize',14);
%     ci = imresize(image,0.2);
end
    