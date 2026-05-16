# Online_cp_detection
online change point detection in large dimensional correlation matrix

We consider the problem of detecting change points in the correlation structure of 10
streaming data under minimum assumptions on the underlying data distribution. 11
Detection statistics are constructed for dense and sparse change settings, based on 12
ℓ1 and ℓ∞ norms, respectively, of the squared difference between vectorized pre- 13
and post-change correlation matrices. We also propose a novel threshold-selection 14
algorithm based on sign-flip permutations, which enhances the efficiency of our pro- 15
cedure, particularly when the data dimension is large compared to the window size. 16
Theoretical guarantees for the proposed methods are provided in terms of the av- 17
erage run length in the no-change regime and the expected detection delay in the 18
post-change regime. We evaluate the performance of the proposed methods across a 19
wide range of simulated datasets and demonstrate their effectiveness, achieving small 20
detection delays comparable to those of the exact optimal CUSUM test. Finally, we 21
demonstrate the effectiveness of our methods on real-world datasets, including El 22
Ni˜no event forecasting and seismic event detection. For El Ni˜no event forecasting, 23
our method achieves a state-of-the-art hit rate exceeding 0.86 with near-zero false 24
alarms.
