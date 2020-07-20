function varargout = respir(varargin)
% RESPIR MATLAB code for respir.fig
%      RESPIR, by itself, creates a new RESPIR or raises the existing
%      singleton*.
%
%      H = RESPIR returns the handle to a new RESPIR or the handle to
%      the existing singleton*.
%
%      RESPIR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESPIR.M with the given input arguments.
%
%      RESPIR('Property','Value',...) creates a new RESPIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before respir_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to respir_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
% GuFei 2020/07/20
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help respir

% Last Modified by GUIDE v2.5 21-Jul-2020 00:20:33

% Begin initialization code - DO NOT EDIT
% 0-allow more than one widow 1-only one window
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @respir_OpeningFcn, ...
                   'gui_OutputFcn',  @respir_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before respir is made visible.
function respir_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to respir (see VARARGIN)

% change path
workingpath=fileparts(mfilename('fullpath'));
cd(workingpath);
% set workingpath
set(handles.path,'string',workingpath);
handles.workingpath=workingpath;
% set acq as default
handles.datatype='acq';
set(handles.acq,'Value',1);
set(handles.acq,'BackgroundColor','green');
% init list
data=list('.',handles.datatype);
set(handles.data,'string',data);
handles.filename=data{1};
% plot matlab icon
LL=40*membrane(1,25);
surfl(LL)
shading interp
axis off
% disable buttons
handles=setbuttons(handles,'off');
% title('GUI tool for marking respiration','Fontsize',12)
% Choose default command line output for respir
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes respir wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = respir_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in choose.
function choose_Callback(hObject, eventdata, handles)
% hObject    handle to choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% choose point on the figure
handles=choosepoint(handles);
% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% interplay with two other buttons
if get(hObject,'Value')
    set(handles.stop,'Value',0);
    set(handles.peak,'Value',0);
    handles.choosetype='start';
    set(handles.choose,'Enable','on');
    set(handles.stop,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.peak,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.start,'BackgroundColor','green');
else
    handles.choosetype='';
    set(handles.choose,'Enable','off');
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end
guidata(hObject, handles);

function peak_Callback(hObject, eventdata, handles)
% hObject    handle to peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% interplay with two other buttons
if get(hObject,'Value')
    set(handles.stop,'Value',0);
    set(handles.start,'Value',0);
    handles.choosetype='peak';
    set(handles.choose,'Enable','on');
    set(handles.stop,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.start,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.peak,'BackgroundColor','green');
else
    handles.choosetype='';
    set(handles.choose,'Enable','off');
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end
guidata(hObject, handles);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% interplay with two other buttons
if get(hObject,'Value')
    set(handles.start,'Value',0);
    set(handles.peak,'Value',0);
    handles.choosetype='stop';
    set(handles.choose,'Enable','on');
    set(handles.start,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.peak,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.stop,'BackgroundColor','green');
else
    handles.choosetype='';
    set(handles.choose,'Enable','off');
    set(hObject,'BackgroundColor',[0.94,0.94,0.94]);
end
guidata(hObject, handles);



% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% save data to mat
% guisave stores unedited respiration points
guisave=handles.guisave;
data=handles.tempdata;
save([handles.workingpath '/' handles.savename '.mat'],'data','guisave');



% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% set path by txt
handles.workingpath=get(hObject,'String');
% get data file list
data=list(handles.workingpath,handles.datatype);
% set display
set(handles.data,'string',data);
if ~isempty(data)
    % the first file is default file
    handles.filename=data{1};
else
    set(handles.load,'Enable','off');
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a double

% --- Executes on button press in setpath.
function setpath_Callback(hObject, eventdata, handles)
% hObject    handle to setpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% set path by gui
temp= uigetdir('*.*','Choose a folder');
% ensure temp is not 0
if temp~=0
    % set path
    handles.workingpath=temp;
    set(handles.path,'String',handles.workingpath);
    % set display of the listbox
    data=list(handles.workingpath,handles.datatype);
    set(handles.data,'string',data);
    % set the first file as default file
    if ~isempty(data)
        handles.filename=data{1};
    else
        set(handles.load,'Enable','off');
    end
    guidata(hObject, handles);
