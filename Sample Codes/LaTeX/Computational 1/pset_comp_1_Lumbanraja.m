%%      COMPUTATIONAL PROBLEM SETS 1
%%%     ECON 33000: Theory of Income 1
%%%     Alvin Ulido Lumbanraja


%       Notice: for checks, please run each part separately

%       PART A: Line 16
%       PART B: Line 52
%       PART C: Line 124
%       PART D: Line 196
%       PART E: Line 273
%       PART F: Line 343
%       PART G: Line 429

%%      PART A: ANALYTICAL GRAPH

clear
clc
%       Defined Parameters

alpha     = 1/3;
beta      = 0.98;
delta     = 1;
N         = 200;
z         = 1;

%       Error Tolerance
tol       = 1e-5;

%       Other Variables
iter            = 0;
crit            = 1e+10;

kss             = (1/(beta*alpha*z))^(1/(alpha-1));
              
k_0             = 0.05*kss;
k_n             = 1.2*kss;

%   Step 1: Grid for Capital
k           = linspace(k_0,k_n,N);
V0          = (alpha/(1-alpha*beta))*log(k)+(log(z*(1-alpha*beta))...
                +((alpha*beta)/(1-alpha*beta))*log(alpha*beta))/(1-beta);
g           = alpha*beta*z*k.^alpha;


subplot(2,1,1);
plot (k,g);
title ('Policy Function: Analytical');
xlabel ('Level of Capital');
ylabel('g(k)');
subplot(2,1,2)
plot (k,V0);
title ('Value Function: Analytical');
xlabel ('Level of Capital');
ylabel('V(k)');  


%%      PART B: BRUTE FORCE VALUE FUNCTION ITERATION

clear
clc
%       Defined Parameters

alpha     = 1/3;
beta      = 0.98;
delta     = 1;
N         = 200;
z         = 1;

%       Error Tolerance
tol       = 1e-5;

%       Other Variables
iter            = 0;
crit            = 1e+10;

kss             = (1/(beta*alpha*z))^(1/(alpha-1));
              
k_0             = 0.05*kss;
k_n             = 1.2*kss;

%   Step 1: Grid for Capital
k   = linspace(k_0,k_n,N);

%    Initial Guesses
V0  = zeros(N,1);

tic
while crit > tol                  % Criteria to Stop
    
% (a) Fix for current level of k
    for i = 1:N
        
% (b) For each possible next period capital
        for j = 1:N
            
            c = z*k(i)^alpha + (1-delta)*k(i)-k(j);
            c = max(c,0);

% (c) Constructing the Bellman Operator
            if c==0
                T(j) = -1e+10;
            else
                T(j) = log(c) + beta*V0(j);
            end    
        
        end 
        
% (d) Compute the maximum in each row and recover optimal policy
       [V1(i), Ipol(i)] = max(T); 
       b(i) = Ipol(i);
        
    end
