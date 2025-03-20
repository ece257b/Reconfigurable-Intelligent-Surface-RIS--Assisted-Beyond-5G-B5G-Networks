function [P] = AO(hd,hr,G,epsilon,gamma)
    w = hd'/norm(hd); % ?????Ap-user MRT?????
    P_new = 0;
    P = 10;
    while (abs(P-P_new)>epsilon)
        varphi0 = angle(hd*w);
        v = exp(1j*(varphi0 - angle(diag(hr)*G*w)));
        P = P_new;
        P_new = gamma/(norm((v.'*(diag(hr)*G)+hd)*w)^2);
        w = (v.'*diag(hr)*G+hd)'/norm((v.'*diag(hr)*G+hd));
    end
end