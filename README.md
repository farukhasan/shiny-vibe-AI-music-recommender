# Shiny Vibe AI Music Recommender

A Shiny web application for personalized music recommendation built with R. This interactive dashboard leverages machine learning algorithms to analyze musical features and recommend tracks based on user mood preferences and listening habits.

## Live Application

The dashboard is deployed and accessible at: [https://farukhasan.shinyapps.io/vibe_ai/](https://farukhasan.shinyapps.io/vibe_ai/)

## Screenshots

The following screenshots demonstrate the key features and interface of the Vibe AI Music Recommender:

### Landing Page
![Landing Page](https://github.com/farukhasan/shiny-vibe-AI-music-recommender/blob/main/vibe_ai1.png)
*Application landing page with mood selection and main interface*

### Filters
![Filters Interface](https://github.com/farukhasan/shiny-vibe-AI-music-recommender/blob/main/vibe_ai3.png)
*Interactive filtering options for genre, energy levels, and popularity settings*

### Graphs and Visualizations
![Graphs and Charts](https://github.com/farukhasan/shiny-vibe-AI-music-recommender/blob/main/vibe_ai2.png)
*Music feature distributions and mood analytics visualizations*

## Overview

The Vibe AI Music Recommender is an interactive web application that combines music information retrieval with machine learning to provide personalized song recommendations. The system analyzes audio features from the Spotify dataset to understand musical patterns and match them with user preferences based on mood, energy level, and genre preferences.

## Features

- Mood-based music recommendation system with four distinct categories (Energetic, Calm, Happy, Melancholic)
- Real-time audio feature analysis and similarity matching
- Machine learning-powered mood classification using Gradient Boosting Machine (GBM)
- Interactive visualizations of music feature distributions
- Genre filtering and popularity-based recommendations
- Direct integration with YouTube and Spotify for instant music access
- Responsive glassmorphism design with smooth animations
- Real-time data processing and dynamic content updates

## Technical Architecture

### Frontend
- **Shiny Framework**: Built using R Shiny for reactive web applications
- **Modern UI Design**: Glassmorphism aesthetic with CSS3 animations and transitions
- **Interactive Components**: Dynamic mood selection, real-time filtering, and responsive layouts
- **External Integrations**: Direct links to YouTube and Spotify platforms
- **Performance Optimization**: Lazy loading and efficient DOM manipulation

### Backend
- **R Environment**: Core application logic implemented in R
- **Data Processing**: Efficient manipulation of Spotify music dataset
- **Machine Learning**: Gradient Boosting Machine implementation for mood prediction
- **Similarity Algorithms**: Cosine similarity for music feature matching
- **Real-time Analytics**: Live recommendation updates based on user interactions

## Methodology

### Data Processing Pipeline

1. **Data Ingestion**: Spotify dataset containing 32,833 tracks with 23 audio features
2. **Feature Engineering**: Creation of mood categories based on valence, energy, and danceability
3. **Data Cleaning**: Removal of duplicates and handling missing values
4. **Mood Classification**: Categorical assignment based on audio feature thresholds:
   - **Energetic**: High valence (>0.7) and high energy (>0.7)
   - **Calm**: High valence (>0.7) and low energy (<0.4)
   - **Melancholic**: Low valence (<0.3) and low energy (<0.4)
   - **Happy**: High valence (>0.6) and high danceability (>0.7)
   - **Neutral**: All other combinations (filtered out)

### Machine Learning Implementation

#### Gradient Boosting Machine (GBM)
The application utilizes Gradient Boosting Machine algorithms for mood classification:

- **Model Training**: Sequential ensemble learning approach where each model corrects errors from previous iterations
- **Feature Selection**: Utilizes danceability, energy, valence, acousticness, and instrumentalness as predictors
- **Cross-validation**: 5-fold cross-validation for robust model evaluation
- **Hyperparameter Optimization**: Automatic tuning through caret package
- **Performance Metrics**: Multi-class classification accuracy for mood prediction

#### Audio Feature Analysis
- **Danceability**: Rhythm stability and beat strength analysis
- **Energy**: Perceptual measure of intensity and activity
- **Valence**: Musical positivity and emotional tone
- **Acousticness**: Confidence measure of acoustic vs electric instrumentation
- **Instrumentalness**: Prediction of vocal content presence

#### Recommendation Algorithm
1. **Mood Centroid Calculation**: Compute mean feature values for each mood category
2. **User Preference Filtering**: Apply genre, energy, and popularity filters
3. **Similarity Matching**: Calculate cosine similarity between user preferences and track features
4. **Ranking System**: Sort recommendations by similarity score and return top 8 matches

### Shiny Dashboard Development Process

#### Application Structure
1. **User Interface (UI)**: Modern glassmorphism design with interactive mood selection
2. **Server Logic**: Reactive programming for real-time recommendation updates
3. **Data Management**: Efficient in-memory data processing and caching
4. **Visualization**: Interactive charts using plotly for feature distributions and mood analytics

#### Development Workflow
1. **Requirements Analysis**: Identification of music recommendation needs and user experience goals
2. **Data Exploration**: Analysis of Spotify dataset structure and feature distributions
3. **Model Development**: Implementation and training of GBM classifier
4. **UI/UX Design**: Creation of intuitive interface with modern design principles
5. **Integration Testing**: Comprehensive testing of recommendation accuracy and performance
6. **Performance Optimization**: Code optimization for responsive user experience

## Technology Stack

- **R**: Core programming language (version 4.0+)
- **Shiny**: Web application framework for interactive dashboards
- **tidyverse**: Data manipulation and transformation toolkit
- **caret**: Machine learning model training and evaluation
- **gbm**: Gradient Boosting Machine implementation
- **plotly**: Interactive data visualization library
- **proxy**: Similarity calculation algorithms
- **shinyWidgets**: Enhanced UI components and controls
- **shinycssloaders**: Loading animations and user feedback
- **shinyjs**: JavaScript integration for enhanced interactivity

## Installation and Setup

### Prerequisites
- R (version 4.0 or higher)
- RStudio (recommended for development)
- Internet connection for Spotify dataset access

### Required Packages
```r
install.packages(c(
  "shiny",
  "tidyverse",
  "plotly",
  "caret",
  "shinyWidgets",
  "shinycssloaders",
  "shinyjs",
  "proxy",
  "gbm"
))
```

### Local Development
1. Clone the repository:
```bash
git clone https://github.com/farukhasan/shiny-vibe-AI-music-recommender.git
cd shiny-vibe-AI-music-recommender
```

2. Install required packages:
```r
# Run in R console
source("install_packages.R")  # if available, or install packages manually
```

3. Run the application:
```r
shiny::runApp("app.R")
```

## Deployment Process

### Shinyapps.io Deployment

The application is deployed using shinyapps.io, RStudio's cloud-based hosting platform optimized for Shiny applications.

#### Deployment Steps

1. **Account Configuration**:
   - Create account at [shinyapps.io](https://www.shinyapps.io/)
   - Install and configure rsconnect package

2. **Application Preparation**:
   - Ensure all package dependencies are explicitly loaded
   - Optimize data loading for cloud environment
   - Test application locally with production-like settings

3. **Deployment Configuration**:
   ```r
   # Install deployment package
   install.packages("rsconnect")
   
   # Configure account credentials
   rsconnect::setAccountInfo(
     name = "farukhasan",
     token = "your_token_here",
     secret = "your_secret_here"
   )
   ```

4. **Deploy Application**:
   ```r
   # Deploy to shinyapps.io
   rsconnect::deployApp(
     appName = "vibe_ai",
     forceUpdate = TRUE
   )
   ```

5. **Production Monitoring**:
   - Monitor application performance and resource usage
   - Configure auto-scaling based on user demand
   - Set up error logging and notification systems

#### Deployment Considerations
- **Memory Management**: Efficient handling of large Spotify dataset
- **Performance Optimization**: Caching strategies for model predictions
- **User Experience**: Fast loading times and responsive interactions
- **Data Security**: Secure handling of user preferences and recommendations

## Usage

1. **Access the Application**: Navigate to the deployed application URL
2. **Select Mood**: Choose from four mood categories (Energetic, Calm, Happy, Melancholic)
3. **Configure Preferences**: Set genre filters, energy levels, and popularity ranges
4. **Generate Recommendations**: Click "Recommend Music" to receive personalized suggestions
5. **Explore Results**: View recommended tracks with detailed audio feature analysis
6. **Access Music**: Use integrated YouTube and Spotify links for immediate listening

## File Structure

```
vibe_ai/
├── app.R                 # Main application file containing UI and server logic
├── README.md            # Project documentation
└── screenshots/         # Application interface screenshots
    ├── vibe_ai1.png     # Landing page
    ├── vibe_ai2.png     # Visualizations
    └── vibe_ai3.png     # Filters interface
```

## Data Source

The application utilizes the Spotify dataset from TidyTuesday, containing:
- **32,833 tracks** across multiple genres and time periods
- **23 audio features** per track including danceability, energy, valence, and acousticness
- **Metadata** including artist names, track popularity, and genre classifications
- **Real-time access** via GitHub raw file hosting

## Contributing

Contributions are welcome and encouraged. Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/enhancement-name`)
3. Commit your changes with descriptive messages
4. Push to the branch (`git push origin feature/enhancement-name`)
5. Create a Pull Request with detailed description

## Future Enhancements

- Integration with additional music streaming platforms
- User preference learning and personalization
- Advanced audio feature analysis using deep learning
- Social features for music sharing and discovery
- Real-time trending music recommendations
- Mobile-responsive progressive web app conversion
- Multi-language support for global accessibility

## License

This project is open source and available under the MIT License.

---

**GitHub Repository**: [https://github.com/farukhasan/shiny-vibe-AI-music-recommender](https://github.com/farukhasan/shiny-vibe-AI-music-recommender)  
**Live Application**: [https://farukhasan.shinyapps.io/vibe_ai/](https://farukhasan.shinyapps.io/vibe_ai/)  
**Developer**: [https://github.com/farukhasan](https://github.com/farukhasan)
