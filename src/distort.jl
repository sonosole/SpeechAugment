export initClipWav

"""
    y = clipWav(x, a)
use clipping to create distortion effects
"""
function clipWav(x, a)
    if !(2>=a>=0.5); a=1.0; end
    s = (0.4 + 0.1 * rand());
    c = (s + 1) / 2;
    k = (1 - s) / (s - c)^2;
    x .*= a/(maximum(abs.(x)) + 3e-5);
    for t = 1:length(x)
        if c < x[t]
            x[t] = 1.0;
        elseif s < x[t] <= c
            x[t] = -k * ( x[t] - c )^2 + 1;
        elseif -c <= x[t] < -s
            x[t] =  k * ( x[t] + c )^2 - 1;
        elseif x[t] < -c
            x[t] = -1.0;
        end
    end
    return x
end


function initClipWav(clipSpan::NTuple{2,Number})
    clipMin, clipMax = clipSpan
    @assert clipMin <= clipMax
    function clipwav(wav::Array{T,2}) where T
        return clipWav(wav, rand()*(clipMax - clipMin) + clipMin)
    end
    return clipwav
end
