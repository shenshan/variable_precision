function name_out = mapModelName(name_in)
%MAPMODELNAME maps the model names in the paper to the model names in the
%database
%   function name_out = mapModelName(name_in)
%   name_in should be single string or a cell array containing names
%   name_out returns a single name or a cell array cotaining names in the
%   final paper
%   SS 17-04-21

names_db = {'CP','CPG','CPN','CPGN','OP','OPG','OPN','OPGN','VP','VPG','VPN','VPGN','OPVP','OPVPG','OPVPN','OPVPGN'};

names_final = {'Base','G','D','GD','O','G','GO','GDO','V','GV','DV','GDV','OV','GOV','DOV','GDOV'};

if ischar(name_in)
    name_out = names_final(strcmp(names_db,name_in));
else
    name_out = cell(1,length(name_in));
    for ii = 1:length(name_in)
        name_out(ii) = names_final(strcmp(names_db,name_in{ii}));
    end
end


