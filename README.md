# Online_cp_detection
Sequential Change Detection in Correlation Structures with Window-Limited Statistics
https://doi.org/10.48550/arXiv.2502.01010


We consider the problem of detecting change points in the correlation structure of streaming data under minimum assumptions on the underlying data distribution. 
Detection statistics are constructed for dense and sparse change settings, based on ℓ1 and ℓ∞ norms, respectively, of the squared difference between vectorized pre- and post-change correlation matrices. We also propose a novel threshold-selection algorithm based on sign-flip permutations, which enhances the efficiency of our procedure, particularly when the data dimension is large compared to the window size. Theoretical guarantees for the proposed methods are provided in terms of the average run length in the no-change regime and the expected detection delay in the post-change regime. We evaluate the performance of the proposed methods across a wide range of simulated datasets and demonstrate their effectiveness, achieving small detection delays comparable to those of the exact optimal CUSUM test. Finally, we demonstrate the effectiveness of our methods on real-world datasets, including El Ni˜no event forecasting and seismic event detection. For El Ni˜no event forecasting, our method achieves a state-of-the-art hit rate exceeding 0.86 with near-zero false alarms.
