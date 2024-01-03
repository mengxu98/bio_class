#!/bin/bash

# It is only used for cellranger count!

# # Cell Ranger 7.2.0 (Sep 13, 2023)
# wget -O cellranger-7.2.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-7.2.0.tar.gz?Expires=1703465165&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=Wov1QsAhWmRGdR007oNzfg0QXFAKZrZv4bmTtVWsqRfHnr~BBGaV4mZwBSBbfZmxdFV0bdgg05XKISA1Tfm5Sw~G-mqlnzYC57ZYqc6uKdzMDLwg1D-TMWZ12E-CkvBnBgXykH8fqp8bFSHFAzKyqu92Sb6e7E6EtBTBG2qISbpXfs-1l4Yke1GwIruUh8lnPfuhWJ~ppLVLsf9eZ4k7HMvP7Z3bxUl4EgjyXdUXKNqoIfg1LE4l7UzacVxU2c8wZEUtRkG490tKvAB-EtorchIZFWfCukFWuDn-1fiYTGXzSZIAmtVIqi6g1Jzvb2J5MeVOkQ3JOZ1wMI0-5PFECA__"
# tar -xzvf cellranger-7.2.0.tar.gz
# # export PATH=/cellranger-7.2.0:$PATH
# wget -O cellranger-2.0.2.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-2.0.2.tar.gz?Expires=1703510523&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=gSJ0jP48yksmSne-BWJ~X4m2Mfr6m56MvfN8aSRw6fVpfzvtYAfuf03vzBvk8DRfMUlPUMcyI96AruUP9kuXVY-7ooVczPvN8EJSn4bInv7~WvnyjFsgN4Kofy4ulPd-T~2pwBDU4hbYr0GBHdG2QMrWEKTYLnCmcaMG9E-lqF8uElEOAAvjSSX2rhopzx5IHuKNcP19WvnZ6y6FkxKthWM9icX1Fhf1BT~RhQL53Mb6pykyuRtXKmdVKM8alWkw7pcu66S4nUU8EVQqBmpTgNFIFFJh~mqqVgP--xLa-9HJKeUveqhsnneIlm1yL0RtcCAwuevDTQAKLKAge1WszA__"
# tar -xzvf cellranger-2.0.2.tar.gz

# # Mouse reference (mm10) - 2020-A
# wget "https://cf.10xgenomics.com/supp/cell-arc/refdata-cellranger-arc-mm10-2020-A-2.0.0.tar.gz"
# tar -xzvf refdata-cellranger-arc-mm10-2020-A-2.0.0.tar.gz

#cd ~
#sudo vim .bashrc
#export PATH=/opt/cellranger-6.1.2:$PATH

#echo "Configure Cellranger environment"
#cd ~/cellranger-6.1.2
#source sourceme.bash

rna_files=(SRR20963892
SRR20963893
SRR20963894
SRR20963895)
for rna_file in "${rna_files[@]}"; do
    echo "Running for $rna_file"
    mkdir bio_class_data/rna/$rna_file
    mv bio_class_data/rna/"$rna_file"_1.fastq.gz bio_class_data/rna/$rna_file/"$rna_file"_S1_L001_R1_001.fastq.gz
    mv bio_class_data/rna/"$rna_file"_2.fastq.gz bio_class_data/rna/$rna_file/"$rna_file"_S1_L001_R2_001.fastq.gz
    ./cellranger-7.2.0/cellranger count --id=$rna_file \
      --transcriptome=refdata-cellranger-arc-mm10-2020-A-2.0.0 \
      --fastqs=bio_class_data/rna/"$rna_file" \
      --sample=$rna_file \
      --localcores=10 \
      --localmem=32 # \
      # --nosecondary
      # --chemistry=threeprime

done

atac_files=(SRR20963902
SRR20963896
SRR20963897
SRR20963903)
for atac_file in "${atac_files[@]}"; do
    echo "Running for $atac_file"
    mkdir bio_class_data/atac/$atac_file
    mv bio_class_data/atac/"$atac_file"_1.fastq.gz bio_class_data/atac/$atac_file/"$atac_file"_S1_L001_R1_001.fastq.gz
    mv bio_class_data/atac/"$atac_file"_2.fastq.gz bio_class_data/atac/$atac_file/"$atac_file"_S1_L001_R2_001.fastq.gz
    ./cellranger-7.2.0/cellranger count --id=$atac_file \
      --transcriptome=refdata-cellranger-arc-mm10-2020-A-2.0.0 \
      --fastqs=bio_class_data/atac/$atac_file \
      --sample=$atac_file \
      --localcores=10 \
      --localmem=32 # \
      # --nosecondary
      # --no-bam \
done


rna_files=(SRR20963892_fastp
SRR20963893_fastp
SRR20963894_fastp
SRR20963895_fastp)

for rna_file in "${rna_files[@]}"; do
    echo "Running for $rna_file"
    mkdir bio_class_data/rna_fastp/$rna_file
    mv bio_class_data/rna_fastp/"$rna_file"_S1_L001_R1_001.fastq.gz bio_class_data/rna_fastp/$rna_file
    mv bio_class_data/rna_fastp/"$rna_file"_S1_L001_R2_001.fastq.gz bio_class_data/rna_fastp/$rna_file
    ./cellranger-7.2.0/cellranger count --id=$rna_file \
      --transcriptome=refdata-cellranger-arc-mm10-2020-A-2.0.0 \
      --fastqs=bio_class_data/rna_fastp/$rna_file \
      --sample=$rna_file \
      --localcores=10 \
      --localmem=32 # \
      # --nosecondary
done

atac_files=(SRR20963902_fastp
SRR20963896_fastp
SRR20963897_fastp
SRR20963903_fastp)
for atac_file in "${atac_files[@]}"; do
    echo "Running for $atac_file"
    mkdir bio_class_data/atac_fastp/$atac_file
    mv bio_class_data/atac_fastp/"$atac_file"_S1_L001_R1_001.fastq.gz bio_class_data/atac_fastp/$atac_file
    mv bio_class_data/atac_fastp/"$atac_file"_S1_L001_R2_001.fastq.gz bio_class_data/atac_fastp/$atac_file
    ./cellranger-7.2.0/cellranger count --id=$atac_file \
      --transcriptome=refdata-cellranger-arc-mm10-2020-A-2.0.0 \
      --fastqs=bio_class_data/atac_fastp/$atac_file \
      --sample=$atac_file \
      --localcores=10 \
      --localmem=32 # \
      # --nosecondary
done
