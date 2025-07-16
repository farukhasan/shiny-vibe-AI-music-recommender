library(shiny)
library(tidyverse)
library(plotly)
library(caret)
library(shinyWidgets)
library(shinycssloaders)
library(shinyjs)
library(proxy)
library(gbm)

# Load Spotify data
spotify_data <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-21/spotify_songs.csv"
)

set.seed(123)
spotify_data <- spotify_data %>%
  distinct(track_id, .keep_all = TRUE) %>%
  mutate(
    duration_min = round(duration_ms / 60000, 1),
    popularity = as.numeric(track_popularity),
    mood = case_when(
      valence > 0.7 & energy > 0.7 ~ "Energetic",
      valence > 0.7 & energy < 0.4 ~ "Calm",
      valence < 0.3 & energy < 0.4 ~ "Melancholic",
      valence > 0.6 & danceability > 0.7 ~ "Happy",
      TRUE ~ "Neutral"
    )
  ) %>%
  filter(mood != "Neutral")

train_data <- spotify_data %>%
  select(danceability, energy, valence, acousticness, instrumentalness, mood) %>%
  drop_na()

gbm_model <- train(mood ~ ., data = train_data, method = "gbm", trControl = trainControl(method = "cv", number = 5), verbose = FALSE)

mood_centroids <- spotify_data %>%
  group_by(mood) %>%
  summarise(across(c(danceability, energy, valence, acousticness), mean, na.rm = TRUE)) %>%
  column_to_rownames("mood")