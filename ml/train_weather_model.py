import tensorflow as tf
import numpy as np
import os

# Create synthetic data: [temp, humidity, wind_speed, pressure] -> [wind_next_hour, wave_next_hour, rain_next_hour]
np.random.seed(42)
num_samples = 2000
temp = np.random.uniform(10, 40, num_samples)
humidity = np.random.uniform(30, 100, num_samples)
wind = np.random.uniform(0, 30, num_samples)
pressure = np.random.uniform(900, 1100, num_samples)

X = np.stack([temp, humidity, wind, pressure], axis=1)

# Synthetic outputs based on inputs
# Priority: Wind speed (strongly influenced by pressure and current wind)
wind_next_hour = 0.8 * wind - 0.1 * (pressure - 1000) + np.random.normal(0, 2, num_samples)
wind_next_hour = np.clip(wind_next_hour, 0, 100)

# Sea wave conditions (strongly influenced by wind speed)
wave_next_hour = 0.1 * wind_next_hour + np.random.normal(0, 0.2, num_samples)
wave_next_hour = np.clip(wave_next_hour, 0, 10)

# Rain conditions (probability/amount, influenced by humidity and pressure)
rain_next_hour = 0.5 * (humidity - 50) - 0.2 * (pressure - 1000) + np.random.normal(0, 5, num_samples)
rain_next_hour = np.clip(rain_next_hour, 0, 100)

y = np.stack([wind_next_hour, wave_next_hour, rain_next_hour], axis=1)

model = tf.keras.Sequential([
    tf.keras.layers.Dense(32, activation='relu', input_shape=(4,)),
    tf.keras.layers.Dense(16, activation='relu'),
    tf.keras.layers.Dense(3)  # Output size is 3 for wind, wave, rain
])

model.compile(optimizer='adam', loss='mse')
print("Training model...")
model.fit(X, y, epochs=100, batch_size=32, verbose=0)
print("Training complete.")

os.makedirs('assets/models', exist_ok=True)

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open('assets/models/weather_model.tflite', 'wb') as f:
    f.write(tflite_model)
    
print("TFLite model saved to assets/models/weather_model.tflite")
