function [] = S_plot(T, X, SE, sig_inxs, features)
cov = []; % Between T score and X
corr = []; % Between T score and X
fold = length(SE);

nm = size(X);
for i=1:nm(2)
    cov(i) = (T'*X(:,i))/(T'*T);
    corr(i) = (T'*X(:,i))/ (norm(T) * norm(X(:,i)));
    CIJF(1,i) = mean(SE(:,i)) - (std(SE(:,i))/sqrt(fold))*(tinv(.975,fold-1));
    CIJF(2,i) = mean(SE(:,i)) + (std(SE(:,i))/sqrt(fold))*(tinv(.975,fold-1));
end;

%[asel_bins,stats] = perm_cutoff(Y,X,100,.02,fold);
figure;
hold on;
hs = zeros(1,4);
legend_strs = {'Low reliability','Sig. and low reliability','High reliability','Sig. and high reliability'};
for i=1:length(cov)
    if (CIJF(1,i)<0) && (CIJF(2,i)>0) && isempty(find(i == sig_inxs)) % Not sig. and low reliability
        handle = scatter(cov(i), corr(i),'o','b');
        hs(1) = handle;
    elseif (CIJF(1,i)<0) && (CIJF(2,i)>0) && ~isempty(find(i == sig_inxs)) % Low reliability but sig from perm cutoff
        handle = scatter(cov(i), corr(i),'o','k');
        hs(2) = handle;
    elseif isempty(find(i == sig_inxs)) % Sig. in CIJF but not sig from perm cutoff
        handle = scatter(cov(i), corr(i),'o','g');
        hs(3) = handle;
    else % Sig in both
        handle = scatter(cov(i), corr(i),'o','r');
        hs(4) = handle;
    end
    myfunc = @(hObject, eventdata, handles) (msgbox(features{i}));
    set(handle,'ButtonDownFcn',myfunc);
end
inxs = find(hs ~= 0);
legend(hs(inxs),legend_strs{inxs},'Location','NorthWest');
hold off;
xlabel('Covariance');
ylabel('Correlation');