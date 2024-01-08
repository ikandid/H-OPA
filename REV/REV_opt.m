%REV optimization
function REV_opt(Intensity_norm, x0, opt, nulls)  

    Intensity_sum = sum(Intensity_norm(:,opt-nulls:opt+nulls));
    hello
end