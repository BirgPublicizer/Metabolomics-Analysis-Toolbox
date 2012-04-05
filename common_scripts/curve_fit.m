function [y_fit,MGPX,baseline_BETA,x_baseline_BETA,converged] = curve_fit(x,y,fit_inxs,X,all_X,far_left,far_right)
[BETA0,lb,ub] = compute_initial_inputs(x,y,all_X,fit_inxs,X);
BETA0 = BETA0';
lb = lb';
ub = ub';
% step = 0.01;
% x_baseline_BETA = [far_left,far_left-step:step:far_right+step,far_right];
x_baseline_BETA = far_left;
baseline_BETA0 = y(fit_inxs(1));
lb(end+1) = -abs(baseline_BETA0(end));
ub(end+1) = abs(baseline_BETA0(end));
% for i = 2:length(X)
%     ix = find(X(i) == all_X);
%     if ix > 1
%         minxs = find(all_X(ix-1) >= x & x >= all_X(ix));
%         [vs,mixs] = sort(y(minxs),'ascend');
%         try
%             for q = 1:length(mixs) % Look for first minimum
%                 mix = mixs(q);
%                 if y(minxs(mix-1)) > y(minxs(mix)) && y(minxs(mix+1)) > y(minxs(mix)) % Make sure it is a minimum
%                     x_baseline_BETA(end+1) = x(minxs(mix));
%                     baseline_BETA0(end+1) = 0;
%                     lb(end+1) = 0;%-abs(y(minxs(mix)));
%                     ub(end+1) = abs(y(minxs(mix)));
%                     break;
%                 end
%             end
%         catch ME % Ignore
%         end
%     end
% end
x_baseline_BETA(end+1) = far_right;
baseline_BETA0(end+1) = y(fit_inxs(end));
lb(end+1) = -abs(baseline_BETA0(end));
ub(end+1) = abs(baseline_BETA0(end));
% for i = 1:length(baseline_BETA0)
%     if i == 1
%         lb(end+1) = y(fit_inxs(1));
%     elseif i == length(baseline_BETA0)
%         lb(end+1) = y(fit_inxs(end));
%     else
%         lb(end+1) = 0;
%     end
%     ub(end+1) = Inf;
% end

model = @(PARAMS,x_) (global_model(PARAMS,x_,length(X),x_baseline_BETA));

fprintf('Starting fit...\n');
options = optimset('lsqcurvefit');
% options = optimset(options,'MaxIter',10);
options = optimset(options,'MaxFunEvals',10000);
[ALL_BETA,R,RESIDUAL,EXITFLAG] = lsqcurvefit(model,[BETA0,baseline_BETA0],x(fit_inxs)',y(fit_inxs),lb,ub,options);
fprintf('Finished fit\n');

if EXITFLAG <= 0
    fprintf('\n** Could not converge on a fit. Try examining the fits and adding peaks.\n\n');
    y_fit = model([BETA0,baseline_BETA0],x');
    MGPX = BETA0;
    baseline_BETA = baseline_BETA0;
    converged = false;
%     ME = MException('lsqcurvefit:failedconvergences', ...
%      'lsqcurvefit failed to converge on a fit');
%     throw(ME);    
else
    converged = true;
    y_fit = model(ALL_BETA,x');
    last_inx = 4*length(X);
    baseline_BETA = ALL_BETA(last_inx+1:end);
    MGPX = ALL_BETA(1:last_inx);
end