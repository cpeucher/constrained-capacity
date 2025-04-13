% -------------------------------------------------------------------------
% We plot constellation-constrained capacity for a number of
% one-dimensional constellations.
%
% We reproduce Fig. 2a in  
% G. Ungerboeck, "Channel Coding with Multilevel/Phase Signals," 
% IEEE Trans. Inf. Theory IT-28, 55 (1982) [doi: 10.1109/TIT.1982.1056454]
%
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Clean-up
% -------------------------------------------------------------------------
clear all
close all

% -------------------------------------------------------------------------
% Switches
% -------------------------------------------------------------------------
do_print = 1;
do_add_figsize_to_filename = 1;
margin_figure = 0;


%%
% -------------------------------------------------------------------------
% Fonts etc.
% -------------------------------------------------------------------------
fig.font_name = 'times';
fig.font_size = 15;
fig.interpreter = 'latex';
mred = [178 0 24]/255;

% -------------------------------------------------------------------------
% File name
% -------------------------------------------------------------------------
file_name_core_figure = strrep(mfilename,'plot','fig');
file_name_core_data = strrep(mfilename,'plot','data');
time_stamp = datestr(datetime('now','TimeZone','Z'),'yyyymmddThhMMSSZ');


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

do_recalculate = 0;
% Computation can be lengthy. 
% Choose whether to load a data file or to recalculate everything.

% If do_recalculate = 0, then load the data below:
data_path = '../data/';
data_fname = 'data_constellation_constrained_capacity_1d_20230620T053816Z.mat';


% -------------------------------------------------------------------------
% Processing
% -------------------------------------------------------------------------
switch do_recalculate
    
    case 1
        % We fancy recalculating everything.
        
        nreal = 10000;
        % Number of noise realisations for Monte-Carlo estimation.
        
        snr_db = [-10:1:40];
        % Signal-to-noise ration range, in dB.
        
        snr = 10.^(snr_db/10);
        % Linear values of the signal-to-noise ratio.
        
        nquad = 1;
        % Number of noise quadratures / dimensionality of the signal.
        % We focus on 1D constellations in this script.        
        
        
        [constellation,norm_es,norm_emax] = define_constellation('bpsk',2);
        [cstar_pam2,snr_est_db_pam2] = calc_constellation_constrained_capacity(constellation,snr,nquad,nreal);
        
        [constellation,norm_es,norm_emax] = define_constellation('pam4_natural',4);
        [cstar_pam4,snr_est_db_pam4] = calc_constellation_constrained_capacity(constellation,snr,nquad,nreal);
        
        [constellation,norm_es,norm_emax] = define_constellation('pam8_natural',8);
        [cstar_pam8,snr_est_db_pam8] = calc_constellation_constrained_capacity(constellation,snr,nquad,nreal);
        
        [constellation,norm_es,norm_emax] = define_constellation('pam16_natural',16);
        [cstar_pam16,snr_est_db_pam16] = calc_constellation_constrained_capacity(constellation,snr,nquad,nreal);
        
        [constellation,norm_es,norm_emax] = define_constellation('pam32_natural',32);
        [cstar_pam32,snr_est_db_pam32] = calc_constellation_constrained_capacity(constellation,snr,nquad,nreal);
        
        [constellation,norm_es,norm_emax] = define_constellation('pam64_natural',64);
        [cstar_pam64,snr_est_db_pam64] = calc_constellation_constrained_capacity(constellation,snr,nquad,nreal);
        
        c_shannon = 0.5*nquad*log2(1 + snr);
        % Shannon capacity.
        
        file_name_data = [file_name_core_data '_' time_stamp];
        save(file_name_data,'snr_db','cstar_pam2','cstar_pam4','cstar_pam8','cstar_pam16','cstar_pam32','cstar_pam64','c_shannon');
        % Save the data.
        
        
    case 0
        % We do not want to recalculate.
        % We load an exisiting data file.
        
        load([data_path data_fname]);
        
end








%%
% -------------------------------------------------------------------------
% Figure: 
% -------------------------------------------------------------------------
fig_name = [file_name_core_figure];
hfig = figure('Name',fig_name);

% -------------------------------------------------------------------------
% Choice of colormap
% -------------------------------------------------------------------------
line_color = linspecer(6,'qualitative');
% Use plot(x,y,'Color',line_color(1,:));


