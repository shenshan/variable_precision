function j = mapJK(j, jmap, kmap)
%REMAPLAMBDA map j to kappa
%   function j = mapJK(j, jmap, kmap)

j = min(max(jmap),j);
j = interp1(jmap,kmap,j);
