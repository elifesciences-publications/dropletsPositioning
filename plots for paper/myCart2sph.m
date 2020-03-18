function RThetaPhi = myCart2sph(XYZ)
% XYZCell = num2cell(XYZ,2);
XYZCell = num2cell(XYZ,2);
RThetaPhiCell = cell(3,1);
[RThetaPhiCell{:}] = cart2sph(XYZCell{:});
RThetaPhi = flip(cell2mat(RThetaPhiCell));
RThetaPhi(2,:) = pi/2 - RThetaPhi(2,:);
end
