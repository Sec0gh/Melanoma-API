import cv2
import numpy as np
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, Conv2D, MaxPool2D
from keras.layers import BatchNormalization

model = Sequential()
        
# [+] 1st convolutional layer
model.add(Conv2D(filters = 96,
                kernel_size = (11, 11),
                strides = (4, 4),
                activation = 'relu',
                input_shape = (100, 100, 3)))
model.add(BatchNormalization())
model.add(MaxPool2D(pool_size = (3, 3), strides = (2, 2)))

# [+] 2nd convolutional layer
model.add(Conv2D(filters = 256,
                kernel_size=(5, 5),
                strides=(1, 1),
                activation = 'relu',
                padding = "same"))
model.add(BatchNormalization())
model.add(MaxPool2D(pool_size = (3, 3), strides = (2, 2)))

# [+] 3rd convolutional layer
model.add(Conv2D(filters = 384,
                 kernel_size=(3,3),
                 strides=(1,1),
                 activation='relu',
                 padding="same"))
model.add(BatchNormalization())

# [+] 4th convolutional layer
model.add(Conv2D(filters = 384,
                kernel_size = (1, 1), 
                strides = (1, 1), 
                activation = 'relu', 
                padding = "same"))
model.add(BatchNormalization())

# [+] 5th convolutional layer
model.add(Conv2D(filters = 256, 
                kernel_size = (1, 1),
                strides = (1, 1),
                activation = 'relu',
                padding = "same"))
model.add(BatchNormalization())
model.add(MaxPool2D(pool_size = (3, 3), strides = (2, 2)))        
model.add(Flatten())

# [+] 6th, Dense layer:
model.add(Dense(4096, activation = 'relu'))
model.add(Dropout(0.5))
              
# [+] 7th Dense layer
model.add(Dense(4096, activation = 'relu'))
model.add(Dropout(0.5))
              
# [+] 8th output layer
model.add(Dense(7, activation = 'softmax'))
model.load_weights('modelv7.h5')


def classify_image(uploaded_image):
    image = cv2.imread("./uploads/" + uploaded_image)
    image = cv2.resize(image, (100, 100))
    image = np.expand_dims(image, axis=0)
    probabilities = model.predict(image)[0]
    predicted_class_indices = np.argsort(probabilities)[::-1]
    predicted_classes_prob = {}
    highest_prob = 0
    predicted_class = ''
    lesion_names = ['Melanocytic nevus','Malignant melanoma','Benign keratosis','Basal cell carcinoma','Actinic keratosis', 'Vascular lesion','Dermatofibroma']
    for i in range(len(predicted_class_indices)):
        class_name = lesion_names[predicted_class_indices[i]]
        prob = round(probabilities[predicted_class_indices[i]] * 100, 2)
        predicted_classes_prob[class_name] = prob
        if prob > highest_prob:
            highest_prob = prob
            predicted_class = class_name
    
    result = {
        "predicted class": predicted_class,
        "highest probability": highest_prob,
        "probabilities": predicted_classes_prob
    }
    
    return result
