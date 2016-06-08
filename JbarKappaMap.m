%{
varprecision.JbarKappaMap (lookup) # a table to save the mapping between jbar and kappa
jkmap_id     : tinyint      # mapping index, 1 is no mapping, 2 is a mapping jbar = kappa*I1(kappa)/I0(kappa)
-----
jmap         : longblob     # jbar map
kmap         : longblob     # kappa map

%}

classdef JbarKappaMap < dj.Relvar
    
    methods
        function fill(self)
            % id = 1, map kmap with jmap
            tuples(1).jkmap_id = 1;
            kmap = [linspace(0,10,1e3) linspace(10.1,2000,1e3)];
            jmap = kmap.*besseli(1,kmap,1)./besseli(0,kmap,1);
            tuples(1).kmap = kmap;
            tuples(1).jmap = kmap;
            % id = 2, keep kmap and jmap same
            tuples(2).jkmap_id = 2;
            tuples(2).kmap = kmap;
            tuples(2).jmap = jmap;
            self.inserti(tuples)            
        end
    end
end