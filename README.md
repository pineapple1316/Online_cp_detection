# Online change point detection
This repository contains two main works. The first is a methodological study that introduces window-limited statistics for sequential change detection in correlation matrices. The second is an application study that applies the Shewhart-type max statistic to the forecasting of two important climate events: the Indian Ocean Dipole (IOD) and La Niña.

# Part 1: Sequential Change Detection in Correlation Structures with Window-Limited Statistics

We consider the problem of detecting change points in the correlation structure of streaming data under minimum assumptions on the underlying data distribution. 
Detection statistics are constructed for dense and sparse change settings, based on ℓ1 and ℓ∞ norms, respectively, of the squared difference between vectorized pre- and post-change correlation matrices. We also propose a novel threshold-selection algorithm based on sign-flip permutations, which enhances the efficiency of our procedure, particularly when the data dimension is large compared to the window size. Theoretical guarantees for the proposed methods are provided in terms of the average run length in the no-change regime and the expected detection delay in the post-change regime. We evaluate the performance of the proposed methods across a wide range of simulated datasets and demonstrate their effectiveness, achieving small detection delays comparable to those of the exact optimal CUSUM test. Finally, we demonstrate the effectiveness of our methods on real-world datasets, including El Ni˜no event forecasting and seismic event detection. For El Ni˜no event forecasting, our method achieves a state-of-the-art hit rate exceeding 0.86 with near-zero false alarms.

## Simulation
Here we compare our WL-Sum statistic, SMOTE and knockoff enhancement methods, Scan B-statistic and CUSUM method.
<img width="355" height="276" alt="image" src="https://github.com/user-attachments/assets/88a376b5-c887-4d73-8156-6058aa58b3c8" />
<img width="355" height="276" alt="image" src="https://github.com/user-attachments/assets/c01d0064-f9ca-4fbd-9b92-9860ac13d2c9" />


<img width="713" height="356" alt="image" src="https://github.com/user-attachments/assets/8ced3e0f-54f0-4c49-9bbe-ed3b190bf6ba" />

<img width="713" height="356" alt="image" src="https://github.com/user-attachments/assets/9fd6ad0f-5623-4e75-bad7-306314a993f2" />


# References
If you find the code useful for your research, please consider citing
```bibtex
@misc{gao2026sequentialchangedetectioncorrelation,
      title={Sequential Change Detection in Correlation Structures with Window-Limited Statistics}, 
      author={Jie Gao and Liyan Xie and Zhaoyuan Li},
      year={2026},
      eprint={2502.01010},
      archivePrefix={arXiv},
      primaryClass={stat.ME},
      url={https://arxiv.org/abs/2502.01010}, 
}
```
# Part 2: Correlation Change Detection for Prediction in Climate Science

The reliable early prediction of climate events remains a significant challenge, in
part due to the presence of predictability barriers that hamper long lead-time forecasts. Here
we propose a new prediction method based on the correlation structure of multiple climate time
series. The strength of the cross-correlations between climate variables or between different
regions changes constantly, for instance, before and after some critical climate events. This forms
the basis for prediction by the proposed Correlation Change Detection (CCD) method. We apply
the method to forecast Indian Ocean Dipole (IOD) events and La Nina episodes and find that,
for both phenomena, significant changes in the respective regional correlation structures tend to
occur before their respective predictability barriers, which can be crossed by our proposed method.
Based on this method, 10 out of the 15 IOD events between 1986 and 2024 are correctly predicted
with a mean lead time of 1 year and a false alarm rate of 20.8%. Combined with the results of
the previously proposed climate network-based method for forecasting IOD events, the prediction
precision for the occurrence and absence of events increases to more than 85%. Additionally, the
method can predict the onset of a new La Nina episode 1 year ahead with a precision that is higher ˜
than the empirical rule of predicting a La Nina event directly after an El Ni ˜ no event. Overall, ˜
the proposed CCD method offers a new perspective for predicting and understanding regional and
global climate phenomena.

The result for IOD forecasting. According to the JAMSTEC DMI index, of the total of 15 IOD events from 1986 to 2024, 243
10 IOD events (5 positive IODs and 5 negative IODs) occurred the following year after a significant 244
CCD appeared, which corresponds to a hit rate of 66.7%.
<img width="647" height="347" alt="image" src="https://github.com/user-attachments/assets/12582e5f-9798-49bf-b370-9fbd129db24d" />
<img width="720" height="196" alt="image" src="https://github.com/user-attachments/assets/51a2bcfe-facd-4abe-a808-45eb0d8c3d30" />



