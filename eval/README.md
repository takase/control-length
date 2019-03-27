## Calculate ROUGE

- Obtain ROUGE-1.5.5.pl

```sh eval.sh  DIR_REF&OUT SOURCE_PART LENGTH THIS_DIR ROUGE_DIR```

- DIR_REF&OUT: directory contains two directories, references and systems
  - references contains the correct outputs. File name is task1_ref0.txt (if there are multiple references, task1_ref0.txt, task1_ref1.txt, task1_ref2.txt, ...)
  - systems contains the system outputs. File name is task1_SPECIFIC_NAME_OF_YOUR_FILE.txt
 - SOURCE_PART: file contains source parts of references
 - LENGTH: desired length. In our paper, we used 30, 50, and 70 in English.
 - THIS_DIR: path to this directory
 - ROUGE_DIR: directory contains the rouge script, i.e., ROUGE-1.5.5.pl

## Calculate Variance

```python calculate_variance_from_fixlength.py -s SYS_OUTPUT -l LENGTH```

- SYS_OUTPUT: file contains outputs
- LENGTH: desired length. In our paper, we used 30, 50, and 70 in English.