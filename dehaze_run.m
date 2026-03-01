function [Jj, J_wt, I_mean, t, guided_t] = dehaze_run(I, a, b, w, PatchSize)
    [h, wd, ~] = size(I);
    I_gray = rgb2gray(I);
    
  
    I_mean = zeros(h, wd); 
    I_mean_rgb = zeros(h, wd, 3); 
    

    block_count = 0; 
    for i = 1:PatchSize:h-PatchSize+1
        for j = 1:PatchSize:wd-PatchSize+1
            block_count = block_count + 1; 
            
           
            Patch = I(i:i+PatchSize-1, j:j+PatchSize-1, :);
            
            
            mean_r = mean2(Patch(:,:,1)); 
            mean_g = mean2(Patch(:,:,2));
            mean_b = mean2(Patch(:,:,3));
            
            
            total_mean = mean(Patch(:)); 
            
            
            I_mean_rgb(i:i+PatchSize-1, j:j+PatchSize-1, 1) = mean_r;
            I_mean_rgb(i:i+PatchSize-1, j:j+PatchSize-1, 2) = mean_g;
            I_mean_rgb(i:i+PatchSize-1, j:j+PatchSize-1, 3) = mean_b;
            
            
            I_mean(i:i+PatchSize-1, j:j+PatchSize-1) = total_mean;
            J_wt(i:i+PatchSize-1, j:j+PatchSize-1)=a*(1-1./(1+b.*I(i:i+PatchSize-1, j:j+PatchSize-1)));

        end
    end
    
    
    
    J_mean=a*(1-1./(1+b.*I_mean));
    J_wt=a*(1-1./(1+b.*I)); 
    
 
    
    [~, idx] = max(I_mean(:));
    [max_h, max_w] = ind2sub(size(I_mean), idx);
    A = squeeze(I_mean_rgb(max_h, max_w, :))';

    A_norm = norm(A);
   
    A = A / A_norm;
    A=A * w;

    t = zeros(h, wd, 3);
    for k = 1:3
        t(:,:,k)=(I_mean./A(k)-1)./(J_mean-1);
    end
    t = max(min(t, 1), 0.1); 
    
    for k = 1:3
        J(:,:,k) = (I(:,:,1)./A(k)./t(:,:,k)+1);
        
    end
    
    
    guided_t = zeros(size(t));
    r = round(150 * (size(I,1)/500));
    eps = 0.01;
    
    for k = 1:3
        guided_t(:,:,k) = guidedfilter(I_gray, t(:,:,k), r, eps);
    end
    
    
    Jj = zeros(size(I));
    for k = 1:3
        Jj(:,:,k) = (I(:,:,k) ./ A(k) + guided_t(:,:,k) - 1) ./ guided_t(:,:,k);
    end
    Jj = max(min(Jj, 1), 0); 
end