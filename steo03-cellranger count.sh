# It is only used for cellranger count!
#cd ~
#sudo vim .bashrc
#export PATH=/opt/cellranger-6.1.2:$PATH

#echo "Configure Cellranger environment"
#cd ~/cellranger-6.1.2
#source sourceme.bash
files=(SRR20963892
  SRR20963893
  SRR20963894
  SRR20963895
  SRR20963902
  SRR20963896
  SRR20963897
  SRR20963903)
for rna_file in "${rna_files[@]}"; do
    echo "Running for $rna_file"
    cellranger count --id=$rna_file \
      --transcriptome=/data/mengxu/reference/refdata-gex-GRCh38-2020-A \
      --fastqs=bio_class_data/rna_fastp/$rna_file \
      --sample=$rna_file \
      --localcores=10 \
      --localmem=64 #\--nosecondary
done
