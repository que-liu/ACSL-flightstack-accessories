function der = PyC_computeDerivedValues_PID(log, der)

for ii = 1:length(log.time)
    % OUTER LOOP trajectory tracking error
    der.outer_loop.tracking_error(ii,:) = ...
        [log.position.x(ii) - log.user_defined_position.x(ii);
         log.position.y(ii) - log.user_defined_position.y(ii);
         log.position.z(ii) - log.user_defined_position.z(ii);
         log.velocity.x(ii) - log.user_defined_velocity.x(ii);
         log.velocity.y(ii) - log.user_defined_velocity.y(ii);
         log.velocity.z(ii) - log.user_defined_velocity.z(ii)];

    % OUTER LOOP trajectory tracking error norm
    der.outer_loop.tracking_error_norm(ii,1) = norm(der.outer_loop.tracking_error(ii));
end

% OUTER LOOP L2 norm
der.outer_loop.tracking_error_L2norm = ...
  computeL2norm(log.time, der.outer_loop.tracking_error_norm, 0);



end

