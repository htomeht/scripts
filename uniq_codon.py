#! /usr/bin/env python

def generate_codons():
    for x in ["gca", "gcc", "gcg", "gcu", "ugc", "ugu", "gac", "gau", "gaa","gag", "uuc", "uuu", "gga", "ggc", "ggg", "ggu", "cac", "cau", "aua", "auc", "auu", "aaa", "aag", "uaa", "uug", "cua", "cuc", "cug", "cuu", "aug", "aac", "aau", "cca", "ccc", "ccg", "ccu", "caa", "cag", "aga", "agc", "aca", "gua", "ugg", "uac", "uau"]:
        yield x

def hash_codon(codon):

    nuc2int = {'a': 1, 'c': 2, 'g': 3, 'u': 6}
    out = 1
    i = 1

    for nucleon in codon:
        out = out*((nuc2int[nucleon])**i) % 83
        i *= 2
    return out

    
if __name__ == '__main__':
    for codon in generate_codons():
        print hash_codon(codon)
