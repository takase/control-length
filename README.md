# Positional Encoding to Control Output Sequence Length

This repository contains source files we used in our paper
>[Positional Encoding to Control Output Sequence Length](https://www.aclweb.org/anthology/N19-1401)

>Sho Takase, Naoaki Okazaki

> Proceedings of the 2019 Conference of the North American Chapter of the Association for Computational Linguistics: Human Language Technologies


## Requirements

- Python 3.6 or later for training
- Python 2.7 for calculating rouge
- PyTorch 0.4


## Test data

Test data used in our paper for each length

- [https://drive.google.com/open?id=1teets0SZ82cdwQG0s454Y7JFuoutOawb](https://drive.google.com/open?id=1teets0SZ82cdwQG0s454Y7JFuoutOawb)
- Each file contains ```SOURCE PART tab HEADLINE```

## Pre-trained model

The following file contains pre-trained LRPE + PE model in English dataset. This model outputs ``` @@@ ``` as a space, namely, a segmentation marker of words.

The file also contains BPE code to split a plane English text into BPE with [this code](https://github.com/rsennrich/subword-nmt).

[https://drive.google.com/file/d/15Sy8rv6Snw6Nso7T5MxYHSAZDdieXpE7/view?usp=sharing](https://drive.google.com/file/d/15Sy8rv6Snw6Nso7T5MxYHSAZDdieXpE7/view?usp=sharing)

## Acknowledgements

A large portion of this repo is borrowed from the following repos: [https://github.com/pytorch/fairseq](https://github.com/pytorch/fairseq) and [https://github.com/facebookarchive/NAMAS](https://github.com/facebookarchive/NAMAS).
