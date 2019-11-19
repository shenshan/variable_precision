%{
varprecision.FitPredictionBpsBest2D (computed) # compute prediction to plot in 2d.
->varprecision.FitPredictionBpsBest
-----
prediction_plot_2d: longblob   # 2 dimensional matrix, the first dimension is target orientation, the second dimension is distractor orientation
%}

classdef FitPredictionBpsBest2D < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.FitPredictionBpsBest & varprecision.DataStats
    end
	methods(Access=protected)

		function makeTuples(self, key)
            
            [stims,dist,idx1,idx2] = fetch1(varprecision.DataStats2D & key, 'stims','dist','idx_target','idx_dist');
            prediction = fetch1(varprecision.FitPredictionBpsBest & key, 'prediction');
            
            prediction_plot_2d = zeros(length(stims),length(dist));
            
            for ii = 1:length(stims)
                for jj = 1:length(dist)
                    prediction_plot_2d(ii,jj) = mean(prediction(idx1==ii & idx2==jj));
                end
            end

            key.prediction_plot_2d = prediction_plot_2d;
            
			self.insert(key)
		end
	end

end