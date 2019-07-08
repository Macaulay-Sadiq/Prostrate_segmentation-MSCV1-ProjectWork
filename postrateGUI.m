function varargout = postrateGUI(varargin)
% POSTRATEGUI MATLAB code for postrateGUI.fig
%      POSTRATEGUI, by itself, creates a new POSTRATEGUI or raises the existing
%      singleton*.
%
%      H = POSTRATEGUI returns the handle to a new POSTRATEGUI or the handle to
%      the existing singleton*.
%
%      POSTRATEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSTRATEGUI.M with the given input arguments.
%
%      POSTRATEGUI('Property','Value',...) creates a new POSTRATEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before postrateGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to postrateGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help postrateGUI

% Last Modified by GUIDE v2.5 08-May-2019 13:16:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @postrateGUI_OpeningFcn, ...
    'gui_OutputFcn',  @postrateGUI_OutputFcn, ...
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


% --- Executes just before postrateGUI is made visible.
function postrateGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to postrateGUI (see VARARGIN)

% Choose default command line output for postrateGUI


%  Initialization for handes.
handles.output = hObject;
handles.index = 1;
handles.patientID = {};
handles.patientName = {};
handles.patientBirthDate = {};
handles.studyID = {};
handles.studyDate = {};
handles.sliceLocation = {};
handles.imgTitle = {};
handles.instanceNum = {};
handles.fullfilenames = {};
handles.numFile = 0;
handles.information = {};
handles.image = 0;
handles.imageInfo = 0;
handles.tumorMask = 0;
handles.ZTMask = 0;
handles.ZCMask = 0;
handles.ZPMask = 0;

axes(handles.segmentation);
set(gca,'XtickLabel',[],'YtickLabel',[]);

