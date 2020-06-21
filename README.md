# Infinite Feature Selection: A Graph-based Feature Filtering Approach

Giorgio Roffo*, Simone Melzi^, Umberto Castellani^, Alessandro Vinciarelli* and Marco Cristani^

(*) University of Glasgow (UK) - (^) University of Verona (Italy)

Published in the IEEE Transactions on Pattern Analysis and Machine Intelligence (TPAMI) 2020. 

IEEE Article available at https://ieeexplore.ieee.org/document/9119168

ArXiv version: https://arxiv.org/abs/2006.08184 


# Abstract
We propose a filtering feature selection framework that considers a subset of features as a path in a graph, where a node is a feature and an edge indicates pairwise (customizable) relations among features, dealing with relevance and redundancy principles. 
By two different interpretations (exploiting properties of power series of matrices and relying on Markov chains fundamentals) we can evaluate the values of paths (i.e., feature subsets) of arbitrary lengths, eventually go to infinite, from which we dub our framework Infinite Feature Selection (Inf-FS). Going to infinite allows to constrain the computational complexity of the selection process, and to rank the features in an elegant way, that is, considering the value of any path (subset) containing a particular feature. We also propose a simple unsupervised strategy to cut the ranking, so providing the subset of features to keep.
In the experiments, we analyze diverse setups with heterogeneous features, for a total of 11 benchmarks, comparing against  18 widely-know yet effective comparative approaches. The results show that Inf-FS behaves better in almost any situation, that is, when the number of features to keep are fixed a priori, or when the decision of the subset cardinality is part of the process.

# Index Terms

Feature selection, ﬁlter methods, Markov chains


# Introduction

In this paper we introduce a fast graph-based feature ﬁltering approach that ranks and selects features by considering the possible subsets of features as paths on a graph, and works in an unsupervised or supervised setup. 

Our framework is composed by three main steps. 
In the ﬁrst step, an undirected fully-connected weighted graph is built modeling the expectation that features fi and fj are relevant and not redundant.
In the second step, the weighted adjacency matrix associated to the graph is employed to assess the value of each feature while considering possible subsets of features (i.e., subsets of nodes) as they were paths of variable length. We compute a vector which, at the i-th entry, expresses the value (or probability) of having a particular feature in a subset of any length, summing for all the possible lengths, until inﬁnite. 
 In the third step, a threshold over the ranking is automatically selected by clustering over the ranked value. The rationale is to individuate at least two distributions, one which contains the features to keep with higher value, the other the ones to discard. 
 
 # Experiments: Supervised VS Unsupervised 
 
The proposed framework is compared against 18 comparative approaches of feature selection, with the goal of feeding the selected features into an SVM classiﬁer. 
 
 
![Alternate image text](https://github.com/giorgioroffo/Infinite-Feature-Selection/blob/master/figures/SUP.png)

Bubble plot showing the average ranking performance (y-axis) overall the datasets while increasing the number of selected features for supervised methods. The area of each circle is proportional to the variance of the ranking.



![Alternate image text](https://github.com/giorgioroffo/Infinite-Feature-Selection/blob/master/figures/UNSUP.png)

Bubble plot showing the average ranking performance (y-axis) overall the datasets while increasing the number of selected features for unsupervised methods. The area of each circle is proportional to the variance of the ranking.

 # Experiments: Feature selection on CNN Features 

We evaluate the performance of the proposed approach on features learned by the very deep ConvNet.
 
On the PASCAL 2007, we performed an experiment aimed at exploring the performances when spanning the number of features retained from 5% to 100%.  The idea is to check how much difference holds when keeping a small number of features with respect to the whole set. 


![Alternate image text](https://github.com/giorgioroffo/Infinite-Feature-Selection/blob/master/figures/VOC07.png)

Varying the cardinality of the selected features on VOC 2007. Mean average precision instead of classiﬁcation accuracy is provided here.

# Conclusions

In this work we considered the feature selection problem under a brand-new perspective, i.e., as a regularization problem, where features are nodes in a weighted fully-connected graph, and a selection of l features is a path of length l through the nodes of the graph. Under this view, the proposed Inf-FS framework associates each feature to a score originating from pairwise functions (the weights of the edges) that measure relevance and non redundancy


# Code dependencies

All dependencies are contained in the Feature Selection Library.
The MATLAB code is available at the following address: 
https://it.mathworks.com/matlabcentral/fileexchange/56937-feature-selection-library

Please remember to export the library path so that the methods can find all dependencies. For example:

```
addpath('./_path_'); % dependencies
addpath(genpath('./_path_FSLIB_here_'));  % dependencies
```


# Cite

Giorgio Roffo, Simone Melzi, Umberto Castellani, Alessandro Vinciarelli, and Marco Cristani (2020). Infinite Feature Selection: A Graph-based Feature Filtering Approach. In IEEE Transactions on Pattern Analysis and Machine Intelligence (TPAMI), DOI 10.1109/TPAMI.2020.3002843.

Here is the BibTeX citation code: 

```
@ARTICLE{GRoffo_etAll_InfFS_9119168, 
    author={G. {ROFFO} and s. {melzi} and U. {Castellani} and A. {Vinciarelli} and M. {Cristani}}, 
    journal={IEEE Transactions on Pattern Analysis and Machine Intelligence}, 
    title={Infinite Feature Selection: a Graph-based Feature Filtering Approach}, 
    year={2020}, 
    pages={1-1},
    isnn={0162-8828},
    doi={10.1109/TPAMI.2020.3002843},
}
```



