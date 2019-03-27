# -*- coding: utf-8 -*-

#calculate variance of length (the number of characters) between system generation and given correct length
#this variance calculation is based on one defined in http://aclweb.org/anthology/D18-1444


import sys
import collections
import numpy as np
import argparse


def read_file(filename):
    return [line.strip() for line in open(filename)]


def main(args):
    system_out = read_file(args.system_output)
    if args.reference:
        reference = read_file(args.reference)
        reference_len = [len(s) for s in reference]
    else:
        reference_len = [args.length for _ in range(len(system_out))]
    total = 0.0
    abs_diff = 0
    for reflen, sent in zip(reference_len, system_out):
        total += (len(sent) - reflen) ** 2
        abs_diff += abs(len(sent) - reflen)
    sntnum = len(reference_len)
    var = total / sntnum
    print('Variance: %.5f'%(var))
    print('Ave diff: %.5f'%(float(abs_diff) / sntnum))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--system', dest='system_output',
        required=True, help='specify the system output file name')
    parser.add_argument('-r', '--reference', dest='reference', default='',
        help='specify the reference file name')
    parser.add_argument('-l', '--length', dest='length', type=int, default=75,
        help='the number of characters of correct sequence')
    args = parser.parse_args()
    main(args)
