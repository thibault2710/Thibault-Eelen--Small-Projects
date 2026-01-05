# Projects Portfolio

Welcome! This repository showcases a collection of data science projects I’ve worked on to develop and apply my skills in analytics, machine learning, and visualization. Each project tackles a different type of data challenge, from cleaning and exploration to predictive modeling and communication of insights.

---

## 📂 Projects

### Project 1: Quantitative Investing – Factor Backtesting and Multi-Factor Models

- **Description**: Built and tested factor-based investment strategies, analyzing the performance of value, growth, quality, and momentum factors across different time horizons. A portion of the initial code framework was provided by course lecturers, which was then expanded to build and test additional functionality. Developed a multi-factor model to evaluate how combining factors affects returns compared to individual factor performance.  
- **Tasks & Approach**: Conducted factor backtests by creating decile portfolios, measuring returns and hit rates, and calculating long-short spreads. Analyzed factor correlations and persistence through the information coefficient (IC). Designed and tested multi-factor models with different weighting schemes to assess predictive strength relative to standalone factors.  
- **Tech stack**: R, data.table, ggplot2.  
- **Key skills learned**: Factor modeling, portfolio backtesting, correlation analysis, building and interpreting multi-factor investment models, performance evaluation over different horizons.  


### Project 2: Predicting Heart Disease

- **Description**: Used the UCI Heart Disease dataset to build models that predict the presence of heart disease, focusing on the most significant clinical and symptom-based features.  
- **Tasks & Approach**: Cleaned and preprocessed data, explored correlations, and trained Logistic Regression and Decision Tree models. Compared performance across feature sets (risk factors vs. symptoms vs. top predictors).  
- **Tech stack**: Python, Pandas, Scikit-learn, Matplotlib.  
- **Key skills learned**: Data cleaning, feature engineering, classification modeling, model evaluation, and interpreting medical datasets.


### Project 3: Predicting Drug Usage with Classification Models (Final Exam)

- **Description**: Built machine learning models to predict whether individuals had ever used different categories of drugs, based on demographic, personality, and risk-seeking features. Explored feature engineering, categorical encoding, and model evaluation.

- **Tasks & Approach**:
  - **Part A**: Categorized dataset features into demographics, personality, and risk-seeking groups. Encoded categorical drug usage responses into numerical targets across four drug categories (Cat1: controlled/hard, Cat2: controlled/medium, Cat3: controlled/soft, Cat4: legal/soft).
  - **Part B**: Trained multiple classification models (Neural Network, Logistic Regression, Support Vector Machine, Decision Tree, etc.) to predict usage for each drug category.
  - **Part C**: Evaluated models using accuracy on training and testing sets. Summarized results in a performance comparison table for each drug category.
  - **Part D**: Performed subgroup analysis by splitting data by education, age, or sex. Retrained best models for each subgroup and analyzed differences in predictive performance.

- **Tech stack**: Python, Pandas, Scikit-learn, TensorFlow/Keras.
- **Key skills demonstrated**: Feature engineering, classification modeling, neural networks, subgroup analysis, model evaluation.


### Project 4: Predicting Budget-Friendly Airbnb Listings in Paris

- **Description**: Analyzed Airbnb listings data from Paris to identify the strongest predictors of budget-friendly accommodations (<25% of price distribution). The project aimed to understand whether pricing patterns at the low end of the market are formulaic or influenced by subjective factors.  
- **Tasks & Approach**: Cleaned and preprocessed 64,690 raw entries down to 13,690 usable listings. Engineered features such as number of amenities, created price categories, and trained logistic regression models. Evaluated model accuracy with cross-validation, focusing on classification of low-price listings.  
- **Tech stack**: Python, Pandas, Scikit-learn, Matplotlib.  
- **Key skills learned**: Data cleaning and preprocessing, feature engineering, logistic regression modeling, cross-validation, interpreting pricing dynamics in real-world markets.  


