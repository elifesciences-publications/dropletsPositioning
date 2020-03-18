function Fig = scatter_tracking_oop(plot_parameters)
% texts = {@(x) sprintf('%s',x.description), @(x) sprintf('%d min',x.time)};
Fig(1) = figure;
ColOrd = get(gca,'ColorOrder');
[m,n] = size(ColOrd);
subplot = @(M,N,P) subtightplot(M,N,P,[0.07,0.1],[0.1,0.08],[0.1,0.02]);
S = size(plot_parameters)
% subplot = @(m,n,p) subtightplot(m,n,p,[0.16,0.1],[0.07,0.16],[0.08,0.02]);
for i = 1:S(1)
    title_text = '';
    subplot(min(2,S(1)),ceil(S(1)/2),i);
    hold on
    for j = 1:S(2)
        ColRow = rem(i,m);
        if ColRow == 0
            ColRow = m;
        end
        blobRThetaPhi = cat(2,plot_parameters(i,j).BV.blobRThetaPhi);
        blobRThetaPhiErr = cat(2,plot_parameters(i,j).BV.blobRThetaPhiErr);
        blobRError = sort(reshape(blobRThetaPhiErr(1,:),2,[]) - repmat(blobRThetaPhi(1,:),2,1));
%         blobRError = [plot_parameters(i,j).BV.blobRThetaPhiErr];
%         blobRError = reshape(blobRError(1,:),2,[]);
        times = plot_parameters.times(find(~cellfun('isempty',{plot_parameters.BV.dropR})));
        %plot_parameters(i,j).s = errorbar(times, blobRThetaPhi(1,:),...
        %    abs(blobRError(1,:) - blobRThetaPhi(1,:)), blobRError(2,:) - blobRThetaPhi(1,:),'.');
        plot_parameters(i,j).s = errorbar(times, blobRThetaPhi(1,:),...
            abs(blobRError(1,:)), blobRError(2,:),'.');
        plot_parameters(i,j).s.DisplayName = plot_parameters(i,j).description;
        legend('off');
        xlabel('time [s]','FontSize',14);
        ylabel('Displacement','FontSize',14);
        title_text = plot_parameters(i,j).description;
%         title(sprintf('%d min',plot_parameters(i,j).time), 'FontWeight','normal','FontSize',10);
        xlim([times(1),times(end)]);
    end
    plot(times , ones(size(times))*plot_parameters(i,j).BV(1).dropR,'k--');
    plot(times , ones(size(times))*plot_parameters(i,j).BV(1).dropR*(1-plot_parameters(i,j).DATA.drops(1).blobRfactor),'r--');
    title(title_text, 'FontWeight','normal','FontSize',14);
    hold off
%     h = legend([plot_parameters(i,:).s],'location','best');
%     h.FontSize = 14;
end
Fig(1).Name = title_text;

% Fig(2) = figure;
% ColOrd = get(gca,'ColorOrder');
% [m,n] = size(ColOrd);
% subplot = @(M,N,P) subtightplot(M,N,P,[0.07,0.1],[0.1,0.08],[0.1,0.02]);
% S = size(plot_parameters)
% for i = 1:S(1)
%     title_text = '';
%     subplot(min(2,S(1)),ceil(S(1)/2),i);
%     hold on
%     for j = 1:S(2)
%         ColRow = rem(i,m);
%         if ColRow == 0
%             ColRow = m;
%         end
%         blobRThetaPhi = [plot_parameters(i,j).BV.blobRThetaPhi];
%         blobVec = [plot_parameters(i,j).BV.blobVec];
%         blobRDiff = blobRThetaPhi(1,2:end) - blobRThetaPhi(1,1:end-1);
%         blobVecDiff = blobVec(:,2:end) - blobVec(:,1:end-1);
%         
%         Q = [5];
%         for qi=1:length(Q);
%         q = Q(qi);
%         clear avgVecDiff avgRDiff
%         if q ~= 0
%             w = [1/4/q,repmat(1/2/q,1, 2*q - 1),1/4/q];
%             avgRDiff = conv(blobRDiff,w,'valid');
%             for k=1:3
%                 avgVecDiff(k,:) = conv(blobVecDiff(k,:),w,'valid');
%             end
%         else
%             avgRDiff = blobRDiff;
%             avgVecDiff = blobVecDiff;
%         end
%         times = plot_parameters.times(find(~cellfun('isempty',{plot_parameters.BV.dropR})));
%         T = times((q + 1):(end - q));
%         deltaT = T(2:end) - T(1:end-1);
%         Rvelocity = avgRDiff./deltaT;
%         absVelocity = sum(sqrt(avgVecDiff.^2))./deltaT;
%         plot_parameters(i,j).s4(2*qi-1) = plot((T(1:end-1) + T(2:end))/2, Rvelocity);
%         plot_parameters(i,j).s4(2*qi) = plot((T(1:end-1) + T(2:end))/2, absVelocity);
%         plot_parameters(i,j).s4(2*qi-1).DisplayName = sprintf('R-Veclocity (Moving Average %d)',2*q+1);
%         plot_parameters(i,j).s4(2*qi).DisplayName = sprintf('Abs Veclocity (Moving Average %d)',2*q+1);
%         legend('off');
%         end
%         xlabel('time [s]', 'Interpreter' ,'Latex','FontSize',8);
%         ylabel('Blob Velocity [$\frac{\mu}{sec}$]', 'Interpreter' ,'Latex','FontSize',8);
%         title_text = plot_parameters(i,j).description;
% %         title(sprintf('%d min',plot_parameters(i,j).time), 'FontWeight','normal','FontSize',10);
%         xlim([times(1),times(end)]);
%     end
%     title(title_text, 'FontWeight','normal','FontSize',10);
%     plot(times, zeros(1,length(times)), 'k--');
%     hold off
%     h = legend([plot_parameters(i,:).s4],'location','best');
%     h.FontSize = 8;
% end
% Fig(2).Name = title_text;

