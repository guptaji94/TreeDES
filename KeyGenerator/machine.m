classdef machine < handle
    properties
        k %The number of hidden neurons
        n %Then number of input neurons connected to each hidden neuron
        l %Defines the range of each weight ({-L, ..., -2, -1, 0, 1, 2, ..., +L })
        W %The weight matrix between input and hidden layers. Dimensions : [K, N]
        sigma
        X
        tau %Output of the neuron
    end
    
    methods
        function obj = machine( k, n, l)
            obj.k = k;
            obj.n = n;
            obj.l = l;
            obj.W = randi([-l l],k,n);
        end
        function tau_ = get_output(obj, X)
            k_ = obj.k;
            n_ = obj.n;
            W_ = obj.W;
            X_ = reshape(X,k_, n_);

            sigma_ = sign(sum(X_ .* W_,1)) ;
            tau_ = prod(sigma_) ;

            obj.tau = tau_;
            obj.sigma = sigma_;
            obj.X = X_;
        end
        function obj = update(obj, tau2, update_rule)
            X_ = obj.X;
            tau1_ = obj.tau;
            sigma_ = obj.sigma;
            W_ = obj.W;
            l_ = obj.l;
            if(tau1_ == tau2)
                switch update_rule
                case 'hebbian'
                    obj.W = hebbian(W_, X_, sigma_, tau1_, tau2, l_);
                case 'anti_hebbian'
                    obj.W = anti_hebbian(W_, X_, sigma_, tau1_, tau2, l_);
                case 'random_walk'
                    obj.W = random_walk(W_, X_, sigma_, tau1_, tau2, l_);
                otherwise
                    fprintf('Error, no such update rule is found! Try again!\n')
                end
            end
            
        end
    end
    
end