function [MKT, HML, SMB, VOD, BP, SHELL, GSK, SL] = DatasetHandling()
% Load from Excel
datasheet = 'BookN100.xls';
SMB = dataset('XLSFile', datasheet ,'Sheet','SMB')
file = 'SMBdata.dat';
% Save to matlab dataset
save(file, 'SMB')
% Load from matlab dataset
load(file,'-mat')


MKT = dataset('XLSFile',datasheet,'Sheet','MKT')
file = 'MKTdata.dat';
save(file, 'MKT')
load(file,'-mat')

HML = dataset('XLSFile', datasheet ,'Sheet','HML')
file = 'HMLdata.dat';
save(file, 'HML')
load(file,'-mat')

% For Vodafone stock returns
VOD = dataset('XLSFile',datasheet ,'Sheet','VODUK')
file = 'VODdata.dat';
save(file, 'VOD')
load(file,'-mat')

% For BP stock returns
BP = dataset('XLSFile',datasheet, 'Sheet','BPUK')
file = 'BPdata.dat';
save(file, 'BP')
load(file,'-mat')

% For Vodafone stock returns
SHELL = dataset('XLSFile',datasheet,'Sheet','SHELLUK')
file = 'SHELLdata.dat';
save(file, 'SHELL')
load(file,'-mat')

% For Vodafone stock returns
GSK = dataset('XLSFile',datasheet,'Sheet','GSKUK')
file = 'GSKdata.dat';
save(file, 'GSK')
load(file,'-mat')

% For Vodafone stock returns
SL = dataset('XLSFile',datasheet,'Sheet','SLUK')
file = 'SLdata.dat';
save(file, 'SL')
load(file,'-mat')
end