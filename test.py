import os
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator

# load model
model = tf.keras.models.load_model(os.path.join("models", "my_model.h5"))

# prepare test data generator with the same preprocessing function as training
test_datagen = ImageDataGenerator(
    preprocessing_function=tf.keras.applications.mobilenet_v3.preprocess_input
)

test_generator = test_datagen.flow_from_directory(
    'data/green',  # test data directory path
    target_size=(224, 224),  # image will be resized to (224, 224)
    batch_size=32,  # batch size depends on your test set size
    class_mode='categorical',  # use categorical mode because we have multiple classes
    shuffle=False  # don't shuffle test data
)

# use test data to evaluate the model
eval_result = model.evaluate(test_generator)
print(f"Test Loss: {eval_result[0]}, Test Accuracy: {eval_result[1]}")

predictions = model.predict(test_generator)
print(predictions)
print(np.argmax(predictions, axis=1))