function plot_parameters = load_plot_dirs( plot_parameters ,clearimages)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if ~exist('clearimages','var')
    clearimages = true;
end
S = length(plot_parameters);

if ~isfield(plot_parameters,'basename');
    [plot_parameters(:).basename] = deal('analysis_data_');
end

for i=1:S
%    for m = 1:length(plot_parameters(i).dirname)
if isfield(plot_parameters(i),'filename')
    S(1) = length(plot_parameters(i).filename);
else
    S(1) =0;
end
if isfield(plot_parameters(i),'dirname')
    S(2) = length(plot_parameters(i).dirname);
end
    for m = 1:max(S)
        if (~isfield(plot_parameters(i),'filename') || length(plot_parameters(i).filename) < m) && isfield(plot_parameters(i),'dirname')
            T = readtable(fullfile(plot_parameters(i).dirname{m},'filters.txt'),'Delimiter',' ','ReadVariableNames',false);
            filename_suffix = table2cell(T(plot_parameters(i).line,end));
            plot_parameters(i).filename{m}= fullfile(plot_parameters(i).dirname{m},[plot_parameters(i).basename,filename_suffix{1}]);
        end
        %         T = readtable(fullfile(plot_parameters(i).dirname(m).name,'filters.txt'),'Delimiter',' ','ReadVariableNames',false);
%         filename_suffix = table2cell(T(plot_parameters(i).line,end));
%         plot_parameters(i).dirname(m).filename = [plot_parameters(i).basename,filename_suffix{1}];
    end
end

% if isfield(plot_parameters,'blobRfactor')
%     [plot_parameters(cellfun('isempty',{plot_parameters.blobRfactor})).blobRfactor] = deal((0.7^2/15)^(1/3));
% else
    [plot_parameters.blobRfactor] = deal((0.7^2/15/2)^(1/3));
% end


for i = 1:numel(plot_parameters)
    clear blobVec blobRThetaPhi blobVecNormalized blobRThetaPhiNormalized dropR blobRErr blobRErrNormalized
    for j = 1:length(plot_parameters(i).filename)
        if ~isfield(plot_parameters(i),'DATA') || isempty(plot_parameters(i).DATA)...
                || numel(plot_parameters(i).DATA) < j
            plot_parameters(i).DATA(j).drops = [];
            DATA = load(plot_parameters(i).filename{j});
            if isfield(DATA, 'DATA')
                DATA = DATA.DATA;
            elseif isfield(DATA, 'DATA_OUT')
                DATA = DATA.DATA_OUT;
            end
 %           [DATA.drops.blobRfactor] = deal((0.7^2/15/2)^(1/3));
 %           save(plot_parameters(i).filename{j},'DATA','-v7.3');
            if(clearimages)
                [DATA.drops.images] = deal([]);
            end
            plot_parameters(i).DATA(j).drops = DATA.drops;
        end
        if isa(plot_parameters(i).DATA(j).drops,'drop')
            BV = blob_vectors(plot_parameters(i).DATA(j).drops);
            if j == 1
                plot_parameters(i).BV = [];
            end
            plot_parameters(i).BV = [plot_parameters(i).BV, BV];
            clear BV;
        else
            [blobVec{j}, blobRThetaPhi{j}, blobVecNormalized{j},...
                blobRThetaPhiNormalized{j},dropR{j} ,blobRErr{j}, blobRErrNormalized{j}] = ...
                blob_vectors(plot_parameters(i).DATA(j),plot_parameters(i).blobRfactor);
        end
    end
    if ~isa(plot_parameters(i).DATA(j).drops,'drop')
        plot_parameters(i).blobVec = cat(1,blobVec{:});
        plot_parameters(i).blobRThetaPhi = cat(1,blobRThetaPhi{:});
        plot_parameters(i).blobVecNormalized = cat(1,blobVecNormalized{:});
        plot_parameters(i).blobRThetaPhiNormalized = cat(1,blobRThetaPhiNormalized{:});
        plot_parameters(i).dropR = cat(2,dropR{:});
        plot_parameters(i).blobRErr = cat(1,blobRErr{:});
        plot_parameters(i).blobRErrNormalized = cat(1,blobRErrNormalized{:});
    end
end

end

