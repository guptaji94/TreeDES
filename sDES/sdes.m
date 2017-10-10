
function data1=sdes(data,key)
 %clears inputs 
%array = xlsread('Xls_Sample_file', 'E2:F65536');  

%inputs
  %data = [1 0 1 0 0 0 1 0]; 
   
%fprintf(' The original data is ='); disp(data);

%Function Parameters
    P4 = [2 4 3 1]; 
    P8 = [6 3 7 4 8 5 10 9];
   P10 = [3 5 2 7 4 10 1 9 8 6];
SHIFT1 = [2 3 4 5 1 7 8 9 10 6]; %Shift bits 1 space
SHIFT3 = [4 5 1 2 3 9 10 6 7 8]; %Shifts 3 spaces, used to circumvent 2 + 1 logic
   
    IP = [2 6 3 1 4 8 5 7]; %Initial Permutation
    PI = [4 1 3 5 7 2 8 6]; %Inverse IP ;-)
    EP = [4 1 2 3 2 3 4 1]; 
    FP = [4 1 3 5 7 2 8 6]; %Final Permutation
    
    S0 = [1 0 3 2; 3 2 1 0; 0 2 1 3; 3 1 3 2]; % s-boxes
    S1 = [0 1 2 3; 2 0 1 3; 3 0 1 0; 2 1 0 3];
    
%Key Generation

K1 = key(P10(SHIFT1(P8)));
K2 = key(P10(SHIFT3(P8)));

%Initial Permutation 1
L = data(IP(1:4));
R = data(IP(5:8));
R1 = xor(R(EP),K1);

%------ Function 1 with key 1
%function gets decimal location for substitution box then converts back to
%binary and places into matrix 
R2 = de2bi(S0((bi2de(R1([1 4]),2,'left-msb')+1),(bi2de(R1([2 3]),2,'left-msb')+1)),2,'left-msb');
R3 = de2bi(S1((bi2de(R1([5 8]),2,'left-msb')+1),(bi2de(R1([6 7]),2,'left-msb')+1)),2,'left-msb');
R3 = [R2,R3];
R3 = xor(R3(P4),L);

%Swap
data = [R, R3]; %swap halves

%------ Function 1 with key 2
L = data(1:4);
R = data(5:8);
R1 = xor(R(EP),K2);

R2 = de2bi(S0((bi2de(R1([1 4]),2,'left-msb')+1),(bi2de(R1([2 3]),2,'left-msb')+1)),2,'left-msb'); 
R3 = de2bi(S1((bi2de(R1([5 8]),2,'left-msb')+1),(bi2de(R1([6 7]),2,'left-msb')+1)),2,'left-msb');
R3 = [R2,R3];
R3 = xor(R3(P4),L); %xor's with left half

%swap halves
data = [R3, R]; 

%Inverse Permutation
data = data(PI);
data1=data;
%fprintf('The encrypted data is =')
%disp(data);

data = data(IP);
data1=data;
end