% -------------------------------------------------------------------------
% Plot
% -------------------------------------------------------------------------
% yyaxis left
h1 = plot(snr_db,cstar_pam2,'LineWidth',1.5,'Color',line_color(1,:),'LineStyle','-','Marker','none','MarkerSize',12,'MarkerFaceColor','w','HandleVisibility','on');
hold on
h2 = plot(snr_db,cstar_pam4,'LineWidth',1.5,'Color',line_color(2,:),'LineStyle','-','Marker','none','MarkerSize',12,'MarkerFaceColor','w','HandleVisibility','on');
h3 = plot(snr_db,cstar_pam8,'LineWidth',1.5,'Color',line_color(3,:),'LineStyle','-','Marker','none','MarkerSize',12,'MarkerFaceColor','w','HandleVisibility','on');
h4 = plot(snr_db,cstar_pam16,'LineWidth',1.5,'Color',line_color(4,:),'LineStyle','-','Marker','none','MarkerSize',12,'MarkerFaceColor','w','HandleVisibility','on');
% h5 = plot(snr_db,cstar_pam32,'LineWidth',1.5,'Color',line_color(5,:),'LineStyle','-','Marker','none','MarkerSize',12,'MarkerFaceColor','w','HandleVisibility','on');
% h6 = plot(snr_db,cstar_pam64,'LineWidth',1.5,'Color',line_color(6,:),'LineStyle','-','Marker','none','MarkerSize',12,'MarkerFaceColor','w','HandleVisibility','on');

h7 = plot(snr_db,c_shannon,'LineWidth',1.5,'Color','k','LineStyle','-','Marker','none','MarkerSize',12,'MarkerFaceColor','w','HandleVisibility','on');


% -------------------------------------------------------------------------
% Legend
% -------------------------------------------------------------------------
% hleg = legend([h7,h6,h5,h4,h3,h2,h1],{'Shannon','PAM-64','PAM-32','PAM-16','PAM-8','PAM-4','PAM-2'});

hleg.Title.String = '';
hleg.Location = 'NorthWest';
hleg.Orientation = 'vertical';
hleg.NumColumns = 1;

hleg.Box = 'on';
hleg.EdgeColor = 'none';
hleg.TextColor = 'black';
hleg.Color = 'white';
hleg.LineWidth = 1;

hleg.Interpreter = fig.interpreter;
hleg.FontName = fig.font_name;
hleg.FontSize = fig.font_size;

hleg.Visible = 'on';


% -------------------------------------------------------------------------
% Axes
% -------------------------------------------------------------------------
ax = gca;

ax.LineWidth = 1.5;
% ax.XMinorTick = 'on';
% ax.YMinorTick = 'on';
ax.TickLength = [0.01 0.025]*1.5;
ax.TickLabelInterpreter = fig.interpreter;

ax.XAxis.FontName = fig.font_name;
ax.XAxis.FontSize = fig.font_size;
ax.XAxis.Color = 'k';
xlim([-10 40]);
% ax.XTick = [ ];
% xtickformat(ax,'%3.3f')
% ax.XTickLabel = {'','',''}

% yyaxis left
ax.YAxis(1).FontName = fig.font_name;
ax.YAxis(1).FontSize = fig.font_size;
ax.YAxis(1).Color = 'k';
ylim([0 4.7]);
% ax.YTick = [ ];
% ytickformat(ax,'%3.3f')
% ax.YTickLabel = {'','',''}

% yyaxis right
% ax.YAxis(2).FontName = figparams.font_name;
% ax.YAxis(2).FontSize = figparams.font_size;
% ax.YAxis(2).Color = 'k';
% ylim([0 4.7]);
% ax.YTick = [ ];
% ytickformat(ax,'%3.3f')
% ax.YTickLabel = {'','',''}

% ax.Layer = 'top';
% Whenever needed, ensure that the axes are on top of e.g. color boxes.


% -------------------------------------------------------------------------
% Axes labels
% -------------------------------------------------------------------------
x1 = xlabel('$\mathrm{SNR}$ (dB)');
x1.Interpreter = fig.interpreter;
x1.FontName = fig.font_name;
x1.FontSize = fig.font_size;
x1.FontWeight = 'normal';
x1.Color = 'k';

% yyaxis left
yl = ylabel('$C^*$ (bit/symbol)');
yl.Interpreter = fig.interpreter;
yl.FontName = fig.font_name;
yl.FontSize = fig.font_size;
yl.FontWeight = 'normal';
yl.Color = 'k';

% yyaxis right
% y2 = ylabel('');
% y2.Interpreter = figparams.interpreter;
% y2.FontName = figparams.font_name;
% y2.FontSize = figparams.font_size;
% y2.FontWeight = 'normal';
% y2.Color = 'k';



% -------------------------------------------------------------------------
% Grid lines
% -------------------------------------------------------------------------
ax.XGrid = 'off';
ax.XMinorGrid = 'off';

