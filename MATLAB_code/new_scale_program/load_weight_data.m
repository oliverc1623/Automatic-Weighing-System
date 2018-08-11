% This program lets the user open and plot a txt file with weight data
% it will also compute the average of the weight taken over timer

[filename1,filepath1]=uigetfile({'*.*','All Files'},...
'Select Data File 1');
if isequal(filename1,0)
    disp('user selected cancel');
else 
    cd(filepath1);
    handles.rawdata1=load([filepath1 filename1]);
    disp(strcat("Average weight: " , num2str(mean(handles.rawdata1(:,2)))));
    plot(handles.rawdata1(:,2));
    title('Weight of Tree Shrews');
    ylabel('Weight in Grams');
    xlabel('Trials');
end