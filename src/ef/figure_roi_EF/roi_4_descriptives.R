library('ProjectTemplate')
load.project()

pos %>% filter(hemisphere=="Left hemisphere") %>% group_by(session) %>% 
  summarise(mean(mean_pos),median(mean_pos))


