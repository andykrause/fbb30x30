#*****************************************************************************************
#
#   Create Data objeccts for 30x30Baseball
#
#*****************************************************************************************

  library(readr)
  library(tidyverse)
  library(FBB30x30)

### Data Sources -------------------------------------------------------------------------
  
  baseballref_df <- data.frame(data = c('Batting - Standard', 'Batting - Ratio',
                                        'Batting - Value', 'Batting - Pitches',
                                        'Batting - Win Probability', 'Batting - Advanced', 
                                        'Batting - Situational', 'Batting - Baserunning', 
                                        'Fielding - Appearances', 'Fielding - Standard',
                                        'Pitching - Standard', 'Pitching - Starter',
                                        'Pitching - Reliever', 'Pitching - Ratio',
                                        'Pitching - Value', 'Pitching - Pitches', 
                                        'Pitching - Win Probability'),
                               code = c('standard-batting', 'ratio-batting', 
                                        'value-batting', 'pitches-batting', 
                                        'win_probability-batting', 
                                        'advanced-batting', 'situational-batting',
                                        'baserunning-batting', 
                                        'appearances-fielding', 
                                        'standard-fielding', 'standard-pitching',
                                        'starter-pitching', 'reliever-pitching',
                                        'ratio-pitching', 'value-pitching',
                                        'pitches-pitching', 
                                        'win_probability-pitching'),
                               stringsAsFactors = FALSE) %>%
    tibble::as.tibble()
  usethis::use_data(baseballref_df, overwrite=TRUE)
  
### People and Teams ---------------------------------------------------------------------
  
  # Players  
  players_df <- readr::read_delim(file = file.path(getwd(), 'data', 'raw', 'players', 'people.csv'),
                                  delim = ',')
  
  players_df <- players_df %>%
    dplyr::filter(as.Date(as.character(finalGame)) >= as.Date('2014-01-01')) %>%
    dplyr::select(player_id = playerID, retro_id = retroID, bbref_id = bbrefID, 
                  first = nameFirst, last = nameLast, given = nameGiven, 
                  last_game = finalGame) %>%
    dplyr::mutate(full = paste(first, last),
                  last_game = as.Date(as.character(last_game)),
                  player_id = as.character(player_id), 
                  retro_id = as.character(retro_id), 
                  bbref_id = as.character(bbref_id), 
                  first = as.character(first), 
                  last = as.character(last), 
                  given = as.character(given))
  
  class(players_df) <- c('players', class(players_df))
  
  usethis::use_data(players_df, overwrite=TRUE)
  
  # Teams
  teams_df <- readr::read_delim(file.path(getwd(), 'data', 'raw', 'players', 'teams.csv'),
                                delim = ',')
  
  teams_df <- teams_df %>%
    dplyr::filter(yearID == 2017) %>%
    dplyr::select(team_id = teamID, br_id = teamIDBR, lahman_id = teamIDlahman45,
                  retro_id = teamIDretro) %>%
    dplyr::mutate(espn_id = c('ARI', 'ATL', 'BAL', 'BOS', 'CWS', 'CHC', 'CIN', 'CLE',
                              'COL', 'DET', 'HOU', 'KC', 'LAA', 'LAD', 'MIA', 'MIL',
                              'MIN', 'NYY', 'NYM', 'OAK', 'PHI', 'PIT', 'SD', 'SEA',
                              'SF', 'STL', 'TB', 'TEX', 'TOR', 'WAS'),
                  retrosheet_id = c('ARI N', 'ATL N', 'BAL A', 'BOS A', 'CHI A', 'CHI N',
                                    'CIN N', 'CLE A', 'COL N', 'DET A', 'HOU A', 'KC  A', 
                                    'ANA A', 'LA  N', 'MIA N', 'MIL N', 'MIN A', 'NY  A',
                                    'NY  N', 'OAK A', 'PHI N', 'PIT N', 'SD  N', 'SEA A',
                                    'SF  N', 'STL N', 'TB  A', 'TEX A', 'TOR A', 'WAS N'))
  
  class(teams_df) <- c('teams', class(teams_df))

  usethis::use_data(teams_df, overwrite=TRUE)
  