% (e) Compute the distance and update
        crit = max(abs(V1'-V0));
        iter = iter+1;
        V0   = V1';
        g    = k;

%       Sanity Check
fprintf('Iteration = %4.0f, Criteria = %4.3f \n', iter, crit)
end
toc

pf = b*(k_n-k_0)/N+k_0;      % Policy Function
subplot(2,1,1);
plot (k,pf);
title ('Policy Function: Brute Force');
xlabel ('Level of Capital');
ylabel('g(k)');
subplot(2,1,2);
plot (k,V0);
title ('Value Function: Brute Force');
xlabel ('Level of Capital');
ylabel('V(k)');

    %%      PART C: IMPROVED DECISION PROCESS

clear
clc
%       Defined Parameters

alpha     = 1/3;
beta      = 0.98;
delta     = 1;
N         = 200;
z         = 1;

%       Error Tolerance
tol       = 1e-5;

%       Other Variables
iter            = 0;
crit            = 1e+10;

kss             = (1/(beta*alpha*z))^(1/(alpha-1));
              
k_0             = 0.05*kss;
k_n             = 1.2*kss;    
    
%   Step 1: Grid for Capital
k   = linspace(k_0,k_n,N);

%    Initial Guesses
V0  = log((k.^(alpha))-delta.*k)/(1-beta);
V0  = V0';
tic
while crit > tol                  % Criteria to Stop
    
% (a) Fix for current level of k
    for i = 1:N
        
% (b) For each possible next period capital
        for j = 1:N
            
            c = z*k(i)^alpha + (1-delta)*k(i)-k(j);
            c = max(c,0);

% (c) Constructing the Bellman Operator
            if c==0
                T(j) = -1e+10;
            else
                T(j) = log(c) + beta*V0(j);
            end        
        end 
        
% (d) Compute the maximum in each row and recover optimal policy
       [V1(i), Ipol(i)] = max(T);
       b(i) = Ipol(i);
       
    end
% (e) Compute the distance and update
        crit = max(abs(V1-V0));
        iter = iter+1;
        V0   = V1; 
%       Sanity Check
fprintf('Iteration = %4.0f, Criteria = %4.3f \n', iter, crit)
end 
toc

pf = b*(k_n-k_0)/N+k_0;       % Policy Function
subplot(2,1,1);
plot (k,pf);
title ('Policy Function: Improved Guess in V0');
xlabel ('Level of Capital');
ylabel('g(k)');
subplot(2,1,2);
plot (k,V0);
title ('Value Function: Improved Guess in V0')
xlabel ('Level of Capital')
ylabel('V(k)')



%%      PART D: IMPROVED DECISION PROCESS

clear
clc
%       Defined Parameters

alpha     = 1/3;
beta      = 0.98;
delta     = 1;
N         = 200;
z         = 1;

%       Error Tolerance
tol       = 1e-5;

%       Other Variables
iter            = 0;
crit            = 1e+10;

kss             = (1/(beta*alpha*z))^(1/(alpha-1));
              
k_0             = 0.05*kss;
k_n             = 1.2*kss;

%   Step 1: Grid for Capital
k               = linspace(k_0,k_n,N);

%    Initial Guesses
V0              = zeros(N,1);
V1              = zeros(N,1);
    
g               = linspace(1,N,N);

i_prime         = linspace(1,N,N);
i               = 1;
tic
while crit > tol                  % Criteria to Stop
    
% (a) Fix for current level of k
    for i = 1:N
% (b) For each possible next period capital
        for j = i_prime(i):N
            
            c = z*k(i)^alpha + (1-delta)*k(i)-k(j);
            c = max(c,0);
           
% (c) Constructing the Bellman Operator
            if c==0
                T(j) = -1e+10;
            else
                T(j) = log(c) + beta*V0(j);
            end
        end 
        
% (d) Compute the maximum in each row and recover optimal policy
       [V1(i), g(i)] = max(T);     
       i_prime(i+1) = g(i);

    end
% (e) Compute the distance and update
        crit = max(abs(V1'-V0));
        iter = iter+1;
        V0   = V1';  

%       Sanity Check
fprintf('Iteration = %4.0f, Criteria = %4.3f \n', iter, crit)
end
toc

pf = g*(k_n-k_0)/N+k_0       % Policy Function
subplot(2,1,1)
plot (k,pf);
title ('Policy Function: Improved Decision Process');
xlabel ('Level of Capital');
ylabel('g(k)');
subplot(2,1,2);
plot (k,V0);
title ('Value Function: Improved Decision Process');
xlabel ('Level of Capital');
ylabel('V(k)');


%%      PART E: STORING THE RETURN FUNCTION

clear
clc
%       Defined Parameters

alpha     = 1/3;
beta      = 0.98;
delta     = 1;
N         = 200;
z         = 1;

%       Error Tolerance
tol       = 1e-5;

%       Other Variables
iter            = 0;
crit            = 1e+10;

kss             = (1/(beta*alpha*z))^(1/(alpha-1));
              
k_0             = 0.05*kss;
k_n             = 1.2*kss;

%   Step 1: Grid for Capital
k       = linspace(k_0,k_n,N);
g       = linspace(k_0,k_n,N);

%    Initial Guesses
V0      = zeros(N,1);

U       = zeros(N,N);
i_prime = linspace(1,N,N);
 
tic
for i = 1:N        
% (b) For each possible next period capital
        for j = 1:N
            
            c_val   = z*k(i)^alpha + (1-delta)*k(i)-k(j);
            U(i,j)  = log(max(c_val, 0));

        end 
        
end    

while crit>tol
% (c) Constructing the Bellman Operator
        T    = U + beta.*V0;
        
% (d) Compute the maximum
        [V1,g]   = max(T,[],2);

% (e) Compute the distance and update
        crit = max(abs(V1'-V0));
        iter = iter+1;
        V0   = V1';

%       Sanity Check
fprintf('Iteration = %4.0f, Criteria = %4.3f \n', iter, crit)
end
toc

pf = g*(k_n-k_0)/N+k_0;       % Policy Function
subplot(2,1,1)
plot (k,pf);
title ('Policy Function: Storing the Return Function');
xlabel ('Level of Capital');
ylabel('g(k)');
subplot(2,1,2);
plot (k,V0);
title ('Value Function: Storing the Return Function');
xlabel ('Level of Capital');
ylabel('V(k)');


%%      PART F: HOWARD'S IMPROVEMENT ALGORITHM

clear
clc
%       Defined Parameters

alpha     = 1/3;
beta      = 0.98;
delta     = 1;
N         = 200;
n_h       = 100;
z         = 1;

%       Error Tolerance
tol       = 1e-5;

%       Other Variables
iter            = 0;
crit            = 1e+10;

kss             = (1/(beta*alpha*z))^(1/(alpha-1));
              
k_0             = 0.05*kss;
k_n             = 1.2*kss;

%   Step 1: Grid for Capital
k               = linspace(k_0,k_n,N);

%    Initial Guesses
V0              = zeros(N,1);
V1              = zeros(N,1);
    
g               = linspace(1,N,N);

i_prime         = linspace(1,N,N);
i               = 1;
tic
while crit > tol                  % Criteria to Stop
    
% (a) Fix for current level of k
    for i = 1:N
% (b) For each possible next period capital
        for j = i_prime(i):N
            
            c = z*k(i)^alpha + (1-delta)*k(i)-k(j);
            c = max(c,0);
           
% (c) Constructing the Bellman Operator
            if c==0
                T(j) = -1e+10;
            else
                T(j) = log(c) + beta*V0(j);
            end
        end 
        
% (d) Compute the maximum in each row and recover optimal policy
       [V1(i), g(i)] = max(T);     
       i_prime(i+1) = g(i);
    end

% (e) Step 2.5    
        for i = 1:N
            for i_n_h = 1:n_h
                V1(i) = log(z*k(i)^alpha + (1-delta)*k(i) - k(g(i))) + beta*V1(g(i));
            end
        end   
    
% (f) Compute the distance and update
        crit = max(abs(V1'-V0));
          
        iter = iter+1;
        V0   = V1';  

%       Sanity Check
fprintf('Iteration = %4.0f, Criteria = %4.3f \n', iter, crit)
end
toc

pf = g*(k_n-k_0)/N+k_0       % Policy Function
subplot(2,1,1)
plot (k,pf);
title ('Policy Function: Howards Improvement Algorithm');
xlabel ('Level of Capital');
ylabel('g(k)');
subplot(2,1,2)
plot (k,V0);
title ('Value Function: Howards Improvement Algorithm');
xlabel ('Level of Capital');
ylabel('V(k)');

%%      PART G: COMBINATION OF PART E AND PART F

clear
clc
%       Defined Parameters

alpha     = 1/3;
beta      = 0.98;
delta     = 1;
N         = 200;
n_h       = 100;
z         = 1;

%       Error Tolerance
tol       = 1e-5;

%       Other Variables
iter            = 0;
crit            = 1e+10;

kss             = (1/(beta*alpha*z))^(1/(alpha-1));
              
k_0             = 0.05*kss;
k_n             = 1.2*kss;

%   Step 1: Grid for Capital
k       = linspace(k_0,k_n,N);
g       = linspace(k_0,k_n,N);

%    Initial Guesses
V0      = zeros(N,1);

U       = zeros(N,N);
i_prime = linspace(1,N,N);
 
tic
for i = 1:N        
% (b) For each possible next period capital
        for j = 1:N
            
            U(i,j)  = log(max(z*k(i)^alpha + (1-delta)*k(i)-k(j), 0));

        end 
        
end    

while crit>tol
% (c) Constructing the Bellman Operator
        T    = U + beta.*V0;
        
% (d) Compute the maximum
        [V1,g]   = max(T,[],2);
        
% (e) Steps 2.5        
        for i = 1:N
            for i_n_h = 1:n_h
                V1(i) = U(i,g(i)) + beta*V1(g(i));
            end
        end   

% (f) Compute the distance and update
        crit = max(abs(V1'-V0));
        iter = iter+1;
        V0   = V1';

%       Sanity Check
fprintf('Iteration = %4.0f, Criteria = %4.3f \n', iter, crit)
end
toc

pf = g*(k_n-k_0)/N+k_0;       % Policy Function
subplot(2,1,1)
plot (k,pf);
title ('Policy Function: Combination of E & F');
xlabel ('Level of Capital');
ylabel('g(k)');
subplot(2,1,2);
plot (k,V0);
title ('Value Function: Combination of E & F');
xlabel ('Level of Capital');
ylabel('V(k)');

