library(vroom)
library(tidyverse)


h2_ests_long = vroom("estimate_h2_ldms_dnm_counts.txt", 
                     delim="\t") %>%
  mutate(maf_bin=ifelse(maf_bin %in% c("0.001-0.01", "0.01-0.05", "0.05-1"), y=maf_bin,n="none"),
         ld_bin=ifelse(ld_bin %in% c("low", "high"), y=ld_bin,n="none"), 
         parent_subset=case_when(individual_subset == "mother" ~ "mothers only", 
                                 individual_subset == "father" ~ "fathers only", 
                                 individual_subset == "sex_concat" ~ "both parents")) %>%
  mutate(parent_subset= factor(parent_subset, 
                                   levels = c("mothers only", "fathers only", "both parents") ), 
         maf_bin=factor(maf_bin, levels=c("0.001-0.01", "0.01-0.05", "0.05-1", "total")), 
         ld_bin=factor(ld_bin, levels= c("low", "high", "total")))


maf_bins_labs = data.frame(maf_bin = unique(h2_ests_long[["maf_bin"]]), 
                           maf_bin_lab = c( ">=0.001<0.01", ">=0.01<0.05" , ">=0.05", "total")) 

h2_ests_long = h2_ests_long %>%
  left_join(., maf_bins_labs) %>%
  mutate(maf_bin_lab=factor(maf_bin_lab, levels=c( ">=0.001<0.01", ">=0.01<0.05" , ">=0.05", "total")))

maf_colors=c("0.001-0.01"="#87CEFF", "0.01-0.05" = "#1F90FF", "0.05-1"= "#191870")
ld_colors=c("low"="#87CEFF", "high"= "#1F90FF", "none"="azure3")

h2_ests_long %>%
  ggplot(., aes(x=maf_bin_lab, y=h2, group=ld_bin)) +
  geom_errorbar(aes(ymin=h2 - 1.96 * se, 
                    ymax=h2 + 1.96 * se, color=ld_bin), 
                position = position_dodge(0.9), linewidth=2, width=0) +
  scale_color_manual(values=ld_colors) +
  geom_point(size=1.5, position = position_dodge(0.9), color="black") +
  facet_wrap(~parent_subset) + 
  theme_minimal(base_size = 20) + 
  theme(panel.grid.minor.x = element_blank(), 
        axis.title = element_text(face="bold"), 
        axis.text = element_text(face="bold",  size = 18), 
        axis.text.x= element_text(angle=30, hjust=1, vjust=1), 
        strip.text.x = element_text(face="bold")) + 
  labs(color="LD cutoff", y=expression(bold(paste(h^2, " estimate"))), x="MAF")
