import tensorflow as tf
import numpy as np
import os

model = tf.keras.Sequential([
    tf.keras.layers.Dense(32, activation='relu', input_shape=(4,)),
    tf.keras.layers.Dense(16, activation='relu'),
    tf.keras.layers.Dense(3)
])

model.compile(optimizer='adam', loss='mse')
print("Model built successfully.")

os.makedirs('assets/models', exist_ok=True)

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open('assets/models/weather_model.tflite', 'wb') as f:
    f.write(tflite_model)
    
print("TFLite model saved to assets/models/weather_model.tflite")
