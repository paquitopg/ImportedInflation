%[~,data_tab, thetime] = call_dbnomics('Eurostat/IRT_LT_GBY10_M/M.Y10.TR')

[output_mat,output_table,dates_nb] = call_dbnomics('Eurostat/prc_hicp_manr/M.RCH_A.TOT_X_NRG.AT')
thetime = datenum(dates_nb)

figure;
plot(thetime, output_table)
xlabel('Date');
ylabel('Values');
title('Data from Eurostat');
grid on;
legend(ooutput_table.Properties.VariableNames, 'Location', 'best');