### Statistics ---------------------------------------------------------------------------
  
  # Read in Fielding data
  fielding_df <- purrr::map(.x = 2013:2019,
                            .f = getBRStats,
                            type ='fielding') %>%
    dplyr::bind_rows()
  
   usethis::use_data(fielding_df, overwrite=TRUE)
   
  # Load Data
   batting_df <- purrr::map(.x = 2013:2019,
                            .f = getBRStats,
                            type ='batting') %>%
     dplyr::bind_rows()
   
   usethis::use_data(batting_df, overwrite=TRUE)
   
 ## Pitching stats
   
   pitching_df <- purrr::map(.x = 2013:2019,
                             .f = getBRStats,
                             type ='pitching') %>%
     dplyr::bind_rows()
   
   usethis::use_data(pitching_df, overwrite=TRUE)
   
### Projections --------------------------------------------------------------------------

   ## Marcel
   
   marcel2019_proj <- scrapeMarcelProjections(year = 2019)
   
   usethis::use_data(marcel2019_proj, overwrite = TRUE)
   
   ## Load Projection Data

    # Hitters
    hp_2014 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_hitters_2014.csv'))
    hp_2015 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_hitters_2015.csv'))
    hp_2016 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_hitters_2016.csv'))
    hp_2017 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_hitters_2017.csv'))
    hp_2018 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_hitters_2018.csv')) %>%
      dplyr::filter(Team != '158')
    hp_2019 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_hitters_2019.csv'))
    hp_2020 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_hitters_2020.csv'))
    
    

    # Hitters
    pp_2014 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_pitchers_2014.csv'))
    pp_2015 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_pitchers_2015.csv'))
    pp_2016 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_pitchers_2016.csv'))
    pp_2017 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_pitchers_2017.csv'))
    pp_2018 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_pitchers_2018.csv'))
    pp_2019 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_pitchers_2019.csv'))
    pp_2020 <- read.csv(file.path(getwd(), 'data', 'raw', 'projections',
                                  'fp_pitchers_2020.csv'))

   ## Standardize Projection Data

    # 2014
    names(hp_2014) <- tolower(names(hp_2014))
    hp_2014 <- hp_2014 %>% 
      dplyr::rename(pos = position,
                    avg = ave,
                    h = hits,
                    hr = hrs,
                    player = name,
                    r = runs) %>%
      dplyr::mutate(pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    year = 2014,
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest(cols = c(pos_list)) %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list = c(pos_list)) %>%
      dplyr::select(-c(cs, type)) %>%
      addPlayerID(., players_df = players_df) 
      
      gidp_df <- projectGIDP(batting_df, hp_2014, proj_year = 2014)
      e_df <- projectErrors(fielding_df, hp_2014, proj_year = 2014)
      
      hp_2014 <- hp_2014 %>%
        dplyr::left_join(gidp_df, by = 'player_id') %>%
        dplyr::left_join(e_df, by = 'player_id')
      

    # 2015
    names(hp_2015) <- tolower(names(hp_2015))
    hp_2015 <- hp_2015 %>%
      dplyr::mutate(player = paste0(substr(name, str_locate(name, ',')+2, 100),
                                    " ", substr(name, 1, str_locate(name, ',') - 1)),
                    pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    year = 2015,
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::rename(so = k, 
                    ops = obps) %>%
      dplyr::select(-c(cs, g, al.nl.., mixed.., name))%>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    gidp_df <- projectGIDP(batting_df, hp_2015, proj_year = 2015)
    e_df <- projectErrors(fielding_df, hp_2015, proj_year = 2015)
    
    hp_2015 <- hp_2015 %>%
      dplyr::left_join(gidp_df, by = 'player_id') %>%
      dplyr::left_join(e_df, by = 'player_id')
    
    # 2016
    names(hp_2016) <- tolower(names(hp_2016))
    hp_2016 <- hp_2016 %>%
      dplyr::rename(avg = ave,
                    h = hits,
                    hr = hrs,
                    player = name,
                    r = runs) %>%
      dplyr::mutate(pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    year = 2016,
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    gidp_df <- projectGIDP(batting_df, hp_2016, proj_year = 2016)
    e_df <- projectErrors(fielding_df, hp_2016, proj_year = 2016)
    
    hp_2016 <- hp_2016 %>%
      dplyr::left_join(gidp_df, by = 'player_id') %>%
      dplyr::left_join(e_df, by = 'player_id')
    
    
    # 2017
    names(hp_2017) <- tolower(names(hp_2017))
    hp_2017 <- hp_2017 %>%
      fixFPName(.) %>%
      dplyr::mutate(year = 2017,
                    pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    gidp_df <- projectGIDP(batting_df, hp_2017, proj_year = 2017)
    e_df <- projectErrors(fielding_df, hp_2017, proj_year = 2017)
    
    hp_2017 <- hp_2017 %>%
      dplyr::left_join(gidp_df, by = 'player_id') %>%
      dplyr::left_join(e_df, by = 'player_id')
    
    # 2018
    names(hp_2018) <- tolower(names(hp_2018))
    hp_2018 <- hp_2018 %>%
      dplyr::rename(pos = positions) %>%
      dplyr::mutate(year = 2018,
                    pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    player = as.character(player),
                    team = as.character(team))%>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    gidp_df <- projectGIDP(batting_df, hp_2018, proj_year = 2018)
    e_df <- projectErrors(fielding_df, hp_2018, proj_year = 2018)
    
    hp_2018 <- hp_2018 %>%
      dplyr::left_join(gidp_df, by = 'player_id') %>%
      dplyr::left_join(e_df, by = 'player_id')
    
    
    # 2019
    names(hp_2019) <- tolower(names(hp_2019))
    hp_2019 <- hp_2019 %>%
      dplyr::rename(pos = positions) %>%
      dplyr::mutate(year = 2019,
                    pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    gidp_df <- projectGIDP(batting_df, hp_2019, proj_year = 2019)
    e_df <- projectErrors(fielding_df, hp_2019, proj_year = 2019)
    
    hp_2019 <- hp_2019 %>%
      dplyr::left_join(gidp_df, by = 'player_id') %>%
      dplyr::left_join(e_df, by = 'player_id')
    
    # 2020
    names(hp_2020) <- tolower(names(hp_2020))
    hp_2020 <- hp_2020 %>%
      dplyr::rename(pos = positions) %>%
      dplyr::mutate(year = 2020,
                    pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    gidp_df <- projectGIDP(batting_df, hp_2020, proj_year = 2020)
    e_df <- projectErrors(fielding_df, hp_2020, proj_year = 2020)
    
    hp_2020 <- hp_2020 %>%
      dplyr::left_join(gidp_df, by = 'player_id') %>%
      dplyr::left_join(e_df, by = 'player_id')
    
    
    # Combine
    batprojs_df <- rbind(hp_2014, hp_2015, hp_2016, hp_2017, hp_2018, hp_2019, hp_2020) %>%
      tibble::as.tibble()%>%
      dplyr::select(player_id, player, team, year, pos, pos_list, 
                    tidyselect::everything())%>%
      structure(., class = c('projections', 'batting', 'tbl_df', 'tbl', 'data.frame'))
    

   ## Pitchers

    # 2014
    names(pp_2014) <- tolower(names(pp_2014))
    pp_2014 <- pp_2014 %>% 
      dplyr::rename(pos = position,
                    player = name,
                    bb = bbi) %>%
      dplyr::mutate(pos =  gsub(',', '/', pos),
                    pos =  gsub('/', ' | ', pos),
                    year = 2014,
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::select(-c(hd, hr, type, bs))%>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    qs_df <- projectQS(pitching_df, pp_2014, proj_year = 2014)
    holds_df <- projectHolds(pitching_df, pp_2014, proj_year = 2014)
    
    pp_2014 <- pp_2014 %>%
      dplyr::left_join(qs_df, by = 'player_id') %>%
      dplyr::left_join(holds_df, by = 'player_id')
    
    # 2015
    names(pp_2015) <- tolower(names(pp_2015))
    pp_2015 <- pp_2015 %>%
      dplyr::mutate(gsp = gs/g,
                    player = paste0(substr(name, str_locate(name, ',')+2, 100),
                                   " ", substr(name, 1, str_locate(name, ',') - 1)),
                    pos = 'SP, RP',
                    pos = ifelse(gsp == 0, 'RP', pos),
                    pos = ifelse(gsp >= .85, 'SP', pos),
                    pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    year = 2015,
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::select(-c(al.nl.., mixed.., sho, name, gsp))%>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    qs_df <- projectQS(pitching_df, pp_2015, proj_year = 2015)
    holds_df <- projectHolds(pitching_df, pp_2015, proj_year = 2015)
    
    pp_2015 <- pp_2015 %>%
      dplyr::left_join(qs_df, by = 'player_id') %>%
      dplyr::left_join(holds_df, by = 'player_id')
    
    # 2016
    names(pp_2016) <- tolower(names(pp_2016))
    pp_2016 <- pp_2016 %>%
      dplyr::rename(player = name,
                    bb = bbi) %>%
      dplyr::mutate(pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    year = 2016,
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::select(-c(hr))%>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    qs_df <- projectQS(pitching_df, pp_2016, proj_year = 2016)
    holds_df <- projectHolds(pitching_df, pp_2016, proj_year = 2016)
    
    pp_2016 <- pp_2016 %>%
      dplyr::left_join(qs_df, by = 'player_id') %>%
      dplyr::left_join(holds_df, by = 'player_id')
    
    # 2017
    names(pp_2017) <- tolower(names(pp_2017))
    pp_2017 <- pp_2017 %>%
      fixFPName() %>%
      dplyr::mutate(year = 2017,
                    pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::select(-c(hr))%>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    qs_df <- projectQS(pitching_df, pp_2017, proj_year = 2017)
    holds_df <- projectHolds(pitching_df, pp_2017, proj_year = 2017)
    
    pp_2017 <- pp_2017 %>%
      dplyr::left_join(qs_df, by = 'player_id') %>%
      dplyr::left_join(holds_df, by = 'player_id')
    
    # 2018
    names(pp_2018) <- tolower(names(pp_2018))
    pp_2018 <- pp_2018 %>%
      dplyr::rename(pos = positions) %>%
      dplyr::mutate(pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    year = 2018,
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::select(-c(hr))%>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    qs_df <- projectQS(pitching_df, pp_2018, proj_year = 2018)
    holds_df <- projectHolds(pitching_df, pp_2018, proj_year = 2018)
    
    pp_2018 <- pp_2018 %>%
      dplyr::left_join(qs_df, by = 'player_id') %>%
      dplyr::left_join(holds_df, by = 'player_id')
    
    # 2019
    names(pp_2019) <- tolower(names(pp_2019))
    pp_2019 <- pp_2019 %>%
      dplyr::rename(pos = positions) %>%
      dplyr::mutate(pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    year = 2019,
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::select(-c(hr))%>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    qs_df <- projectQS(pitching_df, pp_2019, proj_year = 2019)
    holds_df <- projectHolds(pitching_df, pp_2019, proj_year = 2019)
    
    pp_2019 <- pp_2019 %>%
      dplyr::left_join(qs_df, by = 'player_id') %>%
      dplyr::left_join(holds_df, by = 'player_id')
    
    # 2020
    names(pp_2020) <- tolower(names(pp_2020))
    pp_2020 <- pp_2020 %>%
      dplyr::rename(pos = positions) %>%
      dplyr::mutate(pos = gsub(',', '/', pos),
                    pos = gsub('/', ' | ', pos),
                    year = 2020,
                    player = as.character(player),
                    team = as.character(team)) %>%
      dplyr::select(-c(hr))%>%
      dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
      tidyr::unnest() %>%
      dplyr::filter(pos_list != '|') %>%
      tidyr::nest(pos_list, .key = 'pos_list') %>%
      addPlayerID(., players_df = players_df) 
    
    qs_df <- projectQS(pitching_df, pp_2020, proj_year = 2020)
    holds_df <- projectHolds(pitching_df, pp_2020, proj_year = 2020)
    
    pp_2020 <- pp_2020 %>%
      dplyr::left_join(qs_df, by = 'player_id') %>%
      dplyr::left_join(holds_df, by = 'player_id')
    
    # Combine Al
    pitchprojs_df <- rbind(pp_2014, pp_2015, pp_2016, pp_2017, pp_2018, pp_2019, pp_2020) %>%
      tibble::as.tibble() %>%
      dplyr::select(player_id, player, team, year, pos, pos_list, 
                    tidyselect::everything()) %>%
      structure(., class = c('projections', 'pitching', 'tbl_df', 'tbl', 'data.frame'))

  ## Save
    
  usethis::use_data(batprojs_df, overwrite=TRUE)
  usethis::use_data(pitchprojs_df, overwrite=TRUE) 
    
### Rankings -----------------------------------------------------------------------------    
    
  ## Read in Data  
  rank_2016 <- read.csv(file.path(getwd(), 'data', 'raw', 'rankings', 
                                  'fp_draftrankings_2016.csv'))
  rank_2017 <- read.csv(file.path(getwd(), 'data', 'raw', 'rankings', 
                                  'fp_draftrankings_2017.csv'))
  rank_2018 <- read.csv(file.path(getwd(), 'data', 'raw', 'rankings', 
                                  'fp_draftrankings_2018.csv'))
  rank_2019 <- read.csv(file.path(getwd(), 'data', 'raw', 'rankings', 
                                  'fp_draftrankings_2019.csv'))
  
  rank_2020 <- read.csv(file.path(getwd(), 'data', 'raw', 'rankings', 
                                  'fp_draftrankings_2020.csv'))
  
  # 2016
  names(rank_2016) <- tolower(names(rank_2016))
  rank_2016 <- rank_2016 %>% 
    dplyr::rename(avg = ave,
                  st_dev = stdev,
                  ranking = ecr,
                  player = name) %>%
    dplyr::mutate(pos = gsub(',', '/', pos),
                  pos = gsub('/', ' | ', pos),
                  year = 2016,
                  x = NULL,
                  adp = as.numeric(as.character(adp)),
                  player = as.character(player),
                  team = as.character(team)) %>%
    tibble::as.tibble()
  rank_2016$adp[is.na(rank_2016$adp)] <- ceiling(rank_2016$avg[is.na(rank_2016$adp)])
  
  # 2017
  names(rank_2017) <- tolower(names(rank_2017))
  x1 <- str_locate(rank_2017$name, '[(]')[,1]
  name <- substr(rank_2017$name, 1, x1-2)
  team <- substr(rank_2017$name, x1+1, x1+3)
  team <- gsub(',', '', team)
  team <- gsub(')', '', team)
  pos <- substr(rank_2017$name, x1+5, 100)
  x2 <- str_locate(pos, '[)]')[,1]
  pos <- substr(pos, 1, x2-1)
  pos <- gsub(',', ' | ', pos)
  rank_2017$year <- 2017
  rank_2017$name <- NULL
  rank_2017$player <- name
  rank_2017$team <- team
  rank_2017$pos <- substr(pos, 2, 100)
  rank_2017 <- rank_2017 %>% 
    dplyr::rename(st_dev = stdev,
                  avg = average) %>%
    tibble::as.tibble() %>%
    dplyr::select(player, team, pos, tidyselect::everything())
  rank_2017$adp[is.na(rank_2017$adp)] <- ceiling(rank_2017$avg[is.na(rank_2017$adp)])
  
  # 2018
  names(rank_2018) <- tolower(names(rank_2018))
  rank_2018 <- rank_2018 %>% 
    dplyr::rename(pos = positions,
                  ranking = rank,
                  st_dev = std.dev) %>%
    dplyr::mutate(pos = gsub(',', '/', pos),
                  pos = gsub('/', ' | ', pos),
                  year = 2018,
                  vs..adp = NULL,
                  team = as.character(team),
                  player = as.character(player)) %>%
    tibble::as.tibble()
  rank_2018$adp[is.na(rank_2018$adp)] <- ceiling(rank_2018$avg[is.na(rank_2018$adp)])
  
  # 2019
  names(rank_2019) <- tolower(names(rank_2019))
  rank_2019 <- rank_2019 %>% 
    dplyr::rename(pos = positions,
                  ranking = rank,
                  st_dev = std.dev) %>%
    dplyr::mutate(pos = gsub(',', '/', pos),
                  pos = gsub('/', ' | ', pos),
                  year = 2019,
                  team = as.character(team),
                  player = as.character(player),
                  adp = as.numeric(adp),
                  avg = as.numeric(avg)) %>%
    tibble::as.tibble() %>%
    dplyr::select(-c(vs..adp))
  
  # ## TEMP
  # rank_2019$adp <- 0
  rank_2019$adp[is.na(rank_2019$adp)] <- ceiling(rank_2019$avg[is.na(rank_2019$adp)])

  # 2020
  names(rank_2020) <- tolower(names(rank_2020))
  rank_2020 <- rank_2020 %>% 
    dplyr::rename(pos = positions,
                  ranking = rank,
                  st_dev = std.dev) %>%
    dplyr::mutate(pos = gsub(',', '/', pos),
                  pos = gsub('/', ' | ', pos),
                  year = 2020,
                  team = as.character(team),
                  player = as.character(player),
                  adp = as.numeric(adp),
                  avg = as.numeric(avg)) %>%
    tibble::as.tibble() %>%
    dplyr::select(-c(vs..adp))
  
  # ## TEMP
  # rank_2020$adp <- 0
  rank_2020$adp[is.na(rank_2020$adp)] <- ceiling(rank_2020$avg[is.na(rank_2020$adp)])
  
  # Combine All
  rankings_df <- rbind(rank_2016, rank_2017, rank_2018, rank_2019, ran_2020) %>%
    tibble::as.tibble() %>%
    dplyr::mutate(pos_list = strsplit(pos, ' | ')) %>%
    tidyr::unnest() %>%
    dplyr::filter(pos_list != '|') %>%
    tidyr::nest(pos_list, .key = 'pos_list') %>%
    dplyr::select(player, team, pos, year, ranking, tidyselect::everything())
    
  rankings_df <- rankings_df %>%
    addPlayerID(., players_df) %>%
    dplyr::select(player_id, player, year, team, pos, pos_list, ranking,
                  tidyselect::everything())
  
  rankings_df <- structure(rankings_df,
                           class = c('draftRankings', 'tbl_df', 'tbl', 'data.frame'),
                           source = 'fantasy_pros',
                           team_value = NULL,
                           pos_value = NULL,
                           roster_value = NULL)
  
  usethis::use_data(rankings_df, overwrite=TRUE) 
  
### Seasons ------------------------------------------------------------------------------
  
  ## Read in Data  
  season2019_df <- readr::read_delim(file.path(getwd(), 'data', 'raw', 'seasons', 'season2019.csv'),
                                     delim = ';')
  season2018_df <- read.csv(file.path(getwd(), 'data', 'raw', 'seasons', 'season2018.csv'))
  season2017_df <- read.csv(file.path(getwd(), 'data', 'raw', 'seasons', 'season2017.csv'))
  season2016_df <- read.csv(file.path(getwd(), 'data', 'raw', 'seasons', 'season2016.csv'))
  season2015_df <- read.csv(file.path(getwd(), 'data', 'raw', 'seasons', 'season2015.csv'))
  
  # 2015
  season2015_df <- season2015_df %>%
    dplyr::mutate(Team = c(2, 3, 1, 5, 6, 4)) %>%
    dplyr::select(team = Team, rank = Rank, r = R, hr = HR, rbi = RBI, so = K, hbp = HBP,
                  sbn = SBN, obp = OBP, slg = SLG, e = E, qs = QS, k = K.1, oba = OBA,
                  whip = WHIP, ptw = PTW, svhd = SVHD, moves = Moves)
  
  # 2016
  season2016_df <- season2016_df %>%
    dplyr::mutate(Team = c(7, 1, 2, 4, 5, 8)) %>%
    dplyr::select(team = Team, rank = Rank, r = R, hr = HR, rbi = RBI, so = K, sbn = SBN, 
                  obp = OBP, slg = SLG, gidp = GIDP, ppa = PPA, fpct = FPCT, ip = IP, 
                  qs = QS, k = K.1, hb = HB, sv = SV, hd = HD, whip = WHIP, moves = Moves)
  
  # 2017
  season2017_df <- season2017_df %>%
    dplyr::mutate(Team = c(2, 9, 8, 3, 11, 1, 10)) %>%
    dplyr::select(team = Team, rank = Rank, r = R, hr = HR, rbi = RBI, so = K, sbn = SBN, 
                  obp = OBP, slg = SLG, gidp = GIDP, e = E, ip = IP, qs = QS, k = K.1, 
                  sv = SV, hd = HD, whip = WHIP, moves = Moves, starts = Starts)
  
  # 2018
  season2018_df <- season2018_df %>%
    dplyr::mutate(Team = c(8, 1, 12, 3, 4, 10, 2, 9)) %>%
    dplyr::select(team = Team, rank = Rank, r = R, hr = HR, rbi = RBI, so = K, sb = SB, 
                  obp = OBP, slg = SLG, gidp = GIDP, e = E, ip = IP, qs = QS, k = K.1, 
                  sv = SV, hd = HD, whip = WHIP, moves = Moves, starts = Starts)
  
  season2019_df <- season2019_df %>%
    dplyr::select(team = Team, rank = Rank, r = R, hr = HR, rbi = RBI, so = K, sb = SB, 
                  obp = OBP, slg = SLG, gidp = GIDP, e = E, ip = IP, qs = QS, k = K_1, 
                  sv = SV, hd = HD, whip = WHIP, moves = Moves, starts = Starts)
  
  
  seasons_ <- list(`2015` = structure(season2015_df, 
                                      class = c('season', class(season2015_df))),
                   `2016` = structure(season2016_df, 
                                      class = c('season', class(season2015_df))),
                   `2017` = structure(season2017_df, 
                                      class = c('season', class(season2015_df))),
                   `2018` = structure(season2018_df, 
                                      class = c('season', class(season2015_df))),
                   `2019` = structure(season2019_df,
                                      class = c('season', class(season2015_df))))
  
  usethis::use_data(seasons_, overwrite=TRUE) 
  