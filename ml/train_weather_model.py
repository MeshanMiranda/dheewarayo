import tensorflow as tf
import numpy as np
import os
import requests
import pandas as pd

def fetch_weather_data():
    print("Fetching historical weather data from Open-Meteo")
    url = "https://archive-api.open-meteo.com/v1/archive?latitude=6.9271&longitude=79.8612&start_date=2024-01-01&end_date=2025-12-31&hourly=temperature_2m,relative_humidity_2m,surface_pressure,wind_speed_10m,rain"
    response = requests.get(url)
    data = response.json()
    
    hourly = data['hourly']
    df = pd.DataFrame({
        'temperature': hourly['temperature_2m'],
        'humidity': hourly['relative_humidity_2m'],
        'pressure': hourly['surface_pressure'],
        'wind_speed': hourly['wind_speed_10m'],
        'rain': hourly['rain']
    })
    
    df = df.dropna()
    return df

def preprocess_data(df):
    print("Preprocessing data...")
    
    # Synthesize wave height based on wind speed (rough approximation for ML purposes)
    np.random.seed(42)
    df['wave'] = df['wind_speed'] * 0.15 + np.random.normal(0, 0.1, len(df))
    df['wave'] = df['wave'].clip(lower=0.0)
    
    # Features: temperature, humidity, pressure, wind_speed
    features = df[['temperature', 'humidity', 'pressure', 'wind_speed']].values
    
    # Targets: wind_speed, wave, rain
    targets = df[['wind_speed', 'wave', 'rain']].values
    
    # Predict next hour
    X = features[:-1]
    y = targets[1:]
    
    return X, y

def main():
    df = fetch_weather_data()
    X, y = preprocess_data(df)
    
    print(f"Data shape: X={X.shape}, y={y.shape}")
    
    X_mean = np.mean(X, axis=0)
    X_std = np.std(X, axis=0)
    X_std[X_std == 0] = 1.0
    
    mean_tensor = tf.constant(X_mean, dtype=tf.float32)
    std_tensor = tf.constant(X_std, dtype=tf.float32)
    
    inputs = tf.keras.layers.Input(shape=(4,))
    norm_out = (inputs - mean_tensor) / std_tensor
    x_layer = tf.keras.layers.Dense(32, activation='relu')(norm_out)
    x_layer = tf.keras.layers.Dense(16, activation='relu')(x_layer)
    outputs = tf.keras.layers.Dense(3)(x_layer)
    
    model = tf.keras.Model(inputs=inputs, outputs=outputs)

    model.compile(optimizer='adam', loss='mse', metrics=['mae'])
    
    print("Training weather model...")

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
