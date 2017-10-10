prod=1;
sum=0;
for i=1:3
    sum=0;
    for j=1:3
        sum=sum+abs(ans.W(j,i));
    end
    prod=prod*sum;
end
key=de2bi(prod,10);
array = xlsread('F:\Dot\Downloads\Xls_Sample_file', 'E2:E65535'); %reading data to encrypt from Xls_Sample_file  
fprintf('\nThe actual data:');disp(array);
array=array-564; %scaling down the data
arrayOfFlag=zeros(65534,1); %array which stores 3rd key to determine which data has been 2s complemented
arrayOfBinary=zeros(65534,8); %vector which stores binary vectors of all data
arrayOfEncV=zeros(65534,8); %vector which stores encrypted binary vectors of all data
arrayOfEncD=zeros(65534,1); %array which stores encrypted data in decimal
for i=1:65534
    if(array(i)<0) %check if data is negative
        arrayOfFlag(i,:)=1; %corresponding bit of the 3rd key is changed to 1 if true
        arrayOfBinary(i,:)=decimalToBinaryVector((2^8+array(i,1)), 8, 'MSBFirst'); %convert negative decimal number to binary vector
    else
        arrayOfBinary(i,:)=decimalToBinaryVector(array(i,1),8,'MSBFirst'); %convert positive decimal number to binary vector
    end
    arrayOfEncV(i,:)=sdes(arrayOfBinary(i,:),key); %binary bector is encrypted
    arrayOfEncD(i,:)=bi2de(arrayOfEncV(i,:)); %encrypted binary vector is converted to its decimal form
    
end
%fprintf('\nThe scaled down data:'); 
%disp(array);
%disp(arrayOfBinary);
%disp(arrayOfEncV);
fprintf('\nEncrypted data:');disp(arrayOfEncD);
filename = 'F:\Dot\Downloads\testdata.xlsx'; 
xlswrite(filename,arrayOfEncD,1,'A1:A65534'); %store encrypted data in testdata
xlswrite(filename,arrayOfFlag,1,'B1:B65534'); %store 3rd key in testdata




    
