figure;
for condInd = 1:3
    for i=1:3
        curAx = get(FigSim(i,condInd),'CurrentAxes');
        
        h(i,condInd) = subplot(3,3,condInd * 3 + i -3);
        copyobj(allchild(curAx),h(i,condInd));
        modifiiable_axes_fields_names = fieldnames(set(curAx));
        for fieldName = 1:length(modifiiable_axes_fields_names)
            curField = modifiiable_axes_fields_names{fieldName};
            if isstruct(get(curAx,curField)) || isgraphics(get(curAx,curField))
                copyStruct(h(i,condInd).(curField), get(curAx,curField));
            else
                h(i,condInd).(curField) = get(curAx,curField);
            end
        end
    end
end
% % Add legends
% l(1)=legend(h(1),'LegendForFirstFigure')
% l(2)=legend(h(2),'LegendForSecondFigure')