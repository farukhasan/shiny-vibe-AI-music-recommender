server <- function(input, output, session) {
  # Initialize mood state with proper reactiveValues
  values <- reactiveValues(
    current_mood = "Happy",
    trigger_recommend = 0,
    mood_buttons_state = list(
      mood_energetic = FALSE,
      mood_calm = FALSE,
      mood_happy = TRUE,  # Default selected
      mood_melancholic = FALSE
    )
  )
  
  # Function to update mood button states
  updateMoodButtons <- function(selected_mood) {
    # Reset all buttons
    values$mood_buttons_state <- list(
      mood_energetic = FALSE,
      mood_calm = FALSE,
      mood_happy = FALSE,
      mood_melancholic = FALSE
    )
    
    # Set the selected button
    mood_mapping <- list(
      "Energetic" = "mood_energetic",
      "Calm" = "mood_calm",
      "Happy" = "mood_happy",
      "Melancholic" = "mood_melancholic"
    )
    
    if (selected_mood %in% names(mood_mapping)) {
      values$mood_buttons_state[[mood_mapping[[selected_mood]]]] <- TRUE
    }
    
    # Send custom message to update UI
    session$sendCustomMessage("updateMoodButtons", list(
      mood = selected_mood,
      states = values$mood_buttons_state
    ))
  }
  
  # Handle mood selection from JavaScript
  # Handle mood selection from JavaScript
  observeEvent(input$current_mood_selection, {
    cat("JavaScript mood selection received:", input$current_mood_selection, "\n")
    
    mood_map <- list(
      "energetic" = "Energetic",
      "calm" = "Calm", 
      "happy" = "Happy",
      "melancholic" = "Melancholic"
    )
    
    if (input$current_mood_selection %in% names(mood_map)) {
      old_mood <- values$current_mood
      values$current_mood <- mood_map[[input$current_mood_selection]]
      cat("Mood changed from:", old_mood, "to:", values$current_mood, "\n")
    } else {
      cat("Invalid mood selection:", input$current_mood_selection, "\n")
    }
  }, ignoreInit = TRUE)
  
  observeEvent(input$mood_energetic, {
    isolate({
      values$current_mood <- "Energetic"
      cat("Mood changed to: Energetic\n")
      updateMoodButtons("Energetic")
    })
  }, ignoreInit = TRUE)
  
  observeEvent(input$mood_calm, {
    isolate({
      values$current_mood <- "Calm"
      cat("Mood changed to: Calm\n")
      updateMoodButtons("Calm")
    })
  }, ignoreInit = TRUE)
  
  observeEvent(input$mood_happy, {
    isolate({
      values$current_mood <- "Happy"
      cat("Mood changed to: Happy\n")
      updateMoodButtons("Happy")
    })
  }, ignoreInit = TRUE)
  
  observeEvent(input$mood_melancholic, {
    isolate({
      values$current_mood <- "Melancholic"
      cat("Mood changed to: Melancholic\n")
      updateMoodButtons("Melancholic")
    })
  }, ignoreInit = TRUE)
  
  # Handle mood selection from JavaScript
  # Handle mood selection from JavaScript
  observeEvent(input$current_mood_selection, {
    cat("JavaScript mood selection received:", input$current_mood_selection, "\n")
    
    mood_map <- list(
      "energetic" = "Energetic",
      "calm" = "Calm", 
      "happy" = "Happy",
      "melancholic" = "Melancholic"
    )
    
    # Extract just the mood name (first word)
    clean_mood <- tolower(trimws(strsplit(input$current_mood_selection, " ")[[1]][1]))
    
    if (clean_mood %in% names(mood_map)) {
      old_mood <- values$current_mood
      values$current_mood <- mood_map[[clean_mood]]
      cat("Mood changed from:", old_mood, "to:", values$current_mood, "\n")
    } else {
      cat("Invalid mood selection:", clean_mood, "Available moods:", names(mood_map), "\n")
    }
  }, ignoreInit = TRUE)
  
  # Trigger recommendations when button is clicked
  observeEvent(input$recommend, {
    values$trigger_recommend <- values$trigger_recommend + 1
    cat("Recommend button clicked. Trigger count:", values$trigger_recommend, "\n")
    cat("Current mood at recommendation time:", values$current_mood, "\n")
    
    # Maintain the active mood button state after recommendation
    updateMoodButtons(values$current_mood)
  })
  
  # Recommendations function that uses the current mood
  recommendations <- reactive({
    # Make sure this triggers when recommend button is clicked
    req(values$trigger_recommend > 0)
    
    # Get the current mood at the time of recommendation
    selected_mood <- values$current_mood
    
    cat("Generating recommendations for mood:", selected_mood, "\n")
    
    # Start with all data
    filtered <- spotify_data
    
    # Apply genre filter
    if (!"All Genres" %in% input$genre) {
      filtered <- filtered %>% filter(playlist_genre %in% input$genre)
    }
    
    # Apply other filters and mood filter
    filtered <- filtered %>%
      filter(
        energy >= input$energy[1],
        energy <= input$energy[2],
        popularity >= input$popularity[1],
        popularity <= input$popularity[2],
        mood == selected_mood  # Use the captured mood
      ) %>%
      distinct(track_name, track_artist, .keep_all = TRUE)
    
    cat("Found", nrow(filtered), "tracks for mood:", selected_mood, "\n")
    
    # If no tracks found, return empty data frame
    if (nrow(filtered) == 0) {
      return(data.frame())
    }
    
    # Get centroid for the selected mood
    centroid <- mood_centroids[selected_mood, , drop = FALSE]
    
    # Calculate similarity scores
    sim_scores <- proxy::simil(
      filtered %>% select(danceability, energy, valence, acousticness),
      centroid,
      method = "cosine"
    )
    
    filtered$similarity <- as.numeric(sim_scores)
    
    # Return top recommendations
    result <- filtered %>%
      arrange(desc(similarity)) %>%
      slice_head(n = 8) %>%
      select(track_name, track_artist, playlist_genre, popularity, duration_min, 
             danceability, energy, valence, acousticness, mood)
    
    cat("Returning", nrow(result), "recommendations\n")
    return(result)
  })
  
  output$recommendations_ui <- renderUI({
    recs <- recommendations()
    
    runjs("document.getElementById('recommendations_placeholder').style.display = 'none';")
    
    if (nrow(recs) == 0) {
      return(
        div(class = "creative-empty",
            div(class = "content",
                span(class = "emoji", "🔍"),
                div(class = "title", "No Tracks Found"),
                div(class = "subtitle", paste("Try adjusting your filters or selecting a different mood to discover new music! Current mood:", values$current_mood))
            )
        )
      )
    }
    
    fluidRow(
      lapply(1:nrow(recs), function(i) {
        track <- recs[i, ]
        search_query <- URLencode(paste(track$track_name, track$track_artist))
        youtube_url <- paste0("https://www.youtube.com/results?search_query=", search_query)
        spotify_url <- paste0("https://open.spotify.com/search/", search_query)
        
        column(6,
               div(class = "song-card",
                   tags$div(class = "song-title", track$track_name),
                   tags$div(class = "song-artist", track$track_artist),
                   tags$div(class = "song-info",
                            tags$span(paste0("🎵 ", track$playlist_genre)),
                            tags$span(paste0("⭐ ", track$popularity)),
                            tags$span(paste0("⏱ ", track$duration_min, " min"))
                   ),
                   tags$div(class = "song-features",
                            tags$span(class = "feature-badge", paste0("💃 ", round(track$danceability * 100), "%")),
                            tags$span(class = "feature-badge", paste0("⚡ ", round(track$energy * 100), "%")),
                            tags$span(class = "feature-badge", paste0("😊 ", round(track$valence * 100), "%")),
                            tags$span(class = "feature-badge", paste0("🎧 ", round(track$acousticness * 100), "%"))
                   ),
                   tags$div(class = "play-buttons",
                            tags$a(href = youtube_url, target = "_blank", class = "play-btn", tags$i(class = "fab fa-youtube"), "YouTube"),
                            tags$a(href = spotify_url, target = "_blank", class = "play-btn", tags$i(class = "fab fa-spotify"), "Spotify")
                   )
               )
        )
      })
    )
  })
  
  # Violin plot data that uses the current mood
  violin_data <- reactive({
    # Make sure this triggers when recommend button is clicked
    req(values$trigger_recommend > 0)
    
    # Get the current mood at the time of recommendation
    selected_mood <- values$current_mood
    
    recs <- recommendations()
    
    if (!is.null(recs) && nrow(recs) > 0) {
      data <- recs %>%
        select(danceability, energy, valence, acousticness) %>%
        pivot_longer(everything(), names_to = "Feature", values_to = "Value")
      title <- paste("Feature Distribution for", selected_mood, "Recommendations")
    } else {
      data <- spotify_data %>%
        filter(
          mood == selected_mood,
          if (!"All Genres" %in% input$genre) playlist_genre %in% input$genre else TRUE,
          energy >= input$energy[1],
          energy <= input$energy[2],
          popularity >= input$popularity[1],
          popularity <= input$popularity[2]
        ) %>%
        select(danceability, energy, valence, acousticness) %>%
        pivot_longer(everything(), names_to = "Feature", values_to = "Value")
      title <- paste("Feature Distribution for", selected_mood, "Mood")
    }
    
    list(
      data = data,
      title = title
    )
  })
  
  output$feature_violin <- renderPlotly({
    # Show creative placeholder when no recommendations made yet
    if (values$trigger_recommend == 0) {
      # Create a sample visualization showing all moods
      sample_data <- spotify_data %>%
        sample_n(min(1000, nrow(spotify_data))) %>%
        select(danceability, energy, valence, acousticness, mood) %>%
        pivot_longer(cols = c(danceability, energy, valence, acousticness), 
                     names_to = "Feature", values_to = "Value")
      
      colors <- c("#ff2d55", "#ff6b81", "#ff9a9e", "#ffc1cc")
      
      p <- plot_ly(
        data = sample_data,
        x = ~Feature,
        y = ~Value,
        type = "violin",
        box = list(visible = TRUE),
        meanline = list(visible = TRUE),
        split = ~Feature,
        color = ~Feature,
        colors = colors,
        hoverinfo = "y",
        hovertemplate = "Feature: %{x}<br>Value: %{y:.2f}<extra></extra>",
        opacity = 0.6
      ) %>%
        layout(
          yaxis = list(
            title = "Value",
            range = c(0, 1),
            tickfont = list(size = 12)
          ),
          xaxis = list(
            title = "",
            tickfont = list(size = 12),
            tickangle = 90
          ),
          paper_bgcolor = 'rgba(0, 0, 0, 0)',
          plot_bgcolor = 'rgba(0, 0, 0, 0)',
          font = list(color = "#222222", size = 12),
          margin = list(l=60, r=60, b=80, t=60),
          title = list(
            text = "🎵 Explore Musical Features Across All Moods",
            font = list(size = 14, color = "#666")
          ),
          showlegend = FALSE,
          hovermode = "closest",
          annotations = list(
            list(
              x = 0.5, y = 0.5,
              xref = "paper", yref = "paper",
              text = "Select a mood and hit 'Recommend Music' to see personalized features!",
              showarrow = FALSE,
              font = list(size = 12, color = "#999"),
              bgcolor = "rgba(255, 255, 255, 0.8)",
              bordercolor = "#ddd",
              borderwidth = 1
            )
          )
        )
      
      return(p)
    }
    
    # Rest of your existing code for when recommendations are made
    data <- violin_data()
    
    colors <- c("#ff2d55", "#ff6b81", "#ff9a9e", "#ffc1cc")
    
    p <- plot_ly(
      data = data$data,
      x = ~Feature,
      y = ~Value,
      type = "violin",
      box = list(visible = TRUE),
      meanline = list(visible = TRUE),
      split = ~Feature,
      color = ~Feature,
      colors = colors,
      hoverinfo = "y",
      hovertemplate = "Feature: %{x}<br>Value: %{y:.2f}<extra></extra>",
      opacity = 0.9
    ) %>%
      layout(
        yaxis = list(
          title = "Value",
          range = c(0, 1),
          tickfont = list(size = 12)
        ),
        xaxis = list(
          title = "",
          tickfont = list(size = 12),
          tickangle = 90
        ),
        paper_bgcolor = 'rgba(0, 0, 0, 0)',
        plot_bgcolor = 'rgba(0, 0, 0, 0)',
        font = list(color = "#222222", size = 12),
        margin = list(l=60, r=60, b=80, t=60),
        title = list(
          text = data$title,
          font = list(size = 14, color = "#666")
        ),
        showlegend = FALSE,
        hovermode = "closest"
      ) %>%
      animation_opts(frame = 500, transition = 300, redraw = TRUE)
    
    p
  })
  
  # Mood distribution that highlights the current mood
  output$mood_distribution <- renderPlotly({
    filtered_data <- spotify_data
    
    if (values$trigger_recommend > 0) {
      if (!"All Genres" %in% input$genre) {
        filtered_data <- filtered_data %>% filter(playlist_genre %in% input$genre)
      }
      
      filtered_data <- filtered_data %>%
        filter(
          energy >= input$energy[1],
          energy <= input$energy[2],
          popularity >= input$popularity[1],
          popularity <= input$popularity[2]
        )
    }
    
    mood_counts <- filtered_data %>%
      count(mood) %>%
      mutate(percentage = n / sum(n) * 100) %>%
      arrange(desc(percentage))
    
    # Highlight the current mood
    selected_mood <- values$current_mood
    colors <- ifelse(mood_counts$mood == selected_mood, "#ff2d55", "#cccccc")
    
    plot_ly(
      mood_counts,
      x = ~reorder(mood, percentage),
      y = ~percentage,
      type = 'bar',
      text = ~paste0(round(percentage, 1), "%"),
      textposition = 'auto',
      marker = list(color = colors, line = list(width = 0)),
      hoverinfo = "x+y",
      opacity = 0.8
    ) %>%
      layout(
        yaxis = list(title = "Percentage (%)", range = c(0, max(mood_counts$percentage) + 5)),
        xaxis = list(title = "", tickfont = list(size = 13)),
        paper_bgcolor = 'rgba(0, 0, 0, 0)',
        plot_bgcolor = 'rgba(0, 0, 0, 0)',
        font = list(color = "#222222"),
        margin = list(l=40, r=40, b=40, t=40),
        title = list(text = if(values$trigger_recommend > 0) "Filtered Dataset Distribution" else "Overall Dataset Distribution", 
                     font = list(size = 14, color = "#666"))
      )
  })
}

shinyApp(ui, server)