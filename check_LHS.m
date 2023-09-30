dim = 2;
ub = 10 * ones(dim,1)
lb = -10 * ones(dim,1) 

a = repmat(lb', 5*dim,1)
b = lhsdesign(5*dim,dim, 'iterations',1000)
c = b.*(repmat(ub' - lb', 5*dim, 1))
