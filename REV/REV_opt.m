%REV optimization
function REV_opt(Intensity_norm,Int_sum, x0, opt, nulls)  

    Int_sum_REV = sum(sum(Intensity_norm(:,opt-nulls:opt+nulls)));
    Intensity_ratio = Int_sum_REV/Int_sum;

end