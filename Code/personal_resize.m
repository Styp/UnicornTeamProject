function image = personal_resize(image)

im_size = size(image);
  
 resize = 600/im_size(1);
 
 image = imresize(image,resize);
end