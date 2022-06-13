#!/bin/bash
#Stage 1 Tasks

#To count the number of sequences in DNA.fa (https://raw.githubusercontent.com/HackBio-Internship/wale-home-tasks/main/DNA.fa)

mkdir stage_one

#Download DNA.fa
wget https://raw.githubusercontent.com/HackBio-Internship/wale-home-tasks/main/DNA.fa

#Count the number of sequences in DNA.fa
grep ">" DNA.fa | wc -l


#Write a one-line command in Bash to get the total A, T, G & C counts for all the sequences in the file above
grep -Eo 'A|T|G|C' DNA.fa | sort | uniq -c | awk '{print $2": "$1}'

cd

#Download miniconda for setting up environment on the terminal
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh

#Verify your installer hashes
#sha256sum Miniconda3-py39_4.12.0-Linux-x86_64.sh

#give permission to execute the file
chmod +x Miniconda3-py39_4.12.0-Linux-x86_64.sh

#run the file to install miniconda
./Miniconda3-py39_4.12.0-Linux-x86_64.sh

#activate conda in new terminal manually
source ~/.bashrc

#if we don't want the conda to be activated while opening a new terminal
#conda config --set auto_activate_base false

#reactivate conda if deactivated
#conda activate base

#download and install softwares
conda install -c bioconda fastqc
conda install -c conda-forge multiqc
conda install -c bioconda fastp
conda install -c bioconda samtools
conda install -c bioconda bwa
conda install -c bioconda bbmap
#conda install -c bioconda fastx_toolkit

cd \stage_one

#make folder for downloading datasets
mkdir raw_reads


#Downloads some sample datasets
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/ACBarrie_R1.fastq.gz?raw=true/ -O ACBarrie_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/ACBarrie_R2.fastq.gz?raw=true/ -O ACBarrie_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R1.fastq.gz?raw=true/ -O Alsen_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R2.fastq.gz?raw=true/ -O Alsen_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Baxter_R1.fastq.gz?raw=true/ -O Baxter_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Baxter_R2.fastq.gz?raw=true/ -O Baxter_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Chara_R1.fastq.gz?raw=true/ -O Chara_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Chara_R2.fastq.gz?raw=true/ -O Chara_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Drysdale_R1.fastq.gz?raw=true/ -O Drysdale_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Drysdale_R2.fastq.gz?raw=true/ -O Drysdale_R2.fastq.gz

cd ..

#Create a folder called output
mkdir output && cd output
mkdir QC_reports

cd \raw_reads

#Implement fastqc for all fastq files
fastqc raw_reads/*.fastq.gz -o output/QC_reports

cd ..

#Implement multiQC (assembling quality control reports)
multiqc output/QC_reports

#move multiqc html report
mv multiqc_report.html \output

#Implement fastk (fastq_to_fasta : convert fastq to fasta)
#convert all fastq.gz to fastq by keeping the original gz files
#gunzip -k *.gz
#convert fastq to fasta using fastx
#fastq_to_fasta -i ACBarrie_R1.fastq -o ACBarrie_R1.fasta
#fastq_to_fasta -i ACBarrie_R2.fastq -o ACBarrie_R2.fasta
#fastq_to_fasta -i Alsen_R1.fastq -o Alsen_R1.fasta
#fastq_to_fasta -i Alsen_R2.fastq -o Alsen_R2.fasta
#fastq_to_fasta -i Baxter_R1.fastq -o Baxter_R1.fasta
#fastq_to_fasta -i Baxter_R2.fastq -o Baxter_R2.fasta

cd \raw_reads

#Implement fastp
#download trim.sh
wget https://raw.githubusercontent.com/josoga2/yt-dataset/main/dataset/trim.sh

#run
bash trim.sh

#rename
mv \qc_reads trimmed_reads

#Implementing burrow wheeler alignment (assembles genomes)

mkdir references && cd references

#download reference genome
wget https://raw.githubusercontent.com/josoga2/yt-dataset/main/dataset/references/reference.fasta

cd ..

#download script for performing bwa
wget https://raw.githubusercontent.com/josoga2/yt-dataset/main/dataset/aligner.sh

#run
bash aligner.sh


#samtools (manipulating sam/bam/cram files)

cd \alignment_map

#convert sam to bam
#samtools view -S -b filename.bam > filename.bam

#view bam files
samtools view ACBarrie.bam | less
samtools view Alsen.bam | less
samtools view Baxter.bam | less
samtools view Chara.bam | less
samtools view Drysdale.bam | less

#View bam files (head,upto 5 lines)
samtools view ACBarrie.bam | head -n 5
samtools view Alsen.bam | head -n 5
samtools view Baxter.bam | head -n 5
samtools view Chara.bam | head -n 5
samtools view Drysdale.bam | head -n 5

#sort according to ascending order
samtools sort ACBarrie.bam -o sorted_ACBarrie.bam
samtools sort Alsen.bam -o sorted_Alsen.bam
samtools sort Baxter.bam -o sorted_Baxter.bam
samtools sort Chara.bam -o sorted_Chara.bam
samtools sort Drysdale.bam -o sorted_Drysdale.bam

#visualize to check if bam files are sorted
samtools view sorted_ACBarrie.bam | head -n 5
samtools view sorted_Alsen.bam | head -n 5
samtools view sorted_Baxter.bam | head -n 5
samtools view sorted_Chara.bam | head -n 5
samtools view sorted_Drysdale.bam | head -n 5

#move remaining results to output folder
#move alignment_map and repaired folders
mv -v alignment_map/ ..
mv -v repaired/ ..
cd ..
mv -v alignment_map/ output/
mv -v repaired/ output/


