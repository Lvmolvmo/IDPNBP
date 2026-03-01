# IDPNBP: Image Dehazing Using Patch-wise Nonlinear Brightness Prior

This repository contains the official implementation of the paper:  
**"Image Dehazing Using Patch-wise Nonlinear Brightness Prior"**  accepted by **IEEE Signal Processing Letters (SPL), 2026**.

Author: Xiaoyue Wu, Tianyi Lyu, and Mingye Ju.

[![IEEE Xplore](https://img.shields.io/badge/IEEE-Xplore-blue)](https://ieeexplore.ieee.org/document/11415625) 

---

## 📖 Overview

**Abstract**: Currently available dehazing methods, whether based on hand-crafted priors or learned from datasets, typically ignore the brightness consistency between hazy images and their dehazed results, which often leads to over-enhancement and color cast. To address this issue, we first investigate a **patch-wise nonlinear brightness prior (PNBP)** that explicitly characterizes the relationship between the brightness of hazy patches and that of their clear counterparts. By combining PNBP with the atmospheric scattering model, the single image dehazing problem can be recast as a restoration formula with only three parameters, substantially shrinking the solution space for haze removal. Under a multi-objective joint optimization that simultaneously considers information gain, exposure, and preservation of the pixel-histogram distribution, this restoration formula can directly produce high-quality dehazed images. Thanks to PNBP, our method inherits brightness consistency from the prior and thereby avoids the risk of over-enhancement while reducing the possibility of color cast. Extensive experiments demonstrate that the proposed method outperforms state-of-the-art approaches in terms of defogging quality, robustness, and computational efficiency.

## 🚀 Quick Start

### Requirements
- Matlab R2023b
### Installation
```bash
git clone https://github.com/Lvmolvmo IDPNBP.git
cd IDPNBP
```
### Test by Folder
put your hazy image in path: "./input"

Install dependencies:
```bash
run Joint_demo.m
```
## 📝 Citations
If you find this code useful for your research, please cite our paper:

```bash
@ARTICLE{IDPNBP,
  author={Wu, Xiaoyue and Lyu, Tianyi and Ju, Mingye},
  journal={IEEE Signal Processing Letters}, 
  title={Image Dehazing Using Patch-wise Nonlinear Brightness Prior}, 
  year={2026},
  volume={},
  number={},
  pages={1-5},
  doi={10.1109/LSP.2026.3668456}
}
```
## 📄 License

This project is licensed under the MIT License – see the [LICENSE](https://github.com/Lvmolvmo/IDPNBP/blob/main/LICENSE) file for details.