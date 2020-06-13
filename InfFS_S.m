function [RANKED, WEIGHT, SUBSET] = InfFS_S(X, Y , alpha)
% [RANKED, WEIGHT, SUBSET ] = InfFS_S( X, Y, alpha ) computes ranks and weights
% of features for input data matrix X and labels Y using Inf-FS algorithm.
%
% Version 1.0, June 2020.
%
% INPUT:
%
% X is a T by n matrix, where T is the number of samples and n the number
% of features.
% Y is column vector with class labels (e.g., -1, 1)
% alpha: mixing coefficient in range [0,1]
%
% OUTPUT:
%
% RANKED are indices of columns in X_train ordered by attribute importance,
% meaning RANKED(1) is the index of the most important/relevant feature.
% WEIGHT are attribute weights with large positive weights assigned
% to important attributes.
% SUBSET is the selected subset of features
%  ------------------------------------------------------------------------
% Please consider to cite:

%[1] Roffo, G., Melzi, S., Castellani, U., Vinciarelli, A., and Cristani, M., 2020. Infinite Feature Selection: A Graph-based Feature Filtering Approach. In the IEEE Transactions on Pattern Analysis and Machine Intelligence (TPAMI).

%[1] Roffo, G., Melzi, S., Castellani, U. and Vinciarelli, A., 2017. Infinite Latent Feature Selection: A Probabilistic Latent Graph-Based Ranking Approach. arXiv preprint arXiv:1707.07538.

%[2] Roffo, G., Melzi, S. and Cristani, M., 2015. Infinite feature selection. In Proceedings of the IEEE International Conference on Computer Vision (pp. 4202-4210).

%  ------------------------------------------------------------------------

fprintf('\n+ Feature selection method: Inf-FS Supervised (2020)\n');

N = size(X,2);

eps = 5e-06 * N;

factor = 1 - eps; % shrinking 

%% Building the Graph
[A,rho] = getGraphWeights(full(X), Y, alpha, eps );

%% Letting paths tend to infinite: Inf-FS Core
I = eye( size( A ,1 )); % Identity Matrix

% rho = max(eig(A));

r = factor/rho; % Set a meaningful value for r :=  0 < r < 1/rho

y = I - ( r * A );

S = inv( y );


%% 5) Estimating energy scores
WEIGHT = sum( S , 2 ); % prob. scores s(i)

%% 6) Ranking features according to s
[~ , RANKED ]= sort( WEIGHT , 'descend' );

RANKED = RANKED';
WEIGHT = WEIGHT';

e = ones(N,1);
t = S * e;

nbins = 0.5*N;
counts = hist(t,nbins);
thr = mean(counts);
size_sub = sum(counts>thr);


fprintf('Inf-FS (S) Nb. Features Selected = %.4f (%.2f%%)\n',size_sub,100*(size_sub/N))

SUBSET = RANKED(1:size_sub);


end

% Building the Graph - Supervised
function [G, rho] = getGraphWeights( train_x , train_y,  alpha, eps )

% Metric 1: Mutual Information
mi_s = [];
for i = 1:size(train_x,2)
    mi_s = [mi_s, muteinf(train_x(:,i),train_y)];
end
mi_s(isnan(mi_s)) = 0; % remove NaN
mi_s(isinf(mi_s)) = 0; % remove inf
        
% Zero-Max norm
mi_s = mi_s - min(min( mi_s ));
mi_s = mi_s./max(max( mi_s ));

% Metric 2: class separation
fi_s = ([mean(train_x(train_y==1,:)) - mean(train_x(train_y==-1,:))].^2);
st   = std(train_x(train_y==1,:)).^2;
st   = st + std(train_x(train_y==-1,:)).^2;
tmp = find(st==0); %% remove ones where nothing occurs
st(tmp) = 10000;  %% remove ones where nothing occurs
fi_s = fi_s ./ st;

fi_s(isnan(fi_s)) = 0; % remove NaN
fi_s(isinf(fi_s)) = 0; % remove inf
        

%Zero-Max norm
fi_s = fi_s - min(min( fi_s ));
fi_s = fi_s ./max(max( fi_s ));

% Standard Deviation
std_s = std(train_x,[],1);
std_s(isnan(std_s)) = 0; % remove NaN
std_s(isinf(std_s)) = 0; % remove inf

SD = bsxfun( @max, std_s, std_s' );
SD = SD - min(min( SD ));
SD = SD./max(max( SD ));

MI = repmat(mi_s,[size(mi_s,2),1]);
FI = repmat(fi_s,[size(fi_s,2),1]);


G = alpha(1)*[(MI + FI')/2] + alpha(2)*[(MI + SD')/2] + alpha(3)*[(SD + FI')/2];

rho = max(sum(G,2));

% Substochastic Rescaling 
G = G ./ ( max(sum(G,2))+eps);

assert(max(sum(G,2)) < 1.0);

end

%  =========================================================================
%   More details:
%   Reference   : Infinite Feature Selection: A Graph-based Feature Filtering Approach
%   Journal     : IEEE Transactions on Pattern Analysis and Machine Intelligence (TPAMI).
%   Author      : Roffo, G., Melzi, S., Castellani, U., Vinciarelli, A., and Cristani, M.
%   Link        : https://github.com/giorgioroffo/Infinite-Feature-Selection
%  =========================================================================