end



% --- Executes on button press in acq.
function acq_Callback(hObject, eventdata, handles)
% hObject    handle to acq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% interplay with mat button
if get(hObject,'Value')
    set(handles.mat,'Value',0);
    handles.datatype='acq';
    set(handles.mat,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.acq,'BackgroundColor','green');
else
    set(handles.mat,'Value',1);
    handles.datatype='mat';
    set(handles.mat,'BackgroundColor','green');
    set(handles.acq,'BackgroundColor',[0.94,0.94,0.94]);
end
% update filename list
data=list(handles.workingpath,handles.datatype);
set(handles.data,'string',data);
if ~isempty(data)
    set(handles.data,'Value',1);
    handles.filename=data{1};
end
guidata(hObject, handles);


% --- Executes on button press in mat.
function mat_Callback(hObject, eventdata, handles)
% hObject    handle to mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%和mat按钮互斥
if get(hObject,'Value')
    set(handles.acq,'Value',0);
    handles.datatype='mat';
    set(handles.acq,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.mat,'BackgroundColor','green');
else
    set(handles.acq,'Value',1);
    handles.datatype='acq';
    set(handles.mat,'BackgroundColor',[0.94,0.94,0.94]);
    set(handles.acq,'BackgroundColor','green');
end
% update filename list
data=list(handles.workingpath,handles.datatype);
set(handles.data,'string',data);
if ~isempty(data)
set(handles.data,'Value',1);
handles.filename=data{1};
% 检查mat文件是不是对的
    if strcmp(handles.datatype,'mat')
            load([handles.workingpath,'/',handles.filename]);
            if ~exist('guisave','var')
                set(handles.load,'Enable','off');
            end
    end
end
guidata(hObject, handles);

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.filename)
    switch handles.datatype
        case 'mat'
            load([handles.workingpath,'/',handles.filename]);
        case 'acq'
            alldata=load_acq([handles.workingpath '/' handles.filename]);
            [data,error]=marker_trans(alldata.data);
            res=findres(data);
            data(:,3)=res;
            disp(error);
            if error==0
                % 去掉首尾的部分减少工作量,先找到marker的首位和末位然后延伸
                first=find(data(:,2)~=0,1,'first');
                last=find(data(:,2)~=0,1,'last');
                % 前面取到上一个结束位置的后一个点
                first2=find(data(1:first,3)==3,1,'last')+1;
                % 后面取到下一个开始位置的前一个点
                last2=last+find(data(last+1:end,3)==1,1,'first')-1;
                if ~isempty(first2)
                    first=first2;
                end
                if ~isempty(last2)
                    last=last2;
                end
                data=data(first:last,:);
            end
    end
            handles.tempdata=data;

    % enable buttons
    handles=setbuttons(handles,'on');
% 设置保存的名称部分
    set(handles.name,'String',handles.filename(1:end-4));
    name_Callback(hObject, eventdata, handles)
    handles.savename=get(handles.name,'String');
% 找到呼吸的数量
handles.resnum=length(find(data(:,3)==2));
% 初始化时间点的矩阵
handles.points=findpoints(data);
handles.guisave=handles.points;
% 用来调试转换是否正确
% d=transmat(handles.points,length(data(:,3)));
% if isequal(d,data(:,3))
%     disp('OK');
% end
% 设置滚动条和数字显示
set(handles.allnum,'String',num2str(handles.resnum));
set(handles.position,'Max',handles.resnum);
set(handles.position,'Value',1);
% 设置plot的位置
handles.plotnum=1;
set(handles.currentnum,'String','1');
% plot
plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
% % set start as default
% set(handles.start,'Value',1);
% handles.choosetype='start';
% set(handles.start,'BackgroundColor','green');
end
guidata(hObject, handles);



