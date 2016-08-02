#!/usr/bin/env bash
# type: sbatch -J name script.sh "subs"
# subs should either be a vector ([1:4 5:6]) or 'all'
# Keep lines starting with #SBATCH together and at top of script! Modify settings as appropriate.

#SBATCH -J dartel				# Job name
#SBATCH --workdir=./			# Set working directory
#SBATCH -t 01:00:00				# Set runtime in hh:mm:ss, d-hh, d-hh:mm, mm:ss, or m
#SBATCH --mem 5120				# Set amount of memory in MB (1GB = 1024 MB)

# write out parameters file for DARTEL
bash ../../notes/write_pfile_DARTEL.sh

# get subjects to run from first argument
subs="$1"

echo "Beginning DARTEL analysis of subject(s) $subs at $(date)"

# run matlab from the command line as part of a submit job
module load matlab/R2015b
# run script
matlab -nosplash -nodisplay -nodesktop -r "try; DARTEL_spm8_vars($subs); catch me; fprintf('%s / %s\n',me.identifier,me.message); end; exit"

# move files to DARTEL_prep
for d in $(ls -d $PREP_DIR/$last_prep*/ | xargs -n 1 basename); do
	s=$PREP_DIR/DARTEL_prep/$d/
	mkdir $s
	mv mean* $s
	mv r* $s
	mv u* $s
	mv w* $s
	mv y* $s
	mv Template* $s
done

echo "Finished DARTEL analysis of subject(s) $subs at $(date)"