L=10;        % oversampling rate, each symbol contains L samples
Nsym = 40;  %filter span in symbol duration
beta = [0 0.1 0.3 0.5 0.7 1];
p=zeros(length(beta),Nsym*L+1);
for k=1:length(beta)
[p(k,:),t,filtDelay]=srrcFunction(beta(k),L,Nsym);

end

figure;
for i=1:length(beta)
    plot(t, p(i,:),'LineWidth',1.6);
hold on;
end

title('Square Root Raised Cosine Pulse');
xlabel('Time (seconds)');
ylabel('Amplitude');
legend('0','0.1','0.3','0.5','0.7','1')
grid on;



%% frequency domain
Nfft=1024;

fdom=zeros(length(beta),Nfft);
for k=1:length(beta)
   fdom(k,:)=fftshift(fft(p(k,:),Nfft)); 
   fdom(k,:)=fdom(k,:)/Nfft;
   
end
f=-Nfft/2:Nfft/2-1 ;
f=f.*L/Nfft;
figure;
for i=1:length(beta)
   plot(f,abs(fdom(i,:)) ,'LineWidth',1.6);
   hold on; 
end

title('Square Root Raised Cosine Pulse');
xlabel('Hz');
ylabel('Amplitude');
legend('0','0.1','0.3','0.5','0.7','1')
grid on;