% 
% Fig(2) = figure;
% ColOrd = get(gca,'ColorOrder');
% [m,n] = size(ColOrd);
% subplot = @(M,N,P) subtightplot(M,N,P,[0.07,0.1],[0.1,0.08],[0.1,0.02]);
% S = size(plot_parameters)
% % subplot = @(m,n,p) subtightplot(m,n,p,[0.16,0.1],[0.07,0.16],[0.08,0.02]);
% for i = 1:S(1)
%     title_text = '';
%     subplot(min(2,S(1)),ceil(S(1)/2),i);
%     hold on
%     for j = 1:S(2)
%         ColRow = rem(i,m);
%         if ColRow == 0
%             ColRow = m;
%         end
%         blobVec = cat(1,plot_parameters(i,j).BV.blobVec);
%         times = plot_parameters.times(find(~cellfun('isempty',{plot_parameters.BV.dropR})));
%         plot_parameters(i,j).s2 = scatter(times, blobVec(:,3));
%         plot_parameters(i,j).s2.DisplayName = plot_parameters(i,j).description;
%         legend('off');
%         xlabel('time [s]', 'Interpreter' ,'Latex','FontSize',8);
%         ylabel('Z [$\mu m$]', 'Interpreter' ,'Latex','FontSize',8);
%         title_text = plot_parameters(i,j).description;
% %         title(sprintf('%d min',plot_parameters(i,j).time), 'FontWeight','normal','FontSize',10);
%         xlim([times(1),times(end)]);
% %         ylim([0,1]);
%     end
%     title(title_text, 'FontWeight','normal','FontSize',10);
%     hold off
%     h = legend([plot_parameters(i,:).s2],'location','best');
%     h.FontSize = 8;
% end
% Fig(2).Name = title_text;
% 
% Fig(3) = figure;
% ColOrd = get(gca,'ColorOrder');
% [m,n] = size(ColOrd);
% subplot = @(M,N,P) subtightplot(M,N,P,[0.07,0.1],[0.1,0.08],[0.1,0.02]);
% S = size(plot_parameters)
% % subplot = @(m,n,p) subtightplot(m,n,p,[0.16,0.1],[0.07,0.16],[0.08,0.02]);
% for i = 1:S(1)
%     title_text = '';
%     subplot(min(2,S(1)),ceil(S(1)/2),i);
%     hold on
%     for j = 1:S(2)
%         ColRow = rem(i,m);
%         if ColRow == 0
%             ColRow = m;
%         end
% %         dropR = cat(1,plot_parameters(i,j).BV.dropR);
%         blobVec = cat(1,plot_parameters(i,j).BV.blobVec);
%         times = plot_parameters.times(find(~cellfun('isempty',{plot_parameters.BV.dropR})));
%         plot_parameters(i,j).s3 = scatter(times, sqrt(blobVec(:,1).^2 + blobVec(:,2).^2));
%         plot_parameters(i,j).s3.DisplayName = plot_parameters(i,j).description;
%         legend('off');
%         xlabel('time [s]', 'Interpreter' ,'Latex','FontSize',8);
%         ylabel('XY displacement [$\mu m$]', 'Interpreter' ,'Latex','FontSize',8);
%         title_text = plot_parameters(i,j).description;
% %         title(sprintf('%d min',plot_parameters(i,j).time), 'FontWeight','normal','FontSize',10);
%         xlim([times(1),times(end)]);
% %         ylim([0,1]);
%     end
%     title(title_text, 'FontWeight','normal','FontSize',10);
%     hold off
%     h = legend([plot_parameters(i,:).s3],'location','best');
%     h.FontSize = 8;
% end
% Fig(3).Name = title_text;
% 
