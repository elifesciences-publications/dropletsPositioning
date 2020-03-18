function Fig = scatter_and_histograms(plot_parameters)
% texts = {@(x) sprintf('%s',x.description), @(x) sprintf('%d min',x.time)};
Fig(1) = figure;
ColOrd = get(gca,'ColorOrder');
[m,n] = size(ColOrd);
subplot = @(M,N,P) subtightplot(M,N,P,[0.07,0.1],[0.1,0.08],[0.1,0.02]);
S = size(plot_parameters)
Lmin = 30;
Lmax = 200;
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
        plot_parameters(i,j).numDrops = sum(plot_parameters(i,j).dropR * 2 > Lmin & plot_parameters(i,j).dropR * 2 < Lmax);
%         plot_parameters(i,j).s = plot(plot_parameters(i,j).dropR,plot_parameters(i,j).blobRThetaPhiNormalized(:,1),'.');
        plot_parameters(i,j).s = errorbar(plot_parameters(i,j).dropR * 2,plot_parameters(i,j).blobRThetaPhiNormalized(:,1),abs(plot_parameters(i,j).blobRErrNormalized(:,1)),plot_parameters(i,j).blobRErrNormalized(:,2),'.');
        plot_parameters(i,j).s.DisplayName = sprintf('%s, N=%d',plot_parameters(i,j).description, plot_parameters(i,j).numDrops);
        %             PARAMS(ind).f = fit(PARAMS(ind).dropR',PARAMS(ind).blobRThetaPhiNormalized(:,1),'exp1');
        %             PARAMS(ind).fp = plot(PARAMS(ind).f);
        %             set(PARAMS(ind).fp,'color',Col);
        legend('off');
        xlabel('Drop Diameter  [$\mu m$]', 'Interpreter' ,'Latex','FontSize',8);
        ylabel('Symmetry Breaking','FontSize',8);
        if max([plot_parameters(i,:).time]) == min([plot_parameters(i,:).time])
            title_text = [title_text,sprintf(' %s',plot_parameters(i,j).description)];
            if j == S(2)
                title_text = [title_text, sprintf(' at T=%d min.',plot_parameters(i,j).time)];
            else
                title_text = [title_text, ' vs'];
            end
        else
            title_text = [title_text,sprintf(' %s at T=%d min.',plot_parameters(i,j).description, plot_parameters(i,j).time)];
            if j ~= S(2)
                title_text = [title_text, ' vs'];
            end
        end
%         title(sprintf('%d min',plot_parameters(i,j).time), 'FontWeight','normal','FontSize',10);
        xlim([Lmin,Lmax]);
        ylim([0,1]);
    end
    title(title_text, 'FontWeight','normal','FontSize',10);
    pl = plot(Lmin:Lmax , 10./((Lmin:Lmax) * (1-plot_parameters(i,j).blobRfactor)),'k--');
    hold off
    h = legend([plot_parameters(i,:).s],'location','best');
    h.FontSize = 8;
end
Fig(1).Name = title_text;

Fig(2) = figure;
ColOrd = get(gca,'ColorOrder');
[m,n] = size(ColOrd);
subplot = @(M,N,P) subtightplot(M,N,P,[0.07,0.1],[0.1,0.08],[0.1,0.02]);
S = size(plot_parameters)
Lmin = 30;
Lmax = 200;
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
        plot_parameters(i,j).s2 = plot(plot_parameters(i,j).dropR * 2,plot_parameters(i,j).blobVecNormalized(:,3),'.');
        plot_parameters(i,j).s2.DisplayName = sprintf('%s, N=%d',plot_parameters(i,j).description, plot_parameters(i,j).numDrops);
        legend('off');
        xlabel('Drop Diameter  [$\mu m$]', 'Interpreter' ,'Latex','FontSize',8);
        ylabel('Blob Vertical Displacement','FontSize',8);
        if max([plot_parameters(i,:).time]) == min([plot_parameters(i,:).time])
            title_text = [title_text,sprintf(' %s',plot_parameters(i,j).description)];
            if j == S(2)
                title_text = [title_text, sprintf(' at T=%d min.',plot_parameters(i,j).time)];
            else
                title_text = [title_text, ' vs'];
            end
        else
            title_text = [title_text,sprintf(' %s at T=%d min.',plot_parameters(i,j).description, plot_parameters(i,j).time)];
            if j ~= S(2)
                title_text = [title_text, ' vs'];
            end
        end
%         title(sprintf('%d min',plot_parameters(i,j).time), 'FontWeight','normal','FontSize',10);
        xlim([Lmin,Lmax]);
        ylim([-1,1]);
    end
    title(title_text, 'FontWeight','normal','FontSize',10);
    plot(Lmin:Lmax, 10./((Lmin:Lmax) * (1-plot_parameters(i,j).blobRfactor)),'k--');
    plot(Lmin:Lmax, -10./((Lmin:Lmax) * (1-plot_parameters(i,j).blobRfactor)),'k--');
    hold off
    h2 = legend([plot_parameters(i,:).s2],'location','best');
    h2.FontSize = 8;
end
Fig(2).Name = title_text;

% 
% % legend([PARAMS(:,1,1).fp],cellfun(@(x) sprintf('%d%% extract',x),{PARAMS(:,1,1).percent},'UniformOutput',false));
% subplot = @(M,N,P) subtightplot(M,N,P,[0.15,0.1],0.1,[0.08,0.02]);
% Fig(2) = figure;
% for i = 1:size(plot_parameters,plot_order(1))
%     for j = 1:size(plot_parameters,plot_order(2))
%         subplot(size(plot_parameters,plot_order(1)),size(plot_parameters,plot_order(2)),(i-1)*size(plot_parameters,plot_order(2)) + j);
%         hold on
%         for k = 1:size(plot_parameters,plot_order(3))
%             I=[i,j,k];
%             I = I(inevrse_perm);
%             ind = sub2ind(size(plot_parameters),I(1),I(2),I(3));
%             
%             plot_parameters(ind).h = histogram(plot_parameters(ind).blobRThetaPhiNormalized(plot_parameters(ind).dropR > Lmin & plot_parameters(ind).dropR <Lmax,1),0:0.1:1,'Normalization','probability');
%             plot_parameters(ind).h.DisplayName = plot_parameters.legend_text(plot_parameters(ind),plot_order(3));
%             plot_parameters(ind).YL = ylim();
%             xlabel('Symmetry Breaking','FontSize',8);
%             ylabel('Fraction of Drops','FontSize',8);
%             title([plot_parameters.texts{plot_order(1)}(plot_parameters(ind)),', ', plot_parameters.texts{plot_order(2)}(plot_parameters(ind))], 'FontWeight','normal','FontSize',10);
%         end
%         hold off
%         S.type = '()';
%         [S.subs{plot_order(1:2)}] = deal(i,j);
%         S.subs{plot_order(3)} = ':';
%         P = subsref(plot_parameters,S);
%         h = legend([P.h],'location','northwest');
%         h.FontSize = 8;
%     end
% end
% for i = 1:size(plot_parameters,plot_order(1))*size(plot_parameters,plot_order(2))
%     subplot(size(plot_parameters,plot_order(1)),size(plot_parameters,plot_order(2)),i);
%     ylim([0,max(max([plot_parameters(:,:,:).YL]))]);
% end
% 
% Fig(3) = figure;
% for i = 1:size(plot_parameters,plot_order(1))
%     for j = 1:size(plot_parameters,plot_order(2))
%         subplot(size(plot_parameters,plot_order(1)),size(plot_parameters,plot_order(2)),(i-1)*size(plot_parameters,plot_order(2)) + j);
%         hold on
%         for k = 1:size(plot_parameters,plot_order(3))
%             I=[i,j,k];
%             I = I(inevrse_perm);
%             ind = sub2ind(size(plot_parameters),I(1),I(2),I(3));
%             
%             plot_parameters(ind).h2 = histogram(plot_parameters(ind).dropR,linspace(Lmin,Lmax,10),'Normalization','probability');
%             plot_parameters(ind).h2.DisplayName = plot_parameters.legend_text(plot_parameters(ind),plot_order(3));
%             plot_parameters(ind).YL2 = ylim();
%             xlabel('Drop Radius','FontSize',8);
%             ylabel('Fraction of Drops','FontSize',8);
%             title([plot_parameters.texts{plot_order(1)}(plot_parameters(ind)),', ', plot_parameters.texts{plot_order(2)}(plot_parameters(ind))], 'FontWeight','normal','FontSize',10);
%             xlim([Lmin,Lmax]);
%         end
%         hold off
%         S.type = '()';
%         [S.subs{plot_order(1:2)}] = deal(i,j);
%         S.subs{plot_order(3)} = ':';
%         P = subsref(plot_parameters,S);
%         h = legend([P.h2],'location','northwest');
%         h.FontSize = 8;
%     end
% end
% for i = 1:size(plot_parameters,plot_order(1))*size(plot_parameters,plot_order(2))
%     subplot(size(plot_parameters,plot_order(1)),size(plot_parameters,plot_order(2)),i);
%     ylim([0,max(max([plot_parameters(:,:,:).YL2]))]);
% end
% 
% Fig(4) = figure;
% subplot = @(M,N,P) subtightplot(M,N,P,[0.08,0.08],[0.08,0.114],[0.1,0.02]);
% % subplot = @(m,n,p) subtightplot(m,n,p,[0.16,0.1],[0.07,0.16],[0.08,0.02]);
% for i = 1:size(plot_parameters,plot_order(1))
%     for j = 1:size(plot_parameters,plot_order(2))
%         subplot(size(plot_parameters,plot_order(1)),size(plot_parameters,plot_order(2)),(i-1)*size(plot_parameters,plot_order(2)) + j);
%         hold on
%         for k = 1:size(plot_parameters,plot_order(3))
%             I=[i,j,k];
%             I = I(inevrse_perm);
%             ind = sub2ind(size(plot_parameters),I(1),I(2),I(3));
%             ColRow = rem(k,m);
%             if ColRow == 0
%                 ColRow = m;
%             end
%             Col = ColOrd(ColRow,:);
%             %             PARAMS(ind).numDrops = sum(PARAMS(ind).dropR > Lmin & PARAMS(ind).dropR <Lmax);
%             plot_parameters(ind).s2 = plot(plot_parameters(ind).dropR,plot_parameters(ind).blobRThetaPhi(:,1),'.','color',Col);
%             plot_parameters(ind).s2.DisplayName = plot_parameters.legend_text(plot_parameters(ind),plot_order(3));
%             plot_parameters(ind).lp = plot(0:100,(0:100)*(1 - plot_parameters(ind).blobRfactor));
%             %             PARAMS(ind).fp2 = plot(PARAMS(ind).f2);
%             set(plot_parameters(ind).lp,'color',Col);
%             legend('off');
%             xlabel('Drop Radius [$\mu m$]', 'Interpreter' ,'Latex','FontSize',8);
%             ylabel('Blob Distance [$\mu m$]', 'Interpreter' ,'Latex','FontSize',8);
%             title([plot_parameters.texts{plot_order(1)}(plot_parameters(ind)),', ', plot_parameters.texts{plot_order(2)}(plot_parameters(ind))], 'FontWeight','normal','FontSize',10);
%             xlim([0,100]);
%             ylim([0,100]);
%             %             axis square;
%         end
%         plot(0:100,ones(1,101)*5,'k--');
%         hold off
%         S.type = '()';
%         [S.subs{plot_order(1:2)}] = deal(i,j);
%         S.subs{plot_order(3)} = ':';
%         P = subsref(plot_parameters,S);
%         h = legend([P.s2],'location','northoutside');
%         h.FontSize = 8;
%     end
% end
% 
% fig_suptitles = {sprintf('Normalized Blob distances from center per drop radius, for $%d-%d \\mu m$',Lmin,Lmax),...
%     sprintf('Histograms of blob distances from center, for drops of radii $%d-%d \\mu m$',Lmin,Lmax),...
%     sprintf('Histograms of drop radii from $%d-%d \\mu m$',Lmin,Lmax),...
%     sprintf('Absolute Blob distances from center per drop radius, for $%d-%d \\mu m$',Lmin,Lmax)};
% 
% for i=1:length(Fig)
%     set(Fig(i),'Units','pixels','Position', [0 0 580 600]);
%     figure(Fig(i));
%     if i<=length(fig_suptitles)
%         suptitle(fig_suptitles{i}, 'Interpreter' ,'Latex');
%     end
% end
% 
% order_text = {'percent','temp','time'};
% fig_names = {'scatter', 'hist_sym', 'hist_size', 'scatter_absolute'};
% for i = 1:length(Fig)
%     if i<=length(fig_names)
%         filename{i} = sprintf('%s_%s_by_%s-%s_%d-%d',fig_names{i},order_text{flip(plot_order)},Lmin,Lmax);
%     end
% end
% 
% % if (exist('do_print','var') && do_print == true)
% %     for i = 1:length(Fig)
% %         if i<=length(filename)
% %             print(Fig(i),'-dpng',['../',filename{i}]);
% %             export_fig(['../',filename{i},'_exfig'],'-png','-m4',Fig(i));
% %         end
% %     end
% % end