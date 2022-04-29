%% hi

clear
close all


markers_used = [2,3,4,5];
nosepoint = 4;
tailpoint = 5;
starboard = 3;
port = 2;


%% Import and plot Qualisys Data

% Make a figure with a white background
figure('Units','normalized','Position',[0.1 0.1 0.8 0.8]); 
set(gcf,'color','w');

fontSize  = 14;
lineWidth = 2;
rows      = 2;        
colums    = 2;


%% Import data
load 11_04_22\qualsis_data\3\UAS_Ollie_8ms0037.mat
data = UAS_Ollie_8ms0037;

time = (1:1:data.Frames)/data.FrameRate;

trajectories = data.Trajectories.Unidentified.Data;

%% Plot initial positions and label to identify markers

subplot(rows,colums,1)
for n = markers_used
    plot3(trajectories(n,1,1),trajectories(n,2,1),trajectories(n,3,1),'xk',...
        'LineWidth',lineWidth)
    hold on
    text(trajectories(n,1,1),trajectories(n,2,1),trajectories(n,3,1),num2str(n),'FontSize',fontSize+6)
end

xlabel ('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)');
title('Initial Position, labelled')
set(gca,'fontsize',fontSize)
grid on; grid minor;
axis equal

%% Plot trajectories with labels
subplot(rows,colums,2)
for n = markers_used
    
plot3(squeeze(trajectories(n,1,:)),...
      squeeze(trajectories(n,2,:)),...
      squeeze(trajectories(n,3,:)),...
    'LineWidth',lineWidth,'DisplayName',num2str(n))
hold on

end
legend
xlabel ('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)');
title('All marker trajectories')
set(gca,'fontsize',fontSize)
grid on; grid minor;
axis equal

%% Calculate velocity and plot

% Based on plot, use points 1 and 2

nosePositions  = squeeze(trajectories(nosepoint,1:3,:));
tailPositions  = squeeze(trajectories(tailpoint,1:3,:));
portPositions  = squeeze(trajectories(port,1:3,:));
starboardPositions = squeeze(trajectories(starboard,1:3,:));

centrePositions = 0.5*(nosePositions+tailPositions);

velocities = [0, diff(centrePositions(1,:))./diff(time);...
              0, diff(centrePositions(2,:))./diff(time);...
              0, diff(centrePositions(3,:))./diff(time)]*1e-3;
          
absVelocity = sum(velocities.^2, 1).^0.5;

smoothVelocity = smooth(time,absVelocity,12,'sgolay'); 

subplot(rows,colums,3)
plot(time,absVelocity,'-','LineWidth',lineWidth,'DisplayName','Absolute Velocity')
hold on
plot(time,smoothVelocity,':','LineWidth',lineWidth,'DisplayName','Smoothed Velocity (span 0.1s)')
legend('Location','SouthEast');
xlabel ('Time (s)'); ylabel('Velocity (m/s)');
title(['Velcoity of points ' num2str(nosepoint) ' and ' num2str(tailpoint)]);
set(gca,'fontsize',fontSize);
grid on; grid minor;

%% Calculate pitch angle

pitchAngle = atand((nosePositions(3,:)-tailPositions(3,:))./(nosePositions(1,:)-tailPositions(1,:)))+90;
yawAngle = atand((nosePositions(2,:)-tailPositions(2,:))./(nosePositions(1,:)-tailPositions(1,:)))+90;
roll_Angle = atand((portPositions(2,:)-starboardPositions(2,:))./(portPositions(1,:)-starboardPositions(1,:)));

glideAngle = smooth(time,atand(velocities(1,:)./velocities(2,:)),12,'sgolay')';

angleOfAttack = pitchAngle - glideAngle;

subplot(rows,colums,4)
hold on
plot(time,pitchAngle,'-','LineWidth',lineWidth,'DisplayName','Pitch Angle')
plot(time,yawAngle,':','LineWidth',lineWidth,'DisplayName','Yaw Angle')
plot(time,glideAngle,'--','LineWidth',lineWidth,'DisplayName','Glide Angle')
plot(time,angleOfAttack,'-.','LineWidth',lineWidth,'DisplayName','Angle of Attack')
plot(time,roll_Angle,'-.','LineWidth',lineWidth,'DisplayName','Roll')
hold off

xlabel ('Time (s)'); ylabel('Angle (deg)');
title(['Angle between points ' num2str(nosepoint) ' and ' num2str(tailpoint)])
set(gca,'fontsize',fontSize)
grid on; grid minor;
legend

shg