axes(handles.display);
set(gca,'XtickLabel',[],'YtickLabel',[]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes postrateGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = postrateGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImage.
function loadImage_Callback(hObject, eventdata, handles)
% hObject    handle to loadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  This callback function allow to interactively load folder preferred
%  directory of DICOM images

Folder = uigetdir('home/macaulay/Desktop','Image Folder'); % default directory to dicom data

% storing the file name and path to all dicom data in the directory
FileList = dir(fullfile(Folder, '*'));
NameList = {FileList.name};
PathList = FileList.folder;
hasDot   = contains(NameList, '.');
NameList(hasDot) = [];

handles.NameList = NameList; % storing file names to handles
handles.fullfilenames = fullfile(PathList,NameList); % storing full file paths to handles
fullfilenames = handles.fullfilenames; % retreiving back full file pats from handles


handles.numFile = length(fullfilenames);
handles.nextImage = dicomread(fullfilenames{1}); % reading first dicom file to workspace
tempInfo = dicominfo(fullfilenames{1}); % obtaining required informaton of the sclice
% storing the file information to handles
handles.patientName = struct2array(tempInfo.PatientName);
handles.patientID = num2str(tempInfo.PatientID);
handles.patientBirthDate = num2str(tempInfo.PatientBirthDate);
handles.studyID = num2str(tempInfo.StudyID);
handles.studyDate = num2str(tempInfo.StudyDate);
handles.sliceLocation = num2str(tempInfo.SliceLocation);
handles.instanceNum = num2str(tempInfo.InstanceNumber);
handles.imgTitle = 'Original Slice Info...';

%  Displaying the read dicom file on guide axis
axes(handles.display);
imshow(handles.nextImage, []);

%  Displaying the read dicom information to guide texbox 
information = sprintf('   %s \n\nPatient Name: \n%s\n\nPatient ID:\n%s\n\nPatient Birth Date: \n%s\n\nStudy ID: \n%s\n\nStudy Date: \n%s\n\nSlice Location: \n%s\n\nInstance Number: \n%s\n',...
   handles.imgTitle, handles.patientName, handles.patientID, handles.patientBirthDate, handles.studyID,handles.studyDate,handles.sliceLocation,handles.instanceNum);
handles.information = information;
set(handles.info, 'String', handles.information);

guidata(hObject,handles)



% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  this callback funtion allow to sequentially display dicom images and the
%  corresponding info to the user interface

% retreiving the full fie path from handles
fullfilenames = handles.fullfilenames;
index = handles.index;

numFile = handles.numFile;

if index == numFile          % checking the limit of available image to display
    return;
end

index = index+1;
handles.index = index;

if isempty(fullfilenames)    % checkig if files are succesfuly uploaded to workspace
    set(handles.info, 'String', 'Please load Images from Directory...');
    return;
end

% reading DICOM data and image
nextImage = dicomread(fullfilenames{index});
sliceInfo = dicominfo(fullfilenames{index});

% updating the information of the current DICOM information on the ui.
handles.image = nextImage;
handles.imageInfo = sliceInfo;
handles.sliceInfo = sliceInfo;
handles.nextImage = nextImage;
handles.patientName = struct2array(sliceInfo.PatientName);
handles.patientID = num2str(sliceInfo.PatientID);
handles.patientBirthDate = num2str(sliceInfo.PatientBirthDate);
handles.studyID = num2str(sliceInfo.StudyID);
handles.studyDate = num2str(sliceInfo.StudyDate);
handles.sliceLocation = num2str(sliceInfo.SliceLocation);
handles.instanceNum = num2str(sliceInfo.InstanceNumber);
handles.imgTitle = 'Original Slice Info...';

% displaying current dicom image and information on ui
handles.information = sprintf('   %s \n\nPatient Name: \n%s\n\nPatient ID:\n%s\n\nPatient Birth Date: \n%s\n\nStudy ID: \n%s\n\nStudy Date: \n%s\n\nSlice Location: \n%s\n\nInstance Number: \n%s\n',...
   handles.imgTitle, handles.patientName, handles.patientID, handles.patientBirthDate, handles.studyID,handles.studyDate,handles.sliceLocation,handles.instanceNum);
set(handles.info, 'String', handles.information);
axes(handles.display);
imshow(nextImage, []);

 guidata(hObject, handles);


% --- Executes on button press in Previous.
function Previous_Callback(hObject, eventdata, handles)
% hObject    handle to Previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  This callback funtion allow to sequentially display previous dicom images and the
%  crresponding info to the user interface

% Retriving file path from handles
fullfilenames = handles.fullfilenames;
index = handles.index;

if index == 1           % checking if curent dicom data is the first.
    return;
end

index = index - 1;
handles.index = index;

% reading previous dicom info to the workspace
nextImage = dicomread(fullfilenames{index});
sliceInfo = dicominfo(fullfilenames{index});

% updating the current dicom information
handles.sliceInfo = sliceInfo;
handles.nextImage = nextImage;
handles.patientName = struct2array(sliceInfo.PatientName);
handles.patientID = num2str(sliceInfo.PatientID);
handles.patientBirthDate = num2str(sliceInfo.PatientBirthDate);
handles.studyID = num2str(sliceInfo.StudyID);
handles.studyDate = num2str(sliceInfo.StudyDate);
handles.sliceLocation = num2str(sliceInfo.SliceLocation);
handles.instanceNum = num2str(sliceInfo.InstanceNumber);
handles.imgTitle = 'Original Slice Info...';

% Displaying dicom data on GUI
handles.information = sprintf('   %s \n\nPatient Name: \n%s\n\nPatient ID:\n%s\n\nPatient Birth Date: \n%s\n\nStudy ID: \n%s\n\nStudy Date: \n%s\n\nSlice Location: \n%s\n\nInstance Number: \n%s\n',...
   handles.imgTitle, handles.patientName, handles.patientID, handles.patientBirthDate, handles.studyID,handles.studyDate,handles.sliceLocation,handles.instanceNum);
set(handles.info, 'String', handles.information);
axes(handles.display);
imshow(nextImage, []);

guidata(hObject, handles);






% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  This callback funtion perfoms annonimization of the dicom data in the
%  working directory and store the new dicom data in a new directory

%  retreiving dicom file paths 
numFiles = handles.numFile;
fullfilenames = handles.fullfilenames;

if isempty(fullfilenames)     %    checking if working directory has files
    set(handles.info, 'String', 'Please load Images from Directory...');
else
    if isfolder('newDicomfolder')     % checking if anonimize data have been previously created
        rmdir('newDicomfolder','s');  
        mkdir('newDicomfolder');     % recreating a directory for annonimized dicom data
    else
        mkdir('newDicomfolder');
    end
       
%     editing dicom info data to be annonimous
        patientID = ' ';
        patientName = ' ';
        patientBirthDate = ' ';
        
%         creating new annonymous dicom files
        for i = 1:numFiles
            
            s = sprintf('newDicomfolder/newSlice%d.dcm', i);
            img = dicomread(fullfilenames{i});
            info = dicominfo(fullfilenames{i});
            
            info.PatientName = patientName;
            info.PatientID = patientID;
            info.PatientBirthDate = patientBirthDate;
            
            dicomwrite(img,s, info);
        end   
    set(handles.analysis, 'String', 'Anonimided data are save to newDicomfolder directory ');
        
%         reading data from directory of annonimised dicom data
    annDcmImg = dir('newDicomfolder/*.dcm');
%     updating the handles of full dicom file path
    fullfilenames = {};
    for i = 1 : length(annDcmImg)
        fullfilenames = [fullfilenames, {fullfile(annDcmImg(i).folder, annDcmImg(i).name)}];
    end
    handles.numFile  = length(annDcmImg);
    handles.fullfilenames = fullfilenames;
%     checkin if dicom files exist
    if isempty(fullfilenames)
        set(handles.info, 'String', 'Please load Images from Directory...');
    else
%         reading data from current directory
        img = dicomread(fullfilenames{handles.index});
        newSliceInfo = dicominfo(fullfilenames{handles.index});
        
%         updating handles of dicom info
        handles.patientName = struct2array(newSliceInfo.PatientName);
        handles.patientID = num2str(newSliceInfo.PatientID);
        handles.patientBirthDate = num2str(newSliceInfo.PatientBirthDate);
        handles.studyID = num2str(newSliceInfo.StudyID);
        handles.studyDate = num2str(newSliceInfo.StudyDate);
        handles.sliceLocation = num2str(newSliceInfo.SliceLocation);
        handles.instanceNum = num2str(newSliceInfo.InstanceNumber);
        handles.imgTitle = 'Anonymize .dcm info.';
        
%         Displaying current image and data from new directory
        information = sprintf('   %s \n\nPatient Name: \n%s\n\nPatient ID:\n%s\n\nPatient Birth Date: \n%s\n\nStudy ID: \n%s\n\nStudy Date: \n%s\n\nSlice Location: \n%s\n\nInstance Number: \n%s\n',...
            handles.imgTitle, handles.patientName, handles.patientID, handles.patientBirthDate, handles.studyID,handles.studyDate,handles.sliceLocation,handles.instanceNum);
        handles.information = information;
        set(handles.info, 'String', handles.information);
        axes(handles.display);
        imshow(img,[]);
    end
end
guidata(hObject,handles)




% --- Executes on button press in jpgConverter.
function jpgConverter_Callback(hObject, eventdata, handles)
% hObject    handle to jpgConverter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  This callback funtion perfoms convertion of the dicom data in the
%  working directory to a '.jpg' file extention and store the new 
% data in a new directory containg both .jpg image files and respective
% .mat for image data.

% retriving data fom handles
numFiles = handles.numFile;
fullfilenames = handles.fullfilenames;

if isempty(fullfilenames)         %    checking if working directory has files
    set(handles.info, 'String', 'Please load Images from Directory...');
else
    if isfolder('dicom2jpgFolder')% checking if directory of converted data have been previously created
        rmdir('dicom2jpgFolder','s');
        mkdir('dicom2jpgFolder');% recreating a directory for converted file
    else
        mkdir('dicom2jpgFolder');
    end
%     creating jpg files into new directory
    for i = 1:numFiles
        
        s = sprintf('dicom2jpgFolder/newSlice%d.jpg', i);
        f = sprintf('dicom2jpgFolder/newSlice%ddata.mat', i);
        img = dicomread(fullfilenames{i});
        info = dicominfo(fullfilenames{i});
        
        dcmImagei = uint8(255 * mat2gray(img));
        imwrite(dcmImagei,s);
        jpginfo = info;
        save(f,'jpginfo');
    end
        set(handles.analysis, 'String', 'jpg files and their corresponding .mat files containing patient data have been save to  dicom2jpgFolder directory ');

%     reading path to new directory
    newFolder = dir('dicom2jpgFolder/*.jpg');
    infoFiles = dir('dicom2jpgFolder/*.mat');

%     updating handles with full file path of new directory
    sliceInfo= [];
    for i = 1 : length(infoFiles)
        sliceInfo = [sliceInfo; {fullfile(infoFiles(i).folder, infoFiles(i).name)}];
    end
    handles.sliceInfo = sliceInfo;
    fullfilenames = {};
    for i = 1 : length(newFolder)
        fullfilenames = [fullfilenames, {fullfile(newFolder(i).folder, newFolder(i).name)}];
    end
    
%     handles.numFile  = length(fullfilenames);
%     handles.fullfilenames = fullfilenames;

    %     checkin if jpg files exist
    if isempty(fullfilenames)
        set(handles.info, 'String', 'Please load Images from Directory...');
        return;
    else % reading files from new directory
        img = imread(fullfilenames{handles.index});
        sInfo = load(sliceInfo{handles.index});
        sInfo = struct2array(sInfo);
    end
    
%     Updating informations on handles with the current directory
    handles.patientName = struct2array(sInfo.PatientName);
    handles.patientID = num2str(sInfo.PatientID);
    handles.patientBirthDate = num2str(sInfo.PatientBirthDate);
    handles.studyID = num2str(sInfo.StudyID);
    handles.studyDate = num2str(sInfo.StudyDate);
    handles.sliceLocation = num2str(sInfo.SliceLocation);
    handles.instanceNum = num2str(sInfo.InstanceNumber);
    handles.imgTitle = 'dcm2jpg slice info.';
    
%     displaying image and data of new files on GUI
    axes(handles.display);
    imshow(img,[]);
    information = sprintf('   %s \n\nPatient Name: \n%s\n\nPatient ID:\n%s\n\nPatient Birth Date: \n%s\n\nStudy ID: \n%s\n\nStudy Date: \n%s\n\nSlice Location: \n%s\n\nInstance Number: \n%s\n',...
        handles.imgTitle, handles.patientName, handles.patientID, handles.patientBirthDate, handles.studyID,handles.studyDate,handles.sliceLocation,handles.instanceNum);
    handles.information = information;
    set(handles.info, 'String', handles.information);
end

guidata(hObject,handles)



% --- Executes on button press in dicomConverter.
function dicomConverter_Callback(hObject, eventdata, handles)
% hObject    handle to dicomConverter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global fullfilenames;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  This callback funtion perfoms convertion of the dicom data in the
%  working directory to a '.jpg' file extention and store the new 
% data in a new directory containg both .jpg image files and respective
% .mat for image data.

% retriving files from handles
fullfilenames = handles.fullfilenames;

if isempty(fullfilenames)      %    checking for available files in working directory
    set(handles.info, 'String', 'Please load Images from Directory...');
else
    if ~isfolder('dicom2jpgFolder')    %    checking for directory of .jpg files
        set(handles.info, 'String', 'No .jpg directory...');
    else
        jpgFiles = dir('dicom2jpgFolder/*.jpg');
        infoFiles = dir('dicom2jpgFolder/*.mat');
    end
    
    handles.numFile  = length(jpgFiles);
    
    if isfolder('jpg2dicomfolder')  % checking and recreating new folder for converted files
        rmdir('jpg2dicomfolder','s');
        mkdir('jpg2dicomfolder');
    else
        mkdir('jpg2dicomfolder');
    end
    
%     converting files fron jpg to dicom  in newly created directory
    for i = 1 : length(jpgFiles)
        
        s = sprintf('jpg2dicomfolder/newSlice%d.dcm', i);  
        fullfilenames = fullfile(jpgFiles(i).folder, jpgFiles(i).name);
        imgInfo = load(fullfile(infoFiles(i).folder,infoFiles(i).name));
        imgInfo = struct2array(imgInfo);
        img = imread(fullfilenames);
        
        dicomwrite(img,s,imgInfo);
    end
    set(handles.analysis, 'String', 'Converted files have been saved to jpg2dicomfolder directory');

%     loading converted fiile from the directory
    newFolder = dir('jpg2dicomfolder/*.dcm');
    handles.numFile= length(newFolder);
    
    
%     updating file handles of full file path
    fullfilenames= {};
    for i = 1 : length(newFolder)
        fullfilenames = [fullfilenames, {fullfile(newFolder(i).folder, newFolder(i).name)}];
    end
    
    handles.fullfilenames = fullfilenames;
    if isempty(fullfilenames)
        set(handles.info, 'String', 'Please load Images from Directory...');  % checking for files in the directory  
        return;
    else
        img = dicomread(fullfilenames{handles.index});
        imgInfo = dicominfo(fullfilenames{handles.index});
    end
    
%     updating handles wiiith the dicom information
    handles.patientName = struct2array(imgInfo.PatientName);
    handles.patientID = num2str(imgInfo.PatientID);
    handles.patientBirthDate = num2str(imgInfo.PatientBirthDate);
    handles.studyID = num2str(imgInfo.StudyID);
    handles.studyDate = num2str(imgInfo.StudyDate);
    handles.sliceLocation = num2str(imgInfo.SliceLocation);
    handles.instanceNum = num2str(imgInfo.InstanceNumber);
    handles.imgTitle = 'jpg2dcm slice info.';
    
%     displaying image and information on the gui

    axes(handles.display);
    imshow(img,[]);
    
    information = sprintf('   %s \n\nPatient Name: \n%s\n\nPatient ID:\n%s\n\nPatient Birth Date: \n%s\n\nStudy ID: \n%s\n\nStudy Date: \n%s\n\nSlice Location: \n%s\n\nInstance Number: \n%s\n',...
        handles.imgTitle, handles.patientName, handles.patientID, handles.patientBirthDate, handles.studyID,handles.studyDate,handles.sliceLocation,handles.instanceNum);
    handles.information = information;
    set(handles.info, 'String', handles.information);
end
guidata(hObject,handles);

    
    
% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  This callback funtion allows the segmentation and computation of metrics
%  of data on the gui

handles.imgTitle = sprintf('Current Slice information');
set(handles.info, 'String', handles.information);

% retreive data from handles
fullfilenames = handles.fullfilenames;

if isempty(fullfilenames)     % checking for available files in working directory
    set(handles.analysis, 'String', 'Please load Images from Directory...');
    return;
end

% reading file information into  container
data = [];
for i = 1:size(fullfilenames,2)
    data = [data ,dicominfo(fullfilenames{i})];
end

for i = 1:size(fullfilenames,2)0.2
cine(:,:,i) = dicomread(fullfilenames{i});
end

sliceSpacing = data(handles.index).PixelSpacing;
sliceThickness = data(handles.index).SliceThickness;

itr = 400;

% interactively drawing of region to segment
information = sprintf('   Please draw line around\n             ROI \n for Tumor \n\n');
set(handles.analysis, 'String',information);
mask1 = imfreehand(gca, 'closed', 'false');
handles.tumorMask = createMask(mask1);
tumorSegment = activecontour(handles.nextImage, handles.tumorMask, itr, 'edge','ContractionBias',0.1);


information = sprintf('   Please draw polygon around\n            ROI \n for ZC \n\n');
set(handles.analysis, 'String',information);
mask2 = imfreehand(gca, 'closed', 'false');
handles.ZCMask = createMask(mask2);
ZCsegment = activecontour(handles.nextImage, handles.ZCMask, itr, 'edge','ContractionBias',0.1);


information = sprintf('   Please draw polygon around\n            ROI \n for ZP \n\n');
set(handles.analysis, 'String',information);
mask3 = imfreehand(gca, 'closed', 'false');
handles.ZPMask = createMask(mask3);
ZPsegment = activecontour(handles.nextImage,handles.ZPMask, itr, 'edge','ContractionBias',0.1);


information = sprintf('   Please draw polygon around\n            ROI \n for ZT \n\n');
set(handles.analysis, 'String',information);
mask4 = imfreehand(gca, 'closed', 'false');
handles.ZCMask = createMask(mask4);
ZTsegment = activecontour(handles.nextImage, handles.ZCMask, itr, 'edge','ContractionBias',0.1);

set(handles.analysis, 'String','Computing metrics of segmented regions');


segmentArea  = calculateArea( tumorSegment, ZCsegment, ZPsegment, ZTsegment, sliceSpacing);
% calculating the Area of segmented part
set(handles.tumorArea, 'string', num2str(segmentArea(1,1)));
set(handles.czArea, 'string', num2str(segmentArea(1,2)));
set(handles.pzArea, 'string', num2str(segmentArea(1,3)));
set(handles.tzArea, 'string', num2str(segmentArea(1,4)));

volumeImages  = calculateVolume( segmentArea, sliceThickness);
% calculating the Volume of segmented part
set(handles.tumorVolume, 'string', num2str(volumeImages(1,1)));
set(handles.czVolume, 'string', num2str(volumeImages(1,2)));
set(handles.pzVolume, 'string', num2str(volumeImages(1,3)));
set(handles.tzVolume, 'string', num2str(volumeImages(1,4)));

% Showing segmented region on axis of gui

axes(handles.segmentation)
im1 = imshow(cine(:,:,handles.index), []);
hold on
% visboundaries(tumorSegment,'Color','r', 'LineWidth', 1.5);
% visboundaries(ZCsegment,'Color','b', 'LineWidth', 1.5);
% visboundaries(ZPsegment,'Color','g', 'LineWidth', 1.5);
% visboundaries(ZTsegment,'Color',[0.8500 0.3250 0.0980], 'LineWidth', 1.5);

axis off;
sz  = size(cine(:,:,1));

tmp = zeros(sz(1), sz(2), 3);
tmp(:,:,1) =  tumorSegment;
tmp(:,:,2) =  ZCsegment;
tmp(:,:,3) =  ZPsegment;
tmp = tmp + ZTsegment;

ov = imagesc(tmp);
set(im1,'CData',cine(:,:,handles.index));
set(ov,'AlphaData',0.5,'CData',tmp);
colormap('gray')

set(handles.analysis, 'String','Select a new slice to segment');

guidata(hObject,handles);


% --- Executes on button press in pushbuttonSaveImage.
function pushbuttonSaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  This callback funtion allows the segmentation and computation of metrics
%  of data on the gui

% creating directory to save curent image on axis
if ~isfolder('segmentedImageFolder')
    mkdir('segmentedImageFolder');
end    

F = getframe(handles.segmentation); % capturing image from axis handles
Image = frame2im(F);
imwrite(Image, 'segmentedImageFolder/Image.jpg') %saving image to directory

set(handles.analysis, 'String','Current Slice with segmented part has been saved to segmentedImageFolder directory');

guidata(hObject,handles);

% --- Executes on button press in sliceIn3D.
function sliceIn3D_Callback(hObject, eventdata, handles)
% hObject    handle to sliceIn3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  This callback funtion allows the segmentation and computation of metrics
%  of data on the gui


information = sprintf('   Please draw line around: Tumor, ZC, ZP, ZT respctively\n           on 10 consecutive slice  \n\n');
set(handles.analysis, 'String',information);

% retreiving file path from handles
fullfilenames = handles.fullfilenames;

if isempty(fullfilenames)       % checking for files in directory
    set(handles.analysis, 'String', 'Please load Images from Directory...');
    return;
end



img = dicomread(handles.fullfilenames{handles.index});
sz = size(img);
cine = zeros(sz(1),sz(2),size(fullfilenames,2));

% reading dicom file into a container
data = [];
for i = 1:size(fullfilenames,2)
data = [data ,dicominfo(fullfilenames{i})];
end


for i = 1:size(fullfilenames,2)
cine(:,:,i) = dicomread(fullfilenames{i});
end

itr = 200;
n = 1;

for i = 29 : 30
    
%     updating information of dicom file info on handles
    handles.patientName = struct2array(data(i).PatientName);
    handles.patientID = num2str(data(i).PatientID);
    handles.patientBirthDate = num2str(data(i).PatientBirthDate);
    handles.studyID = num2str(data(i).StudyID);
    handles.studyDate = num2str(data(i).StudyDate);
    handles.sliceLocation = num2str(data(i).SliceLocation);
    handles.instanceNum = num2str(data(i).InstanceNumber);
    sliceSpacing = data(i).PixelSpacing;
    sliceThickness = data(i).SliceThickness;
    handles.imgTitle = sprintf('Current Slice information');
    set(handles.info, 'String', handles.information);

     handles.information = sprintf('   %s \n\nPatient Name: \n%s\n\nPatient ID:\n%s\n\nPatient Birth Date: \n%s\n\nStudy ID: \n%s\n\nStudy Date: \n%s\n\nSlice Location: \n%s\n\nInstance Number: \n%s\n',...
        handles.imgTitle, handles.patientName, handles.patientID, handles.patientBirthDate, handles.studyID,handles.studyDate,handles.sliceLocation,handles.instanceNum);
    set(handles.info, 'String', handles.information);
    
    axes(handles.display);
    imshow(cine(:,:,i),[])
    
%     interactive segmentation of image on preset axis 
    information = sprintf('   Please draw line around\n             ROI \n for Tumor \n\n');
    set(handles.analysis, 'String',information);
    mask1 = imfreehand(gca, 'closed', 'false');
    tumorMask = createMask(mask1);
    tumorSegment = activecontour(cine(:,:,i), tumorMask, itr, 'edge','ContractionBias',0.1);
    
    
    information = sprintf('   Please draw polygon around\n            ROI \n for ZC \n\n');
    set(handles.analysis, 'String',information);
    mask2 = imfreehand(gca, 'closed', 'false');
    ZCMask = createMask(mask2);
    ZCsegment = activecontour(cine(:,:,i), ZCMask, itr, 'edge','ContractionBias',0.1);
    
    
    information = sprintf('   Please draw polygon around\n            ROI \n for ZP \n\n');
    set(handles.analysis, 'String',information);
    mask3 = imfreehand(gca, 'closed', 'false');
    ZPMask = createMask(mask3);
    ZPsegment = activecontour(cine(:,:,i),ZPMask, itr, 'edge','ContractionBias',0.1);
    
    
    information = sprintf('   Please draw polygon around\n            ROI \n for ZT \n\n');
    set(handles.analysis, 'String',information);
    mask4 = imfreehand(gca, 'closed', 'false');
    ZCMask = createMask(mask4);
    ZTsegment = activecontour(cine(:,:,i), ZCMask, itr, 'edge','ContractionBias',0.1);
    
    
    segmentArea  = calculateArea( tumorSegment, ZCsegment, ZPsegment, ZTsegment, sliceSpacing);
    % calculating the Area of segmented part
    set(handles.tumorArea, 'string', num2str(segmentArea(1,1)));
    set(handles.czArea, 'string', num2str(segmentArea(1,2)));
    set(handles.pzArea, 'string', num2str(segmentArea(1,3)));
    set(handles.tzArea, 'string', num2str(segmentArea(1,4)));
    
    volumeImages  = calculateVolume( segmentArea, sliceThickness);
    % calculating the Volume of segmented part
    set(handles.tumorVolume, 'string', num2str(volumeImages(1,1)));
    set(handles.czVolume, 'string', num2str(volumeImages(1,2)));
    set(handles.pzVolume, 'string', num2str(volumeImages(1,3)));
    set(handles.tzVolume, 'string', num2str(volumeImages(1,4)));

%     displaying dicom image on guide axis
    axes(handles.segmentation)
    tmp = zeros(sz(1), sz(2), 3);
    tmp(:,:,1) =  tumorSegment;
    tmp(:,:,2) =  ZCsegment;
    tmp(:,:,3) =  ZPsegment;
    tmp = tmp + ZTsegment;
    
    imshow(tmp);
    
%     storing up data of segmented regions
    F = getframe(handles.segmentation);
    F = imresize(F.cdata, [sz(1) sz(2)]);
    F = rgb2gray(F);

    volumeImage(:,:,n) = F;
   
    n = n+1;
end

set(handles.analysis, 'String','Drawing 3D model...');

% 3D visualization of segmented region
 cla(handles.segmentation,'reset');
limits = [NaN NaN NaN NaN NaN 2];
[x, y, z, volumeImage] = subvolume(volumeImage, limits);

[fo,vo] = isosurface(x,y,z,volumeImage,1);     
[fe,ve,ce] = isocaps(x,y,z,volumeImage,1);

p1 = patch('Faces', fo, 'Vertices', vo);       
p1.FaceColor = 'red';
p1.EdgeColor = 'none';
p1.FaceAlpha = 0.6;

p2 = patch('Faces', fe, 'Vertices', ve, ...    
   'FaceVertexCData', ce);
p2.FaceColor = 'interp';
p2.EdgeColor = 'none';
p2.FaceAlpha = 0.6;

view(-40,24)
daspect([1 1 0.3])               
colormap(gray(100))
box on

camlight(40,40)                                
camlight(-20,-10)
lighting gouraud

% to visualize the whole slices in 3D uncomment this section
% figure
% cm = brighten(jet(length('gray')),-.5);
% colormap(cm)
% contourslice(cine,[],[],[1:10],8);
% view(3);
% axis tight

%  Displaying all slices in 3D
% figure; 
% limits = [NaN NaN NaN NaN NaN 64];
% [x, y, z, cine] = subvolume(cine, limits);
% 
% [fo,vo] = isosurface(x,y,z,cine,32);     
% [fe,ve,ce] = isocaps(x,y,z,cine,32);
% 
% p1 = patch('Faces', fo, 'Vertices', vo);       
% p1.FaceColor = 'red';
% p1.EdgeColor = 'none';
% p1.FaceAlpha = 0.6;
% 
% p2 = patch('Faces', fe, 'Vertices', ve, ...    
%    'FaceVertexCData', ce);
% p2.FaceColor = 'interp';
% p2.EdgeColor = 'none';
% p2.FaceAlpha = 0.6;
% 
% view(-40,24)
% daspect([1 1 1])               
% colormap(gray(100))
% box on

camlight(40,40)                                
camlight(-20,-10)
lighting gouraud


guidata(hObject,handles);


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CALLBACK DESCRIPTIONS;
%  This callback funtion allows clearing workspace before new start.

clear all;
clear global fullfilenames;
clc;
delete( postrateGUI);
