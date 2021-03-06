#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N iqtree_host                                    
#PBS -l nodes=1:ppn=24 -l mem=100gb                                        
#PBS -l walltime=300:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

module load IQ-TREE/1.6.5-omp

iqtree -redo -nt AUTO -m MFP -pre /scratch/rx32940/interrogans-coregenes -s 
