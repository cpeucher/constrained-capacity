function [cstar,snr_est_db] = calc_constellation_constained_capacity(constellation,snr,nquad,nreal)
% Constellation-constrained capacity over AWGN channel (uniform)
%
% -------------------------------------------------------------------------
% DESCRIPTION:
% -------------------------------------------------------------------------
% This function calculates the constellation-constrained capacity of a
% memoryless additive white Gaussian noise (AWGN) channel for a given value 
% of signal-to-noise ratio (SNR) based on Monte-Carlo integration. 
% It implements the calculation of equation (5) in 
% G. Ungerboeck, "Channel coding with multilevel/phase signals," 
% IEEE Trans. Inf. Theory IT-28, 55 (1982) [doi: 10.1109/TIT.1982.1056454]
% 
% The function is currently limited to uniform constellations, i.e.
% signals for which each symbol in the constellation is generated with the
% same probabiity 1/M, where M is the size of the constellation. It
% therefore does not allow the consideration of probabilistic shaping.
%
% -------------------------------------------------------------------------
% FUNCTION CALL:
% -------------------------------------------------------------------------
% [constellation,norm_es,norm_emax] = define_constellation(type,m);
% cstar =
% calc_constellation_constrained_capacity(constellation,snr,nquad,nreal);
%
% -------------------------------------------------------------------------
% INPUTS:
% -------------------------------------------------------------------------
% constellation     constellation [complex vector]
% 
%                       As obtained by a call to the function
%                       [constellation,norm_es,norm_emax] = 
%                                   ...define_constellation(type,m)
% 
% snr               values of signal-to-noise ratio, in linear units, at 
%                       which the constrained capacity will be evaluated
%                       [real vector]
% 
% nquad             number of quadratures of the modulation format / AWGN
%                       [nquad = 1,2]
%                       
%                       nquad = 1 for unidimensional constellations
%                           e.g. m-PAM
%
%                       nquad = 2 for bidimensional constellations
%                           e.g. BPSK, QPSK, m-QAM
%
% nreal             number of noise realisations to consider for the
%                       Monte-Carlo evaluation of the constrained capacity
%                       [integer scalar]
%
% -------------------------------------------------------------------------
% OUTPUTS:
% -------------------------------------------------------------------------
% cstar             constellation constrained capacity, in bit per channel 
%                       use [real vector]  
% 
% snr_est_db        estimated signal-to-noise ratio obtained through
%                       generation of noise realisation at which the
%                       capacity is evaluated, in dB [real vector]
%
%                       This is just a simple way to check that the number
%                       of realisations is sufficient to reach the
%                       specified SNR with sufficient accuracy.
%
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

cstar = zeros(1,length(snr));
% Preallocate vector to save constrained capacity values

snr_est_db = zeros(1,length(snr));
% Preallocate vector to save SNR estimates

m = length(constellation);
% Modulation order = number of points in the constellation


for isnr = 1:length(snr)
    % Loop over specified SNR values
    
    sig2_per_quad = mean(abs(constellation).^2)/snr(isnr)/nquad;
    % Extract noise variance per quadrature from specified SNR
    
    w = sqrt(sig2_per_quad)*randn(1,nreal) + (nquad > 1)*1j*sqrt(sig2_per_quad)*randn(1,nreal);
    % Prepare white gaussian noise vector for a given SNR
    
    snr_est_db(isnr) = 10*log10(mean(abs(constellation).^2)/var(w));
    % Estimation of the SNR based on the generated white Gaussian noise
    
    sumkterm = zeros(1,m);
    % Preallocate vector containing terms of sum over kk
    
    for kk = 1:m
        % Loop over all symbols in the constellation
        
        sumi = zeros(1,nreal);
        % Preallocate vector containing sum over ii
        
        for inoise = 1:nreal
            % Loop over all noise realisations            
            
            sumiterm = zeros(1,m);
            % Preallocate vector containing terms of sum over ii.
            
            for ii = 1:m
                % Loop over all symbols in the constellation
                
                sumiterm(ii) =  exp(-(abs(constellation(kk) + w(inoise) - constellation(ii)).^2 - abs(w(inoise)).^2)/2/sig2_per_quad);
                
                
            end
            % End of loop over all symbols in the constellation
            
            sumi(inoise) = sum(sumiterm);           
            
            
        end
        % End of loop over all noise realisations
        
        sumkterm(kk) = mean(log2(sumi));
        
    end
    % End of loop over all symbols in the constellation
    
    
    
    cstar(isnr) = log2(m) - sum(sumkterm)/m;
    
end
% End of loop over snr values

end