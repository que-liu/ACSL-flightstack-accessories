function plotEulerAngleErrors(log, der, pp)
% Plot Euler angle errors vs time

% Compute angle errors
roll_error = log.euler_angles.roll - log.desired_euler_angles.roll;
pitch_error = log.euler_angles.pitch - log.desired_euler_angles.pitch;
yaw_error = log.euler_angles.yaw - log.user_defined_yaw;

set(figure, 'Color', 'white', 'WindowState', 'maximized')
% Plot Roll angle error
subplot(3,1,1)
plot(log.time, rad2deg(roll_error), 'r-', 'LineWidth', 2)
hold on
yline(0, 'k--', 'LineWidth', 1)
legend({'$$e_{\phi}(t) = \phi(t) - \phi_{\rm d}(t)$$'})
ylabel('Roll Error [deg]', 'interpreter', 'latex', 'fontsize', pp.font_size)
title(pp.folder_controller, 'interpreter', 'latex', 'fontsize', pp.font_size_title)
axis tight
xlim([pp.x_lim_min, pp.x_lim_max])
hold off

% Plot Pitch angle error
subplot(3,1,2)
plot(log.time, rad2deg(pitch_error), 'r-', 'LineWidth', 2)
hold on
yline(0, 'k--', 'LineWidth', 1)
legend({'$$e_{\theta}(t) = \theta(t) - \theta_{\rm d}(t)$$'})
ylabel('Pitch Error [deg]', 'interpreter', 'latex', 'fontsize', pp.font_size)
axis tight
xlim([pp.x_lim_min, pp.x_lim_max])
hold off

% Plot Yaw angle error
subplot(3,1,3)
plot(log.time, rad2deg(yaw_error), 'r-', 'LineWidth', 2)
hold on
yline(0, 'k--', 'LineWidth', 1)
legend({'$$e_{\psi}(t) = \psi(t) - \psi_{\rm d}(t)$$'})
xlabel('$t$ [s]', 'interpreter', 'latex', 'fontsize', pp.font_size)
ylabel('Yaw Error [deg]', 'interpreter', 'latex', 'fontsize', pp.font_size)
axis tight
xlim([pp.x_lim_min, pp.x_lim_max])
hold off

end
