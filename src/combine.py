#!/bin/python3
import numpy as np
import pandas as pd
import networkx as nx
from tqdm import tqdm
from grn import grn


# data lives here
outd="/oak/stanford/groups/pritch/users/magu/projects/genetwork/grn-paper/grns/"
ixs=range(1,1921)


# save logs
logs={i: pd.read_csv(outd+'graph.{}.relog.log'.format(i), 
                     sep='\t', 
                     skiprows=1, 
                     names=[i]) 
      for i in tqdm(ixs)}

pd.concat(logs, axis=1).T.reset_index(level=0
                      ).drop(columns=['level_0','kos']
                      ).rename(columns={'out':'files', 'num_genes':'n', 'num_groups':'k'}
                      ).to_csv(outd[:-5]+'networks.tsv', sep='\t')


# save items from grn objects: this is slower on file i/o but better on memory
for field, attr in {'module':'module', 'dist':'dist', 'alpha':'alpha', 'degrade':'l', 'beta':'beta', 'rna':'rna','ko':'ko'}.items():
    np.save(outd[:-5]+field+'.npy', np.stack([getattr(nx.read_gpickle(outd + 'graph.{}.gpickle'.format(i)), attr) for i in tqdm(ixs)]))