% --- Executes on button press in plotall.
function plotall_Callback(hObject, eventdata, handles)
% hObject    handle to plotall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% plot all data points
% plot in a new figure
figure;
set(gcf,'position',[0 150 3500 300])
plot(handles.tempdata(:,1));
% set title, avoid latex
title(handles.filename,'Interpreter','none','Fontsize',12,'LineWidth',3);
hold on
% plot respiration markers
resplot(handles.tempdata);

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% disp(eventdata.Key);
switch eventdata.Key
    % press d or leftarrow to move left
    case {'leftarrow','d'}
    if strcmp(get(handles.left,'Enable'),'on')
        if handles.plotnum>1
        handles.plotnum=handles.plotnum-1;
        set(handles.currentnum,'String',num2str(handles.plotnum));
        set(handles.position,'Value',handles.plotnum);
        plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
        end
    end
    %press f or rightarrow to move right
    case {'rightarrow','f'}
    if strcmp(get(handles.right,'Enable'),'on')
        if handles.plotnum<handles.resnum
        handles.plotnum=handles.plotnum+1;
        set(handles.currentnum,'String',num2str(handles.plotnum));
        set(handles.position,'Value',handles.plotnum);
        plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
        end
    end
    %press v or downarrow to choose point
    case {'downarrow','v'}
    if strcmp(get(handles.choose,'Enable'),'on')
        handles=choosepoint(handles);
    end
    %press s to save the data
    case 's'
    guisave=handles.guisave;
    data=handles.tempdata;
    save([handles.workingpath '/' handles.savename '.mat'],'data','guisave');
end
guidata(hObject, handles);

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.plotnum>1
handles.plotnum=handles.plotnum-1;
set(handles.currentnum,'String',num2str(handles.plotnum));
set(handles.position,'Value',handles.plotnum);
plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
end
guidata(hObject, handles);

% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.plotnum<handles.resnum
handles.plotnum=handles.plotnum+1;
set(handles.currentnum,'String',num2str(handles.plotnum));
set(handles.position,'Value',handles.plotnum);
plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function currentnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function currentnum_Callback(hObject, eventdata, handles)
% hObject    handle to currentnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num=str2num(get(hObject,'String'));
if num>=1 && num <=handles.resnum
    handles.plotnum=num;
    set(handles.position,'Value',handles.plotnum);
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
else
    set(handles.currentnum,'String',num2str(handles.plotnum));
end
guidata(hObject, handles);

% --- Executes on slider movement.
function position_Callback(hObject, eventdata, handles)
% hObject    handle to position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plotnum=ceil(get(hObject,'Value'));
set(handles.position,'Value',handles.plotnum);
set(handles.currentnum,'String',handles.plotnum);
plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
guidata(hObject, handles);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function position_CreateFcn(hObject, eventdata, handles)
% hObject    handle to position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% delete temporarily by changing the forth column
handles.points(handles.plotnum,4)=0;
temp=handles.tempdata;
temp(:,3)=transmat(handles.points,length(handles.tempdata(:,3)));
if handles.plotnum==handles.resnum
   currentnum=handles.plotnum-1;
else
   currentnum=handles.plotnum;
end
% plot
plotcurrentnum(temp,currentnum,handles.filename);

% confirmation
answer=questdlg('Do you confirm？','Clear','Yes','No','No');
if strcmp(answer,'Yes')
    handles.points(handles.plotnum,:)=[];
    handles.tempdata=temp;
    handles.resnum=handles.resnum-1;
    set(handles.allnum,'String',handles.resnum);
    set(handles.position,'Max',handles.resnum);
    handles.plotnum=currentnum;
    set(handles.position,'Value',handles.plotnum);
    set(handles.currentnum,'String',handles.plotnum);
    % plot
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
else
    handles.points(handles.plotnum,4)=1;
    % plot
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
end
guidata(hObject, handles);


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.plot);
[x,~]=ginput(3);
x=sort(floor(x));
points=handles.points(handles.points(:,4)~=0,:);
% 考虑第一个和最后一个是不同的
if handles.plotnum==1
    xmin=1;
    xmax=points(handles.plotnum+1,2);
