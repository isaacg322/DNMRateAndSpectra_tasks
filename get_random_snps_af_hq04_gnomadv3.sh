#!/usr/bin/env bash

## Extract random SNPs (AF>0.8) mapping to regions in ${giab_hq_regions}
## from each of the gnomAD VCFs (divided by chromosome).

module load bcftools-1.19/python-3.11.6

chrom=${LSB_JOBINDEX}
if [ "${LSB_JOBINDEX}" -eq 23 ]
then
  chrom=X
fi

curr_vcf=${gnomadloc}/gnomad.genomes.v3.1.1.sites.chr${chrom}.vcf.bgz
out_file=chr_${chrom}_1K_random_snps_af_hq04_gnomadv3.tsv

bcftools view -i "AF>=0.8" ${curr_vcf} -m2 -M2 -v snps -R ${giab_hq_regions} | \
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AF\n' | \
shuf -n 1000 | sort -V -k1,1 -k2,2 > ${out_file}
