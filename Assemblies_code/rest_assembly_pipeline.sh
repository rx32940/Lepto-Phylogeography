#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N assemble_rest                                       
#PBS -l nodes=1:ppn=12 -l mem=10gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

###################################################################
#
# fastqc 
# quality check
# pair end reads
# reverse file: _2,_3,_4
#
####################################################################

# seqpath="/scratch/rx32940/rest_sra_216/SRAseq"
# path_qc="/scratch/rx32940/Lepto_Work/rest_211/fastqc"

# module load FastQC/0.11.8-Java-1.8.0_144

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_2.txt |\
# xargs -I{} fastqc -t 12 -o fastqc -o $path_qc -f fastq $seqpath/{}_1.fastq.gz \
# $seqpath/{}_2.fastq.gz

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_3.txt |\
# xargs -I{} fastqc -t 12 -o fastqc -o $path_qc -f fastq $seqpath/{}_1.fastq.gz \
# $seqpath/{}_3.fastq.gz

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_4.txt |\
# xargs -I{} fastqc -t 12 -o fastqc -o $path_qc -f fastq $seqpath/{}_1.fastq.gz \
# $seqpath/{}_4.fastq.gz

######################################################################
#
# multiqc
# Aggregate all fastqc reports for the 211 biosamples with collection date 
#
# #####################################################################

# path_qc="/scratch/rx32940/Lepto_Work/rest_211/fastqc" 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $path_qc/*_fastqc.zip -o $path_qc

############################################################################
# 
# trimming 
# Trimmomatic
# single end and pair end fastq files need to trim separately with separate adapters
# all trimmed seq with reverse file renamed as _2
# 
############################################################################

# path_seq="/scratch/rx32940/rest_sra_216/SRAseq"
# output_dir="/scratch/rx32940/Lepto_Work/rest_211/trimmed"

# module load Trimmomatic/0.36-Java-1.8.0_144

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_2.txt  | \
# while read biosample;
# do  
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 12 $path_seq/${biosample}_1.fastq.gz $path_seq/${biosample}_2.fastq.gz \
#     $output_dir/${biosample}_1_paired_trimmed.fastq.gz $output_dir/${biosample}_1_unpaired_trimmed.fastq.gz \
#     $output_dir/${biosample}_2_paired_trimmed.fastq.gz $output_dir/${biosample}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_3.txt  | \
# while read biosample;
# do  
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 12 $path_seq/${biosample}_1.fastq.gz $path_seq/${biosample}_3.fastq.gz \
#     $output_dir/${biosample}_1_paired_trimmed.fastq.gz $output_dir/${biosample}_1_unpaired_trimmed.fastq.gz \
#     $output_dir/${biosample}_2_paired_trimmed.fastq.gz $output_dir/${biosample}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_4.txt  | \
# while read biosample;
# do  
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 12 $path_seq/${biosample}_1.fastq.gz $path_seq/${biosample}_4.fastq.gz \
#     $output_dir/${biosample}_1_paired_trimmed.fastq.gz $output_dir/${biosample}_1_unpaired_trimmed.fastq.gz \
#     $output_dir/${biosample}_2_paired_trimmed.fastq.gz $output_dir/${biosample}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

###################################################################
#
# fastqc 
# 25 seq didn't pass qc, re-qc after trimming
# quality check
# pair end reads
##################################################################################

# seqpath="/scratch/rx32940/Lepto_Work/rest_211/trimmed"
# path_qc="/scratch/rx32940/Lepto_Work/rest_211/2nd_qc"

# module load FastQC/0.11.8-Java-1.8.0_144

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/rest_sra_212.txt |\
# xargs -I{} fastqc -t 12 -o fastqc -o $path_qc -f fastq $seqpath/{}_1_paired_trimmed.fastq.gz \
# $seqpath/{}_2_paired_trimmed.fastq.gz

######################################################################
#
# multiqc
# see the qualities for rest 211 isolates after trimming 
#
# #####################################################################

# path_qc="/scratch/rx32940/Lepto_Work/rest_211/fastqc" 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $path_qc/*_fastqc.zip -o $path_qc

############################################################################
#
# SPADES 
# Assemble the trimmed seq 
#
############################################################################


# path_seq="/scratch/rx32940/All_Lepto_Assemblies/rest_sra_216"
# trim_seq="/scratch/rx32940/Lepto_Work/rest_211/trimmed"

# paste $path_seq/rest_sra_211.txt $path_seq/rest_biosample_211.txt |\
# while IFS="$(printf '\t')" read SRA SAMN; 
#  do
#     echo "Starting command"
#     (
#     echo "$SRA \t $SAMN"
#     sapelo2_header="#!/bin/bash
#         #PBS -q bahl_salv_q                                                            
#         #PBS -N assembleRest_pair_$SAMN                                        
#         #PBS -l nodes=1:ppn=12 -l mem=10gb                                        
#         #PBS -l walltime=100:00:00                                                
#         #PBS -M rx32940@uga.edu                                                  
#         #PBS -m abe                                                              
#         #PBS -o /scratch/rx32940                        
#         #PBS -e /scratch/rx32940                        
#         #PBS -j oe
#     "

