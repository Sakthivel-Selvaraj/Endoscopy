function endoscopic_image(input_path)
field_directory=dir(input_path);
mkdir([input_path '\' 'output' '\']);
mkdir([input_path '\' 'input' '\']);
addpath('F:\endoscope_data\');
flag_field_odd=0;
flag_field_even=0;
image_name=1;
sequence = 32130:32140;
count=0;
combinefield=zeros(766,961,'uint16');
weaving = combinefield;
nrows = 383;
for ii = sequence(1:2)
    img = uint16(readdat(num2str(ii)));
%     if mod(ii,2)==0
%         even_field=img;
%     else
%         odd_field=img;
%     end
    
    count = count + 1;
    
    
    idx = mod(ii,2);  % 0=>even, 1=>odd
    if idx==0
        idx=2;     % 1 => odd, 2=> even
    end
    if count == 1
        combinefield(idx:2:end,:)=img;
    end
    weaving(idx:2:end,:)=img;
    if count > 1
        if idx == 2
            combinefield(2,:)=img(1,:);
            for ri=2:nrows-1
                V = img(ri,:); % new input
                A = combinefield(2*ri-1,:); % 2*ri-idx+1
                G = combinefield(2*ri+1,:);
                M1 = max(A,G);
                M2 = min(A,G);
                V(V>M1)=M1(V>M1);
                V(V<M2)=M2(V<M2);
                combinefield(2*ri,:)=V;
            end
        else
            for ri=2:nrows
                V = img(ri,:); % new input
                A = combinefield(2*ri-2,:);
                G = combinefield(2*ri,:);
                M1 = max(A,G);
                M2 = min(A,G);
                V(V>M1)=M1(V>M1);
                V(V<M2)=M2(V<M2);
                combinefield(2*ri-1,:)=V;
            end            
        end
    end
end
     
for field_count=1:size(field_directory,1)/2
    file_exist=field_directory(field_count).isdir;
    if file_exist==0
        field_name_odd=field_directory(field_count+flag_field_odd).name;
        flag_field_odd=flag_field_odd+1;
        field_name_even=field_directory(field_count+flag_field_even+1).name;
        flag_field_even=flag_field_even+1;
        odd_field=uint16(readdat(field_name_odd));
        even_field=uint16(readdat(field_name_even));
    flag=1;
    %% flag variable m&n for combining odd and even field
    m=0;
    n=0;
    
    combinedfield=zeros(766,961,'like',even_field);
    combinedfield(1:2:end,:)=odd_field;
    combinedfield(2:2:end,:)=even_field;
    imwrite(uint16(combinedfield),[input_path '\input\' num2str(image_name) '.png']);
%     for ii=1:size(odd_field,1)
%         combinedfield(ii+m,:)=odd_field(flag,:);
%         m=m+1;
%         combinedfield(ii+n+1,:)=even_field(flag,:);
%         n=n+1;
%         flag=flag+1;
%     end
%     Applying vertical temporal median filtering in a frame
   m1=0;
    for k=1:size(odd_field,1)-1
        deinterlacing=combinedfield(k+m1:k+2+m1,:);
        m1=m1+1;
        median_even_field=median(deinterlacing);
        deinterlacing(2,:)=median_even_field;
        if k==1
            final=deinterlacing(1:2,:);
        end
        if k>1
            final=vertcat(final,deinterlacing(1:2,:));
        end     
    end
    imwrite(uint16(final),[input_path '\output\' num2str(image_name) '.png']);
    image_name=image_name+1;
    end
end