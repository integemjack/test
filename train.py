import os
import json
import warnings
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV3Small
from tensorflow.keras.layers import GlobalAveragePooling2D, Dense
from tensorflow.keras.models import Model

import ssl
# ignore SSL certificate verification
ssl._create_default_https_context = ssl._create_unverified_context

# ignore warnings
warnings.filterwarnings('ignore')

# Assuming you have a 'data' directory with subdirectories for each class
# e.g., 'data/class1', 'data/class2', ..., 'data/classN'

# 1. prepare data generator with appropriate preprocessing
train_datagen = ImageDataGenerator(
    preprocessing_function=tf.keras.applications.mobilenet_v3.preprocess_input
)

train_generator = train_datagen.flow_from_directory(
    'data',  # train data directory path
    target_size=(224, 224),  # image will be resized to (224, 224)
    batch_size=32,  # batch size depends on your test set size
    class_mode='categorical'  # because we have multiple classes
)

# 2. load pre-trained MobileNetV3 models without top layer
base_model = MobileNetV3Small(weights='imagenet', include_top=False, input_shape=(224, 224, 3))

# freeze base models layers
base_model.trainable = False

# 3. build transfer learning models
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(1024, activation='relu')(x)  # 可以根据需要添加更多的层
predictions = Dense(train_generator.num_classes, activation='softmax')(x)  # 输出层

model = Model(inputs=base_model.input, outputs=predictions)

# compile models
model.compile(optimizer='adam',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

# 4. train models
model.fit(
    train_generator,
    epochs=5  # 可以根据需要调整
)

class_names = list(train_generator.class_indices.keys())
# output class names to a  json file
with open(os.path.join("models", "class_names.json"), "w") as f:
    json.dump(class_names, f)

# save models
model.save(os.path.join("models", "my_model.keras"))
# model.save(os.path.join("models", "my_model.h5"))

model.summary()

print("Done!")

