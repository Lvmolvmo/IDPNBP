
clc;
clear all;
close all;


input_folder = 'input';
output_folder = 'output';


if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end


file_list = dir(fullfile(input_folder, '*.jpg'));


PatchSize = 55;
a_bounds = [0,3];     
b_bounds = [0,2];     
w_bounds = [0.8,1.70]; 
tol = 0.001;        
max_iter =50;        


for i = 1:length(file_list)
   
    filename = file_list(i).name;
    I_original = double(imread(fullfile(input_folder, filename))) / 255;
    
   
    I = imresize(I_original, 0.5); 
    [height, width, ~] = size(I);
    
  
    a0 = 0.5;
    b0 = 1;
    w0 = 0.5;
    
  
    for iter = 1:max_iter
       
        f_a = @(a) -object_function(I, a, b0, w0, PatchSize);
        a_new = golden_section_search(f_a, a_bounds(1), a_bounds(2), tol);
        
       
        f_b = @(b) -object_function(I, a_new, b, w0, PatchSize);
        b_new = golden_section_search(f_b, b_bounds(1), b_bounds(2), tol);
        
       
        f_w = @(w) -object_function(I, a_new, b_new, w, PatchSize);
        w_new = golden_section_search(f_w, w_bounds(1), w_bounds(2), tol);
        
       
        if abs(a_new - a0) < tol && abs(b_new - b0) < tol && abs(w_new - w0) < tol
            break;
        end
        
       
        a0 = a_new;
        b0 = b_new;
        w0 = w_new;
    end
    
    
    fprintf('Processing %s: Optimal parameters: a=%.4f, b=%.4f, w=%.4f\n', filename, a0, b0, w0);
    
    
    [J_final, J_wt, I_mean, t, guided_t] = dehaze_run(I_original, a0, b0, w0, PatchSize);
    
    
    [~, name, ext] = fileparts(filename);
    
    
    imwrite(I_original, fullfile(output_folder, [name '_original' ext]));
    
    
    imwrite(J_wt, fullfile(output_folder, [name '_no_asm' ext]));
    
   
    %imwrite(guided_t, fullfile(output_folder, [name '_transmission' ext]));
   
    imwrite(J_final, fullfile(output_folder, [name '_dehazed' ext]));
end

fprintf('Batch processing completed. All results saved to %s\n', output_folder);