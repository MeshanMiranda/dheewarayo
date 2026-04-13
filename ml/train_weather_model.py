import tensorflow as tf
import numpy as np
import os

# Create a blank neural network model using Keras
model = tf.keras.Sequential([
    # First layer: 32 neurons, expecting 4 inputs (temperature, humidity, wind, pressure)
    tf.keras.layers.Dense(32, activation='relu', input_shape=(4,)),
    # Second layer: 16 neurons
    tf.keras.layers.Dense(16, activation='relu'),
    # Output layer: 3 neurons (predicting wind next hour, wave next hour, and rain next hour)
    tf.keras.layers.Dense(3)  # Output size is 3 for wind, wave, rain
])

# Configure the learning process
model.compile(optimizer='adam', loss='mse')
print("Model built successfully.")

os.makedirs('assets/models', exist_ok=True)

# Convert the trained model to TensorFlow Lite format so it can run efficiently on mobile
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open('assets/models/weather_model.tflite', 'wb') as f:
    f.write(tflite_model)
    
print("TFLite model saved to assets/models/weather_model.tflite")
