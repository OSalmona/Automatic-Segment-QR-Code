function [  ] = QRextraction( Rimg )
    %pkg load image
    %pkg load statistics
    Rimg = imread('TestCases/Case_Main/7.1.bmp');
    figure,imshow(Rimg);
    img = rgb2gray(Rimg);
    
    %image preparing
    img = imsharpen(img,'Radius',10,'Amount',1);   
    img = ~im2bw(img);
    %figure,imshow(img); 
    img = bwFix(img);
    figure,imshow(img); 
    
    [L num] = bwlabel(img);
    RP = regionprops(L,'all');
    hit = QRkey(img,L,RP);
    hit = [hit;QRkey(imrotate(img, -45),imrotate(L, -45),RP)];%the extra line 
    hit = [unique(hit) histc(hit,unique(hit))]
    
    [row ~]=size(hit);
    flag = zeros(row);
    for i = 1:(row)-1
        j = i+1;
        if flag(i)==1 || flag(j)==1
            continue;
        end
        ci = RP(hit(i,1)).Centroid;
        cj = RP(hit(j,1)).Centroid;
        for k = 1:(row)
            if i == k || j == k || flag(k)==1 
                continue;
            end
            ck = RP(hit(k,1)).Centroid;
            a = pdist([ci ; cj],'euclidean');
            b = pdist([ci ; ck],'euclidean');
            c = pdist([cj ; ck],'euclidean');
            if c<a || c<b
                continue;
            end
            diff = cj - ci;
            d = ck+diff;
            zz = abs((a*a + b*b)-(c*c))/(c*c);
            center = ((cj+ci+ck+d)/4);
            if zz < 0.1 
                x = [cj(1);ci(1);ck(1);d(1)];
                y = [cj(2);ci(2);ck(2);d(2)];
                x = x+(x-center(1))*0.6;
                y = y+(y-center(2))*0.6;
                
                flag(i)=1;flag(j)=1;flag(k)=1;
                figure,imshow(CropQR( Rimg , [x y]));
                break;              
            end
        
        end
    end
    
end

