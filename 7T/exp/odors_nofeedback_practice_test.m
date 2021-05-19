function odors_nofeedback_practice_test(offcenter_x, offcenter_y)
% ROIsLocalizer(offcenter_x, offcenter_y), [LO, FFA, and EBA]
% Scan = 390s, TR = 3s, 130TR
times=2;% even number
% times
waittime=1;
cuetime=1.5;
odortime=2;
offset=1;
blanktime=0.5;
ratetime=4.5;
jmean=12-ratetime-blanktime-odortime-cuetime;
% jitter ( 3.5s when times=2 )
if ~mod(times/2,2)
    jitter=jmean-(times/4-0.5):jmean+(times/4-0.5);   
else
    jitter=jmean-floor(times/4):jmean+floor(times/4);
end

% fixation
fix_size=18;
fix_thick=3;
fixcolor_back=[0 0 0];
fixcolor_cue=[246 123 0]; %[211 82 48];
fixcolor_inhale=[0 154 70];  %[0 0 240];

% port
port='COM4';
% open ttl port
% ttlport='COM3';

% keys
KbName('UnifyKeyNames');
Key1 = KbName('1!');
Key2 = KbName('2@');
Key3 = KbName('3#');
Key4 = KbName('4$');
Key5 = KbName('6^');
Key6 = KbName('7&');
Key7 = KbName('8*');
Key8 = KbName('9(');
escapeKey = KbName('ESCAPE');
triggerKey = KbName('s');
% text_rate={double('愉 悦 度'),double('强 度')};
text_rate={'愉 悦 度','强 度'};
text_rate={'Valence','Intensity'};
% rating instruction
imageSizex=100;
imageSizey=75;
StimSize=[0 0 imageSizex imageSizey];
StimSize_num=[0 0 450 75];
StimSize_circle=[0 0 35 35];
StimSize_rect=[0 0 20 3];
circle_w=2;
% feedbackSizex=75;
% feedbackSizey=75;
% StimSizef=[0 0 feedbackSizex feedbackSizey];
% block config
% odor seq
odors=[7 8 9 10];
air=0;
odors=repmat(odors,[times 1]);
% rating 1 valence 2 intensity
rating=[ones(times/2,size(odors,2));ones(times/2,size(odors,2))*2];
% jitter
jitter=repmat(jitter',[2 size(odors,2)]);

% final seq
seq=[reshape(odors,[],1) reshape(rating,[],1) reshape(jitter,[],1)];
seq=randseq(seq);
seq=seq(:,1:3);

% record
result=zeros(length(seq),7);
result(:,1:3)=seq;
% record all keystrokes
response=cell(length(seq),2);

% input
[subject, runnum] = inputsubinfo;
Screen('Preference', 'SkipSyncTests', 1);
% text encoding
Screen('Preference', 'TextEncodingLocale', 'UTF-8');

if nargin < 2
    offcenter_x=0; offcenter_y=-150;
end

AssertOpenGL;
whichscreen=max(Screen('Screens'));
% backup resolution
oldResolution=Screen('Resolution', whichscreen);
Screen('Resolution', whichscreen, 800, 600);

% ettport
delete(instrfindall('Type','serial'));
% ettport=ett('init',port);
% s = serial(ttlport, 'BaudRate',115200);
% fopen(s); 

%每次重启matlab时的随机种子都是相同的，所以随机数是一样的
%所以通过系统时间设置随机数的种子
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end));
rng(tseed);

% colors
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)*4/5);
backcolor=gray;

datafile=sprintf('Data%s%s_nofeed%s.mat',filesep,subject,datestr(now,30));

[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
StimRect=OffsetRect(CenterRect(StimSize,rect),offcenter_x,offcenter_y);
% StimRectf=OffsetRect(CenterRect(StimSizef,rect),offcenter_x,offcenter_y+50);
StimRect_num=OffsetRect(CenterRect(StimSize_num,rect),offcenter_x,offcenter_y+50);
% StimRect_circle=OffsetRect(CenterRect(StimSize_circle,rect),offcenter_x,offcenter_y+55);
choose=OffsetRect(CenterRect(StimSize_rect,rect),offcenter_x,offcenter_y+75);
choose=repmat(choose,[7 1])';
choose([1 3],:)=choose([1 3],:)+repmat(44*[-3:3],[2 1]);

fixationp1=OffsetRect(CenterRect([0 0 fix_thick fix_size],rect),offcenter_x,offcenter_y);
fixationp2=OffsetRect(CenterRect([0 0 fix_size fix_thick],rect),offcenter_x,offcenter_y);

fps=round(FrameRate(windowPtr));%Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
oldPriority=Priority(MaxPriority(windowPtr));
% load pictures
cd ins
ins(1)=Screen('MakeTexture', windowPtr, imread('valence.bmp'));
ins(2)=Screen('MakeTexture', windowPtr, imread('intensity.bmp'));
number=Screen('MakeTexture', windowPtr, imread('number.bmp'));
cd ..
HideCursor;
ListenChar(2);      %关闭Matlab自带键盘监听
% ett('set',ettport,air); 
% start screen
msg=sprintf('Waiting for the trigger to start...');
errinfo=ShowInstructionSE_UMNVAL(windowPtr, rect, msg, triggerKey, backcolor, white);
    if errinfo==1
		Screen('CloseAll');
        return
    end

tic;
zerotime=GetSecs;
% start marker
% fwrite(s, 1);

% start
Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
Screen('Flip',windowPtr);

% wait time
WaitSecs(waittime);
% after wait
% fwrite(s, 0);


for cyc=1:length(seq)
    
    odor=seq(cyc,1);
    
    % hint
    Screen('FillRect',windowPtr,fixcolor_cue,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_cue,fixationp2);
    vbl=Screen('Flip',windowPtr);
    starttime=GetSecs;
    result(cyc,4)=starttime-zerotime;
    % trial start
%     fwrite(s, 2);
    
    % open
    WaitSecs(cuetime-offset);
%     ett('set',ettport,odor);
    % odor
%     fwrite(s, odor);
    
    % offset
    % WaitSecs(offset);
    
    % inhale
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp2);
    vbl=Screen('Flip', windowPtr, vbl + (fps*cuetime-0.1)*ifi);
    trialtime=GetSecs;
    result(cyc,5)=trialtime-zerotime;
    
    % close 
    WaitSecs(odortime-offset);
