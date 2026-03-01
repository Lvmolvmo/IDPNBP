
function c = object_function(I_original, a, b, w, PatchSize)
    [~, J, ~, ~] = dehaze_run(I_original, a, b, w, PatchSize);
    [h, wd, ~] = size(J);
    J_gray = rgb2gray(J);

    
    J_all_mean_values = []; 
    I_all_mean_values = []; 

    J_block_count = 0; 
    for i = 1:PatchSize:h-PatchSize+1
        for j = 1:PatchSize:wd-PatchSize+1
            J_block_count = J_block_count + 1;
     
            J_Patch = J(i:i+PatchSize-1, j:j+PatchSize-1, :);
        
            
            J_total_mean = mean(J_Patch(:)); 
       
         
            J_all_mean_values(J_block_count) = J_total_mean;
        end
    end
    
    I_block_count = 0; 
    for i = 1:PatchSize:h-PatchSize+1
        for j = 1:PatchSize:wd-PatchSize+1
            I_block_count = I_block_count + 1; 
           
            I_Patch = I_original(i:i+PatchSize-1, j:j+PatchSize-1, :);
        
            
            I_total_mean = mean(I_Patch(:)); 

            I_all_mean_values(I_block_count) = I_total_mean;
        end
    end
    
    
    [counts_original, edges] = histcounts(I_all_mean_values, 50, 'Normalization', 'probability');
    [counts_translated, ~] = histcounts(J_all_mean_values, edges, 'Normalization', 'probability');
    
    
    counts_original = counts_original + eps;
    counts_translated = counts_translated + eps;
    
    
    kl_divergence = sum(counts_original .* log2(counts_original ./ counts_translated));
    
    
    entropy_value = -sum(counts_translated .* log2(counts_translated));
    
    
    c1 = mean(J_all_mean_values);
    center_deviation = abs(c1 - 0.5);
    
    
    alpha = 5;  
    beta = 500;   
    gamma = 1; 
    
    c = alpha * kl_divergence + beta * (1/entropy_value) + gamma * center_deviation;
end


% function c = object_function(I_original, a, b, w, PatchSize)
%     [J, ~, ~, ~] = dehaze_run(I_original, a, b, w, PatchSize);
%     [h, wd, ~] = size(J);
%     J_gray = rgb2gray(J);
% 
%     % 初始化平均通道
%     all_mean_values = []; % 存储所有块的平均亮度值的一维数组
%     
%     % 遍历图像的每个局部块
%     block_count = 0; % 块计数器
%     for i = 1:PatchSize:h-PatchSize+1
%         for j = 1:PatchSize:wd-PatchSize+1
%             block_count = block_count + 1; % 增加块计
%             % 获取局部块
%             Patch = J(i:i+PatchSize-1, j:j+PatchSize-1, :);
%         
%             % 计算所有通道所有像素的平均亮度值
%             total_mean = mean(Patch(:)); % 整个块所有像素的均值
%        
%             % 将总平均值存入一维数组
%             all_mean_values(block_count) = total_mean;
%         end
%     end
%     
%     % 计算原始平均值并平移至0.5中心
%     c1 = mean(all_mean_values);
%     c2 = 0.5;
%     all_mean_values_translated = all_mean_values + (c2 - c1);
%     
%     % 检查平移后的最小值
%     m =min(all_mean_values_translated);
%     k = (0.5 - m) /0.4 ;
% 
%     % 最大化膨胀因子k
%     c = k;
% 
%     %c=var(all_mean_values);
% end