#     echo "$sapelo2_header" > ./sub_assembleRest.sh
#     echo "module load spades/3.12.0-k_245" >> ./sub_assembleRest.sh

#     echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
#     --pe1-1 $trim_seq/${SRA}_1_paired_trimmed.fastq.gz \
#     --pe1-2 $trim_seq/${SRA}_2_paired_trimmed.fastq.gz \
#     --careful --mismatch-correction \
#     -o /scratch/rx32940/Lepto_Work/rest_211/assemblies/$SAMN" >> ./sub_assembleRest.sh


#     qsub ./sub_assembleRest.sh
    
#     echo "$SAMN pair-end submitted"
#     ) &

#     echo "Waiting..."
#     wait

# done

######################################################################
#
# QUAST
# check the quality of each assemblies - not providing reference
#
######################################################################

# module load QUAST/5.0.2-foss-2018a-Python-2.7.14


# QUASTPATH="/scratch/rx32940/Lepto_Work/rest_211" 
# refseq="/scratch/rx32940/reference"

# for file in /scratch/rx32940/Lepto_Work/rest_211/assemblies/*;
# do
#     biosample="$(basename "$file")"
#     species="$(python /home/rx32940/github/Lepto-Phylogeography/get_biosample_species.py "$biosample")" # get the species of the biosample acc
#     refname="$(ls "$refseq"/"$species"/*_genomic.fna)"
#     annotation="$(ls "$refseq"/"$species"/*_genomic.gff)"
    
#     quast.py \
#     $QUASTPATH/assemblies/$biosample/scaffolds.fasta \
#     --fragmented \
#     -r $refname \
#     -g $annotation \
#     -o $QUASTPATH/quast/$biosample/ \
#     -t 8 
# done

# # ######################################################################
# # #
# # # multiqc
# # # Aggregate all QUAST reports for the 50 biosamples with collection date 
# # #
# # # #####################################################################

# path_quast="/scratch/rx32940/Lepto_Work/rest_211" 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $path_quast/quast/*/report.tsv \
# -d -dd 1 -o $path_quast \
# -n quast_rest_211

#########################################################################
###  QUAST low mapping isolates with NCBI STAT identified reference genome
###########################################################################

# module load QUAST/5.0.2-foss-2018a-Python-2.7.14
# module load MultiQC/1.5-foss-2016b-Python-2.7.14

 
# QUASTPATH="/scratch/rx32940/Lepto_Work/rest_211" 
# refseq="/scratch/rx32940/reference"

# cat /scratch/rx32940/Lepto_Work/rest_211/low_map_isolates.txt |\
# while IFS="$(printf '\t')" read ACC SP;
# do
#     refname="$(ls "$refseq"/"$SP"/*_genomic.fna)"
#     annotation="$(ls "$refseq"/"$SP"/*_genomic.gff)"

#     quast.py \
#     $QUASTPATH/assemblies/$ACC/scaffolds.fasta \
#     --fragmented \
#     -r $refname \
#     -g $annotation \
#     -o $QUASTPATH/low_map_requast/$ACC \
#     -t 8

# done

# multiqc $QUASTPATH/low_map_requast/*/report.tsv \
# -d -dd 1 -o $QUASTPATH \
# -n low_map_requast_rest

#########################################################################
# BWA mem + Samtools for coverage
#########################################################################

module load SAMtools/1.10-GCC-8.2.0-2.31.1
module load BWA/0.7.17-foss-2016b
module load Anaconda3/2019.03
ml Qualimap2/2.2.1-foss-2016b-Java-1.8.0_144
module load MultiQC/1.5-foss-2016b-Python-2.7.14


ppath="/scratch/rx32940/Lepto_Work/rest_211"

cat $ppath/rest_211_sra_samn.csv | 
while IFS="$(printf ',')" read SRA SAMN; 
do
    species="$(python /home/rx32940/github/Lepto-Phylogeography/get_biosample_species.py "$SAMN" "$ppath"/biosample_species_dict_rest_new.csv)"

    bwa mem -t 12 /scratch/rx32940/reference/$species/*_genomic.fna /scratch/rx32940/Lepto_Work/rest_211/trimmed/${SRA}_1_paired_trimmed.fastq.gz /scratch/rx32940/Lepto_Work/rest_211/trimmed/${SRA}_2_paired_trimmed.fastq.gz | samtools view -b - | samtools sort - > /scratch/rx32940/Lepto_Work/rest_211/bwa/$SAMN.sorted.bam

    qualimap bamqc -bam /scratch/rx32940/Lepto_Work/rest_211/bwa/$SAMN.sorted.bam -outdir /scratch/rx32940/Lepto_Work/rest_211/cov/$SAMN -nt 12
    
done

multiqc /scratch/rx32940/Lepto_Work/rest_211/cov -o /scratch/rx32940/Lepto_Work/rest_211/ -n multiqc_qualimap_rest_211
