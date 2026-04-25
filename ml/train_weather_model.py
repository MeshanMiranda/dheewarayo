import tensorflow as tf
import numpy as np
import os
import requests
import pandas as pd

def fetch_weather_data():
    print("Fetching historical weather data from Open-Meteo")
    url = "https://archive-api.open-meteo.com/v1/archive?latitude=6.9271&longitude=79.8612&start_date=2024-01-01&end_date=2025-12-31&hourly=temperature_2m,relative_humidity_2m,surface_pressure,wind_speed_10m"
    response = requests.get(url)
    data = response.json()
    
    hourly = data['hourly']
    df = pd.DataFrame({
        'temperature': hourly['temperature_2m'],
        'humidity': hourly['relative_humidity_2m'],
        'pressure': hourly['surface_pressure'],
        'wind_speed': hourly['wind_speed_10m']
    })
    
    df = df.dropna()
    return df

def preprocess_data(df):
    print("Preprocessing data...")
    
    features = df[['temperature', 'humidity', 'pressure', 'wind_speed']].values
    targets = df[['temperature', 'humidity', 'wind_speed']].values
    
    X = features[:-1]
    y = targets[1:]
    
    X_mean = X.mean(axis=0)
    X_std = X.std(axis=0)
    X_normalized = (X - X_mean) / X_std
    
    print(f"Feature means: {X_mean}")
    print(f"Feature std devs: {X_std}")
    
    return X_normalized, y

def main():
    df = fetch_weather_data()
    X, y = preprocess_data(df)
    
    print(f"Data shape: X={X.shape}, y={y.shape}")
    
    model = tf.keras.Sequential([
        tf.keras.layers.Dense(32, activation='relu', input_shape=(4,)),
        tf.keras.layers.Dense(16, activation='relu'),
        tf.keras.layers.Dense(3)
    ])

    model.compile(optimizer='adam', loss='mse', metrics=['mae'])
    
    print("Training model...")
    
    model.fit(X, y, epochs=20, batch_size=64, validation_split=0.2)
    print("Model trained successfully.")

    os.makedirs('assets/models', exist_ok=True)

    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()

    with open('assets/models/weather_model.tflite', 'wb') as f:
        f.write(tflite_model)
        
    print("TFLite model saved to assets/models/weather_model.tflite")

if __name__ == "__main__":
    main()