elseif handles.plotnum==handles.resnum
    xmin=points(handles.plotnum-1,2);
    xmax=length(handles.tempdata(:,1));
else
    xmin=points(handles.plotnum-1,2);
    xmax=points(handles.plotnum+1,2);
end

% if the point is in the range
if all(x>=1) && all(x<=xmax-xmin+1)
    x=xmin+x-1;
    x=x';
    oldx=points(handles.plotnum,2);
    points(end+1,:)=[x 1];
    points=sortrows(points,2);
    handles.points=points;
    handles.tempdata(:,3)=transmat(handles.points,length(handles.tempdata(:,3)));
    % 改变数字
    handles.resnum=handles.resnum+1;
    if x(2)>=oldx
        handles.plotnum=handles.plotnum+1;
    end
    % plot
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
    % 设置显示
    set(handles.allnum,'String',handles.resnum);
    set(handles.position,'Max',handles.resnum);
    set(handles.position,'Value',handles.plotnum);
    set(handles.currentnum,'String',handles.plotnum);
end
guidata(hObject, handles);

function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.savename=get(handles.name,'String');
if isempty(dir([handles.workingpath,'/',handles.savename,'.mat']))
        set(handles.save,'BackgroundColor','green');
else
        set(handles.save,'BackgroundColor','red');
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of name as text
%        str2double(get(hObject,'String')) returns contents of name as a double


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate plot


% --- Executes on selection change in data.
function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.load,'Enable','on');
handles.filename=get(hObject,'String');
if ~isempty(handles.filename)
handles.filename=handles.filename{get(hObject,'Value')};
fnum=length(dir([handles.workingpath,'/',handles.filename(1:end-3) '*']));
switch fnum
    case 1
        set(handles.load,'BackgroundColor','green');
    case 2
        set(handles.load,'BackgroundColor','red');
end
% 检查mat文件是不是对的
    if strcmp(handles.datatype,'mat')
            load([handles.workingpath,'/',handles.filename]);
            % 判断是否是该程序生成的矩阵
            if ~exist('guisave','var')
                set(handles.load,'Enable','off');
            end
    end
end
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from data


% --- Executes during object creation, after setting all properties.
function data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% 其它的函数
% 找文件生成列表
function li=list(folder,type)
li=dir([folder '/*.' type]);
li=struct2cell(li);
li=li(1,:);

% 画上呼吸点的函数
function resplot(data)
res=data(:,3);
%start
timepoint=nan(size(data,1),1);
start=find(res==1);
timepoint(start)=data(start,1);
plot(timepoint,'>','MarkerFaceColor','g','MarkerSize',10);
%stop
timepoint=nan(size(data,1),1);
stop=find(res==3);
timepoint(stop)=data(stop,1);
plot(timepoint,'<','MarkerFaceColor','r','MarkerSize',10);
%peak
timepoint=nan(size(data,1),1);
peak=find(res==2);
timepoint(peak)=data(peak,1);
plot(timepoint,'^','MarkerFaceColor','k','MarkerSize',10);

% 画出当前点的数据的函数
function plotcurrentnum(data,num,t)
% t-title
% 找到当前对应的数据段，以相邻的peak为边界
peak=find(data(:,3)==2);
len=length(peak);
% 考虑第一个和最后一个是不同的
if num==1
    left=1;
    right=peak(2);
elseif num==len
    left=peak(len-1);
    right=length(data(:,1));
else
    left=peak(num-1);
    right=peak(num+1);
end
% current=peak(num);
currentdata=data(left:right,:);
plot(currentdata(:,1),'LineWidth',3,'Color',[0 0.74902 1]);
% 设置坐标轴和标题
axis([1 length(currentdata(:,1)) min(currentdata(:,1))-0.1 max(currentdata(:,1))+0.1])
% set(gca,'XTick',[]);
set(gca,'FontName','Times New Roman','FontSize',8);
title(t,'Interpreter','none','Fontsize',12,'LineWidth',3);
% 画上呼吸的点
hold on
resplot(currentdata);
hold off

