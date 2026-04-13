import tensorflow as tf
import numpy as np
import os

# Create a blank neural network model using Keras
model = tf.keras.Sequential([
    # First hidden layer with 16 neurons. Input shape is 3 (temperature, chlorophyll, sea height)
    tf.keras.layers.Dense(16, activation='relu', input_shape=(3,)),
    # Second hidden layer with 8 neurons
    tf.keras.layers.Dense(8, activation='relu'),
    # Output layer with 1 neuron (probability between 0 and 1)
    tf.keras.layers.Dense(1, activation='sigmoid') # Sigmoid for probability 0-1
])

# Configure the learning process
model.compile(optimizer='adam', loss='mse', metrics=['mae'])
print("PFZ Model built successfully.")

# Ensure directory exists
os.makedirs('assets/models', exist_ok=True)

# Convert the trained Keras model to TensorFlow Lite format for use in the mobile app
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

tflite_path = 'assets/models/pfz_model.tflite'
with open(tflite_path, 'wb') as f:
    f.write(tflite_model)
    
print(f"PFZ TFLite model saved to {tflite_path}")
