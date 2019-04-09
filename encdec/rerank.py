# -*- coding: utf-8 -*-

#extract a sentence which contains the most source tokens

import sys
import re
import collections
import argparse
from nltk.stem.porter import PorterStemmer

alphabet = re.compile('[a-z]')


def extract_source_word(filename, stemmer=None):
    d = {}
    for i, line in enumerate(open(filename)):
        line = line.strip()
        words = line.split()
        if stemmer is None:
            wordset = set([w for w in words if alphabet.search(w)])
        else:
            wordset = set([stemmer.stem(w) for w in words if alphabet.search(w)])
        d[i] = wordset
    return d


def extract_output(filename, space_symbol):
    d = collections.defaultdict(list)
    for line in open(filename):
        line = line.strip()
        if not line.startswith('H-'):
            continue
        index, prob, cand = line.split('\t')
        index = int(index.replace('H-', ''))
        d[index].append(cand.replace(' ', '').replace(space_symbol, ' '))
    return d


def main(args):
    if args.m:
        stemmer = PorterStemmer()
    else:
        stemmer = None
    source_word_dict = extract_source_word(args.source, stemmer)
    output_dict = extract_output(args.cand, args.space_symbol)
    for index in range(len(output_dict)):
        wordset = source_word_dict[index]
        out = None
        for cand in output_dict[index]:
            if stemmer is None:
                word = cand.split()
            else:
                word = [stemmer.stem(w) for w in cand.split()]
            num = sum([1 for w in word if w in wordset])
            if out is None:
                out = cand
                maxnum = num
            elif num > maxnum:
                out = cand
                maxnum = num
        print(out)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--cand', required=True,
        help='specify the candidate file')
    parser.add_argument('--source', required=True,
        help='specify the source file')
    parser.add_argument('-m', default=False, action='store_true',
        help='stemming (by porter stemmer) or not')
    parser.add_argument('--space', dest='space_symbol', default='@@@@',
        help='symbol to represent a space in the candidate file')
    args = parser.parse_args()
    main(args)
