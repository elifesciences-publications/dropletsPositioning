function T = Z_bias(p)
    V = cat(1,p.blobVec);
    Z = V(:,3);
    VN = cat(1,p.blobVecNormalized);
    ZN = VN(:,3);
    SZ = sum(Z);
    SZb = sum(Z(abs(Z)>6));
    SZN = sum(ZN);
    SZNb = sum(ZN(abs(Z)>6));
    SX = sum(V(:,1));
    SXN = sum(VN(:,1));
    SY = sum(V(:,2));
    SYN = sum(VN(:,2));
    Zcount = sum(Z>0) - sum(Z<0);
    Zcountb = sum(Z>6) - sum(Z<-6);
    Xcount = sum(V(:,1)>1) - sum(V(:,1)<0);
    Ycount = sum(V(:,2)>1) - sum(V(:,2)<0);
    T = table([SX;SXN;Xcount],[SY;SYN;Ycount],[SZ;SZN;Zcount],[SZb;SZNb;Zcountb],...
        'VariableNames',{'Xbias', 'Ybias', 'Zbias', 'Zbias2'},...
        'RowNames',{'Microns';'Normalized';'Count'});
end

