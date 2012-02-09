function new_score = apply_pca_model(X,Y,model,new_X)
if length(model.coeff) ~= size(X,1)
    X = X';
end
if length(model.coeff) ~= size(new_X,1)
    new_X = new_X';
end
Xres = bsxfun(@minus,new_X',mean(X'));
new_score = (model.coeff'*Xres')';

