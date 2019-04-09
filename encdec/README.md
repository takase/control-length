## Preprocessing

- Construction of binarized data with shared vocabulary

```
python preprocess.py --source-lang SOURCE_SUFFIX --target-lang TARGET_SUFFIX 
--trainpref PREFIX_PATH_TO_TRAIN_DATA --validpref PREFIX_PATH_TO_VALID_DATA 
--joined-dictionary  --destdir PREPROCESS_PATH
```

- Preprocessing to test file

```
python preprocess.py --source-lang SOURCE_SUFFIX --target-lang TARGET_SUFFIX 
--tgtdict PATH_TO_TARGET_DICT --srcdict PATH_TO_SOURCE_DICT 
--testpref PREFIX_PATH_TO_TEST_DATA --destdir PREPROCESS_TEST_PATH
```

## Training

- E.g., training Transformer+LRPE+PE on 4 GPU machine

	- +LRPE: --represent-length-by-lrpe

	- +LDPE: --represent-length-by-ldpe

	- +PE: --ordinary-sinpos 

```
python train.py PREPROCESS_PATH --source-lang SOURCE_SUFFIX --target-lang TARGET_SUFFIX 
--arch transformer_wmt_en_de --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 
--lr-scheduler inverse_sqrt --warmup-init-lr 1e-07  --warmup-updates 4000 --lr 0.001 --min-lr 1e-09 
--dropout 0.3 --weight-decay 0.0 --criterion label_smoothed_cross_entropy --label-smoothing 0.1 
--max-tokens 3584 --seed 2723 --max-epoch 100 --update-freq 16 --share-all-embeddings 
--represent-length-by-lrpe --ordinary-sinpos --save-dir PATH_TO_SAVE_MODEL
```

- If you run the training process on 1 GPU, please modify update freq 16 -> 64

- Averaging last 10 checkpoints

```
python scripts/average_checkpoints.py --inputs PATH_TO_SAVE_MODEL --num-epoch-checkpoints 10 --output PATH_TO_AVERAGED_MODEL
```

## Generation

1. Generate headlines in the constraint of 75 characters

```
python generate.py PREPROCESS_TEST_PATH --source-lang SOURCE_SUFFIX --target-lang TARGET_SUFFIX 
--path PATH_TO_AVERAGED_MODEL --desired-length 75 --batch-size 32 --beam 5 
| grep '^H' | sed 's/^H\-//g' | sort -t 'TAB' -k1,1 -n | cut -f 3-
```

2. Generate n-best headlines and re-ranking

- Generate n-best headlines (n = 20 in the following example)

```
python generate.py PREPROCESS_TEST_PATH --source-lang SOURCE_SUFFIX --target-lang TARGET_SUFFIX 
--path PATH_TO_AVERAGED_MODEL --batch-size 32 --beam 20 --nbest 20 --desired-length 75 > nbest.txt
```

- Re-ranking n-best headlines

```
python rerank.py --cand nbest.txt -m --source SOURCE_FILE
```
