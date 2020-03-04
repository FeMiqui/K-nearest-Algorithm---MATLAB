%{
    author: Fellipe Sho Miqui
    class: BENG420
    version: 1.0.0
    Size of the data used: 8000 samples
%}

clear all;clc;
data = load("data_in_txt_format.txt");
x = data.features(:,1); %x axis
y = data.features(:,2); %y axis
lab = data.classlabels;
%{
    figure;
    plot(x,y,"o"); %Plotting the graph overall
    title("Overall Graph");
    xlabel("x_(data)");
    ylabel("y_(data)");
%}
%-------------------------END of the first Graph --------------------------

%b)
figure;
hold on;
%separating the data based on their classification
for i=1:length(data.features)
    if lab(i)==1
        plot(x(i),y(i),"g*"); %Monster colors
    else
        plot(x(i),y(i),"ko");
    end
end
title("Graph with two data represented");
xlabel("x");
ylabel("y");
legend("label1", "label2");
%------------------------END OF THE FIGURE WITH LABELS---------------------


%This will calculate the Best K in the interval between 150 and 180 (random sampling)
errors = zeros(80,1);
for i= 150:180
    for k=1:80
        class = shortestDistance(x(i),y(i),x(1:500),y(1:500),lab(1:500),k);
        if class~=lab(i)
           errors(k) = errors(k)+ 1;
        end
    end
end

%{
    [V,K] = min(A)
    where V - is the min value
    and K - is index of the minimum value, or the KMM
%}
figure;
plot((1:80),(errors/length(errors))*100); 
title("Errors based on K");
xlabel("K");
ylabel("error percentage(%)");

[V,K] = min(errors); 


%Validation dataset:

errors2 = 0;
k = 1;
for i= 4001:4500
    class = shortestDistance(x(i),y(i),x(4001:4500),y(4001:4500),lab(4001:4500),K);
    if class~=lab(i)
       errors2 = errors2 + 1;
       k = k+1;
    end
end
ErV = errors2/5;
%TESTING WITH 2500 SAMPLES:

%This will calculate the Best K in the interval between 150 and 180(random)
e250 = zeros(80,1);
for i= 150:180
    for k=1:80
        class = shortestDistance(x(i),y(i),x(1:1000),y(1:1000),lab(1:1000),k);
        if class~=lab(i)
           e250(k) = e250(k)+ 1;
        end
    end
end

%{
    [V,K] = min(A)
    where V - is the min value
    and K - is index of the minimum value, or the KMM
%}
figure;
plot((1:80),(e250/length(e250))*100); 
title("Errors based on K");
xlabel("K");
ylabel("error percentage(%)");

[V250,K250] = min(e250); 


%Validation dataset:

errors250 = 0;
k = 1;
for i= 4001:4500
    class = shortestDistance(x(i),y(i),x(4001:4500),y(4001:4500),lab(4001:4500),K250);
    if class~=lab(i)
       errors250 = errors250 + 1;
       k = k+1;
    end
end
ErV250 = errors250/25;



%------------------------Functions:----------------------------------------

function dis = findD(pointX,pointY,x,y)
    dis =  sqrt((pointX-x).^2 + (pointY-y).^2);
end

function classification = shortestDistance(pointX,pointY,xArray,yArray,ClassificationArray,k)
   arr = struct('distance',0,'x',0,'y',0,'classification',1);
   classification = 1;
   countA = 0;
   countB = 0;
   
   for i = 1:length(xArray)
       p = struct('distance',findD(pointX,pointY,xArray(i),yArray(i)),'x',pointX,'y',pointY,'classification',ClassificationArray(i));
       arr(i) = p;
   end
   [n,idx] = sort([arr.distance]); %sorting the data based on the structure's feature 'distance'
   arr = arr(idx);
   
   if arr(1).distance==0
       for i=2:k+1    
           if arr(i).classification == 1
               countA = countA + 1;
           else
               countB = countB + 1;
           end
       end
   else
       for i=1:k
           if arr(i).classification == 1
               countA = countA + 1;
           else
               countB = countB + 1;
           end
       end
   end
   if countB>countA
       classification = 2;
   end
end

