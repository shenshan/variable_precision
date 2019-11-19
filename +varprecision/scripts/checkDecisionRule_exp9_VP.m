sigma_vec = [5,4,6,8];
x_vec = [10,3,3,3];

sigma_s = 9;

a = sum(1./sigma_vec.^2)*(sum(x_vec.^2./sigma_vec.^2)/sum(1./sigma_vec.^2) - (sum(x_vec./sigma_vec.^2)/sum(1./sigma_vec.^2))^2) + (sum(x_vec./sigma_vec.^2)/sum(1./sigma_vec.^2))^2/(1/sum(1./sigma_vec.^2)+sigma_s^2)

b = sum(x_vec.^2./sigma_vec.^2) - sum(x_vec./sigma_vec.^2)^2/(sum(1./sigma_vec.^2)+1/sigma_s^2)