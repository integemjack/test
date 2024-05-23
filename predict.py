import os
import json
import tensorflow as tf
import tkinter as tk
from PIL import Image, ImageTk
import cv2
import numpy as np

VIDEO_WIDTH = 1280
VIDEO_HEIGHT = 720

# load class names
with open(os.path.join("models", "class_names.json"), "r") as f:
    class_names = json.load(f)

# load model
model = tf.keras.models.load_model(os.path.join("models", "my_model.keras"))
# confirm that your model's input size is correct
input_width, input_height = 224, 224

# initialize Tkinter window
window = tk.Tk()
screen_width = window.winfo_screenwidth()
screen_height = window.winfo_screenheight()
x = (screen_width - VIDEO_WIDTH) / 2
y = (screen_height - VIDEO_HEIGHT) / 2
window.geometry("%dx%d+%d+%d" % (VIDEO_WIDTH, VIDEO_HEIGHT + 50, x, y))
window.title("Camera with TensorFlow Prediction")

# add a label to display the camera frame
label = tk.Label(window)
label.pack()


def close():
    # release camera
    cap.release()
    window.quit()
    window.destroy()


# add a button to close the window
button = tk.Button(window, text="Exit", width=20, pady=5, command=close)
button.pack()

# initialize camera
cap = cv2.VideoCapture(0)


def update_frame():
    # get a frame from the video source
    ret, frame = cap.read()
    if ret:
        processed_frame = cv2.resize(frame, (input_width, input_height))
        processed_frame = np.expand_dims(processed_frame, axis=0)

        prediction = model.predict(processed_frame)
        print(prediction)

        # show prediction result on camera frame
        percentage = np.max(prediction, axis=1)[0] * 100
        prediction_text = f"Prediction: {class_names[np.argmax(prediction, axis=1)[0]]}, {percentage:.2f}%"
        # put text on frame
        cv2.putText(frame, prediction_text, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

        display_frame = cv2.resize(frame, (VIDEO_WIDTH, VIDEO_HEIGHT))

        # turn OpenCV format to Tkinter format
        cv2image = cv2.cvtColor(display_frame, cv2.COLOR_BGR2RGBA)
        img = Image.fromarray(cv2image)
        imgtk = ImageTk.PhotoImage(image=img)

        label.imgtk = imgtk
        label.configure(image=imgtk)

    # update every 20ms
    window.after(20, update_frame)


update_frame()

# start Tkinter mainloop
window.mainloop()
