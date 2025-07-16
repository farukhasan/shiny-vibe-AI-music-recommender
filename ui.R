# UI with loading screen
ui <- fluidPage(
  useShinyjs(),
  tags$head(
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"),
    tags$style(HTML("
        :root {
          --glass-bg: rgba(255, 255, 255, 0.15);
          --glass-border: rgba(255, 255, 255, 0.3);
          --accent-color: #ff2d55;
          --text-color: #222222;
          --shadow-light: rgba(255, 255, 255, 0.15);
          --shadow-dark: rgba(0, 0, 0, 0.07);
          --font-sans: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }
  
        body {
          background: #fafafa;
          color: var(--text-color);
          font-family: var(--font-sans);
          margin: 0; padding: 0 30px 40px 30px;
          -webkit-font-smoothing: antialiased;
          overflow-x: hidden;
          font-size: 13px;
          user-select: none;
        }
  
        /* Loading Screen */
        .loading-overlay {
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(250, 250, 250, 0.95);
          backdrop-filter: blur(10px);
          z-index: 10000;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-direction: column;
        }
        .loading-spinner {
          width: 60px;
          height: 60px;
          border: 4px solid rgba(255, 45, 85, 0.2);
          border-top: 4px solid var(--accent-color);
          border-radius: 50%;
          animation: spin 1s linear infinite;
          margin-bottom: 20px;
        }
        @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }
        .loading-text {
          color: var(--accent-color);
          font-size: 16px;
          font-weight: 600;
          text-align: center;
        }
  
        h1, h2, h3, h4 {
          font-weight: 600;
          color: var(--text-color);
          margin-bottom: 0.2rem;
          font-size: 1.1rem;
        }
  
        p {
          color: #555;
          margin-top: 0; margin-bottom: 0.8rem;
          font-size: 0.85rem;
        }
  
        .glass-panel {
          background: var(--glass-bg);
          border: 1px solid var(--glass-border);
          border-radius: 18px;
          box-shadow: 0 5px 20px var(--shadow-dark), inset 0 0 0 0.4px var(--shadow-light);
          backdrop-filter: blur(12px);
          -webkit-backdrop-filter: blur(12px);
          padding: 20px 22px;
          margin-bottom: 25px;
          transition: box-shadow 0.3s ease;
        }
        .glass-panel:hover {
          box-shadow: 0 10px 35px var(--shadow-dark), inset 0 0 0 0.7px var(--accent-color);
        }
  
        .mood-btn {
          width: 100%;
          margin: 8px 0;
          padding: 14px 0;
          border-radius: 28px;
          font-weight: 600;
          font-size: 14px;
          border: none;
          cursor: pointer;
          color: var(--text-color);
          background: var(--glass-bg);
          border: 1.2px solid var(--glass-border);
          box-shadow: 0 3px 15px var(--shadow-light);
          transition: background-color 0.25s ease, border-color 0.25s ease, color 0.25s ease, transform 0.2s ease;
          user-select: none;
        }
        .mood-btn:hover {
          background-color: var(--accent-color);
          border-color: var(--accent-color);
          color: white;
          transform: scale(1.04);
          box-shadow: 0 10px 25px rgba(255, 45, 85, 0.3);
        }
        .mood-btn.active {
          background-color: var(--accent-color);
          border-color: var(--accent-color);
          color: white;
          transform: scale(1.06);
          box-shadow: 0 12px 30px rgba(255, 45, 85, 0.5);
        }
  
        .btn-apple {
          background-color: var(--accent-color);
          color: white;
          border-radius: 38px;
          font-weight: 700;
          padding: 14px 50px;
          font-size: 16px;
          border: none;
          box-shadow: 0 7px 23px rgba(255, 45, 85, 0.38);
          cursor: pointer;
          transition: background-color 0.3s ease, transform 0.3s ease;
          width: 100%;
          user-select: none;
        }
        .btn-apple:hover {
          background-color: #ff375f;
          transform: scale(1.07);
          box-shadow: 0 10px 35px rgba(255, 45, 85, 0.6);
        }
  
        .song-card {
          background: var(--glass-bg);
          border-radius: 22px;
          padding: 14px 18px;
          margin-bottom: 14px;
          border: 1.1px solid var(--glass-border);
          box-shadow: 0 2px 12px var(--shadow-light);
          transition: transform 0.25s ease, box-shadow 0.25s ease;
          cursor: pointer;
          color: var(--text-color);
        }
        .song-card:hover {
          transform: translateY(-4px);
          box-shadow: 0 14px 38px rgba(255, 45, 85, 0.2);
        }
        .song-card:hover .play-btn {
          background: var(--accent-color) !important;
          color: white !important;
        }
        .song-title {
          font-size: 15px;
          font-weight: 600;
          margin-bottom: 3px;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        .song-artist {
          font-size: 11.5px;
          color: #666;
          margin-bottom: 8px;
        }
        .song-info {
          font-size: 11px;
          color: #777;
          display: flex;
          justify-content: space-between;
          margin-bottom: 10px;
        }
        .feature-badge {
          background: rgba(255, 255, 255, 0.22);
          border-radius: 16px;
          padding: 4px 10px;
          margin-right: 6px;
          font-size: 10px;
          color: var(--text-color);
          display: inline-block;
        }
  
        .play-buttons {
          display: flex;
          gap: 4px;
          margin-top: 8px;
        }
        .play-btn {
          padding: 4px 8px;
          border-radius: 12px;
          border: none;
          cursor: pointer;
          font-size: 9px;
          font-weight: 600;
          transition: all 0.2s ease;
          text-decoration: none;
          text-align: center;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 2px;
          min-width: 50px;
          background: #bbb;
          color: white;
        }
  
        .selectize-control {
          width: 100% !important;
          margin-bottom: 15px !important;
        }
        .selectize-control .selectize-input {
          background: white !important;
          border: 2px solid var(--glass-border) !important;
          border-radius: 12px !important;
          color: var(--text-color) !important;
          font-size: 13px !important;
          font-weight: 500 !important;
          padding: 10px 16px !important;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1) !important;
          transition: all 0.2s ease !important;
          min-height: 44px !important;
          line-height: 1.4 !important;
        }
        .selectize-control .selectize-input:hover,
        .selectize-control .selectize-input.focus {
          border-color: var(--accent-color) !important;
          box-shadow: 0 0 0 3px rgba(255, 45, 85, 0.1) !important;
        }
        .selectize-control .selectize-input .item {
          background: var(--accent-color) !important;
          color: white !important;
          border-radius: 8px !important;
          padding: 4px 8px !important;
          margin: 2px 4px 2px 0 !important;
          font-size: 12px !important;
          font-weight: 500 !important;
        }
        .selectize-control .selectize-input .item .remove {
          border-left: 1px solid rgba(255, 255, 255, 0.3) !important;
          color: white !important;
          margin-left: 6px !important;
          padding-left: 6px !important;
        }
        .selectize-control .selectize-input .item .remove:hover {
          background: rgba(255, 255, 255, 0.2) !important;
        }
        .selectize-control .selectize-input input[type='text'] {
          color: var(--text-color) !important;
          font-size: 13px !important;
        }
        .selectize-control .selectize-input input[type='text']::placeholder {
          color: #999 !important;
        }
        .selectize-dropdown {
          background: white !important;
          border: 2px solid var(--glass-border) !important;
          border-radius: 12px !important;
          box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2) !important;
          z-index: 9999 !important;
          margin-top: 4px !important;
        }
        .selectize-dropdown .option {
          padding: 10px 16px !important;
          color: var(--text-color) !important;
          font-size: 13px !important;
          font-weight: 500 !important;
          transition: all 0.2s ease !important;
          border-bottom: 1px solid rgba(0, 0, 0, 0.05) !important;
        }
        .selectize-dropdown .option:hover,
        .selectize-dropdown .option.active {
          background: var(--accent-color) !important;
          color: white !important;
        }
        .selectize-dropdown .option:last-child {
          border-bottom: none !important;
        }
        .container-fluid {
          padding-left: 28px;
          padding-right: 28px;
        }
  
        .section-header {
          margin-bottom: 14px;
          border-bottom: 1.8px solid var(--accent-color);
          padding-bottom: 4px;
          font-size: 1rem;
        }
  
        .creative-empty {
          background: linear-gradient(135deg, rgba(255, 45, 85, 0.1) 0%, rgba(255, 45, 85, 0.03) 100%);
          border-radius: 20px;
          padding: 40px 30px;
          text-align: center;
          margin: 20px 0;
          border: 1px dashed rgba(255, 45, 85, 0.3);
          position: relative;
          overflow: hidden;
        }
        .creative-empty::before {
          content: '';
          position: absolute;
          top: -50%;
          left: -50%;
          width: 200%;
          height: 200%;
          background: radial-gradient(circle, rgba(255, 45, 85, 0.05) 0%, transparent 70%);
          animation: pulse 4s ease-in-out infinite;
        }
        @keyframes pulse {
          0%, 100% { transform: scale(1); opacity: 0.7; }
          50% { transform: scale(1.1); opacity: 1; }
        }
        .creative-empty .content {
          position: relative;
          z-index: 1;
        }
        .creative-empty .emoji {
          font-size: 64px;
          margin-bottom: 20px;
          display: block;
          animation: bounce 2s ease-in-out infinite;
        }
        @keyframes bounce {
          0%, 100% { transform: translateY(0); }
          50% { transform: translateY(-10px); }
        }
        .creative-empty .title {
          font-size: 20px;
          font-weight: 700;
          color: var(--accent-color);
          margin-bottom: 10px;
        }
        .creative-empty .subtitle {
          font-size: 14px;
          color: #666;
          line-height: 1.5;
          max-width: 400px;
          margin: 0 auto;
        }
  
        @media (max-width: 992px) {
          .container-fluid {
            padding-left: 12px;
            padding-right: 12px;
          }
          .mood-btn {
            font-size: 13px;
            padding: 12px 0;
          }
          .song-title {
            font-size: 14px;
          }
        }
      "))
  ),
  
  # Loading Screen
  div(id = "loading-overlay", class = "loading-overlay",
      div(class = "loading-spinner"),
      div(class = "loading-text", "Loading Vibe AI...")
  ),
  
  fluidRow(
    column(12, div(style = "text-align:center; padding: 32px 0 24px 0;",
                   h1("Vibe AI", style = "font-size: 28px; font-weight: bold;"),
                   p(style = "font-size: 14px; color:#555;", "Discover your perfect soundtrack using AI")))
  ),
  
  fluidRow(
    column(3,
           div(class = "glass-panel",
               h3("Select Your Mood", class = "section-header"),
               actionButton("mood_energetic", "Energetic", class = "mood-btn", id = "mood_energetic"),
               actionButton("mood_calm", "Calm", class = "mood-btn", id = "mood_calm"),
               actionButton("mood_happy", "Happy", class = "mood-btn", id = "mood_happy"),
               actionButton("mood_melancholic", "Melancholic", class = "mood-btn", id = "mood_melancholic"),
               br(), br(),
               h3("Preferences", class = "section-header"),
               selectInput("genre", "Music Genre",
                           choices = c("All Genres" = "All Genres", setNames(sort(unique(as.character(spotify_data$playlist_genre[!is.na(spotify_data$playlist_genre)]))), 
                                                                             sort(unique(as.character(spotify_data$playlist_genre[!is.na(spotify_data$playlist_genre)]))))),
                           selected = "All Genres", multiple = TRUE, selectize = TRUE),
               sliderTextInput("energy", "Energy Level", choices = seq(0, 1, 0.1), selected = c(0.4, 0.8), grid=TRUE),
               sliderInput("popularity", "Popularity", min = 0, max = 100, value = c(30, 90)),
               br(),
               actionButton("recommend", "Recommend Music", class = "btn-apple")
           )
    ),
    column(9,
           fluidRow(
             column(12,
                    div(class = "glass-panel",
                        h3("Recommended Tracks", class = "section-header"),
                        div(id = "recommendations_placeholder", class = "creative-empty",
                            div(class = "content",
                                span(class = "emoji", "🎵"),
                                div(class = "title", "Let's Find Your Perfect Beat!"),
                                div(class = "subtitle", "Choose your mood and preferences above, then click 'Recommend Music' to discover tracks that match your vibe perfectly.")
                            )
                        ),
                        uiOutput("recommendations_ui") %>% shinycssloaders::withSpinner(color = "#ff2d55")
                    )
             )
           ),
           fluidRow(
             column(6,
                    div(class = "glass-panel",
                        h3("Feature Distribution", class = "section-header"),
                        plotlyOutput("feature_violin", height = "320px") %>% shinycssloaders::withSpinner(color = "#ff2d55")
                    )
             ),
             column(6,
                    div(class = "glass-panel",
                        h3("Mood Distribution", class = "section-header"),
                        plotlyOutput("mood_distribution", height = "320px") %>% shinycssloaders::withSpinner(color = "#ff2d55")
                    )
             )
           )
    )
  ),
  
  tags$script(HTML("
  $(document).ready(function() {
    // Hide loading screen after 2 seconds
    setTimeout(function() {
      $('#loading-overlay').fadeOut(500);
    }, 2000);
    
    // Set initial mood to Happy
    $('#mood_happy').addClass('active');
  });
  
  // Handle mood button clicks and send to Shiny
  $(document).on('click', '.mood-btn', function() {
    var moodId = $(this).attr('id');
    var mood = moodId.replace('mood_', '');
    
    console.log('Button clicked:', moodId, 'Mood:', mood);
    
    // Update visual state
    $('.mood-btn').removeClass('active');
    $(this).addClass('active');
    
    // Send ONLY the mood name to Shiny
    Shiny.setInputValue('current_mood_selection', mood, {priority: 'event'});
    console.log('Sent to Shiny:', mood);
  });
  
  // Custom message handler to maintain active state
  $(document).on('shiny:connected', function() {
    Shiny.addCustomMessageHandler('setActiveMood', function(mood) {
      $('.mood-btn').removeClass('active');
      $('#mood_' + mood.toLowerCase()).addClass('active');
    });
  });
"))
)