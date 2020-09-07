function output = getfieldall(input, field)
%GETFIELDALL get the fields of a struct array

sample = getfield(input,field);

if isnumeric(sample)
    output = zeros(size(input));
else
    output = cell(size(input));
end

for ii = 1:length(input)
    if isnumeric(sample)
        output(ii) = getfield(input(ii),field);
    else
        output{ii} = getfield(input(ii),field);
    end
end
    

