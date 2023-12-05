#!/bin/bash

# Reference list:
    # multiqc: https://www.jianshu.com/p/db2100baabb5

# Function to run fastqc and fastp
run_quality_control() {
    input_folder=$1
    output_folder=$2
    file_num=$3

    if [ -f ""$input_folder"/"$file_num"_1_fastqc.html" ]; then
        echo ""$input_folder"/"$file_num"_1_fastqc.html file exists. Skipping..."
    else
        echo "Starting fastqc for "$input_folder"/"$file_num""
        fastqc -o "$output_folder" -t 10 \
        "$input_folder"/"$file_num"_1.fastq.gz \
        "$input_folder"/"$file_num"_2.fastq.gz
    fi

    if [ -f ""$output_folder"/"$file_num"_fastp.html" ]; then
        echo ""$output_folder"/"$file_num"_fastp.html file exists. Skipping..."
    else
        echo "Starting fastp for "$input_folder"/"$file_num""
        fastp -i "$input_folder""$file_num"_1.fastq.gz \
        -I "$input_folder""$file_num"_2.fastq.gz \
        -o "$output_folder"/"$file_num"_fastp_S1_L001_R1_001.fastq.gz \
        -O "$output_folder"/"$file_num"_fastp_S1_L001_R2_001.fastq.gz \
        --thread 10 --html "$output_folder"/"$file_num"_fastp.html \
        --json "$output_folder"/"$file_num"_fastp.json
    fi

    if [ -f ""$input_folder"/"$file_num"_fastp_S1_L001_R1_001_fastqc.html" ]; then
        echo ""$input_folder"/"$file_num"_fastp_S1_L001_R1_001_fastqc.html file exists. Skipping..."
    else
        echo "Starting fastqc for "$input_folder"/"$file_num""
        fastqc -o "$output_folder" -t 10 \
        "$output_folder"/"$file_num"_fastp_S1_L001_R1_001.fastq.gz \
        "$output_folder"/"$file_num"_fastp_S1_L001_R2_001.fastq.gz
    fi

}

# Softwares install
# sudo apt update
# sudo apt install -y default-jre default-jdk fastqc fastp

rna_files=(SRR20963892
           SRR20963893
           SRR20963894
           SRR20963895)
atac_files=(SRR20963902
            SRR20963896
            SRR20963897
            SRR20963903)

for rna_file in "${rna_files[@]}"; do
    echo "Running for $rna_file"

    rna_folder="bio_class_data/rna/"
    rna_folder_fastp="bio_class_data/rna_fastp/"

    run_quality_control "$rna_folder" "$rna_folder_fastp" "$rna_file"
done

for atac_file in "${atac_files[@]}"; do
    echo "Running for $atac_file"

    atac_folder="bio_class_data/atac"
    atac_folder_fastp="bio_class_data/atac_fastp"

    run_quality_control "$atac_folder" "$atac_folder_fastp" "$atac_file"
done

cd bio_class_data/rna
multiqc .

cd bio_class_data/rna_fastp
multiqc .

cd bio_class_data/atac
multiqc .

cd bio_class_data/atac_fastp
multiqc .
