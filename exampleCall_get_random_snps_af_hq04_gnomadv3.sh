# Get SNPs global AF >= 0.8 gnomad v3

export gnomadloc=/lustre/scratch125/humgen/resources/gnomAD/release-3.1.1
export giab_hq_regions=/lustre/scratch125/casm/team294rr/ig4/resources/ConfidentRegions_GIAB_hg38_2016_1_small_vars.bed.gz

export working_dir=/lustre/scratch125/casm/team294rr/ig4/giab_snps


logs_dir=${working_dir}/logs

if [ -d ${logs_dir} ]
then
  echo "${logs_dir} exists..."
else
  mkdir ${logs_dir}
fi

job_name=giab_int_random

bsub -J "${job_name}[1-23]%23" \
-o ${logs_dir}/${job_name}_log.%J-%I \
-e ${logs_dir}/${job_name}_err.%J-%I \
-q long \
-R 'select[mem>=6000] rusage[mem=6000]' \
-M6000 -env "all" \
"cd ${working_dir}
bash get_random_snps_af_hq04_gnomadv3.sh"
