import cv2
import tkinter as tk
from PIL import Image, ImageTk


# create a window class
class App:
    def __init__(self, window, window_title, video_source=0):
        self.photo = None
        self.window = window
        self.window.title(window_title)
        self.video_source = video_source

        # open video source (by default this will try to open the computer webcam)
        self.vid = cv2.VideoCapture(video_source)

        # create a canvas that can fit the above video source size
        self.canvas = tk.Canvas(window, width=self.vid.get(cv2.CAP_PROP_FRAME_WIDTH),
                                height=self.vid.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.canvas.pack()

        # update and draw video frames
        self.update()
        self.window.mainloop()

    def update(self):
        # get a frame from the video source
        ret, frame = self.vid.read()
        if ret:
            # use PIL library to convert OpenCV image format to Tkinter acceptable format
            self.photo = ImageTk.PhotoImage(image=Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)))
            self.canvas.create_image(0, 0, image=self.photo, anchor=tk.NW)

        # update every 15 ms
        self.window.after(15, self.update)

    # release the video source when the object is destroyed
    def __del__(self):
        if self.vid.isOpened():
            self.vid.release()


# create a window and run the app
root = tk.Tk()
app = App(root, "Teachable Machine - Image Classification")
