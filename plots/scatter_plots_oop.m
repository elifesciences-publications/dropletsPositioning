function Fig = scatter_plots_oop(plot_parameters,plotsBool)
% texts = {@(x) sprintf('%s',x.description), @(x) sprintf('%d min',x.time)};
if nargin < 2
    plotsBool = [1,0,0];
end
Lmin = 30;
Lmax = 200;
Fig(1) = figure;
% ColOrd = get(gca,'ColorOrder');
% [m,n] = size(ColOrd);
% subplot = @(M,N,P) subtightplot(M,N,P,[0.07,0.1],[0.1,0.08],[0.1,0.02]);
S = size(plot_parameters);
% subplot = @(m,n,p) subtightplot(m,n,p,[0.16,0.1],[0.07,0.16],[0.08,0.02]);
for i = 1:S(1)
    title_text = '';
    subplot(min(2,S(1)),ceil(S(1)/2),i);
    hold on
    for j = 1:S(2)
        %         ColRow = rem(i,m);
        %         if ColRow == 0
        %             ColRow = m;
        %         end
        plot_parameters(i,j).symbreak_plot = scatter_symbreaking_oop(plot_parameters(i,j).BV);
        plot_parameters(i,j).numDrops = sum(plot_parameters(i,j).symbreak_plot.XData > Lmin & plot_parameters(i,j).symbreak_plot.XData < Lmax);
        plot_parameters(i,j).symbreak_plot.DisplayName = sprintf('%s, N=%d',plot_parameters(i,j).description, plot_parameters(i,j).numDrops);
        xlabel('Drop Diameter  [$\mu m$]', 'Interpreter' ,'Latex','FontSize',14);
        ylabel('Symmetry Breaking','FontSize',14);
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
        xlim([Lmin,Lmax]);
    end
    title(['symmetry breaking - ', title_text], 'FontWeight','normal','FontSize',14);
    plot(Lmin:Lmax , 10./((Lmin:Lmax ) * (1-plot_parameters(i,j).blobRfactor)),'k--');
    hold off
    h = legend([plot_parameters(i,:).symbreak_plot],'location','best');
    h.FontSize = 14;
end
Fig(1).Name = ['symmetry breaking - ', title_text];
if ~plotsBool(1)
    close(Fig(1))
end

if plotsBool(2)
    Fig(2) = figure;
    for i = 1:S(1)
        subplot(min(2,S(1)),ceil(S(1)/2),i);
        hold on
        for j = 1:S(2)
            plot_parameters(i,j).displacement_plot = scatter_displacement_oop(plot_parameters(i,j).BV);
            plot_parameters(i,j).displacement_plot.DisplayName = sprintf('%s, N=%d',plot_parameters(i,j).description, plot_parameters(i,j).numDrops);
            xlabel('Drop Diameter  [$\mu m$]', 'Interpreter' ,'Latex','FontSize',14);
            ylabel('Displacement','FontSize',14);
        end
        xlim([Lmin,Lmax]);
        E = [plot_parameters(i,:).displacement_plot];
        XD = [E.XData];
        YD = [E.YData];
        [maxY,Ind] = max(YD);
        ylim([0,max(round(XD(Ind)/2),maxY)]);
        title(['Displacement - ', title_text], 'FontWeight','normal','FontSize',14);
        plot(Lmin:Lmax , (Lmin:Lmax) / 2,'k--');
        plot(Lmin:Lmax , (Lmin:Lmax)*(1-plot_parameters(i,j).blobRfactor) / 2,'r--');
        
        hold off
        h = legend([plot_parameters(i,:).displacement_plot],'location','best');
        h.FontSize = 14;
    end
    Fig(2).Name = ['Displacement - ', title_text];
end

if plotsBool(3)
    Fig(3) = figure;
    for i = 1:S(1)
        subplot(min(2,S(1)),ceil(S(1)/2),i);
        hold on
        for j = 1:S(2)
            plot_parameters(i,j).angle_plot = scatter_angle_oop(plot_parameters(i,j).BV);
            plot_parameters(i,j).angle_plot.DisplayName = sprintf('%s, N=%d',plot_parameters(i,j).description, plot_parameters(i,j).numDrops);
            xlabel('Drop Diameter  [$\mu m$]', 'Interpreter' ,'Latex','FontSize',14);
            ylabel('Angle from zenith','FontSize',14);
            xlim([Lmin,Lmax]);
        end
       title(['angle - ', title_text], 'FontWeight','normal','FontSize',14);
        plot(Lmin:Lmax , pi/2 *ones(length(Lmin:Lmax),1) ,'k:');
        
        hold off
        h = legend([plot_parameters(i,:).angle_plot],'location','best');
        h.FontSize = 14;
    end
    Fig(3).Name = ['angle - ', title_text];
end
Fig(~plotsBool(1:length(Fig))) = [];
