function rating=mrirate(sub)
% extract ratings for odors presented by olfactometer
% sub is the number of subject

run=6;
times=8;
if ~ischar(sub)
    sub=sprintf('S%02d',sub);
end
datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];

%% similarity
if strcmp(sub,'S01_yyt')
    data=dir([datadir lower('S01') '_similarity*.mat']);
else
    data=dir([datadir lower(sub) '_similarity*.mat']);
end
dataname=data(1).name;
load([datadir filesep dataname]);
% change odors to 1-4
result(:,1:2)=sort(result(:,1:2),2)-6;
% get odornumber
odornum=length(unique([result(:,1);result(:,2)]));
% sort rows
result=sortrows(result,[1 2]);
% reshape to 2 rows
similarity=reshape(result(:,6),2,[]);
% calculate means
similarity(similarity==0)=nan;
rating.similarity=nanmean(similarity);

%% intensity and valence
intensity=zeros(run*times/2,odornum);
valence=intensity;
% change sub to match filename
sub=[lower(sub) '_run'];

for i=1:run
    if strcmp(sub,'s01_run')
        % S01 is named from s01_run7
        data=dir([datadir sub num2str(i+6) '*.mat']);
    elseif strcmp(sub,'s01_yyt_run')
        % S01_yyt is named from s01_run1
        data=dir([datadir 's01_run' num2str(i) '*.mat']);
    else
        data=dir([datadir sub num2str(i) '*.mat']);
    end
    dataname=data(1).name;
    load([datadir filesep dataname]);
%     disp(['analyze' sub num2str(i)]);
    
    % rating    
    % intensity=mean(result(result(:,1)==10&result(:,2)==2&result(:,6)~=0,6));
    intensity((i-1)*times/2+1:i*times/2,1)=result(result(:,1)==7&result(:,2)==2,6);
    intensity((i-1)*times/2+1:i*times/2,2)=result(result(:,1)==8&result(:,2)==2,6);
    intensity((i-1)*times/2+1:i*times/2,3)=result(result(:,1)==9&result(:,2)==2,6);
    intensity((i-1)*times/2+1:i*times/2,4)=result(result(:,1)==10&result(:,2)==2,6);
    % valence
    valence((i-1)*times/2+1:i*times/2,1)=result(result(:,1)==7&result(:,2)==1,6);
    valence((i-1)*times/2+1:i*times/2,2)=result(result(:,1)==8&result(:,2)==1,6);
    valence((i-1)*times/2+1:i*times/2,3)=result(result(:,1)==9&result(:,2)==1,6);
    valence((i-1)*times/2+1:i*times/2,4)=result(result(:,1)==10&result(:,2)==1,6);
end
% calculate means
valence(valence==0)=nan;
intensity(intensity==0)=nan;

rating.valence=nanmean(valence);
rating.intensity=nanmean(intensity);

%% RDMs
d=(7-rating.similarity)/6;
rating.simRDM=squareform(d);
rating.valRDM=pdist2(rating.valence',rating.valence')/6;
rating.intRDM=pdist2(rating.intensity',rating.intensity')/6;
end