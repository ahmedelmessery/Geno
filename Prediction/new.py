import pickle

# # Create a variable
# myvar = [{'This': 'is', 'Example': 1}, 'of',
#          'serialisation', ['using', 'pickle']]

# # Use dumps() to make it serialized
# serialized = pickle.dumps(myvar)

# print(serialized)


# binary_string = b'\x80\x04\x95K\x00\x00\x00\x00\x00\x00\x00]\x94(}\x94(\x8c\x04This\x94\x8c\x02is\x94\x8c\x07Example\x94K\x01u\x8c\x02of\x94\x8c\rserialisation\x94]\x94(\x8c\x05using\x94\x8c\x06pickle\x94ee.'

# # Use loads to load the variable
# myvar = pickle.load(binary_string)

# print(myvar)


with open('c:/Users/Nadee/Desktop/final_project/Prediction/model1.picl', 'rb') as myfile:
    print('this is my file')
    print(myfile)
    model = pickle.load(myfile)
