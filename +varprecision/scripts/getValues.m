% helper function

function key = getValues(key_input,idx)
    fields = fieldnames(key_input);
    for ii = 1:numel(fields)
        field = key_input.(fields{ii});
        key.(fields{ii}) = field(idx);
    end
end
