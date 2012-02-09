function isr = is_sig_q2(q2_correct,q2_perm,talpha)
sorted = sort(q2_perm,'descend');
ix = round(length(sorted)*talpha) + 1;
thres = sorted(ix);
if q2_correct >= thres
    isr = true;
else
    isr = false;
end