% 初始时记录所有点的位置
function points=findpoints(data)
allpeak=find(data(:,3)==2);
% 根据peak的数目选择
points=zeros(length(allpeak),4);
% 第四列表示这一组数是否有效
points(:,4)=1;
points(:,2)=allpeak;
% 记录当前的三个点,1-start,2-peak,3-stop
% 没有的点就是0
len=length(allpeak);
for i=1:len
    % 考虑第一个和最后一个是不同的
if i==1
    left=1;
    right=allpeak(2);
elseif i==len
    left=allpeak(len-1);
    right=length(data(:,1));
else
    left=allpeak(i-1);
    right=allpeak(i+1);
end
    current=allpeak(i);
    start=find(data(left:current,3)==1)+left-1;
    if isempty(start)
        start=0;
    end
    peak=current;
    stop=find(data(current:right,3)==3)+current-1;
    if isempty(stop)
        stop=0;
    end
    points(i,1:3)=[start peak stop];
end

% 转换矩阵到一列
function data=transmat(points,len)
points=points(points(:,4)~=0,1:3);
data=zeros(len,1);
for i=1:3
    % 去掉0
    p0=points(:,i);
    p0(p0==0)=[];
    data(p0)=i;
end

% 选择位置
function newhandle=choosepoint(handles)
    axes(handles.plot);
    [x,~]=ginput(1);
    x=floor(x);
    % display(x);
    % range of the x axes
    points=handles.points(handles.points(:,4)~=0,:);

    % 考虑第一个和最后一个是不同的
    if handles.plotnum==1
        xmin=1;
        xmax=points(handles.plotnum+1,2);
    elseif handles.plotnum==handles.resnum
        xmin=points(handles.plotnum-1,2);
        xmax=length(handles.tempdata(:,1));
    else
        xmin=points(handles.plotnum-1,2);
        xmax=points(handles.plotnum+1,2);
    end

    % if the point is in the range
    if x>=1 && x<=xmax-xmin+1
        newx=xmin+x-1;
        range=15;
        left=max(1,newx-range);
        right=min(length(handles.tempdata(:,3)),newx+range);
        mindata=min(handles.tempdata(left:right,1));
        maxdata=max(handles.tempdata(left:right,1));
    switch handles.choosetype
        case 'start'
            newx=find(handles.tempdata(left:right,1)==mindata,1,'last');
            newx=newx+left-1;
            if newx>=points(handles.plotnum,2)
                newx=handles.points(handles.plotnum,1);
            end
            points(handles.plotnum,1)=newx;
        case 'peak'
            newx=find(handles.tempdata(left:right,1)==maxdata,1,'first');
            newx=newx+left-1;
            if newx<=points(handles.plotnum,1) || newx>=points(handles.plotnum,3)
                newx=points(handles.plotnum,2);
            end
            points(handles.plotnum,2)=newx;
        case 'stop'
            newx=find(handles.tempdata(left:right,1)==mindata,1,'first');
            newx=newx+left-1;
            if newx<=points(handles.plotnum,2)
                newx=handles.points(handles.plotnum,3);
            end
            points(handles.plotnum,3)=newx;
    end
    handles.tempdata(:,3)=transmat(points,length(handles.tempdata(:,3)));
    % plot
    plotcurrentnum(handles.tempdata,handles.plotnum,handles.filename);
    % update points
    handles.points=findpoints(handles.tempdata);
    newhandle=handles;
    end

% set button status
function newhandle=setbuttons(handles,status)
    set(handles.plotall,'Enable',status);
    set(handles.clear,'Enable',status);
    set(handles.add,'Enable',status);
    set(handles.name,'Enable',status);
    set(handles.save,'Enable',status);
    set(handles.start,'Enable',status);
    set(handles.peak,'Enable',status);
    set(handles.stop,'Enable',status);
    set(handles.position,'Enable',status);
    set(handles.left,'Enable',status);
    set(handles.right,'Enable',status);
    set(handles.currentnum,'Enable',status);
    set(handles.allnum,'Enable',status);
    newhandle=handles;