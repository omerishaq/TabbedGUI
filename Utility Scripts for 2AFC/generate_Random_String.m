function [ output_String ] = generate_Random_String() 

    symbols = ['a':'z' 'A':'Z' '0':'9'];
    stLength = 10; % gen string of length 10

    nums = randi(numel(symbols),[1 stLength]);
    output_String = symbols (nums);

end





