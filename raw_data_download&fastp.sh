# ref: https://blog.csdn.net/crewkickse/article/details/130982674
# ref: https://www.jianshu.com/p/b3fc0d36954d

# wget -c https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.9/sratoolkit.2.10.9-ubuntu64.tar.gz
# tar -zxvf sratoolkit.2.10.9-ubuntu64.tar.gz
# fastq-dump --help

# When you run this script, please set: nohup bash bio_class.sh &

cd ~

cd sratoolkit.2.10.9-ubuntu64/bin
echo 'export export PATH=/home/mengxu/bio_class/sratoolkit.2.10.9-ubuntu64/bin$PATH' >> ~/.bashrc
source ~/.bashrc

./vdb-config --interactive
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM6436478
# ATAC-seq data from: https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRX16982403&o=acc_s%3Aa
cat ../../SRR_Acc_List_scATAC-seq.txt | while read id; do (./prefetch ${id} --output-directory ../../bio_class_data/atac);done
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM6436479
# RNA-seq data from: https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRX16982404&o=acc_s%3Aa
cat ../../SRR_Acc_List_scRNA-seq.txt | while read id; do (./prefetch ${id} ../../ --output-directory ../../bio_class_data/rna);done

./sratoolkit.2.10.9-ubuntu64/bin/fastq-dump --gzip --split-3 -O bio_class_data/rna/SRR20963892/ bio_class_data/rna/SRR20963892/SRR20963892.sra
./sratoolkit.2.10.9-ubuntu64/bin/fastq-dump --gzip --split-3 -O bio_class_data/atac/SRR20963896/ bio_class_data/atac/SRR20963896/SRR20963896.sra
