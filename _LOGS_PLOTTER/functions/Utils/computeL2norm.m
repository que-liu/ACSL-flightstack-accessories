function L2norm = computeL2norm(time, tracking_error_norm, t_start)
% compute_L2norm
% Computes the cumulative L2 norm of a tracking error starting from t_start.
%
% INPUTS:
%   time               - Nx1 time vector
%   tracking_error_norm - Nx1 vector of ||e(t)|| values
%   t_start            - scalar time at which integration begins
%
% OUTPUT:
%   L2norm - Nx1 vector of cumulative L2 norm from t_start onward

  % --- Find first index where time >= t_start
  idx_start = find(time >= t_start, 1);

  % Handle case where t_start is beyond the time vector
  if isempty(idx_start)
    L2norm = zeros(size(time));
    return;
  end

  % --- Square the error
  error_norm_squared = tracking_error_norm.^2;

  % Zero out data before t_start
  if idx_start > 1
    error_norm_squared(1:idx_start-1) = 0;
  end

  % --- Compute cumulative L2 norm
  L2norm = sqrt(cumtrapz(time, error_norm_squared));

end
