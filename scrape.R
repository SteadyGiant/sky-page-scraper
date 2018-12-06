suppressPackageStartupMessages({
  library(dplyr)
  library(rvest)
})

source('remove_empty.R')

# 6,866 total results.
# 50 results per page.
# First page's index is 0.
# Therefore, 138 total pages and last page's index is 137.
results_tables = vector(mode = 'list', length = 138)

n = 0

for (i in 1:length(results_tables)) {

  next_url = paste0('http://skyscraperpage.com/cities/?s=0&c=2&p=',
                    as.character(n),
                    '&r=50&10=0')

  message('Navigating to ', next_url)

  current_page = rvest::html_session(next_url)

  results_tables[[i]] = current_page %>%
    rvest::html_nodes(css = '#dataTable') %>%
    rvest::html_table(fill = T) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate_all(.funs = funs(ifelse(. == '', NA, .))) %>%
    remove_empty(which = 'rows') %>%
    remove_empty(which = 'cols') %>%
    `names<-`(c('row', 'city', 'country', 'buildings', 'highrises',
                'population')) %>%
    dplyr::mutate(url = next_url,
                  page_num = n + 1,
                  timestamp = Sys.time())

  n = n + 1

  Sys.sleep(1)

}

results = dplyr::bind_rows(results_tables)

timestamp = gsub(x = Sys.time(), pattern = '\\s|\\:', replacement = '\\_')

write.csv(x = results,
          file = paste0('./skyscraperpage_db_', timestamp, '.csv'),
          na = '', row.names = F)
