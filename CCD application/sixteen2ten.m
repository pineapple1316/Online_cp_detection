function num=sixteen2ten(string)
    exchange_list='0123456789ABCDEF#';
    num=zeros(1,3);
    for i=1:3
        tempCoe1=find(exchange_list==string(i*2))-1;
        tempCoe2=find(exchange_list==string(i*2+1))-1;
        num(i)=16*tempCoe1+tempCoe2;
    end
end