ax.YGrid = 'on';
ax.YMinorGrid = 'off';

ax.GridColorMode = 'manual';
ax.GridColor = 'k';

ax.MinorGridColorMode = 'manual';
ax.MinorGridColor = 'k';

ax.GridAlphaMode = 'manual';
ax.GridAlpha = 0.25;

ax.MinorGridAlphaMode = 'manual';
ax.MinorGridAlpha = 0.25;

ax.GridLineStyle = '--';
ax.MinorGridLineStyle = '--';


% -------------------------------------------------------------------------
% Add text
% -------------------------------------------------------------------------
label_position_x = 28;
label_position_y_offset = 0.2;

tt1 = text(label_position_x,1 + label_position_y_offset,'PAM-2','Interpreter',fig.interpreter,'FontName',fig.font_name,'FontSize',fig.font_size,'HorizontalAlignment','left');
tt2 = text(label_position_x,2 + label_position_y_offset,'PAM-4','Interpreter',fig.interpreter,'FontName',fig.font_name,'FontSize',fig.font_size,'HorizontalAlignment','left');
tt3 = text(label_position_x,3 + label_position_y_offset,'PAM-8','Interpreter',fig.interpreter,'FontName',fig.font_name,'FontSize',fig.font_size,'HorizontalAlignment','left');
tt4 = text(label_position_x,4 + label_position_y_offset,'PAM-16','Interpreter',fig.interpreter,'FontName',fig.font_name,'FontSize',fig.font_size,'HorizontalAlignment','left');
% tt5 = text(label_position_x,5 + label_position_y_offset,'PAM-32','Interpreter',fig.interpreter,'FontName',fig.font_name,'FontSize',fig.font_size,'HorizontalAlignment','left');
% tt6 = text(label_position_x,6 + label_position_y_offset,'PAM-64','Interpreter',fig.interpreter,'FontName',fig.font_name,'FontSize',fig.font_size,'HorizontalAlignment','left');

% We display the label of the Shannon capacity curve (with proper slope...)
% after we have rescaled the figure.

% tt = text(0.63,-0.5,'$x \simeq 0.6$');
% tt.Interpreter = fig.interpreter;
% tt.FontSize = fig.font_size;
% tt.FontName = fig.font_name;
% tt.FontWeight = 'normal';
% tt.Color = 'black';
% tt.HorizontalAlignment = 'left';


% -------------------------------------------------------------------------
% Horizontal or vertical lines
% -------------------------------------------------------------------------
% xline = 7.5;
% yy = get(gca,'ylim');
% plot([xline xline],yy,'k--','LineWidth',1);
% % Vertical line
% 
% yline = 0.4;
% xx = get(gca,'xlim');
% plot(xx,[yline yline],'k','Linewidth',1);
% % Horizontal line


% -------------------------------------------------------------------------
% Adjust aspect ratio of the figure, if needed.
% -------------------------------------------------------------------------
if margin_figure
    hfig.Position(3:4) = [1 0.9]*hfig.Position(4);
end

% -------------------------------------------------------------------------
% Add label on the Shannon capacity curve
% -------------------------------------------------------------------------

% Experimentation to display a label with proper slope

label_position_x = 20;
DDY = ylim(gca);
DDX = xlim(gca);

index_anchor = find(snr_db == label_position_x);

slope = (c_shannon(index_anchor + 1) - c_shannon(index_anchor))/(snr_db(index_anchor + 1) - snr_db(index_anchor))/((DDY(2) - DDY(1))/(DDX(2) - DDX(1)))/(hfig.Position(3)/hfig.Position(4));
angle_label = atan(slope)/pi*180;

tt7 = text(label_position_x,c_shannon(index_anchor)+ 0.2,'Shannon','Interpreter',fig.interpreter,'FontName',fig.font_name,'FontSize',fig.font_size,'HorizontalAlignment','center','VerticalAlignment','bottom','BackgroundColor','w','Rotation',angle_label);

% End of experimentation





% -------------------------------------------------------------------------
% print to file
% -------------------------------------------------------------------------
if do_add_figsize_to_filename
    [figure_ratio_numerator,figure_ratio_denominator] = rat(hfig.Position(3)/hfig.Position(4));
    fig_name = [fig_name '_w' num2str(figure_ratio_numerator,'%u') 'h' num2str(figure_ratio_denominator,'%u')];
end

if do_print
    print(fig_name,'-dmeta');  
    print(fig_name,'-djpeg');
    print(fig_name,'-dpdf');
    crop_command =['pdfcrop ' fig_name '.pdf ' fig_name '.pdf'];
    system(crop_command);
end