import tensorflow as tf
import numpy as np
import pandas as pd
import os
import requests
import base64
import time

def fetch_marine_data():
    records = []
    print("Fetching real marine data from local Marine API...")
    
    # Sri Lankan Fishing Regions Bounding Boxes (lat_min, lat_max, lng_min, lng_max)
    regions = [
        (6.5, 8.5, 79.5, 80.0), # West Coast (Colombo, Gampaha, Puttalam)
        (5.8, 6.3, 80.0, 81.5), # South Coast (Galle, Matara, Hambantota)
        (6.5, 9.0, 81.5, 82.0), # East Coast (Ampara, Batticaloa, Trincomalee)
        (8.8, 9.9, 79.5, 80.5)  # North Coast (Jaffna, Mannar)
    ]
    
    np.random.seed(42)
    lats = []
    lngs = []
    
    # Generate 2000 points (500 per region)
    for r in regions:
        lats.extend(np.random.uniform(r[0], r[1], 500))
        lngs.extend(np.random.uniform(r[2], r[3], 500))
        
    coords = list(zip(lats, lngs))
    np.random.shuffle(coords)
    total = len(coords)
    
    for i, (lat, lng) in enumerate(coords):
        try:
            res = requests.get(f"https://dheewarayo-marine-api.onrender.com/api/marine_data?lat={lat}&lng={lng}", timeout=10)
            if res.status_code == 200:
                data = res.json()
                records.append({
                    'sst': data.get('sst', 28.0),
                    'chlorophyll': data.get('chlorophyll', 0.5),
                    'ssh': data.get('ssh', 0.0)
                })
                print(f"Point {i+1}/{total}: Successfully fetched data.")
            else:
                print(f"Point {i+1}/{total}: Failed with status {res.status_code}.")
        except Exception as e:
            print(f"Point {i+1}/{total}: Error fetching data: {e}")
            
        time.sleep(0.05)
        
    return pd.DataFrame(records)

def preprocess_data(df):
    print("Preprocessing data...")
    if df.empty:
        raise ValueError("No real data fetched from Copernicus API. Check your connection or API status.")
        
    def calculate_pfz(row):
        score = 0.0
        
        # SST Factor (max 0.4)
        if 27.0 <= row['sst'] <= 29.5:
            score += 0.4
        elif 26.0 <= row['sst'] <= 30.0:
            score += 0.2
            
        # Chlorophyll Factor (max 0.3)
        if row['chlorophyll'] > 0.2:
            score += 0.3
        elif row['chlorophyll'] > 0.1:
            score += 0.15
            
        # SSH Factor (max 0.3) - Upwelling regions or neutral SSH are usually better
        if -0.2 <= row['ssh'] <= 0.1:
            score += 0.3
        elif -0.4 <= row['ssh'] <= 0.2:
            score += 0.15
            
        return min(1.0, max(0.0, score))
        
    df['pfz'] = df.apply(calculate_pfz, axis=1)
    
    features = df[['sst', 'chlorophyll', 'ssh']].values
    targets = df[['pfz']].values
    
    return features, targets

def main():
    df = fetch_marine_data()
    X, y = preprocess_data(df)
    
    print(f"Data shape: X={X.shape}, y={y.shape}")
    
    model = tf.keras.Sequential([
        tf.keras.Input(shape=(3,)),
        tf.keras.layers.Dense(16, activation='relu'),
        tf.keras.layers.Dense(8, activation='relu'),
        tf.keras.layers.Dense(1, activation='sigmoid')
    ])

    model.compile(optimizer='adam', loss='mse', metrics=['mae'])
    
    print("Training PFZ model...")
    model.fit(X, y, epochs=20, batch_size=4, validation_split=0.2 if len(X) > 10 else 0.0)
    print("PFZ Model trained successfully.")

    os.makedirs('assets/models', exist_ok=True)

    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()

    tflite_path = 'assets/models/pfz_model.tflite'
    with open(tflite_path, 'wb') as f:
        f.write(tflite_model)
        
    print(f"PFZ TFLite model saved to {tflite_path}")

if __name__ == "__main__":
    main()
