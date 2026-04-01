import tensorflow as tf
import numpy as np
import os

# Set random seed for reproducibility
np.random.seed(42)
tf.random.set_seed(42)

# Generate synthetic data for Potential Fishing Zone (PFZ)
# Inputs:
# - Sea Surface Temperature (SST): typical range 20-35 C
# - Chlorophyll-a (chl_a): typical range 0.0 - 10.0 mg/m^3
# - Sea Surface Height anomaly (SSH): typical range -1.0 to 1.0 m

num_samples = 5000

# Generate input features
sst = np.random.uniform(20.0, 35.0, num_samples)
chl_a = np.random.uniform(0.0, 10.0, num_samples)
ssh = np.random.uniform(-1.0, 1.0, num_samples)

# Generate target variable (Probability of PFZ: 0.0 to 1.0)
# A simple heuristic for PFZ:
# High probability if SST is exactly optimal (e.g., 26-29°C for Tuna/Pelagic fish)
# High probability if Chlorophyll-a is moderate to high (> 0.5) indicating phytoplankton
# High probability if SSH is slightly positive or neutral (-0.2 to 0.5), indicating convergence or upwelling boundaries
def calculate_pfz_prob(t, c, s):
    prob = 0.0
    
    # Temperature component (closer to 27.5 is better)
    temp_diff = abs(t - 27.5)
    temp_score = max(0.0, 1.0 - (temp_diff / 5.0)) # 1.0 at 27.5, drops to 0 at <= 22.5 or >= 32.5
    
    # Chlorophyll component (higher is generally better, up to a point)
    chl_score = min(1.0, c / 4.0)
    
    # SSH component (optimal around 0.1)
    ssh_diff = abs(s - 0.1)
    ssh_score = max(0.0, 1.0 - (ssh_diff / 0.8))
    
    # Combine scores (weights: temp 40%, chl 40%, ssh 20%)
    prob = (temp_score * 0.4) + (chl_score * 0.4) + (ssh_score * 0.2)
    
    # Add some noise
    prob += np.random.normal(0, 0.05)
    return max(0.0, min(1.0, prob))

pfz_prob = np.array([calculate_pfz_prob(t, c, s) for t, c, s in zip(sst, chl_a, ssh)])

X = np.stack([sst, chl_a, ssh], axis=1)
y = pfz_prob

# Build the model using Keras
model = tf.keras.Sequential([
    # First hidden layer with 16 neurons. Input shape is 3 (temperature, chlorophyll, sea height)
    tf.keras.layers.Dense(16, activation='relu', input_shape=(3,)),
    # Second hidden layer with 8 neurons
    tf.keras.layers.Dense(8, activation='relu'),
    # Output layer with 1 neuron (probability between 0 and 1)
    tf.keras.layers.Dense(1, activation='sigmoid') # Sigmoid for probability 0-1
])

# Configure the model for training (using Adam optimizer and Mean Squared Error for loss)
model.compile(optimizer='adam', loss='mse', metrics=['mae'])

print("Training PFZ model...")
model.fit(X, y, epochs=100, batch_size=32, verbose=1, validation_split=0.1)
print("Training complete.")

# Ensure directory exists
os.makedirs('assets/models', exist_ok=True)

# Convert the trained Keras model to TensorFlow Lite format for use in the mobile app
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

tflite_path = 'assets/models/pfz_model.tflite'
with open(tflite_path, 'wb') as f:
    f.write(tflite_model)
    
print(f"TFLite model saved to {tflite_path}")
