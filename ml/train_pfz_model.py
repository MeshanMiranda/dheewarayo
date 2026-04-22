import tensorflow as tf
import numpy as np
import os


model = tf.keras.Sequential([
    tf.keras.layers.Dense(16, activation='relu', input_shape=(3,)),
    tf.keras.layers.Dense(8, activation='relu'),
    tf.keras.layers.Dense(1, activation='sigmoid')
])

model.compile(optimizer='adam', loss='mse', metrics=['mae'])
print("PFZ Model built successfully.")

os.makedirs('assets/models', exist_ok=True)

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

tflite_path = 'assets/models/pfz_model.tflite'
with open(tflite_path, 'wb') as f:
    f.write(tflite_model)
    
print(f"PFZ TFLite model saved to {tflite_path}")
