%%
%key production
prod=1;
sum=0;
for i=1:3
    sum=0;
    for j=1:3
        sum=sum+abs(ans.W(j,i));
    end
    prod=prod*sum;
end
%%
key=de2bi(prod,10); 
arrayOfEncD=xlsread('F:\Dot\Downloads\testdata', 'A1:A65534'); %array to store encrypted decimal data
arrayOfFlag = xlsread('F:\Dot\Downloads\testdata', 'B1:B65534');  %array to store 3rd key to check which data has been 2s complemented 
arrayOfDecV1=zeros(65534,8); %vector to store encrypted binary vectors
arrayOfDecV2=zeros(65534,8); %vector to store decrypted binary vectors
arrayOfDecD=zeros(65534,1); %array to store decrypted decimal data
for i=1:65534
    arrayOfDecV1(i,:)=decimalToBinaryVector(arrayOfEncD(i,1),8,'LSBFirst'); %convert encrypted decimal data to encrypted binary vectors
    arrayOfDecV2(i,:)=sdesd(arrayOfDecV1(i,:),key); %decrypting binary vectors
    
    if(arrayOfFlag(i,1)==0) %check if data has been 2s complemented by reading the 3rd key
        arrayOfDecD(i,:)=bi2de(arrayOfDecV2(i,:),'left-msb'); %convert binary vector to decimal data if not 2s complemented
    else
        str_x = num2str(arrayOfDecV2(i,:)); %if data has been 2s complemented then 2s complement conversion to decimal 
        str_x(isspace(str_x)) = '';
        arrayOfDecD(i,:)=sbin2dec(str_x);
    end
end
%fprintf('\nDecrypted data:');
%disp(arrayOfDecD);
arrayOfDecD=arrayOfDecD+564; %decrypted data is scaled up
fprintf('\nScaled up data:');
disp(arrayOfDecD);
filename2 = 'C:\Users\dot\Downloads\testdata2.xlsx'; 
xlswrite(filename2,arrayOfDecD,1,'A1:A65534'); %store decrypted data in testdata2