library(foreign)
library(tidyverse)

demo <- read.xport("./Original Data/DEMO_I.XPT.txt")
diet1 <- read.xport("./Original Data/DR1TOT_I.XPT.txt")
diet2 <- read.xport("./Original Data/DR2TOT_I.XPT.txt")
bp <- read.xport("./Original Data/BPX_I.XPT.txt")
ldl <- read.xport("./Original Data/TRIGLY_I.XPT.txt")

demo <- demo %>% select(SEQN, RIAGENDR, RIDAGEYR, RIDRETH3) %>% 
  rename(seqn = SEQN, gender = RIAGENDR, age = RIDAGEYR, race = RIDRETH3) %>% 
  mutate(gender = as.factor(gender)) %>% 
  mutate(race = as.factor(race))

# saveRDS(demo, "./Cleaning/demo.rds")

diet1 <- diet1 %>% select(SEQN, DR1TTFAT, DR1TCHOL) %>% 
  mutate(day = 1) %>% 
  rename(fat = DR1TTFAT, chol = DR1TCHOL, seqn = SEQN)

diet2 <- diet2 %>% select(SEQN, DR2TTFAT, DR2TCHOL) %>% 
  mutate(day = 2) %>% 
  rename(fat = DR2TTFAT, chol = DR2TCHOL, seqn = SEQN)

# saveRDS(diet1, "./Cleaning/diet1.rds")
# saveRDS(diet1, "./Cleaning/diet2.rds")

bp <- bp %>% select(SEQN, BPXSY1, BPXSY2, BPXSY3, BPXSY4, 
                    BPXDI1, BPXDI2, BPXDI3, BPXDI4) %>% 
  rename(sy1 = BPXSY1, sy2 = BPXSY2, sy3 = BPXSY3, sy4 = BPXSY4,
         di1 = BPXDI1, di2 = BPXDI2, di3 = BPXDI3, di4 = BPXDI4,
         seqn = SEQN) %>% 
  mutate(sy = rowMeans(select(., starts_with("sy")), na.rm = TRUE)) %>% 
  mutate(di = rowMeans(select(., starts_with("di")), na.rm = TRUE)) %>% 
  select(seqn, sy, di) %>% 
  mutate(sy = ifelse(sy == "NaN", NA, sy),
         di = ifelse(di == "NaN", NA, di))

# saveRDS(bp, "./Cleaning/bp.rds")

ldl <- ldl %>% select(SEQN, LBDLDL, LBXTR) %>% 
  rename(ldl = LBDLDL, trig = LBXTR, seqn = SEQN)

# saveRDS(ldl, "./Cleaning/ldl.rds")

## merge datasets
day1 <- inner_join(demo, bp, by = "seqn") %>% 
  inner_join(., ldl, by = "seqn") %>% 
  inner_join(., diet1, by = "seqn") 
  

day2 <- inner_join(demo, bp, by = "seqn") %>% 
  inner_join(., ldl, by = "seqn") %>% 
  inner_join(., diet2, by = "seqn")

final <- rbind(day1, day2) %>% 
  arrange(seqn) %>% 
  na.omit()

# saveRDS(final, "./Cleaning/final.rds")
