suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

options(scipen = 999)

sky = read_csv('skyscraperpage_db_2018-12-05_21_51_55.csv')

sky = sky %>%
  mutate_at(.vars = vars(buildings, highrises),
            .funs = funs({
              dplyr::if_else(. == 'no data', NA_character_, .) %>%
                readr::parse_number()
            })
  ) %>%
  mutate(
    build_per_cap = buildings / population,
    highr_per_cap = highrises / population,
    build_rate = build_per_cap * 100000,
    highr_rate = highr_per_cap * 100000
  )

sky_100k = sky %>%
  filter(population >= 100000) %>%
  mutate(build_rate_rank = min_rank(desc(build_rate)),
         highr_rate_rank = min_rank(desc(highr_rate))) %>%
  arrange(build_rate_rank)

write_csv(x = sky_100k,
          path = './cities_100k.csv')
