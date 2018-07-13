%  all the value of angle in angle_bartlett_add_max equals to 200, means it do not exist.
%  all the peak value equals to 0 means it do not exist.

function [angle_bartlett_add_max,value_max]=first3peaks(S_all, index_prefix, irregular_antenna_alignment  )

figure (index_prefix)
subplot(2,2,3)

if irregular_antenna_alignment
  angles = (-179:1:180); 
  
%  true_angle= [ -180 -135 -90 -45 0 45 90 135 180 ];
  true_angle= [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
  position_true = true_angle + 181 ; 
else
  angles=(-90:0.5:90);
  true_angle= [ -90 -60 -30 0 30 60 90 ];
  position_true = (true_angle+90)*2+1 ;    % just for plotting the true angle line for (-90,90)
end
 

plot(1:length(S_all),S_all,'b')
xlabel(['Ground Truth angle is ', num2str(true_angle(index_prefix)), ' degree'])
hold on
plot([position_true(index_prefix),position_true(index_prefix)],ylim,'g--')

set(gca,'xtick',[1 91 181 271 361],'xticklabel',{'-180','-90','0','90','180'})
set(gca,'ytick',[],'yticklabel',{''})


value_max = nan * ones(3,1);
angle_bartlett_add_max  =  nan * ones(3,1);
num_peak  =  0   ;  

if irregular_antenna_alignment
  cutoff_num = 10  ;
  if issorted(S_all(cutoff_num:-1:1))   &&  issorted(S_all((end-cutoff_num):1:end))
    num_peak = num_peak + 1 ;
    ind_max(num_peak) = 1 ;
    val_max(num_peak) = S_all(1) ;
  end
  
else
  cutoff_num = 20  ;
  if issorted(S_all(cutoff_num:-1:1))
    num_peak = num_peak + 1 ;
    ind_max(num_peak) = 1 ;
    val_max(num_peak) = S_all(1) ;
  end
  
  if issorted(S_all((end-cutoff_num):1:end))
    num_peak = num_peak + 1 ;
    ind_max(num_peak) =  length(S_all) ;
    val_max(num_peak) = S_all(end)      ;
  end 
end
 
for n= 2 : 1 : length(S_all)-1
  
  if S_all(n-1)< S_all(n)  &&  S_all(n+1)<S_all(n) 
    num_peak = num_peak + 1 ;
    ind_max(num_peak) = n ;
    val_max(num_peak) = S_all(n) ;
  end
  
end
 
val_max_sort = sort(val_max,'descend');

[value_max(1), ind_max1]=max(S_all);
angle_bartlett_add_max(1) = angles(ind_max1);
plot(ind_max1,max(S_all),'k*','markersize',10)
  
if num_peak == 0
  disp('error: the max value of the spctrum dose not exist.')
  
elseif num_peak == 1
  
  value_max(2)= 0;
  value_max(3)= 0;
     
  angle_bartlett_add_max(2) = 200 ;  
  angle_bartlett_add_max(3) = 200 ;
  
elseif num_peak == 2
  
  value_max(2) = val_max_sort(2);
  ind_max2 = ind_max(find(val_max==val_max_sort(2)));
  angle_bartlett_add_max(2) = angles(ind_max2);
  plot(ind_max2,val_max_sort(2),'co','markersize',10)
  
  value_max(3) = 0 ;  
  angle_bartlett_add_max(3) = 200 ;
else
  
  value_max(2) = val_max_sort(2);
  ind_max2 = ind_max(find(val_max==val_max_sort(2)));
  angle_bartlett_add_max(2) = angles(ind_max2);
  plot(ind_max2,val_max_sort(2),'co','markersize',10)
  
  value_max(3) = val_max_sort(3)  ;
  ind_max3 = ind_max(find(val_max==val_max_sort(3))) ;
  angle_bartlett_add_max(3) = angles(ind_max3);
  plot(ind_max3,val_max_sort(3),'m+','markersize',10)
end

value_max = value_max / value_max(1) ;
end