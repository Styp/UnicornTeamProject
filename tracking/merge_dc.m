function [method_out, label_out] = merge_dc(bb_all, method, label)
    % ####################  merge_dc  #################################
    %
    % This function merges bounding boxes by just changing their method
    % and label. No bounding box is being deleted here! But by changing the
    % method to -1 it is no longer  ploted into the frame. Merging to 
    % boxes therefor means to set the method of one to -1 and for the other
    % for example to 12 or 13.
    % 
    % The method numbers mean the following
    %   1: detected by deep learning
    %   2: detected hough circle detection
    %   3: detected by hough triangle down detection
    %   12: 1 and 2 merged ("solid")
    %   21: former 1 and 2 merged and tracked 
    %   13: 1 and 3 merged ("solid")
    %   31: former 1 and 3 merged and tracked
    
    % Number of bounding boxes
    N = size(bb_all,1);
    
    % Only merge if there are boxes to merge.
    if N>0
    label_out = cellstr(label);
    method_out = method;
    
    % Areas of the bounding boxes
    A = bb_all(:,3).*bb_all(:,4);   
    
    % Compute Am which is a NxN Matrix with the normalized shared area on
    % the upper triangle and zeros on the rest
    Am = zeros(N,N);
    bbm = zeros(N,N,4);
    bbd = zeros(N,N,4);    
    for i = 1:N
        for j=1+i:N
            bbm(i,j,:) = [max([bb_all(i,1),bb_all(j,1)]), max([bb_all(i,2),bb_all(j,2)]), max(0, min([bb_all(i,1)+bb_all(i,3),bb_all(j,1)+bb_all(j,3)]) - max([bb_all(i,1),bb_all(j,1)])), max(0, min([bb_all(i,2)+bb_all(i,4),bb_all(j,2)+bb_all(j,4)]) - max([bb_all(i,2),bb_all(j,2)]))];
            bbd(i,j,:) = [min([bb_all(i,1),bb_all(j,1)]), min([bb_all(i,2),bb_all(j,2)]), max(0, max([bb_all(i,1)+bb_all(i,3),bb_all(j,1)+bb_all(j,3)]) - min([bb_all(i,1),bb_all(j,1)])), max(0, max([bb_all(i,2)+bb_all(i,4),bb_all(j,2)+bb_all(j,4)]) - min([bb_all(i,2),bb_all(j,2)]))];
            Am(i,j) = bbm(i,j,3)*bbm(i,j,4)/(0.5*(A(j)+A(i))); 
        end
    end
    
    % Check the upper triangle for normalized shared areas >=0.5 and merge
    % by changing the method number.  
    for i = 1:N
        for j=1+i:N
            if Am(i,j)>=0.4
                %% merging 1
                if method(i,1) == 2 && method(j,1) == 1      
                    i_d = j;
                    i_c = i;
                    method_out(i_d,1) = -1;
                    method_out(i_c,1) = 12;
                    label_out{i_c,1} = char(label(i_d,1));
                elseif method(j,1) == 2 && method(i,1) == 1    
                    i_d = i;
                    i_c = j;
                    method_out(i_d,1) = -1;
                    method_out(i_c,1) = 12;
                    label_out{i_c,1} = char(label(i_d,1));
                %% merging 3
                elseif method(i,1) == 3 && method(j,1) == 1      
                    i_d = j;
                    i_t = i;
                    method_out(i_d,1) = -1;
                    method_out(i_t,1) = 13;
                    label_out{i_t,1} = char(label(i_d,1));
                elseif method(j,1) == 3 && method(i,1) == 1    
                    i_d = i;
                    i_t = j;
                    method_out(i_d,1) = -1;
                    method_out(i_t,1) = 13;
                    label_out{i_t,1} = char(label(i_d,1));
                %% merging 21
                elseif method(j,1) == 21 && method(i,1) == 1     
                    method_out(j,1) = -1;                    
                    method_out(i,1) = 12;
                elseif method(j,1) == 1 && method(i,1) == 21
                    method_out(i,1) = -1;                    
                    method_out(j,1) = 12;                    
                elseif method(j,1) == 21 && method(i,1) == 2
                    method_out(i,1) = 12;
                    label_out{i,1} = char(label(j,1));
                    method_out(j,1) = -1;
                elseif method(j,1) == 2 && method(i,1) == 21
                    method_out(j,1) = 12;
                    label_out{j,1} = char(label(i,1));
                    method_out(i,1) = -1;                       
                elseif method(j,1) == 21 && method(i,1) == 3
                    method_out(j,1) = -1;                      
                elseif method(j,1) == 3 && method(i,1) == 21
                    method_out(i,1) = -1;
                elseif method(j,1) == 12 && method(i,1) == 21
                    method_out(i,1) = -1;
                elseif method(j,1) == 21 && method(i,1) == 12
                    method_out(j,1) = -1;
                %% merging 31           
                elseif method(j,1) == 31 && method(i,1) == 1     
                    method_out(j,1) = 13;
                    label_out{j,1} = char(label(i,1));                    
                    method_out(i,1) = -1;
                elseif method(j,1) == 1 && method(i,1) == 31
                    method_out(i,1) = 13;
                    label_out{i,1} = char(label(j,1));                    
                    method_out(j,1) = -1;                    
                elseif method(j,1) == 31 && method(i,1) == 3
                    method_out(j,1) = 13;
                    method_out(i,1) = -1;                    
                elseif method(j,1) == 3 && method(i,1) == 31
                    method_out(i,1) = 13;
                    method_out(j,1) = -1;                       
                elseif method(j,1) == 31 && method(i,1) == 2
                    method_out(j,1) = -1;                      
                elseif method(j,1) == 2 && method(i,1) == 31
                    method_out(i,1) = -1;
                elseif method(j,1) == 13 && method(i,1) == 31
                    method_out(i,1) = -1;
                elseif method(j,1) == 31 && method(i,1) == 13
                    method_out(j,1) = -1;
                end
            end
        end
    end
    % Output
    label_out = categorical(label_out);
    else
        method_out = [];
        label_out = categorical();
    end   
end

