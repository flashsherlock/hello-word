run=6;
times=8;
sub='s01_run';
datadir='/Volumes/WD_D/gufei/7T_odor/S01_yyt/behavior/';
cd(datadir);
timing=zeros(run,times,4);

for i=1:run
    data=dir([sub num2str(i) '*.mat']);
    dataname=data(1).name;
    load(dataname);
    disp([sub num2str(i)]);
    % response number
    resnum=length(result(result(:,6)~=0,7));
    rt=mean(result(result(:,6)~=0,7));
    % rt-2.5(green cross and black cross) is real rt
    disp([resnum rt-2.5]);
    % odor numbers
    odors=unique(result(:,1));    
    % for each odor, find timing
    for oi=1:length(odors)
        odor=odors(oi);        
        inhale=result(result(:,1)==odor,5)';
        timing(i,:,oi)=inhale;
    end
    
end

names={'lim','tra','car','cit'};
for i=1:length(names)
    % timing for each odor(all runs)
    dlmwrite([names{i} '.txt'],timing(:,:,i),'delimiter',' ');
    % timing for each odor(each run)
    for runi=1:run
        dlmwrite([names{i} '_run_' num2str(runi) '.txt'],timing(runi,:,i),'delimiter',' ');
    end
end
