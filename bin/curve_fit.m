function [BETA,EXITFLAG] = curve_fit(x,y,left_right_inxs,BETA0,lb,ub,num_maxima,baseline_options)

X = BETA0(4:4:4*num_maxima);
y = y(left_right_inxs);

model = @(PARAMS,x_) (global_model(PARAMS,x_,length(X),baseline_options));

% try
    options = optimset('lsqcurvefit');
    %options = optimset(options,'MaxIter',10);
    options = optimset(options,'Display','off');
    %options = optimset(options,'MaxFunEvals',length(BETA0));
    [BETA,R,RESIDUAL,EXITFLAG] = lsqcurvefit(model,BETA0,...
        x(left_right_inxs),y,lb,ub,options);
% catch ME
%     fprintf('\nlsqcurvefit exception\n');
%     fprintf('identifier: %s\n',ME.identifier);
%     fprintf('message: %s\n',ME.message);
%     fprintf('stack: \n');
%     for stack_i = 1:length(ME.stack)
%         fprintf('file: %s\n',ME.stack(stack_i).file);
%         fprintf('name: %s\n',ME.stack(stack_i).name);
%         fprintf('line: %d\n',ME.stack(stack_i).line);
%     end
%     EXITFLAG = -Inf;
% end

if EXITFLAG <= 0
    BETA = BETA0;
end