%     ett('set',ettport,air);    
    % odor off
%     fwrite(s, air);

    % offset
    WaitSecs(offset);
    
    % blank screen
    Screen('FillRect',windowPtr,fixcolor_back ,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    Screen('Flip', windowPtr);
    WaitSecs(blanktime);
    
    % rating
    point=4;
    Screen('DrawTexture',windowPtr,ins(seq(cyc,2)),[],StimRect);
    Screen('DrawTexture',windowPtr,number,[],StimRect_num);
    Screen('FillRect',windowPtr,black,choose(:,point));
%     Screen('FrameOval',windowPtr,black,StimRect_circle,circle_w);
%     [r1,r2]=Screen('TextBounds',windowPtr,text_rate{seq(cyc,2)});
%     disp([r1 r2])
%     Screen('FrameRect',windowPtr,0,r2);
%     Screen('DrawText',windowPtr,text_rate{seq(cyc,2)});
    vbl=Screen('Flip',windowPtr);
    lastsecs=0;
    while GetSecs-trialtime<(fps*(odortime+blanktime+ratetime)-0.9)*ifi        
        [touch, secs, keyCode] = KbCheck;
        ifkey=[keyCode(Key1) keyCode(Key2) keyCode(Key3)];
        if touch && ismember(1,ifkey)             
            switch find(ifkey==1,1,'first')
                % left
                case 1
                    if secs-lastsecs>0.2
                    point=max(1,point-1);
                    response{cyc,1}=[response{cyc,1} 1];
                    response{cyc,2}=[response{cyc,2} secs-trialtime];
                    Screen('DrawTexture',windowPtr,ins(seq(cyc,2)),[],StimRect);
                    Screen('DrawTexture',windowPtr,number,[],StimRect_num);
                    Screen('FillRect',windowPtr,black,choose(:,point));
                    Screen('Flip', windowPtr);
                    lastsecs=secs;
                    end
                % right
                case 2
                    if secs-lastsecs>0.2
                    point=min(7,point+1);
                    response{cyc,1}=[response{cyc,1} 2];
                    response{cyc,2}=[response{cyc,2} secs-trialtime];
                    Screen('DrawTexture',windowPtr,ins(seq(cyc,2)),[],StimRect);
                    Screen('DrawTexture',windowPtr,number,[],StimRect_num);
                    Screen('FillRect',windowPtr,black,choose(:,point));
                    Screen('Flip', windowPtr);
                    lastsecs=secs;
                    end
                % confirm
                case 3
                    if ~ismember(3,response{cyc,1})      
                    result(cyc,6)=point;
                    result(cyc,7)=secs-trialtime;
                    response{cyc,1}=[response{cyc,1} 3];
                    response{cyc,2}=[response{cyc,2} result(cyc,7)];
                    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
                    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
                    Screen('Flip', windowPtr);
                    end
            end
        elseif touch && keyCode(escapeKey)
            ListenChar(0);      %还原Matlab键盘监听
            Screen('CloseAll');
            save(datafile,'result','response');
            return
        end
    end

    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    vbl = Screen('Flip', windowPtr, vbl + (fps*ratetime-0.1)*ifi);

    while GetSecs-trialtime<odortime+blanktime+ratetime+seq(cyc,3)%jitter
        [touch, ~, keyCode] = KbCheck;
        if touch && keyCode(escapeKey)
            ListenChar(0);      %还原Matlab键盘监听
            Screen('CloseAll');
            save(datafile,'result','response');
            return
        end
    end
    
end

toc;
% restore
Priority(oldPriority);
ShowCursor;
ListenChar(0);      %还原Matlab键盘监听
Screen('CloseAll');
%restore resolution
Screen('Resolution', whichscreen, oldResolution.width, oldResolution.height);
%save
save(datafile,'result','response');
return