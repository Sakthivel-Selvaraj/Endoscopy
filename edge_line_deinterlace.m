function edge_line_deinterlace(input_path)
addpath('/home/htic1/sakthivel/endoscopy/');
sequence=32115;
combinefield=zeros(766,961,'uint16');
%% 

for i=sequence
    if mod(i,2)~=0
        field=uint16(readdat(num2str(i)));
        combinefield(1:2:end,:)=field;
        m1=0;
%         for k=1:size(combinefield,1)-1
        for k=1:382
        deinterlacing=combinefield(k+m1:k+2+m1,:);
        m1=m1+1;
        %Edge line deinterlacing
        for j=1:size(deinterlacing,2)
            if j==1
                ela(:,j)=(deinterlacing(1,1)+deinterlacing(3,1))/2;
            end
            if j==961
                ela(:,j)=(deinterlacing(1,961)+deinterlacing(3,961))/2;
            end
            if j>1&&j<961
%                for j=2:960
                  edge=double(deinterlacing(1:3,j-1:j+1));
                  edgeA=edge(1,1);edgeB=edge(1,2);edgeC=edge(1,3);
                  edgeD=edge(3,1);edgeE=edge(3,2);edgeF=edge(3,3);
                  Xa=(edgeA+edgeF)/2;
                  Xb=(edgeB+edgeE)/2;
                  Xc=(edgeC+edgeD)/2;
                  if abs(edgeA-edgeF)<abs(edgeC-edgeD)&&abs(edgeA-edgeF)<abs(edgeB-edgeE)
                      X=Xa;
                  elseif abs(edgeC-edgeD)<abs(edgeA-edgeF)&&abs(edgeC-edgeD)<abs(edgeB-edgeE)
                      X=Xc;
                  else
                      X=Xb;
                   end
                  ela(:,j)=X;
%                end
            end
        end
        deinterlacing(2,:)=ela;
        
        if k==1
            final=deinterlacing(1:2,:);
        else
            final=vertcat(final,deinterlacing(1:2,:));
        end     
        end
    end
    
    FA = imresize(field,[766 961],'bilinear');
    FA = FA(2:end-1,:);
end

end
        
        
    