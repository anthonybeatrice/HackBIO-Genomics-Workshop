grep -c ">" DNA.fa
grep -EO 'A|T|G|C' DNA.fa | sort | uniq -c | awk '{print $2": "$1}'



#setting up conda
sudo apt update
sudo apt upgrade

cd /tmp
curl -O https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.shsudo apt update
sudo apt upgrade

cd /tmp
curl -O https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh
#Welcome to Anaconda3 5.3.0
#In order to continue the installation process, please review the license
#agreement.
#Please, press ENTER to continue
#>>>
#Do you accept the license terms? [yes|no]
#Press Enter to continue the installation and type yes to accept when prompted.
#to test conda installation type
conda list

#installation of fastqc
sudo apt-get install fastqc
mkdir fsq_output

#download datasets
#run fastqc on datasets
fastqc ACBarrie_R1_rep_fastq --outdir fsq_output
fastqc ACBarrie_R2_rep_fastq --outdir fsq_output
fastqc singleq_fastq --outdir fsq_output
