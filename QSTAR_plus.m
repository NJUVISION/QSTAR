%Date 2020.6.17
%Author: Yu Meng (Any question, please contact:mengyu@smail.nju.edu.cn)
%Affiliation: Nanjing University

function  q_pre = QSTAR_plus(q_pam, s, q, t, QP)
%input: q_pam  is a output array of QSTAR_plus_pam.
%          s is normalized SR, s = S/Smax
%          q is normalized q,  q = qmin/q
%           t is normalized TR, t = TR/TRmax
%output:q_pre is the predicted normalized perceptual quality
as = q_pam(1);
aq = q_pam(2);
at = q_pam(3);
as = as*(-0.1317*QP +6.3227);
NQS = (1 - exp(-as*(s^(1.345))))/(1-exp(-as));
NQQ = (1 - exp(-aq*(q^(0.916))))/(1-exp(-aq));
NQT = (1 - exp(-at*(t^(0.404))))/(1-exp(-at));
q_pre = NQS*NQQ*NQT;
end

