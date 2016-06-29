function [ qty ] = saliency_quality(fx)


sal2=mat2gray(fx);
    
    fjm=im2bw(double(sal2),graythresh(sal2));
    
    
    
    t1=sal2(fjm);
    t2=sal2(~fjm);
    
    if isempty(t1)
        t1=0;
    end
    if isempty(t2)
        t2=0;
    end
    
    
    m1=sum(t1(:))/(sum(fjm(:))+eps);
    m2=sum(t2(:))/(sum(~fjm(:))+eps);
    s1=sqrt(var(t1(:)))+eps;
    s2=sqrt(var(t2(:)))+eps;
    x=linspace(0,1,256);
    fg=[exp(-0.5*((x-m1)/s1).^2)/(s1*sqrt(2*pi));exp(-0.5*((x-m2)/s2).^2)/(s2*sqrt(2*pi))];
   
    a=1/s2^2-1/s1^2;
    b=-2*(m2/s2^2-m1/s1^2);
    c=m2^2/s2^2-m1^2/s1^2+2*(log(s2+eps)-log(s1+eps));

    rt=roots([a b c]);
    
    rt=rt(rt>=0);
    rtx=rt(rt<=1);
    rtx=rtx(1);
    fg1=fg(1,:);
    fg2=fg(2,:);
    qty=1/(1+log10(1+sum(fg1(x<rtx))+sum(fg2(x>=rtx))));

end

