clear all;
clc;


update_rule = 'hebbian';

%% Machine Parameters
k = 3;%The number of hidden neurons
n = 3;%Then number of input neurons connected to each hidden neuron
l = 3;%Defines the range of each weight ({-L, ..., -2, -1, 0, 1, 2, ..., +L })
%%
Alice = machine(k, n, l);
Bob = machine(k, n, l);
Eve = machine(k, n, l);

%%
sync = 0; % Flag to check if weights are sync
nb_updates = 0; % Update counter
nb_eve_updates = 0; % To count the number of times eve updated
sync_history = []; % to store the sync score after every update
tic
%%
%figure('units','normalized','outerposition',[0 0 1 1])
while(not(sync))
    X = randi([-l l],k,n);%randomly generated input vector
	tauA = Alice.get_output(X); % Get output from Alice
	tauB = Bob.get_output(X); % Get output from Bob
	tauE = Eve.get_output(X); % Get output from Eve 
    
    Alice.update(tauB, update_rule); % Update Alice with Bob's output
	Bob.update(tauA, update_rule); % Update Bob with Alice's output
    
 	%Eve would update only if tauA = tauB = tauE
	if(tauA == tauB == tauE)
		Eve.update(tauA, update_rule);
		nb_eve_updates = nb_eve_updates + 1;  
    end
    nb_updates = nb_updates + 1;
    score = 100 * sync_score(Alice, Bob,l) % Calculate the synchronization of the 2 machines
    
    sync_history = [sync_history score];
    
     if(score == 100)
         sync = 1;
     end
     pause(0.001)
     imagesc(Alice.W - Bob.W,[-l,l])
     title('SYNCHRONIZATION OF MACHINE WEIGHTS')
     xlabel('Input')
     ylabel('Hidden Neuron')
end

%See if Eve got what she wanted:
eve_score = round(100 * (sync_score(Alice, Eve,l)))
if eve_score > 100
    disp('Oops! Eve synced her machine with Alice and Bob !')
else
    disp(strcat('Eves machine is only ',num2str(eve_score),'% ', 'synced with Alices and Bobs and she did  ',num2str(nb_eve_updates),' updates'));
end
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
key=de2bi(prod,10);
%%




    



   
        