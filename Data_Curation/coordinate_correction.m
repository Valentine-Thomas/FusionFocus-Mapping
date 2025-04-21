roifile=dir('ROI*')
roi=load(roifile(1).name)

trajfiles= dir('*_R*')
for i=1:length(trajfiles)
    traj=load(trajfiles(i).name)
    new=traj
    new(:,2)=new(:,2)+roi(i,7)
    new(:,3)=new(:,3)+roi(i,6)
    save(strcat(trajfiles(i).name(1:(length(trajfiles(i).name))),'_original'), '-ascii', 'traj')
    save(trajfiles(i).name, '-ascii', 'new')
end
clear trajfiles
clear traj
clear new

trajfiles= dir('*_B*')
for i=1:length(trajfiles)
    traj=load(trajfiles(i).name)
    new=traj
    new(:,2)=new(:,2)+roi(i,7)
    new(:,3)=new(:,3)+roi(i,6)
    save(strcat(trajfiles(i).name(1:(length(trajfiles(i).name))),'_original'), '-ascii', 'traj')
    save(trajfiles(i).name, '-ascii', 'new')
end
clear trajfiles
clear traj
clear new

trajfiles= dir('*_G*')
for i=1:length(trajfiles)
    traj=load(trajfiles(i).name)
    new=traj
    new(:,2)=new(:,2)+roi(i,7)
    new(:,3)=new(:,3)+roi(i,6)
    save(strcat(trajfiles(i).name(1:(length(trajfiles(i).name))),'_original'), '-ascii', 'traj')
    save(trajfiles(i).name, '-ascii', 'new')
end
clear trajfiles
clear traj
clear new

clear all
